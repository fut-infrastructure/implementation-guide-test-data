// Provenances — ONE PER SUBMISSION, and the reason anything happens afterwards.
//
// A Provenance under the policy coherent-submitted-measurement is what the submit operation
// records, and it is also the TRIGGER for automated processing: the measurement-received queue
// watches for it, and triage runs because one appeared. Without it the observations and the
// questionnaire response are just stored data and nothing is triaged.
//
// ONE PROVENANCE COVERS THE WHOLE SUBMISSION, not one per resource. Production shows a single
// Provenance with several targets — an Observation and a QuestionnaireResponse submitted together
// under one record. So each of these names all three resources of its submission: two
// observations and one questionnaire response.
//
// THAT IS NOT THE SAME AS ONE TRIAGE RUN. The rules each take exactly one input — the observation
// rule throws "Forventede præcis en måling" on more than one, and the questionnaire rule
// "Flere input. Forventede én spørgeskemabesvarelse". So one submission of three resources is one
// Provenance and three triage runs, giving three ClinicalImpressions and three Tasks.
//
// entity LISTS WHAT THE SUBMISSION WAS AGAINST, each with role `quotation`: the service requests
// used, and the episode of care. Production includes both, so both are here.
//
// agent IS THE PATIENT. These are patient-submitted measurements, so the patient is the only
// agent, and production records it with no agent type.
//
// THE EXPECTED TRIAGE RESULT OF EACH SUBMISSION, derived from the values and answers:
//
//   open episode       saturation 96 %   green   routine
//                      pulse 72/min      green   routine
//                      questionnaire     green   routine
//   completed episode  saturation 84 %   red     asap
//                      pulse 118/min     yellow  urgent
//                      questionnaire     red     asap
//
// The guide does not carry those ClinicalImpressions and Tasks: the environment creates them when
// these Provenances trigger processing, and they can be compared against the table above.

RuleSet: SubmitProvenance(episode, qr, obsSat, obsPulse, srQ, srSat, srPulse, recorded)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* target[0] = Reference({qr})
* target[+] = Reference({obsSat})
* target[+] = Reference({obsPulse})
* recorded = "{recorded}"
* policy = "http://ehealth.sundhed.dk/policy/ehealth/coherent-submitted-measurement"
* agent.who = Reference(patient)
* entity[0].role = #quotation
* entity[=].what = Reference({srQ})
* entity[+].role = #quotation
* entity[=].what = Reference({srSat})
* entity[+].role = #quotation
* entity[=].what = Reference({srPulse})
* entity[+].role = #quotation
* entity[=].what = Reference({episode})

Instance: provenance
InstanceOf: ehealth-provenance
Usage: #example
Title: "Submission under the open episode"
Description: "The submit record for the open episode: one questionnaire response and two observations, submitted together against the unscheduled branch. This is what triggers automated processing, which should triage all three green with routine tasks."
* insert SubmitProvenance(episodeofcare, questionnaireresponse, observation-saturation, observation-pulse, sr-extra-questionnaire, sr-extra-saturation, sr-extra-pulse, 2026-01-12T08:30:05+00:00)

Instance: provenance-completed
InstanceOf: ehealth-provenance
Usage: #example
Title: "Submission under the completed episode"
Description: "The submit record for the completed episode, made while the plan was still active in May 2025. Triage should return red for the saturation and the questionnaire, and yellow for the pulse."
* insert SubmitProvenance(episodeofcare-completed, questionnaireresponse-completed, observation-saturation-completed, observation-pulse-completed, sr-completed-extra-questionnaire, sr-completed-extra-saturation, sr-completed-extra-pulse, 2025-05-14T10:00:05+00:00)
