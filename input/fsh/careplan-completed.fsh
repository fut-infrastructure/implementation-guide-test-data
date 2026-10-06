// CarePlan for the COMPLETED episode — the same plan definition, delivered and finished.
//
// The other half of the pair the customer's dataset needs: of 20 care plans, 7 are completed and
// 13 active. This is the completed shape. See careplan.fsh for what $apply would also have built
// and why the activity list is absent.
//
// "COMPLETED" IS `completed` HERE, unlike the episode. CarePlan.status is bound to request-status,
// which has a completed code; EpisodeOfCare.status is bound to episode-of-care-status, which does
// not and uses `finished` instead. The same real-world state, two different codes — see
// episodeofcare-completed.fsh.
//
// THE PERIOD STAYS OPEN even though the plan is completed, and that is deliberate rather than an
// oversight. A production care plan with status completed carried `period` with a start and no
// end: the careplan service does not close the period when the plan completes. The episode's
// period IS closed. Copying the service's behaviour matters more here than internal tidiness,
// because this data is meant to look like what the environment produces.
//
// statusHistory RUNS draft -> active -> completed, each entry closed except the last. The plan
// completes shortly before the episode is finished, which is the real order of events: the
// monitoring stops, then the episode is closed.

Instance: careplan-completed
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan (completed)"
Description: "The monitoring plan as delivered under the completed episode of care, which ran from March to June 2025. Status completed, with the full status history and — following the environment's behaviour — a period that is left open."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference(episodeofcare-completed)
* extension[statusHistory][0].extension[status].valueCodeableConcept = $request-status#draft
* extension[statusHistory][=].extension[period].valuePeriod.start = "2025-03-03T09:05:00+00:00"
* extension[statusHistory][=].extension[period].valuePeriod.end = "2025-03-03T09:05:01+00:00"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#active
* extension[statusHistory][=].extension[period].valuePeriod.start = "2025-03-03T09:05:01+00:00"
* extension[statusHistory][=].extension[period].valuePeriod.end = "2025-06-30T11:55:00+00:00"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#completed
* extension[statusHistory][=].extension[period].valuePeriod.start = "2025-06-30T11:55:00+00:00"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam)
* extension[teamHistory].extension[period].valuePeriod.start = "2025-03-03T09:05:00+00:00"
* extension[teamHistory].extension[period].valuePeriod.end = "2025-06-30T11:55:00+00:00"
* instantiatesCanonical = Canonical(plandefinition)
* status = #completed
* intent = #order
* subject = Reference(patient)
* period.start = "2025-03-03T09:05:00+00:00"
* careTeam = Reference(careteam)
* addresses = Reference(condition-completed)
// One entry per activity, in the order the plan runs them. See servicerequest.fsh.
* activity[0].reference = Reference(sr-completed-head)
* activity[+].reference = Reference(sr-completed-intro)
* activity[+].reference = Reference(sr-completed-sat-pulse-intro)
* activity[+].reference = Reference(sr-completed-sat-pulse-prep)
* activity[+].reference = Reference(sr-completed-sat-pulse)
* activity[+].reference = Reference(sr-completed-saturation)
* activity[+].reference = Reference(sr-completed-pulse)
* activity[+].reference = Reference(sr-completed-questionnaire)
* activity[+].reference = Reference(sr-completed-closing)
* activity[+].reference = Reference(sr-completed-extra-head)
* activity[+].reference = Reference(sr-completed-extra-sat-pulse)
* activity[+].reference = Reference(sr-completed-extra-saturation)
* activity[+].reference = Reference(sr-completed-extra-pulse)
* activity[+].reference = Reference(sr-completed-extra-questionnaire)
