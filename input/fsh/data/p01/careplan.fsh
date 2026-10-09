Instance: p01-cp1
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan (completed)"
Description: "The monitoring plan as delivered under the completed episode of care, which ran from March to June 2025. Status completed, with the full status history and — following the environment's behaviour — a period that is left open."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference(p01-eoc1)
* extension[statusHistory][0].extension[status].valueCodeableConcept = $request-status#draft
* extension[statusHistory][=].extension[period].valuePeriod.start = "2025-03-03T09:05:00+00:00"
* extension[statusHistory][=].extension[period].valuePeriod.end = "2025-03-03T09:05:01+00:00"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#active
* extension[statusHistory][=].extension[period].valuePeriod.start = "2025-03-03T09:05:01+00:00"
* extension[statusHistory][=].extension[period].valuePeriod.end = "2025-06-30T11:55:00+00:00"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#completed
* extension[statusHistory][=].extension[period].valuePeriod.start = "2025-06-30T11:55:00+00:00"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam-placeholder)
* extension[teamHistory].extension[period].valuePeriod.start = "2025-03-03T09:05:00+00:00"
* extension[teamHistory].extension[period].valuePeriod.end = "2025-06-30T11:55:00+00:00"
* instantiatesCanonical = Canonical(plandefinition)
* status = #completed
* intent = #order
* subject = Reference(p01)
* period.start = "2025-03-03T09:05:00+00:00"
* careTeam = Reference(careteam-placeholder)
* addresses = Reference(p01-eoc1-cond)
// One entry per activity, in the order the plan runs them. See servicerequest.fsh.
* activity[0].reference = Reference(p01-cp1-sr-head)
* activity[+].reference = Reference(p01-cp1-sr-intro)
* activity[+].reference = Reference(p01-cp1-sr-sat-pulse-intro)
* activity[+].reference = Reference(p01-cp1-sr-sat-pulse-prep)
* activity[+].reference = Reference(p01-cp1-sr-sat-pulse)
* activity[+].reference = Reference(p01-cp1-sr-saturation)
* activity[+].reference = Reference(p01-cp1-sr-pulse)
* activity[+].reference = Reference(p01-cp1-sr-questionnaire)
* activity[+].reference = Reference(p01-cp1-sr-closing)
* activity[+].reference = Reference(p01-cp1-sr-extra-head)
* activity[+].reference = Reference(p01-cp1-sr-extra-sat-pulse)
* activity[+].reference = Reference(p01-cp1-sr-extra-saturation)
* activity[+].reference = Reference(p01-cp1-sr-extra-pulse)
* activity[+].reference = Reference(p01-cp1-sr-extra-questionnaire)

// ─── the other six patients ─────────────────────────────────────────────────────────────────────

Instance: p01-cp2
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan (active)"
Description: "The monitoring plan as delivered under the open episode of care. Normally created by $apply, which would also create one ServiceRequest per activity."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference(p01-eoc2)
* extension[statusHistory][0].extension[status].valueCodeableConcept = $request-status#draft
* extension[statusHistory][=].extension[period].valuePeriod.start = "2026-01-08T09:05:00+00:00"
* extension[statusHistory][=].extension[period].valuePeriod.end = "2026-01-08T09:05:01+00:00"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#active
* extension[statusHistory][=].extension[period].valuePeriod.start = "2026-01-08T09:05:01+00:00"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam-placeholder)
* extension[teamHistory].extension[period].valuePeriod.start = "2026-01-08T09:05:00+00:00"
* instantiatesCanonical = Canonical(plandefinition)
* status = #active
* intent = #order
* subject = Reference(p01)
* period.start = "2026-01-08T09:05:00+00:00"
* careTeam = Reference(careteam-placeholder)
* addresses = Reference(p01-eoc2-cond)
// One entry per activity, in the order the plan runs them. See servicerequest.fsh.
* activity[0].reference = Reference(p01-cp2-sr-head)
* activity[+].reference = Reference(p01-cp2-sr-intro)
* activity[+].reference = Reference(p01-cp2-sr-sat-pulse-intro)
* activity[+].reference = Reference(p01-cp2-sr-sat-pulse-prep)
* activity[+].reference = Reference(p01-cp2-sr-sat-pulse)
* activity[+].reference = Reference(p01-cp2-sr-saturation)
* activity[+].reference = Reference(p01-cp2-sr-pulse)
* activity[+].reference = Reference(p01-cp2-sr-questionnaire)
* activity[+].reference = Reference(p01-cp2-sr-closing)
* activity[+].reference = Reference(p01-cp2-sr-extra-head)
* activity[+].reference = Reference(p01-cp2-sr-extra-sat-pulse)
* activity[+].reference = Reference(p01-cp2-sr-extra-saturation)
* activity[+].reference = Reference(p01-cp2-sr-extra-pulse)
* activity[+].reference = Reference(p01-cp2-sr-extra-questionnaire)

// ─── the other nine patients ────────────────────────────────────────────────────────────────────
// No activity list yet: the ServiceRequests these plans consist of are a later step, and
// CarePlan.activity is 0..* so the plans are valid without it.
