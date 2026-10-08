### FUT test data

Test data resources for the Danish eHealth Infrastructure. Every resource here is an instance of a
profile published in the
[eHealth Infrastructure Implementation Guide](http://ehealth.sundhed.dk/fhir) — this guide defines
no profiles, extensions, code systems or value sets of its own.

See the [Artifacts Summary](artifacts-grouped.html) for the full list.

#### What is here

A COPD monitoring plan and everything it needs: oxygen saturation and pulse from a single
pulse-oximeter reading, and a symptom questionnaire. The plan has a scheduled branch and an
unscheduled one, and the difference between them is the design — a scheduled activity accrues an
expected occurrence whether or not anything is submitted against it, while an unscheduled activity
expects nothing.

#### Loading

Two kinds of resource appear here, and the distinction is not declared anywhere in this guide:

* most resources are **created** on the target environment by the data loader
* `Organization`, `Practitioner`, `PractitionerRole` and `Patient` are **resolved** there instead —
  they are expected to exist already, and the loader finds each by identifier and rewrites the
  references accordingly

The loader decides which is which from the resource **type**, so nothing in the ids, titles or file
layout marks it.

#### Placeholders

Values written as `${NAME}` are substituted by the loader at load time. Each takes its value from
the target environment, and the ones that are codes draw on a code system defined elsewhere.

**Environment values** — these belong to the deployment, not to the test data. Both take a code
from a code system the core IG defines, so the candidate values are published there rather than
restated here:

* `${EHEALTH_PROGRAM}` — the programme these definitions belong to. It names the deployment being
  loaded for, so it cannot be fixed in the guide.
  Codes: [eHealth Program](http://ehealth.sundhed.dk/fhir/CodeSystem-ehealth-program.html)
* `${COEXISTENCE_TAG}` — the coexistence tag in `meta.tag`, marking which deployment owns the
  record. Carried by the patient-specific resources only; the definitions do not have it.
  Codes: [Ehealth System](http://ehealth.sundhed.dk/fhir/CodeSystem-ehealth-system.html)

Both code systems declare `content: complete`, so each lists every code valid **for the version of
the core IG this guide depends on**. A deployment running a newer core IG may have more — which is
the reason these are placeholders and not a fixed value.

The patients have **no** placeholders. There are ten of them, each a concrete test identity read
back from the target environment, so the CPR the loader resolves by is a real value that already
exists there. 

**Organization-data values** — the care team and the practitioner on it already exist on the target
environment and are resolved there, so their identities belong to it:

* `${CARETEAM_IDENTIFIER}`
* `${PRACTITIONER_IDENTIFIER}`, `${PRACTITIONER_FAMILY_NAME}`, `${PRACTITIONER_GIVEN_NAME}`,
  `${PRACTITIONER_AUTHORISATION_ID}`
* `${PROFESSION_GROUP}` — the practitioner's profession.
  Codes: [DkCoreProfessionGroupCodes](http://hl7.dk/fhir/core/CodeSystem-DkCoreProfessionGroupCodes.html),
  defined by hl7.fhir.dk.core rather than by the eHealth core IG

#### What a placeholder costs

Not every element can hold one, and the guide carries validation errors where it does anyway.

* **Free** — a plain string with no constraint beyond its type: the practitioner's name and
  identifier, the care team's UUID. These validate exactly as a real value would.
* **A validation error per occurrence** — a *coded* element, because the validator looks the code
  up in its code system and does not find it: `${EHEALTH_PROGRAM}`, `${COEXISTENCE_TAG}` and
  `${PROFESSION_GROUP}`.
* **Impossible** — a string whose constraint no placeholder can satisfy. The practitioner's
  authorisation number is capped at five characters drawn from the consonants, Y and the digits,
  and `${X}` is already four. That element is left out instead.

Where a constraint merely dictates the *shape*, the placeholder moves inside it rather than being
abandoned: the care team's identifier is `urn:uuid:${CARETEAM_UUID}`, because `dk-core` requires a
full URI and only the UUID is actually environment-specific.

None of these errors can be suppressed — the publisher's suppression file covers warnings and
hints only.
