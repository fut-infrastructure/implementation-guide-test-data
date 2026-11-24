#!/usr/bin/env bash
# TEMPORARY: why does tx.fhir.org not resolve on the larger-disk runner? Delete when solved.
# The publisher image has no curl or dig, so this uses getent, wget and jq.
# A different DNS is tried through DNS-over-HTTPS to the resolver's IP, which needs no DNS itself.

host=tx.fhir.org
path=/r4/metadata

echo "== /etc/resolv.conf"
cat /etc/resolv.conf

echo
echo "== system resolver (getent)"
for name in "$host" packages.fhir.org build.fhir.org github.com; do
  getent hosts "$name" || echo "$name: NOT RESOLVED"
done

echo
echo "== HTTPS to $host by name (system resolver)"
wget -q -O /dev/null --timeout=10 --tries=1 "https://$host$path" && echo "OK" || echo "FAILED"

echo
echo "== other DNS, via DNS-over-HTTPS to the resolver's IP"
for doh in "https://8.8.8.8/resolve?name=$host&type=A" "https://1.1.1.1/dns-query?name=$host&type=A"; do
  echo "-- $doh"
  ip=$(wget -q -O - --timeout=10 --tries=1 --header 'accept: application/dns-json' "$doh" \
    | jq -r '[.Answer[]? | select(.type == 1) | .data][0] // empty')
  if [ -z "$ip" ]; then
    echo "no answer"
    continue
  fi
  echo "answer: $ip"
  # certificate check off on purpose: the certificate is for the name, not the IP; this tests reachability only
  wget -q -O /dev/null --timeout=10 --tries=1 --no-check-certificate --header "Host: $host" "https://$ip$path" \
    && echo "HTTPS to $ip: OK" || echo "HTTPS to $ip: FAILED"
done
