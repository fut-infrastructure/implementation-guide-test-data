### FUT test data

Test data resources for the Danish eHealth Infrastructure. Every resource here is an instance of a
profile published in the
[eHealth Infrastructure Implementation Guide](http://ehealth.sundhed.dk/fhir) — this guide defines
no profiles, extensions, code systems or value sets of its own.

See the [Artifacts Summary](artifacts-grouped.html) for the full list.

#### What is here

Data representing a scenario covering 10 patients with a COPD condition. The patients are enrolled in episodes of care and has been assigned a plan for COPD monitoring.
The COPD monitoring plan schedules observations for oxygen saturation and pulse, and a symptom questionnaire. 
The plans are assigned to a care team with a single practitioner as participant. 
Some data can be shared across vendor solutions, while others are labeled with a coexistence tag which reserves the data for use with the corresponding system vendor.
The scenario carries a placeholder value for the coexistence tag and the corresponding ehealth program code, and the placeholders are substituted when the data is loaded on a specific environment.
The vendor specific part of the scenario is duplicated across coexistence tag values when loaded. 


#### Loading

Loading on an environment is done idempotent. Data is created only if not already present. The target environment will normally be expunged before loading, but the expunge will only transactions (eg clinical data), while context is kept (eg organizations).
Some clinical data present in this IG will not be loaded, but will become present on the target environment as result of the automatic processing doing triage of submitted observations and questionnaire responses.

#### Placeholders

Values written as `${PLACEHOLDER}` are substituted by the loader at load time. 

**Environment values** — these belong to the deployment, not to the test data. Both take a code
from a code system the core IG defines:

* `${EHEALTH_PROGRAM}` — the programme these definitions belong to. It names the deployment being
  loaded for.
  Codes: [eHealth Program](http://ehealth.sundhed.dk/fhir/CodeSystem-ehealth-program.html)
* `${COEXISTENCE_TAG}` — the coexistence tag in `meta.tag`, marking which deployment owns the
  record. Carried by the patient-specific resources only; the definitions do not have it.
  Codes: [eHealth System](http://ehealth.sundhed.dk/fhir/CodeSystem-ehealth-system.html)

