// ServiceRequests for the OPEN episode's care plan — ONE PER ACTIVITY DEFINITION.
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

// ─── the scheduled branch: nine requests, mon/wed/fri 08:00 ─────────────────────────────────────

Instance: p01-cp2-sr-head
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Head activity (scheduled)"
Description: "The container for the scheduled branch. Nothing is submitted against it; it groups the activities below."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-head)
* code = $activitydefinition-code#HA

Instance: p01-cp2-sr-intro
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Introduction (scheduled)"
Description: "Guidance screen shown at the start of the scheduled measurement round."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-intro)
* code = $activitydefinition-code#409073007

Instance: p01-cp2-sr-sat-pulse-intro
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Saturation and pulse introduction (scheduled)"
Description: "Guidance screen introducing the saturation and pulse measurements."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-sat-pulse-intro)
* code = $activitydefinition-code#409073007

Instance: p01-cp2-sr-sat-pulse-prep
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Saturation and pulse preparation (scheduled)"
Description: "Guidance screen telling the patient how to prepare before measuring."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-sat-pulse-prep)
* code = $activitydefinition-code#409073007

Instance: p01-cp2-sr-sat-pulse
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Saturation and pulse device group (scheduled)"
Description: "Groups the saturation and pulse measurements as one device group, so both are taken from the same device in one go."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-sat-pulse)
* code = $activitydefinition-code#SDG

Instance: p01-cp2-sr-saturation
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Oxygen saturation (scheduled)"
Description: "The scheduled oxygen saturation measurement. Carries the absolute reference ranges its triage rule compares a submitted value against: red at or below 85%, yellow from 85% to 88%."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* insert SRSubmittable
* insert SaturationRanges
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-saturation)
* code = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"

Instance: p01-cp2-sr-pulse
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Pulse (scheduled)"
Description: "The scheduled pulse measurement. Carries four absolute reference ranges, so both a low and a high value triage red: red at or below 50/min and at or above 130/min, yellow in between."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* insert SRSubmittable
* insert PulseRanges
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-pulse)
* code = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"

Instance: p01-cp2-sr-questionnaire
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Questionnaire (scheduled)"
Description: "The scheduled symptom questionnaire. A questionnaire response is submitted against this request and triaged on its answer significance."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* insert SRSubmittable
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-questionnaire)
* code = $activitydefinition-code#273586006

Instance: p01-cp2-sr-closing
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Closing (scheduled)"
Description: "Guidance screen shown after the scheduled round is complete."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-closing)
* code = $activitydefinition-code#409073007

// ─── the extra branch: five requests, no schedule ───────────────────────────────────────────────
// includeAsExtra is true and there is no timing beyond the bounds, which is what lets a submission
// against these happen at any time rather than inside a scheduled window. That is the whole reason
// the plan has this branch: a test submission need not wait for a Monday.

Instance: p01-cp2-sr-extra-head
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Head activity (extra)"
Description: "The container for the unscheduled branch."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-head)
* code = $activitydefinition-code#HA

Instance: p01-cp2-sr-extra-sat-pulse
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Saturation and pulse device group (extra)"
Description: "Groups the unscheduled saturation and pulse measurements as one device group."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-sat-pulse)
* code = $activitydefinition-code#SDG

Instance: p01-cp2-sr-extra-saturation
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Oxygen saturation (extra)"
Description: "The unscheduled oxygen saturation measurement, with the same absolute reference ranges as the scheduled one. A submission against this request can be made at any time."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRSubmittable
* insert SaturationRanges
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-saturation)
* code = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"

Instance: p01-cp2-sr-extra-pulse
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Pulse (extra)"
Description: "The unscheduled pulse measurement, with the same four absolute reference ranges as the scheduled one."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRSubmittable
* insert PulseRanges
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-pulse)
* code = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"

Instance: p01-cp2-sr-extra-questionnaire
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Questionnaire (extra)"
Description: "The unscheduled symptom questionnaire. This is the request a test questionnaire response is most easily submitted against, since it is not bound to a window."
* insert SRCommon(p01-eoc2, active, 2026-01-08T09:05:00+00:00)
* insert SRBounds(2026-01-08T09:05:00+00:00, 2099-12-31T23:00:00+00:00)
* insert SRSubmittable
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-questionnaire)
* code = $activitydefinition-code#273586006
