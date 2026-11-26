# implementation-guide-test-data

FUT test data as a FHIR IG. Every resource is an instance of a profile from
`dk.ehealth.sundhed.fhir.ig.core`; this guide defines no conformance resources of its own.

The data is a COPD monitoring scenario for ten patients. The shared definitions (plan, activities,
questionnaire, rules, organizations, patients) are loaded once; the patient-specific part is a
template carrying `${…}` placeholders, which the test data loader copies once per vendor
(coexistence tag) when it loads the guide on an environment.

This README has two procedures:

* [Publishing a new version](#publishing-a-new-version) — the routine one, after every release of
  the core IG. No test data changes.
* [Modifying the test data](#modifying-the-test-data) — only when the data itself has to change.

Both use [Running the publisher locally](#running-the-publisher-locally) to check the result.

## References

| Topic | Where |
|---|---|
| **Core IG** (every profile used here) | [eHealth Infrastructure IG](http://ehealth.sundhed.dk/fhir), repo `fut-infrastructure/implementation-guide` |
| **Published test data** | `https://ehealth.sundhed.dk/testdata/<version>`, e.g. the examples the loader reads at `…/testdata/1.0.0/examples.json.zip` |
| **Where the data is loaded** | The development test environment (DEVENVCGI), by the `test-data-loader` CronJob. See the Loading page of this guide |
| **IG authoring** | [FHIR IG Guidance](http://build.fhir.org/ig/FHIR/ig-guidance/index.html), [FSH School](https://fshschool.org/docs/sushi/) |

## Publishing a new version

Every new version of the core IG (`dk.ehealth.sundhed.fhir.ig.core`) is followed by a new version of
this guide.

### 1. Update the SUSHI configuration

On a branch named after the Jira issue (`FUT1-xxxx-short-slug`), in `sushi-config.yaml`:

* Set the new core IG version under `dependencies:` → `dk.ehealth.sundhed.fhir.ig.core` → `version`.
* Set `hl7.fhir.dk.core` and `hl7.fhir.uv.sdc` to the versions the new core IG's own
  `sushi-config.yaml` declares. SUSHI does not resolve a dependency's dependencies, so they are
  declared here too.
* Raise `version:`, and set the same version in `publication-request.json`.

### 2. Check locally

[Run the publisher](#running-the-publisher-locally) and check `output/qa.html`: the data must still
validate against the new profiles, with no new errors or warnings. If it does not, the data has to
change first: see [Modifying the test data](#modifying-the-test-data).

Commit `sushi-config.yaml` and `publication-request.json`, plus `sushi-config.yaml`'s generated
blocks if the build changed them.

### 3. Initiate the publication

1. Open a pull request to `main`. The pipeline (`.github/workflows/publish.yaml`) transpiles the
   guide as a check.
2. Merge it.
3. Tag the merge commit on `main` with the version, and push the tag:

   ```
   git tag 1.0.1
   git push origin 1.0.1
   ```

The tag starts the release job. It sets `version` and `releaseLabel: release` in
`sushi-config.yaml` and the version in `publication-request.json` from the tag, builds the guide,
and publishes it to `https://ehealth.sundhed.dk/testdata/<version>` through the `fut-ig-website`
and `ig-registry` repos. The tag must have the form `X.Y.Z`; other tags do not start a release.

## Modifying the test data

### Layout

```
input/fsh/
  aliases.fsh             aliases, and what each ${PLACEHOLDER} means
  loader-settings.fsh     the anchor date, and the vendor table (coexistence tag + programme)
  generated/              written by scripts/make-codesystems.js before every build, gitignored
  shared/                 instances every patient and vendor shares
  types/                  per resource type: the documentation and the rule sets
  vendor/<code>/          one care team and one practitioner per coexistence tag
  data/pNN/               the transactions, one file per resource type
input/pagecontent/        the narrative pages; most are generated, see below
scripts/                  the generators and the publisher wrapper
sushi-config.yaml         IG metadata, dependencies, and the generated groups/pages/menu blocks
```

### What is generated

Files marked `GENERATED … do not hand-edit` are overwritten on the next run of their script. Change
the script (or the FSH it reads) instead, and commit the regenerated output with it.

| Script | Writes | Run when |
|---|---|---|
| `scripts/make-groups.js` | the `groups:`, `pages:` and `menu:` blocks of `sushi-config.yaml`; `shared.md`, `vendors.md`, `vendor-<code>.md`, `patients.md`, `patient-NN.md` | every build |
| `scripts/make-codesystems.js` | `input/fsh/generated/loader-codesystems.fsh`: the core IG's `ehealth-system` and `ehealth-program` CodeSystems, at the version `sushi-config.yaml` depends on. Gitignored | automatically, by `publish.sh` and the GitHub workflow; by hand only for a bare `sushi` build |

Hand-written: `index.md`, `loading.md`, `downloads.md`, and the FSH not marked `GENERATED`.

The text of the generated pages lives in the script: the page introductions in `make-groups.js`
itself, the section texts in its `CATEGORY_ORDER` and `TYPE_ORDER` tables, and each table row's
description in the resource's FSH `Description:`.

### Build

```
node scripts/make-codesystems.js . ; sushi . ; node scripts/make-groups.js . ; sushi .
```

`make-codesystems.js` comes first because `sushi-config.yaml` lists the Bundle it writes; without
it SUSHI fails with "configured with nonexistent resource". It reads the core package from the FHIR
cache, or downloads it from `packages.fhir.org`.

Then `sushi` twice, in that order and separated by `;` rather than `&&`: `make-groups.js` reads the built output
to regenerate the `groups:`, `pages:` and `menu:` blocks of `sushi-config.yaml` and the generated
pages under `input/pagecontent/`, so the resources have to exist before it runs and the config has
to be rebuilt after. The first `sushi` exits non-zero when the groups are stale while still
exporting, which is why `&&` stops the chain.

### Making a change

* Branch from the branch the change belongs to, named after the Jira issue (`FUT1-xxxx-short-slug`).
* Make the change in FSH, or in a script for generated files, then run the build above and commit
  the FSH, the script and the regenerated files together.
* [Run the publisher](#running-the-publisher-locally) and check `output/qa.html`: no new errors or
  warnings.
* The loader validates the whole package before it loads anything. A change that breaks one of its
  rules fails the load on DEVENVCGI, so check the loader README's "The package" section, and when in
  doubt, run the loader's tests against the new `examples.json.zip`.
* To release the change, follow steps 1 (version only) and 3 of
  [Publishing a new version](#publishing-a-new-version).

### Common changes

* **A vendor**: add a `vendor` parameter (system tag + programme) to `loader-settings.fsh`, and
  `input/fsh/vendor/<code>/careteam.fsh` and `practitioner.fsh` with ids `careteam-<code>` and
  `practitioner-<code>`. The care team must carry the same programme as its `program` use context.
  `make-groups.js` refuses a vendor that is incomplete or inconsistent.
  The new Practitioner also needs a login. In `helmsman-environments`, add a user
  `test_practitioner_<code>` to the test-data IG practitioners
  (`007-31-test-data-ig-practitioners-test.yaml`) in `devenvcgi/trifork/values/keycloak-configuration.yaml`,
  modelled on the existing ones:
  * `urn.oid.0.9.2342.19200300.100.1.1`: the Practitioner's `identifier.value`
  * `urn.oid.2.5.4.3`: its name
  * `dk.gov.saml.attribute.Privileges_intermediate`: the base64 OIOSAML privilege list, with the
    care team's roles and two constraints: the Organization context (`sorIdentifier`, the SOR code
    of the care team's managing organization) and the CareTeam context (`careteam`, the UUID of
    the CareTeam's `identifier.value` without `urn:uuid:`)
  * the password from `$$(env:USERS_TEST_PRACTITIONER_<CODE>_PASSWORD)`: map it in the same file
    under `applications/keycloak-migration/keycloak/test-passwords` to the key
    `test_data_ig_practitioner_<code>_password`, and add that key to the Vault secret
* **Page text**: edit the hand-written page, or the generator as described under
  [What is generated](#what-is-generated).
* **A new page**: add the file to `input/pagecontent/` and its entry to the `pageTree` and `menu`
  lists in `make-groups.js`, not to `sushi-config.yaml`.

## Running the publisher locally

```
scripts/publish.sh --offline
```

Runs the IG Publisher (`hl7fhir/ig-publisher-base`) in Docker against the `fhir-cache` volume; see
the comments at the top of the script. `--offline` skips the terminology server, so codes are
validated against cached expansions only; check findings without it before trusting them. Output
lands in `output/`, and `output/qa.html` is the validation report. The log is written to
`publisher-run.log`.

To see the result locally:

```
docker run --rm -p 8080:80 -v "$(pwd)/output:/usr/share/nginx/html:ro" nginx
```

and open http://localhost:8080.

## Gotchas

* **Do not hand-edit generated files.** The next run of their script reverts the edit without a
  warning. See [What is generated](#what-is-generated).
* **Package cache in a volume.** The cache lives in the Docker volume `fhir-cache`, not a bind mount,
  because a Windows bind mount makes the run several times slower. When the volume is reseeded,
  fix its ownership as the script's header describes, or the run fails at its last step with
  "Unable to get file lock after 5 retries".
* **Do not edit `scripts/publish.sh` while it runs**; bash reads it incrementally. Run a copy, and
  give it the repo path as its argument.
* **No IG-level `jurisdiction`** in `sushi-config.yaml`: the publisher would overwrite the
  jurisdiction of every definitional resource with it. The comment there explains why.
* **The IG `id` is also the `ehealth-environment` identifier** on the definitional resources; keep
  the two in step.
