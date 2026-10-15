# implementation-guide-test-data

FUT test data as a FHIR IG. Every resource is an instance of a profile from
`dk.ehealth.sundhed.fhir.ig.core`; this guide defines no conformance resources of its own.

## Layout

```
input/fsh/
  aliases.fsh             aliases, and what each ${PLACEHOLDER} means
  loader-settings.fsh     the anchor date the dates in the data are relative to
  generated/              written by scripts/, committed, not hand-edited
  shared/                 instances every patient and vendor shares
  types/                  per resource type: the documentation and the rule sets
  vendor/<code>/          one care team and one practitioner per coexistence tag
  data/pNN/               the transactions, one file per resource type
```

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

## Publish

```
scripts/publish.sh --offline
```

Runs the IG Publisher in Docker against the `fhir-cache` volume; see the comments at the top of the
script. `--offline` skips the terminology server, which makes the run roughly twice as fast but
validates codes against cached expansions only, so check findings without it before trusting them.
Output lands in `output/`, and `output/qa.html` is the validation report.
