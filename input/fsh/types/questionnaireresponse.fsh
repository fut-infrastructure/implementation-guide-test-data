// QuestionnaireResponses — one per submission.
//
// Each is `basedOn` the EXTRA questionnaire service request, so it can be submitted without
// waiting for a scheduled window.
//
// THE ANSWERS DETERMINE THE TRIAGE COLOUR, and they are chosen, not arbitrary. The questionnaire
// carries an answerSignificance per answer value, and the rule takes the HIGHEST colour across all
// answers: one red answer makes the whole response red; absent any red, one yellow makes it
// yellow. The map, from the questionnaire itself:
//
//   åndenød / hoste / hostet slim    Slet ikke -> green   Lidt -> yellow
//                                    En del -> red        Meget -> red
//   slimfarve                        Klart, Hvidligt -> green
//                                    Lysegult, Grønligt, Mørkegult -> red
//   noget at tilføje                 Ja -> yellow         (Nej has no significance)
//   Prednisolon / Antibiotika        no significance either way
//
// So:
//   open episode       all green answers                -> green, task routine
//   completed episode  "En del" åndenød, "Grønligt" slim -> red,  task asap
//
// which matches the measurements submitted alongside them — see observation.fsh.
//
// THE COMMENT ITEM IS CONDITIONAL. item[7] is required but carries an enableWhen on item[6] being
// "Ja", so it must be answered only when the patient says they have something to add. The green
// response answers "Nej" and therefore leaves item[7] out; the red one answers "Ja" and fills it
// in. Answering it in the green case would be invalid, not merely odd.
//
// linkIds ARE THE QUESTIONNAIRE'S OWN and look like
// "1.2.208.176.7.200.2,<uuid>,ehealth.sundhed.dk" — an OID, a UUID and a domain in one string.
// They have to match the questionnaire exactly, which is why they are written out in full.

RuleSet: SubmittedQR(episode, sr, authored)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference({episode})
* extension[resolvedTiming].extension[serviceRequestVersionId].valueId = "1"
* extension[resolvedTiming].extension[type].valueCodeableConcept = $resolved-timing-type#Extra
* basedOn = Reference({sr})
* questionnaire = Canonical(questionnaire)
* status = #completed
* subject = Reference(p01)
* authored = "{authored}"
* source = Reference(p01)
