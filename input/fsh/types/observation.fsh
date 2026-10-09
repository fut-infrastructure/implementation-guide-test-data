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
