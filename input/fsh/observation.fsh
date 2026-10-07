// Observations — the two measurements of each submission.
//
// FOUR IN ALL: oxygen saturation and pulse, submitted once under each care plan. Each is
// `basedOn` one of the EXTRA service requests, the unscheduled branch, so the submission needs no
// scheduled window — which is the whole reason the plan has that branch.
//
// THE VALUES ARE CHOSEN TO PRODUCE A KNOWN TRIAGE RESULT. The outcome is fully determined by the
// value against the absolute reference ranges carried here, so these are not arbitrary numbers:
//
//   saturation  <= 85        RAL -> red    asap        85.0000001-88  GAL -> yellow  urgent
//               > 88         no range -> green  routine
//   pulse       <= 50        RAL -> red    asap        50.0000001-60  GAL -> yellow  urgent
//               110-129.99   GAL -> yellow urgent      >= 130         RAL -> red     asap
//               60-110       no range -> green  routine
//
//   open episode       saturation 96 %, pulse 72/min   -> both green, routine
//   completed episode  saturation 84 %, pulse 118/min  -> red asap, and yellow urgent
//
// So the dataset exercises all three colours rather than only the quiet path, and each submission
// is internally coherent: a well patient in one, an exacerbation in the other. See
// questionnaireresponse.fsh, whose answers tell the same story.
//
// THE REFERENCE RANGES ARE REPEATED HERE, resolved onto the observation. The service copies them
// from the service request at submission, and the triage rule reads them from the observation —
// it looks for type codings in urn:oid:1.2.208.184.100.1 with code GAL or RAL. They are written
// as proper Observation.referenceRange elements, not as the extension the activity definition and
// service request use, which is why these RuleSets differ from SaturationRanges / PulseRanges.
//
// resolvedTiming IS MANDATORY and its type is `Extra` for these, matching the branch submitted
// against. start and end are 0..1 and omitted: an ad-hoc submission resolves to no window.
// serviceRequestVersionId is 1..1 and set to 1, the version a freshly created request would have.

RuleSet: ObsSaturationRanges
* referenceRange[0].high = 85 '%' "%"
* referenceRange[0].type.coding[0] = $absolute-range#RAL
* referenceRange[0].type.coding[+] = $npu#NPU03011
* referenceRange[1].low = 85.0000001 '%' "%"
* referenceRange[1].high = 88 '%' "%"
* referenceRange[1].type.coding[0] = $absolute-range#GAL
* referenceRange[1].type.coding[+] = $npu#NPU03011

RuleSet: ObsPulseRanges
* referenceRange[0].high = 50 '1/min' "1/min"
* referenceRange[0].type.coding[0] = $absolute-range#RAL
* referenceRange[0].type.coding[+] = $npu#NPU21692
* referenceRange[1].low = 50.0000001 '1/min' "1/min"
* referenceRange[1].high = 60 '1/min' "1/min"
* referenceRange[1].type.coding[0] = $absolute-range#GAL
* referenceRange[1].type.coding[+] = $npu#NPU21692
* referenceRange[2].low = 110 '1/min' "1/min"
* referenceRange[2].high = 129.9999999 '1/min' "1/min"
* referenceRange[2].type.coding[0] = $absolute-range#GAL
* referenceRange[2].type.coding[+] = $npu#NPU21692
* referenceRange[3].low = 130 '1/min' "1/min"
* referenceRange[3].type.coding[0] = $absolute-range#RAL
* referenceRange[3].type.coding[+] = $npu#NPU21692

RuleSet: SubmittedObs(episode, sr, authored)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference({episode})
* extension[resolvedTiming].extension[serviceRequestVersionId].valueId = "1"
* extension[resolvedTiming].extension[type].valueCodeableConcept = $resolved-timing-type#Extra
* basedOn = Reference({sr})
* status = #final
* subject = Reference(p01)
* effectiveDateTime = "{authored}"
* performer = Reference(p01)

// ─── the open episode's submission: a well patient, both measurements green ─────────────────────

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
