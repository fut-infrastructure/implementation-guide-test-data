Instance: p01-cp2-sat
InstanceOf: ehealth-observation
Usage: #example
Title: "Oxygen saturation 96% (open episode)"
Description: "Oxygen saturation submitted against the unscheduled branch of the open episode's care plan. 96% is above every absolute range, so triage returns green and the resulting task is routine."
* insert SubmittedObs(p01-eoc2,p01-cp2-sr-extra-saturation, 2026-01-12T08:30:00+00:00)
* insert ObsSaturationRanges
* code = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"
* valueQuantity = 96 '%' "%"

Instance: p01-cp2-pulse
InstanceOf: ehealth-observation
Usage: #example
Title: "Pulse 72/min (open episode)"
Description: "Pulse submitted against the unscheduled branch of the open episode's care plan. 72/min falls between the low and high ranges, so triage returns green and the resulting task is routine."
* insert SubmittedObs(p01-eoc2,p01-cp2-sr-extra-pulse, 2026-01-12T08:30:00+00:00)
* insert ObsPulseRanges
* code = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"
* valueQuantity = 72 '1/min' "1/min"

// ─── the completed episode's submission: an exacerbation, red and yellow ────────────────────────
// Dated inside the completed care plan's window, which ran to 2025-06-30.

Instance: p01-cp1-sat
InstanceOf: ehealth-observation
Usage: #example
Title: "Oxygen saturation 84% (completed episode)"
Description: "Oxygen saturation submitted under the completed episode. 84% is at or below the red absolute range of 85%, so triage returns red and raises a task with priority asap."
* insert SubmittedObs(p01-eoc1,p01-cp1-sr-extra-saturation, 2025-05-14T10:00:00+00:00)
* insert ObsSaturationRanges
* code = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"
* valueQuantity = 84 '%' "%"

Instance: p01-cp1-pulse
InstanceOf: ehealth-observation
Usage: #example
Title: "Pulse 118/min (completed episode)"
Description: "Pulse submitted under the completed episode. 118/min falls in the upper yellow range of 110 to 130, so triage returns yellow and raises a task with priority urgent."
* insert SubmittedObs(p01-eoc1,p01-cp1-sr-extra-pulse, 2025-05-14T10:00:00+00:00)
* insert ObsPulseRanges
* code = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"
* valueQuantity = 118 '1/min' "1/min"
