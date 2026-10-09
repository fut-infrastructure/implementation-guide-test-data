Instance: p01-cp1-sr-head
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Head activity (scheduled) — completed"
Description: "The container for the scheduled branch. Nothing is submitted against it; it groups the activities below."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-head)
* code = $activitydefinition-code#HA

Instance: p01-cp1-sr-intro
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Introduction (scheduled) — completed"
Description: "Guidance screen shown at the start of the scheduled measurement round."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-intro)
* code = $activitydefinition-code#409073007

Instance: p01-cp1-sr-sat-pulse-intro
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Saturation and pulse introduction (scheduled) — completed"
Description: "Guidance screen introducing the saturation and pulse measurements."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-sat-pulse-intro)
* code = $activitydefinition-code#409073007

Instance: p01-cp1-sr-sat-pulse-prep
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Saturation and pulse preparation (scheduled) — completed"
Description: "Guidance screen telling the patient how to prepare before measuring."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-sat-pulse-prep)
* code = $activitydefinition-code#409073007

Instance: p01-cp1-sr-sat-pulse
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Saturation and pulse device group (scheduled) — completed"
Description: "Groups the saturation and pulse measurements as one device group, so both are taken from the same device in one go."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-sat-pulse)
* code = $activitydefinition-code#SDG

Instance: p01-cp1-sr-saturation
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Oxygen saturation (scheduled) — completed"
Description: "The scheduled oxygen saturation measurement. Carries the absolute reference ranges its triage rule compares a submitted value against: red at or below 85%, yellow from 85% to 88%."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* insert SRSubmittable
* insert SaturationRanges
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-saturation)
* code = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"

Instance: p01-cp1-sr-pulse
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Pulse (scheduled) — completed"
Description: "The scheduled pulse measurement. Carries four absolute reference ranges, so both a low and a high value triage red: red at or below 50/min and at or above 130/min, yellow in between."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* insert SRSubmittable
* insert PulseRanges
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-pulse)
* code = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"

Instance: p01-cp1-sr-questionnaire
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Questionnaire (scheduled) — completed"
Description: "The scheduled symptom questionnaire. A questionnaire response is submitted against this request and triaged on its answer significance."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* insert SRSubmittable
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-questionnaire)
* code = $activitydefinition-code#273586006

Instance: p01-cp1-sr-closing
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Closing (scheduled) — completed"
Description: "Guidance screen shown after the scheduled round is complete."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRScheduled
* extension[includeAsExtra].valueBoolean = false
* instantiatesCanonical = Canonical(ad-closing)
* code = $activitydefinition-code#409073007

// ─── the extra branch: five requests, no schedule ───────────────────────────────────────────────
// includeAsExtra is true and there is no timing beyond the bounds, which is what lets a submission
// against these happen at any time rather than inside a scheduled window. That is the whole reason
// the plan has this branch: a test submission need not wait for a Monday.

Instance: p01-cp1-sr-extra-head
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Head activity (extra) — completed"
Description: "The container for the unscheduled branch."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-head)
* code = $activitydefinition-code#HA

Instance: p01-cp1-sr-extra-sat-pulse
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Saturation and pulse device group (extra) — completed"
Description: "Groups the unscheduled saturation and pulse measurements as one device group."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-sat-pulse)
* code = $activitydefinition-code#SDG

Instance: p01-cp1-sr-extra-saturation
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Oxygen saturation (extra) — completed"
Description: "The unscheduled oxygen saturation measurement, with the same absolute reference ranges as the scheduled one. A submission against this request can be made at any time."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRSubmittable
* insert SaturationRanges
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-saturation)
* code = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"

Instance: p01-cp1-sr-extra-pulse
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Pulse (extra) — completed"
Description: "The unscheduled pulse measurement, with the same four absolute reference ranges as the scheduled one."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRSubmittable
* insert PulseRanges
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-pulse)
* code = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"

Instance: p01-cp1-sr-extra-questionnaire
InstanceOf: ehealth-servicerequest
Usage: #example
Title: "Questionnaire (extra) — completed"
Description: "The unscheduled symptom questionnaire. This is the request a test questionnaire response is most easily submitted against, since it is not bound to a window."
* insert SRCommon(p01-eoc1, completed, 2025-03-03T09:05:00+00:00)
* insert SRBounds(2025-03-03T09:05:00+00:00, 2025-06-30T11:55:00+00:00)
* insert SRSubmittable
* extension[includeAsExtra].valueBoolean = true
* instantiatesCanonical = Canonical(ad-extra-questionnaire)
* code = $activitydefinition-code#273586006

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
