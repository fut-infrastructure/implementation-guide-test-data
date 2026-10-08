// ClinicalImpressions — WHAT TRIAGE PRODUCES. Not loaded; expected results.
//
// These are not input. The loader submits the observations, the questionnaire response and the
// Provenance; the Provenance triggers automated processing, triage runs, and the environment
// creates its own ClinicalImpressions and Tasks. These six are what it should create, written down
// so the generated ones can be compared against them. The loader skips ClinicalImpression and Task
// by resource type, the same way it resolves Organization and Patient by type.
//
// SIX, BECAUSE EACH TRIAGE RUN TAKES EXACTLY ONE INPUT. Two submissions of three resources each
// give six runs, not two: the observation rule rejects more than one measurement
// ("Forventede præcis en måling") and the questionnaire rule more than one response. So one
// Provenance, three ClinicalImpressions, three Tasks — per submission.
//
// THE TWO KINDS DIFFER MORE THAN THEY LOOK. From production examples:
//
//                        observation triage              questionnaire triage
//   description          "Automatisk processering         absent
//                         grundet måling modtaget"
//   finding              two: the measurement coding      one: the overall colour only
//                        plus the overall colour
//   findingBasis         none                             one per scored answer
//   contained Parameters library + the service request    library + service request + questionnaire
//
// decisionContext POINTS AT A CONTAINED Parameters resource holding the library that ran and the
// facts it ran against. Those are the `#dc-*` inline instances below — they are Usage: #inline, so
// they are contained rather than published as resources of their own.
//
// THE EXPECTED OUTCOMES, which follow from the submitted values and answers:
//
//   open episode       saturation 96 %    within range   green    routine
//                      pulse 72/min       within range   green    routine
//                      questionnaire      4 green        green    routine
//   completed episode  saturation 84 %    outside, RAL   red      asap
//                      pulse 118/min      outside, GAL   yellow   urgent
//                      questionnaire      3 red 2 yellow red      asap
//
// The questionnaire colour is the HIGHEST across its answers, which is why three reds and two
// yellows come out red. See observation.fsh and questionnaireresponse.fsh for the inputs.

// ─── contained decision contexts ────────────────────────────────────────────────────────────────

Instance: p01-cp2-dc-sat
InstanceOf: Parameters
Usage: #inline
* parameter[0].name = "library"
* parameter[=].valueReference = Reference(library-observation-absolute-triage)
* parameter[+].name = "fact"
* parameter[=].valueReference = Reference(p01-cp2-sr-extra-saturation)

Instance: p01-cp2-dc-pulse
InstanceOf: Parameters
Usage: #inline
* parameter[0].name = "library"
* parameter[=].valueReference = Reference(library-observation-absolute-triage)
* parameter[+].name = "fact"
* parameter[=].valueReference = Reference(p01-cp2-sr-extra-pulse)

Instance: p01-cp2-dc-qr
InstanceOf: Parameters
Usage: #inline
* parameter[0].name = "library"
* parameter[=].valueReference = Reference(library-questionnaire-triage)
* parameter[+].name = "fact"
* parameter[=].valueReference = Reference(p01-cp2-sr-extra-questionnaire)
* parameter[+].name = "fact"
* parameter[=].valueReference = Reference(questionnaire)

Instance: p01-cp1-dc-sat
InstanceOf: Parameters
Usage: #inline
* parameter[0].name = "library"
* parameter[=].valueReference = Reference(library-observation-absolute-triage)
* parameter[+].name = "fact"
* parameter[=].valueReference = Reference(p01-cp1-sr-extra-saturation)

Instance: p01-cp1-dc-pulse
InstanceOf: Parameters
Usage: #inline
* parameter[0].name = "library"
* parameter[=].valueReference = Reference(library-observation-absolute-triage)
* parameter[+].name = "fact"
* parameter[=].valueReference = Reference(p01-cp1-sr-extra-pulse)

Instance: p01-cp1-dc-qr
InstanceOf: Parameters
Usage: #inline
* parameter[0].name = "library"
* parameter[=].valueReference = Reference(library-questionnaire-triage)
* parameter[+].name = "fact"
* parameter[=].valueReference = Reference(p01-cp1-sr-extra-questionnaire)
* parameter[+].name = "fact"
* parameter[=].valueReference = Reference(questionnaire)

// ─── shared rules ───────────────────────────────────────────────────────────────────────────────

RuleSet: TriageCI(episode, careplan, dc, when)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference({episode})
* extension[carePlan].valueReference = Reference({careplan})
* extension[decisionContext].valueReference.reference = "#{dc}"
* status = #completed
* code = $clinicalimpression-codes#TriagingResult "Result of triaging"
* subject = Reference(p01)
* effectiveDateTime = "{when}"
* date = "{when}"

RuleSet: Investigated(item)
* investigation.code = $clinicalimpression-investigation-item-codes#item-for-investigation "Item for investigation"
* investigation.item = Reference({item})

// The measurement findings are written out in each instance rather than through a RuleSet. FSH
// separates RuleSet arguments with commas and closes the list on a right parenthesis, and both
// appear inside the values here — the NPU displays contain parentheses, and the answer "Klart (1)"
// does too. Escaping them with backslashes works but makes the inserts unreadable, so only values
// free of both are parameterised.

// One per scored answer: the question, the answer, the colour that combination produced, and a
// copy of the significance rule that matched. The linkId's own commas ARE escaped, because there
// is no reasonable alternative to passing it.
RuleSet: FindingBasis(idx, linkId, value, colour, colourdisplay, sig)
// Slice names throughout — linkId, value, finding, answerSignificance, and inside that
// answerCondition and significance. Numeric indices build the same JSON but SUSHI warns on every
// one of them, and mixing the two forms in a project is what produced empty extension stubs
// during the earlier conversion work.
* extension[findingBasis][{idx}].extension[linkId].valueString = "{linkId}"
* extension[findingBasis][{idx}].extension[value].valueString = "{value}"
* extension[findingBasis][{idx}].extension[finding].valueCodeableConcept = $clinicalimpression-finding-codes#{colour} "{colourdisplay}"
* extension[findingBasis][{idx}].extension[answerSignificance].extension[answerCondition][0].extension[value].valueString = "{value}"
* extension[findingBasis][{idx}].extension[answerSignificance].extension[answerCondition][0].extension[operator].valueCode = #=
* extension[findingBasis][{idx}].extension[answerSignificance].extension[significance].valueCoding = $questionnaire-item-significance-indicator#{sig}

// ─── the open episode's submission: three green results ─────────────────────────────────────────

Instance: p01-cp2-ci-sat
InstanceOf: ehealth-clinicalimpression
Usage: #example
Title: "Triage of saturation 96% — green"
Description: "Triage result for the saturation submitted under the open episode. 96% is within every absolute range, so the finding is 'within reference range' and the overall assessment green."
* insert TriageCI(p01-eoc2,p01-cp2,p01-cp2-dc-sat, 2026-01-12T08:30:10+00:00)
* contained[0] = p01-cp2-dc-sat
* description = "Automatisk processering grundet måling modtaget"
* insert Investigated(p01-cp2-sat)
* finding[0].itemCodeableConcept.coding[0] = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"
* finding[0].itemCodeableConcept.coding[+] = $sct#442082004 "Measurement finding within reference range"
* finding[+].itemCodeableConcept.coding = $clinicalimpression-finding-codes#green "Green overall assessment"

Instance: p01-cp2-ci-pulse
InstanceOf: ehealth-clinicalimpression
Usage: #example
Title: "Triage of pulse 72/min — green"
Description: "Triage result for the pulse submitted under the open episode. 72/min falls between the low and high alarm ranges, so the finding is 'within reference range' and the overall assessment green."
* insert TriageCI(p01-eoc2,p01-cp2,p01-cp2-dc-pulse, 2026-01-12T08:30:10+00:00)
* contained[0] = p01-cp2-dc-pulse
* description = "Automatisk processering grundet måling modtaget"
* insert Investigated(p01-cp2-pulse)
* finding[0].itemCodeableConcept.coding[0] = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"
* finding[0].itemCodeableConcept.coding[+] = $sct#442082004 "Measurement finding within reference range"
* finding[+].itemCodeableConcept.coding = $clinicalimpression-finding-codes#green "Green overall assessment"

Instance: p01-cp2-ci-qr
InstanceOf: ehealth-clinicalimpression
Usage: #example
Title: "Triage of the questionnaire response — green"
Description: "Triage result for the questionnaire response submitted under the open episode. Four scored answers, all green, so the overall assessment is green. Carries no description: the questionnaire rule does not set one."
* insert TriageCI(p01-eoc2,p01-cp2,p01-cp2-dc-qr, 2026-01-12T08:30:10+00:00)
* contained[0] = p01-cp2-dc-qr
* insert Investigated(p01-cp2-qr)
* finding.itemCodeableConcept.coding = $clinicalimpression-finding-codes#green "Green overall assessment"
* insert FindingBasis(0, 1.2.208.176.7.200.2\,898d7b4b-bbb8-45d9-9a1b-956b11d2547b\,ehealth.sundhed.dk, Slet ikke, green-question-answer, green question and answer combination, green)
* insert FindingBasis(1, 1.2.208.176.7.200.2\,a5cc4f01-d9f7-4599-a0a6-e4522dbc8797\,ehealth.sundhed.dk, Slet ikke, green-question-answer, green question and answer combination, green)
* insert FindingBasis(2, 1.2.208.176.7.200.2\,9d68396f-62f1-4cd7-9d64-3f0284e07d98\,ehealth.sundhed.dk, Klart (1\), green-question-answer, green question and answer combination, green)
* insert FindingBasis(3, 1.2.208.176.7.200.2\,45c31bc2-27f9-43b8-afb1-be483dfc4b62\,ehealth.sundhed.dk, Slet ikke, green-question-answer, green question and answer combination, green)

// ─── the completed episode's submission: red, yellow, red ───────────────────────────────────────

Instance: p01-cp1-ci-sat
InstanceOf: ehealth-clinicalimpression
Usage: #example
Title: "Triage of saturation 84% — red"
Description: "Triage result for the saturation submitted under the completed episode. 84% is at or below the red alarm range of 85%, so the finding is 'outside reference range' with the RAL coding, and the overall assessment red."
* insert TriageCI(p01-eoc1,p01-cp1,p01-cp1-dc-sat, 2025-05-14T10:00:10+00:00)
* contained[0] = p01-cp1-dc-sat
* description = "Automatisk processering grundet måling modtaget"
* insert Investigated(p01-cp1-sat)
* finding[0].itemCodeableConcept.coding[0] = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"
* finding[0].itemCodeableConcept.coding[+] = $sct#442096005 "Measurement finding outside reference range"
* finding[0].itemCodeableConcept.coding[+] = $absolute-range#RAL "Terapeutiske grænseværdier for RØD alarm"
* finding[+].itemCodeableConcept.coding = $clinicalimpression-finding-codes#red "Red overall assessment"

Instance: p01-cp1-ci-pulse
InstanceOf: ehealth-clinicalimpression
Usage: #example
Title: "Triage of pulse 118/min — yellow"
Description: "Triage result for the pulse submitted under the completed episode. 118/min falls in the upper yellow range of 110 to 130, so the finding is 'outside reference range' with the GAL coding, and the overall assessment yellow."
* insert TriageCI(p01-eoc1,p01-cp1,p01-cp1-dc-pulse, 2025-05-14T10:00:10+00:00)
* contained[0] = p01-cp1-dc-pulse
* description = "Automatisk processering grundet måling modtaget"
* insert Investigated(p01-cp1-pulse)
* finding[0].itemCodeableConcept.coding[0] = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"
* finding[0].itemCodeableConcept.coding[+] = $sct#442096005 "Measurement finding outside reference range"
* finding[0].itemCodeableConcept.coding[+] = $absolute-range#GAL "Terapeutiske grænseværdier for GUL alarm"
* finding[+].itemCodeableConcept.coding = $clinicalimpression-finding-codes#yellow "Yellow overall assessment"

Instance: p01-cp1-ci-qr
InstanceOf: ehealth-clinicalimpression
Usage: #example
Title: "Triage of the questionnaire response — red"
Description: "Triage result for the questionnaire response submitted under the completed episode. Five scored answers, three red and two yellow; the rule takes the highest, so the overall assessment is red."
* insert TriageCI(p01-eoc1,p01-cp1,p01-cp1-dc-qr, 2025-05-14T10:00:10+00:00)
* contained[0] = p01-cp1-dc-qr
* insert Investigated(p01-cp1-qr)
* finding.itemCodeableConcept.coding = $clinicalimpression-finding-codes#red "Red overall assessment"
* insert FindingBasis(0, 1.2.208.176.7.200.2\,898d7b4b-bbb8-45d9-9a1b-956b11d2547b\,ehealth.sundhed.dk, En del, red-question-answer, red question and answer combination, red)
* insert FindingBasis(1, 1.2.208.176.7.200.2\,a5cc4f01-d9f7-4599-a0a6-e4522dbc8797\,ehealth.sundhed.dk, Lidt, yellow-question-answer, yellow question and answer combination, yellow)
* insert FindingBasis(2, 1.2.208.176.7.200.2\,9d68396f-62f1-4cd7-9d64-3f0284e07d98\,ehealth.sundhed.dk, Grønligt (4\), red-question-answer, red question and answer combination, red)
* insert FindingBasis(3, 1.2.208.176.7.200.2\,45c31bc2-27f9-43b8-afb1-be483dfc4b62\,ehealth.sundhed.dk, En del, red-question-answer, red question and answer combination, red)
* insert FindingBasis(4, 1.2.208.176.7.200.2\,c3cc4571-16ec-4325-9781-681521c3ebee\,ehealth.sundhed.dk, Ja, yellow-question-answer, yellow question and answer combination, yellow)
