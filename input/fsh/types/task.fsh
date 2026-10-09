// Tasks — THE OTHER HALF OF WHAT TRIAGE PRODUCES. Not loaded; expected results.
//
// One per ClinicalImpression, created in the same triage run. Like the impressions, these are not
// input: the environment creates them when a Provenance triggers automated processing, and these
// six are what it should create. See clinicalimpression.fsh.
//
// focus POINTS AT THE ClinicalImpression, not at the measurement. That is worth stating plainly
// because the obvious guess is wrong — the task is a request to assess the triage result, so it
// focuses on the result. Production confirms it: of eighteen tasks examined, the six
// MeasurementForAssessment ones all focus on a ClinicalImpression, while the twelve
// MissingMeasurementResolving ones focus on a ServiceRequest instead.
//
// THE DESCRIPTION DIFFERS BY WHAT WAS TRIAGED, and both strings come from production:
//   "Måling til vurdering"                   a measurement
//   "Spørgeskemabesvarelse til evaluering"   a questionnaire response
// The rule's own Drools sets the first; the questionnaire library sets the second.
//
// PRIORITY IS THE TRIAGE COLOUR. red -> asap, yellow -> urgent, green -> routine. This is the one
// element that varies with the result, and it is why the completed episode's tasks are not all
// routine. status is requested and intent is plan on every one.
//
// taskResponsible IS THE CARE TEAM — the team gets the work, not an individual. restrictionCategory
// is measurement-monitoring throughout, and carePlan points back at the plan the submission was
// made under. All four of episodeOfCare, taskCategory, taskResponsible and restrictionCategory are
// mandatory on the profile, which is why extension is 4..* there.

RuleSet: TriageTask(episode, careplan, focus, priority, when)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference({episode})
* extension[taskCategory].valueCodeableConcept = $task-category#MeasurementForAssessment "Need assessment of measurement"
* extension[restrictionCategory].valueCodeableConcept = $restriction-category#measurement-monitoring "Monitoring of measurement(s)"
* extension[taskResponsible].valueReference = Reference(careteam-placeholder)
* extension[carePlan].valueReference = Reference({careplan})
* status = #requested
* intent = #plan
* priority = #{priority}
* focus = Reference({focus})
* for = Reference(p01)
* authoredOn = "{when}"
