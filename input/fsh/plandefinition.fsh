// PlanDefinition — LOADABLE.
//
// A COPD monitoring plan: oxygen saturation and pulse from a single pulse-oximeter reading, and a
// symptom questionnaire. It exists in two branches, and the difference between them is the whole
// design.
//
// STRUCTURE — two top-level head activities, both groupingBehavior=visual-group:
//
//   (1) "Målinger og spørgeskema" — SCHEDULED:
//           mon/wed/fri, opening 08:00, 4-hour window, frequency 1
//       The timing is repeated verbatim on the container and on all six children. It is NOT
//       inherited: an action with no timing of its own is unscheduled, whatever its parent says.
//       The children run in a chain:
//           introduktion -> måling af iltmætning og puls -> forberedelse
//               -> iltmætning og pulsmåling (SDG) -> { iltmætning, puls }
//               -> spørgeskema -> afrunding
//
//   (2) "Ekstra målinger og spørgeskema" — UNSCHEDULED. No timing on any of its five actions, and
//       no guidance either: measurement and questionnaire only, for a patient who already performs
//       this three times a week.
//
// WHY TWO BRANCHES. Occurrences are derived from a ServiceRequest's timing, so a scheduled action
// accrues an expected occurrence every Monday, Wednesday and Friday whether or not anything is
// submitted against it. An unscheduled action expects nothing. Submitting against the extra branch
// therefore records a measurement without also creating an outstanding one.
//
// ONE SUBMISSION AGAINST THE EXTRA BRANCH YIELDS one questionnaire response and two observations.
// The two observations come from the SDG group — "Same device group" — where one device and one
// patient action produce two values. No weight activity, and so no reference-value Goal: the
// saturation and pulse thresholds are absolute and need no baseline to be measured against.
//
// SEQUENCING is a linked list rather than document order: the first child of each group is
// relatedAction after-start its container, and every later sibling is after-end the previous one.
// The one departure is inside the SDG group, where BOTH observations are after-start the group —
// a single device reading produces them together, not one after the other.
//
// A CarePlan built from this plan must carry the action.id values below as its activity.id values;
// that is what ties each service request to the action it realises.

Instance: plandefinition
InstanceOf: ehealth-plandefinition
Usage: #example
Title: "Målinger og spørgeskema (iltmætning, puls og spørgeskema)"
Description: "COPD monitoring plan with a scheduled mon/wed/fri branch and an unscheduled extra branch, each carrying the saturation and pulse device group and the symptom questionnaire. One submission against the extra branch yields one questionnaire response and two observations."
* extension[modifierRole][0].extension[reference].valueReference = Reference(org-region-midtjylland)
* extension[modifierRole][0].extension[role].valueCodeableConcept = $modifier-role#owner
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:cab889d1-e01e-4d38-9a5d-ed050722a6b3"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[baseEnvironment].valueIdentifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[baseEnvironment].valueIdentifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Målinger og spørgeskema"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:b7510240-987f-4ec9-8436-a0af44bbe271"
* version = "1.0"
* title = "Målinger og spørgeskema (iltmætning, puls og spørgeskema)"
* status = #active
// PLACEHOLDER: the programme. See aliases.fsh.
* useContext[0].code = $usage-context-type#focus
* useContext[0].valueCodeableConcept = urn:oid:1.2.208.176.2.4#DJ44 "Kronisk obstruktiv lungesygdom"
* useContext[+].code = $usage-context-type#program
* useContext[=].valueCodeableConcept = $ehealth-program#"${EHEALTH_PROGRAM}"
* jurisdiction = $jurisdiction#healthcare-act
* purpose = "Spørgeskema samt iltmætning og puls, planlagt og ekstra."

// (1) SCHEDULED branch — mon/wed/fri 08:00, 4-hour window, repeated on every action.

* action[0].id = "d8d2c923-8157-455c-bbd2-f2df7c92e26c"
* action[0].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].extension.valueBoolean = false
* action[0].title = "Målinger og spørgeskema"
* action[0].timingTiming.repeat.duration = 4
* action[0].timingTiming.repeat.durationUnit = #h
* action[0].timingTiming.repeat.frequency = 1
* action[0].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].groupingBehavior = #visual-group
* action[0].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-head"

* action[0].action[0].id = "a9c477ac-f301-462c-bcf9-e4e44bfd4320"
* action[0].action[0].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].action[0].extension.valueBoolean = false
* action[0].action[0].title = "Introduktion"
* action[0].action[0].relatedAction.actionId = "d8d2c923-8157-455c-bbd2-f2df7c92e26c"
* action[0].action[0].relatedAction.relationship = #after-start
* action[0].action[0].timingTiming.repeat.duration = 4
* action[0].action[0].timingTiming.repeat.durationUnit = #h
* action[0].action[0].timingTiming.repeat.frequency = 1
* action[0].action[0].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].action[0].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].action[0].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].action[0].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].action[0].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-intro"

* action[0].action[1].id = "7a482753-5424-4d30-a28a-4ab9c120de47"
* action[0].action[1].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].action[1].extension.valueBoolean = false
* action[0].action[1].title = "Måling af iltmætning og puls"
* action[0].action[1].relatedAction.actionId = "a9c477ac-f301-462c-bcf9-e4e44bfd4320"
* action[0].action[1].relatedAction.relationship = #after-end
* action[0].action[1].timingTiming.repeat.duration = 4
* action[0].action[1].timingTiming.repeat.durationUnit = #h
* action[0].action[1].timingTiming.repeat.frequency = 1
* action[0].action[1].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].action[1].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].action[1].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].action[1].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].action[1].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-sat-pulse-intro"

* action[0].action[2].id = "0fa646b6-b48f-4c09-83fa-ff2b33b1763c"
* action[0].action[2].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].action[2].extension.valueBoolean = false
* action[0].action[2].title = "Forberedelse"
* action[0].action[2].relatedAction.actionId = "7a482753-5424-4d30-a28a-4ab9c120de47"
* action[0].action[2].relatedAction.relationship = #after-end
* action[0].action[2].timingTiming.repeat.duration = 4
* action[0].action[2].timingTiming.repeat.durationUnit = #h
* action[0].action[2].timingTiming.repeat.frequency = 1
* action[0].action[2].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].action[2].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].action[2].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].action[2].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].action[2].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-sat-pulse-prep"

// The SDG group. Its two observations are both after-start the group rather than after-end
// each other: one pulse-oximeter reading yields both values at once.
* action[0].action[3].id = "c8a78fad-4a60-4c0c-85bf-674a6e86d86f"
* action[0].action[3].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].action[3].extension.valueBoolean = false
* action[0].action[3].title = "Iltmætning og pulsmåling"
* action[0].action[3].relatedAction.actionId = "0fa646b6-b48f-4c09-83fa-ff2b33b1763c"
* action[0].action[3].relatedAction.relationship = #after-end
* action[0].action[3].timingTiming.repeat.duration = 4
* action[0].action[3].timingTiming.repeat.durationUnit = #h
* action[0].action[3].timingTiming.repeat.frequency = 1
* action[0].action[3].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].action[3].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].action[3].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].action[3].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].action[3].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-sat-pulse"

* action[0].action[3].action[0].id = "701ab1f7-23fe-4ff2-9e4b-d2f2623e22c7"
* action[0].action[3].action[0].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].action[3].action[0].extension.valueBoolean = false
* action[0].action[3].action[0].title = "Iltmætning"
* action[0].action[3].action[0].relatedAction.actionId = "c8a78fad-4a60-4c0c-85bf-674a6e86d86f"
* action[0].action[3].action[0].relatedAction.relationship = #after-start
* action[0].action[3].action[0].timingTiming.repeat.duration = 4
* action[0].action[3].action[0].timingTiming.repeat.durationUnit = #h
* action[0].action[3].action[0].timingTiming.repeat.frequency = 1
* action[0].action[3].action[0].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].action[3].action[0].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].action[3].action[0].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].action[3].action[0].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].action[3].action[0].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-saturation"

* action[0].action[3].action[1].id = "6a152290-db57-4f13-b7bf-92f09e0f09e7"
* action[0].action[3].action[1].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].action[3].action[1].extension.valueBoolean = false
* action[0].action[3].action[1].title = "Puls"
* action[0].action[3].action[1].relatedAction.actionId = "c8a78fad-4a60-4c0c-85bf-674a6e86d86f"
* action[0].action[3].action[1].relatedAction.relationship = #after-start
* action[0].action[3].action[1].timingTiming.repeat.duration = 4
* action[0].action[3].action[1].timingTiming.repeat.durationUnit = #h
* action[0].action[3].action[1].timingTiming.repeat.frequency = 1
* action[0].action[3].action[1].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].action[3].action[1].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].action[3].action[1].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].action[3].action[1].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].action[3].action[1].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-pulse"

* action[0].action[4].id = "5dbb9ca9-01fa-42d5-afcf-b42dff5fc78b"
* action[0].action[4].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].action[4].extension.valueBoolean = false
* action[0].action[4].title = "Spørgeskema om tilstand og symptomer"
* action[0].action[4].relatedAction.actionId = "c8a78fad-4a60-4c0c-85bf-674a6e86d86f"
* action[0].action[4].relatedAction.relationship = #after-end
* action[0].action[4].timingTiming.repeat.duration = 4
* action[0].action[4].timingTiming.repeat.durationUnit = #h
* action[0].action[4].timingTiming.repeat.frequency = 1
* action[0].action[4].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].action[4].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].action[4].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].action[4].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].action[4].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-questionnaire"

* action[0].action[5].id = "de176506-1b2e-4736-a30f-98839969c5d7"
* action[0].action[5].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[0].action[5].extension.valueBoolean = false
* action[0].action[5].title = "Afrunding"
* action[0].action[5].relatedAction.actionId = "5dbb9ca9-01fa-42d5-afcf-b42dff5fc78b"
* action[0].action[5].relatedAction.relationship = #after-end
* action[0].action[5].timingTiming.repeat.duration = 4
* action[0].action[5].timingTiming.repeat.durationUnit = #h
* action[0].action[5].timingTiming.repeat.frequency = 1
* action[0].action[5].timingTiming.repeat.dayOfWeek[0] = #mon
* action[0].action[5].timingTiming.repeat.dayOfWeek[+] = #wed
* action[0].action[5].timingTiming.repeat.dayOfWeek[+] = #fri
* action[0].action[5].timingTiming.repeat.timeOfDay = "08:00:00"
* action[0].action[5].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-closing"

// (2) EXTRA branch — NO timing on any action. Submissions go here, so that
//     missing-measurement can derive no expected occurrence and nothing falls overdue.

* action[1].id = "0ee4c15b-a7b1-40dd-9e44-c1c4238a1dda"
* action[1].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[1].extension.valueBoolean = false
* action[1].title = "Ekstra målinger og spørgeskema"
* action[1].groupingBehavior = #visual-group
* action[1].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-extra-head"

* action[1].action[0].id = "8d76df58-da9f-4096-8e05-a66ebcc13af4"
* action[1].action[0].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[1].action[0].extension.valueBoolean = false
* action[1].action[0].title = "Iltmætning og pulsmåling"
* action[1].action[0].relatedAction.actionId = "0ee4c15b-a7b1-40dd-9e44-c1c4238a1dda"
* action[1].action[0].relatedAction.relationship = #after-start
* action[1].action[0].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-extra-sat-pulse"

* action[1].action[0].action[0].id = "404a936e-89b2-4a6a-ae55-0a54bcea27db"
* action[1].action[0].action[0].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[1].action[0].action[0].extension.valueBoolean = false
* action[1].action[0].action[0].title = "Iltmætning"
* action[1].action[0].action[0].relatedAction.actionId = "8d76df58-da9f-4096-8e05-a66ebcc13af4"
* action[1].action[0].action[0].relatedAction.relationship = #after-start
* action[1].action[0].action[0].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-extra-saturation"

* action[1].action[0].action[1].id = "18dc30db-88f6-4235-b08a-4cfabed13ee7"
* action[1].action[0].action[1].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[1].action[0].action[1].extension.valueBoolean = false
* action[1].action[0].action[1].title = "Puls"
* action[1].action[0].action[1].relatedAction.actionId = "8d76df58-da9f-4096-8e05-a66ebcc13af4"
* action[1].action[0].action[1].relatedAction.relationship = #after-start
* action[1].action[0].action[1].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-extra-pulse"

* action[1].action[1].id = "53ffbcbf-5467-41ee-82fb-bde6ea4d0d07"
* action[1].action[1].extension.url = "http://ehealth.sundhed.dk/fhir/StructureDefinition/ehealth-include-as-extra"
* action[1].action[1].extension.valueBoolean = false
* action[1].action[1].title = "Spørgeskema om tilstand og symptomer"
* action[1].action[1].relatedAction.actionId = "8d76df58-da9f-4096-8e05-a66ebcc13af4"
* action[1].action[1].relatedAction.relationship = #after-end
* action[1].action[1].definitionCanonical = "http://ehealth.sundhed.dk/fhir/testdata/ActivityDefinition/ad-extra-questionnaire"
