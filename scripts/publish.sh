#!/usr/bin/env bash
# Runs the IG Publisher in Docker.
#
#   scripts/publish.sh            full run: network, terminology server, usage stats (~55 min)
#   scripts/publish.sh --offline  cached packages, no terminology server (~11 min)
#
# THE PACKAGE CACHE LIVES IN A DOCKER NAMED VOLUME, not a bind mount from C:\Users\...\.fhir.
# Windows bind mounts into Linux containers go over a file-sharing protocol that costs a round
# trip per file operation, and both the package loader and Jekyll do thousands of tiny reads.
# Measured in this container, 500 small files written then read: 668 ms on the container
# filesystem, 4294 ms on the bind mount. Loading hl7.terminology.r4 alone (4211 resources, all
# already cached) took 1:27 through the mount.
#
# To reseed the volume from the Windows cache, stream it as one tar so the small-file round trips
# never happen — do NOT cp -a through the mount. THEN FIX OWNERSHIP: the volume root is created as
# root and tar carries Windows' mapped uid (4096) onto the contents, but the publisher runs as uid
# 1001 and cannot then create its cache lock file. That surfaces 11 minutes in, at the very last
# step, as the useless message "Unable to get file lock after 5 retries":
#   cd ~ && tar -cf - .fhir | docker run --rm -i -v fhir-cache:/dest alpine \
#     sh -c 'cd /dest && tar -xf - --strip-components=1'
#   docker run --rm -v fhir-cache:/c alpine chown -R 1001:1001 /c
#
# The source tree is still bind-mounted, because the publisher has to write output/ where you can
# read it. That leaves Jekyll's I/O on the slow path; moving the whole repo into WSL2 would fix
# that too, and is the next step if this is not fast enough.

set -euo pipefail

# The repo is normally this script's parent directory, but it can be given explicitly as $1 or in
# REPO. That matters because editing this script while it is running breaks the run — bash reads a
# script incrementally, and the edit shows up as "unexpected EOF while looking for matching '". The
# safe way to iterate on it is to run a copy from elsewhere, which only works if the copy is told
# where the repo is: self-location from /tmp resolves REPO to / and the log path to //publisher-run.log.
OFFLINE=""
REPO_ARG=""
for a in "$@"; do
  case "$a" in
    --offline) OFFLINE=1 ;;
    -*) echo "Unknown option: $a" >&2; exit 1 ;;
    *) REPO_ARG="$a" ;;
  esac
done

REPO="${REPO_ARG:-${REPO:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}}"
if [[ ! -f "$REPO/ig.ini" ]]; then
  echo "No ig.ini in '$REPO'. Pass the repo path as an argument, or set REPO." >&2
  exit 1
fi
CACHE_VOLUME="${CACHE_VOLUME:-fhir-cache}"
LOG="$REPO/publisher-run.log"

ARGS=(-ig ig.ini)
if [[ -n "$OFFLINE" ]]; then
  # -no-network alone is NOT enough: the publisher still opens the terminology server and dies with
  # "Access to the internet is not allowed by local security policy". -tx n/a is what actually
  # takes it out of the build. Codes are then validated only against the cached code systems, so
  # run without --offline before trusting the terminology findings.
  ARGS+=(-no-network -tx n/a)
fi

if ! docker volume inspect "$CACHE_VOLUME" >/dev/null 2>&1; then
  echo "No Docker volume '$CACHE_VOLUME'. Seed it first — see the comment at the top of this script." >&2
  exit 1
fi

# Pre-flight: can uid 1001 write the cache? The publisher only finds out at its very last step,
# after a full build, and reports it as a file-lock failure rather than a permissions one.
if ! docker run --rm --user 1001 -v "$CACHE_VOLUME:/c" alpine \
     sh -c 'touch /c/.writetest && rm /c/.writetest' 2>/dev/null; then
  echo "Volume '$CACHE_VOLUME' is not writable by uid 1001 (the publisher user). Fix with:" >&2
  echo "  docker run --rm -v $CACHE_VOLUME:/c alpine chown -R 1001:1001 /c" >&2
  exit 1
fi

# REFUSE TO RUN TWO PUBLISHES AT ONCE. Both would use /ig/template and /ig/output, and the second
# one rewrites the template directory as it starts — which pulls the files out from under the first
# and kills it, typically with "Source '/ig/template/content/...' does not exist" long after the
# mistake was made.
if docker ps --format '{{.Image}}' | grep -q 'ig-publisher'; then
  echo "A publisher container is already running. Wait for it to finish, or stop it with:" >&2
  echo "  docker stop \$(docker ps -q --filter ancestor=hl7fhir/ig-publisher-base:latest)" >&2
  exit 1
fi

start=$(date +%s)
docker run --rm \
  -v "//$(echo "$REPO" | sed 's|^/||')://ig" \
  -v "$CACHE_VOLUME:/home/publisher/.fhir" \
  -w //ig \
  hl7fhir/ig-publisher-base:latest \
  java -jar input-cache/publisher.jar "${ARGS[@]}" > "$LOG" 2>&1 && rc=0 || rc=$?

echo "exit=$rc  elapsed=$(( ($(date +%s) - start) / 60 ))min"
sed -e 's/\x1b\[[0-9;]*m//g' "$LOG" | grep -aE "^ *(Errors|Warnings)|Publishing Content Failed" | tail -3 || true
exit $rc
