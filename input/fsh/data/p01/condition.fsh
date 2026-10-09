Instance: p01-eoc1-cond
InstanceOf: ehealth-condition
Usage: #example
Title: "Chronic obstructive pulmonary disease (completed episode)"
Description: "The COPD diagnosis as recorded under the completed episode of care. The same diagnosis as the other Condition: each episode carries its own, because a Condition can reference only one episode."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference(p01-eoc1)
* clinicalStatus = $condition-clinical#active "active"
* code = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* subject = Reference(p01)

// ─── the other six patients ─────────────────────────────────────────────────────────────────────
// Same rule set as the open episodes' Conditions — clinicalStatus is active here too.

Instance: p01-eoc2-cond
InstanceOf: ehealth-condition
Usage: #example
Title: "Chronic obstructive pulmonary disease"
Description: "The COPD diagnosis the episode of care addresses and the monitoring plan responds to."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
// The profile names this slice episodeOfCare, so use the slice rather than a raw url — mixing the
// two forms in one project is what produced empty extension stubs in the earlier conversion.
* extension[episodeOfCare].valueReference = Reference(p01-eoc2)
* clinicalStatus = $condition-clinical#active "active"
* code = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* subject = Reference(p01)

// ─── the other nine patients ────────────────────────────────────────────────────────────────────
// Nothing distinguishes one of these from another but the episode it names, so a patient with
// four open episodes carries four Conditions recording the same DJ44.
