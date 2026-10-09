// ServiceRequests — ONE PER ACTIVITY DEFINITION. Rule sets only; the instances are under data/.
//
// $apply creates one of these for every activity in the plan, not only the submittable ones.
// Measured against a production care plan with 9 activities: 9 ServiceRequests, including the
// head-activity containers and the instruction screens. So this plan's 14 activities give 14
// ServiceRequests, and careplan.fsh lists all 14 in its activity array.
//
// THE LINK RUNS ONE WAY ONLY. ServiceRequest.basedOn is constrained to 0..0 by the profile, so a
// request never points back at its care plan; the plan points at the request through
// activity.reference. Each request names its ActivityDefinition through instantiatesCanonical.
//
// WHY A MEASUREMENT CANNOT BE SUBMITTED WITHOUT ONE: triage runs against a ServiceRequest. Both
// automated-processing rules take one as input and use its id when reporting a mismatch, and the
// reference ranges the observation rule compares against are carried here, copied from the
// activity definition. Without these, there is nothing for an Observation or a
// QuestionnaireResponse to be submitted against.
//
// WHAT VARIES, AND WHAT DOES NOT. From the production example, uniform across every request:
// sharingPolicy, triggerEnablementCode NO_TRIGGER, intent order, and an occurrenceTiming whose
// repeat always carries a boundsPeriod. Varying:
//   * the AD's own timing is copied in only when the activity has one — so the nine scheduled
//     activities carry mon/wed/fri 08:00 for 4h and the five extra ones carry bounds alone
//   * sharingApprovalPolicy `manual` appears only on the submittable activities, the two
//     measurements and the questionnaire, never on containers or instruction screens
//   * referenceRange is copied from the measurement activities, reusing the same RuleSets
//     activitydefinition.fsh defines
//   * includeAsExtra marks the unscheduled branch — see servicerequest-extra below
//
// THE BOUNDS END IS A SENTINEL. Production uses 2099-12-31T23:00:00+00:00 to mean open-ended
// rather than omitting the end, and that is copied here rather than tidied.
//
// A COMPLETED PLAN'S REQUESTS differ in three ways: status and statusHistory are completed rather
// than active, the dates are the finished episode's, and the bounds are CLOSED at the moment the
// plan completed instead of carrying the sentinel. That last one is an inference, not an
// observation — the production care plan available for comparison was completed but its
// ServiceRequests were not included. Closing them is consistent with the plan no longer accepting
// submissions; if the environment turns out to leave the sentinel in place, change it here.

RuleSet: SRCommon(episode, srstatus, start)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference({episode})
* extension[sharingPolicy].valueCodeableConcept = $measurement-sharing-policies#sharingAllowedDestinationNationalHealthData
* extension[triggerEnablementCode].valueCode = #NO_TRIGGER
* extension[statusHistory].extension[status].valueCodeableConcept = $request-status#{srstatus}
* extension[statusHistory].extension[period].valuePeriod.start = "{start}"
* status = #{srstatus}
* intent = #order
* subject = Reference(p01)

// The schedule the plan's first branch runs on, copied from the activity definitions.
RuleSet: SRScheduled
* occurrenceTiming.repeat.duration = 4
* occurrenceTiming.repeat.durationUnit = #h
* occurrenceTiming.repeat.frequency = 1
* occurrenceTiming.repeat.dayOfWeek[0] = #mon
* occurrenceTiming.repeat.dayOfWeek[+] = #wed
* occurrenceTiming.repeat.dayOfWeek[+] = #fri
* occurrenceTiming.repeat.timeOfDay = "08:00:00"

RuleSet: SRBounds(boundsStart, boundsEnd)
* occurrenceTiming.repeat.boundsPeriod.start = "{boundsStart}"
* occurrenceTiming.repeat.boundsPeriod.end = "{boundsEnd}"

// Only the activities a patient actually submits against carry an approval policy.
RuleSet: SRSubmittable
* extension[sharingApprovalPolicy].valueCodeableConcept = $measurement-sharing-approval-policies#manual
