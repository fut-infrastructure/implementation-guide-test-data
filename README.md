# implementation-guide-test-data

FUT test data as a FHIR IG. Every resource is an instance of a profile from
`dk.ehealth.sundhed.fhir.ig.core`; this guide defines no conformance resources of its own.

The data is a COPD monitoring scenario for ten patients. The shared definitions (plan, activities,
questionnaire, rules, organizations, patients) are loaded once; the patient-specific part is a
template carrying `${…}` placeholders, which the test data loader copies once per vendor
(coexistence tag) when it loads the guide on an environment.

## References

| Topic | Where |
|---|---|
| **Core IG** (every profile used here) | [eHealth Infrastructure IG](http://ehealth.sundhed.dk/fhir), repo `fut-infrastructure/implementation-guide` |
| **Published test data** | `https://ehealth.sundhed.dk/fhir/testdata/<version>`, e.g. the examples the loader reads at `…/testdata/1.0.0/examples.json.zip` |
| **Where the data is loaded** | The development test environment (DEVENVCGI), by the `test-data-loader` CronJob. See the Loading page of this guide |
| **IG authoring** | [FHIR IG Guidance](http://build.fhir.org/ig/FHIR/ig-guidance/index.html), [FSH School](https://fshschool.org/docs/sushi/) |

## Layout

```
input/fsh/
  aliases.fsh             aliases, and what each ${PLACEHOLDER} means
  loader-settings.fsh     the anchor date, and the vendor table (coexistence tag + programme)
  generated/              written by scripts/, committed, not hand-edited
  shared/                 instances every patient and vendor shares
  types/                  per resource type: the documentation and the rule sets
  vendor/<code>/          one care team and one practitioner per coexistence tag
  data/pNN/               the transactions, one file per resource type
input/pagecontent/        the narrative pages; most are generated, see below
scripts/                  the generators and the publisher wrapper
sushi-config.yaml         IG metadata, dependencies, and the generated groups/pages/menu blocks
```

## What is generated

Files marked `GENERATED … do not hand-edit` are overwritten on the next run of their script. Change
the script (or the FSH it reads) instead, and commit the regenerated output with it.

| Script | Writes | Run when |
|---|---|---|
| `scripts/make-groups.js` | the `groups:`, `pages:` and `menu:` blocks of `sushi-config.yaml`; `shared.md`, `vendors.md`, `vendor-<code>.md`, `patients.md`, `patient-NN.md` | every build (see Build) |
| `scripts/make-codesystems.js` | `input/fsh/generated/loader-codesystems.fsh` | the `dk.ehealth.sundhed.fhir.ig.core` version in `sushi-config.yaml` changes |

Hand-written: `index.md`, `loading.md`, `downloads.md`, and the FSH not marked `GENERATED`.

The text of the generated pages lives in the script: the page introductions in `make-groups.js`
itself, the section texts in its `CATEGORY_ORDER` and `TYPE_ORDER` tables, and each table row's
description in the resource's FSH `Description:`.

## Build

```
sushi . ; node scripts/make-groups.js . ; sushi .
```

Twice, in that order and separated by `;` rather than `&&`: `make-groups.js` reads the built output
to regenerate the `groups:`, `pages:` and `menu:` blocks of `sushi-config.yaml` and the generated
pages under `input/pagecontent/`, so the resources have to exist before it runs and the config has
to be rebuilt after. The first `sushi` exits non-zero when the groups are stale while still
exporting, which is why `&&` stops the chain.

`scripts/make-codesystems.js .` regenerates `input/fsh/generated/loader-codesystems.fsh` from the
core IG package. It is not part of the routine above — rerun it only when the
`dk.ehealth.sundhed.fhir.ig.core` version in `sushi-config.yaml` changes, and commit the diff.

## Authoring a change

* Branch from the branch the change belongs to, named after the Jira issue (`FUT1-xxxx-short-slug`).
* Make the change in FSH, or in a script for generated files, then run the build above and commit
  the FSH, the script and the regenerated files together.
* Run the publisher (see "Publish locally") and check `output/qa.html`: no new errors or warnings.
* The loader validates the whole package before it loads anything. A change that breaks one of its
  rules fails the load on DEVENVCGI, so check the loader README's "The package" section, and when in
  doubt, run the loader's tests against the new `examples.json.zip`.

Common changes:

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
  "What is generated".
* **A new page**: add the file to `input/pagecontent/` and its entry to the `pageTree` and `menu`
  lists in `make-groups.js`, not to `sushi-config.yaml`.

## Publish locally

```
scripts/publish.sh --offline
```

Runs the IG Publisher (`hl7fhir/ig-publisher-base`) in Docker against the `fhir-cache` volume; see
the comments at the top of the script. `--offline` skips the terminology server, which makes the
run roughly five times as fast (about 11 instead of 55 minutes) but validates codes against cached
expansions only, so check findings without it before trusting them. Output lands in `output/`, and
`output/qa.html` is the validation report. The log is written to `publisher-run.log`.

To see the result locally:

```
docker run --rm -p 8080:80 -v "$(pwd)/output:/usr/share/nginx/html:ro" nginx
```

and open http://localhost:8080.

## Releasing

Every new version of the core IG (`dk.ehealth.sundhed.fhir.ig.core`) is followed by a new version of
this guide:

1. Set the new core IG version under `dependencies:` in `sushi-config.yaml`, and raise `version:`.
2. Run `scripts/make-codesystems.js .`, then the build.
3. Publish locally and check `output/qa.html`: the data must still validate against the new profiles.
4. Publish the new version.

Not set up yet: publishing the guide to `https://ehealth.sundhed.dk/fhir/testdata/<version>` is
left for a separate task.

## Gotchas

* **Do not hand-edit generated files.** The next run of their script reverts the edit without a
  warning. See "What is generated".
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
