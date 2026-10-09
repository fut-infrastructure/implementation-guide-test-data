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
