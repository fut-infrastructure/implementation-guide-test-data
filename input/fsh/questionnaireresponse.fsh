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

// ─── the open episode: a well patient, every answer green ───────────────────────────────────────

Instance: p01-cp2-qr
InstanceOf: ehealth-questionnaireresponse
Usage: #example
Title: "Questionnaire response, no symptoms (open episode)"
Description: "A symptom questionnaire answered under the open episode with no symptoms reported. Every answer carries green significance, so triage returns green and the resulting task is routine."
* insert SubmittedQR(p01-eoc2,p01-cp2-sr-extra-questionnaire, 2026-01-12T08:30:00+00:00)
* item[0].linkId = "1.2.208.176.7.200.2,02572a07-8923-4ea3-9ee9-f9aa10344379,ehealth.sundhed.dk"
* item[0].answer.valueString = "Nej"
* item[+].linkId = "1.2.208.176.7.200.2,0c8a7cbd-1dc9-4553-a0f3-9b3d046486a7,ehealth.sundhed.dk"
* item[=].answer.valueString = "Nej"
* item[+].linkId = "1.2.208.176.7.200.2,898d7b4b-bbb8-45d9-9a1b-956b11d2547b,ehealth.sundhed.dk"
* item[=].answer.valueString = "Slet ikke"
* item[+].linkId = "1.2.208.176.7.200.2,a5cc4f01-d9f7-4599-a0a6-e4522dbc8797,ehealth.sundhed.dk"
* item[=].answer.valueString = "Slet ikke"
* item[+].linkId = "1.2.208.176.7.200.2,9d68396f-62f1-4cd7-9d64-3f0284e07d98,ehealth.sundhed.dk"
* item[=].answer.valueString = "Klart (1)"
* item[+].linkId = "1.2.208.176.7.200.2,45c31bc2-27f9-43b8-afb1-be483dfc4b62,ehealth.sundhed.dk"
* item[=].answer.valueString = "Slet ikke"
* item[+].linkId = "1.2.208.176.7.200.2,c3cc4571-16ec-4325-9781-681521c3ebee,ehealth.sundhed.dk"
* item[=].answer.valueString = "Nej"
// item[7] Kommentar is not answered: its enableWhen requires the answer above to be "Ja".

// ─── the completed episode: an exacerbation, red ────────────────────────────────────────────────
// Dated inside the completed care plan's window. Both exacerbation treatments are in progress,
// breathlessness is "En del" (red) and the sputum is greenish (red), so the response triages red.

Instance: p01-cp1-qr
InstanceOf: ehealth-questionnaireresponse
Usage: #example
Title: "Questionnaire response, exacerbation (completed episode)"
Description: "A symptom questionnaire answered under the completed episode during an exacerbation. Breathlessness 'En del' and greenish sputum both carry red significance, so triage returns red and raises a task with priority asap."
* insert SubmittedQR(p01-eoc1,p01-cp1-sr-extra-questionnaire, 2025-05-14T10:00:00+00:00)
* item[0].linkId = "1.2.208.176.7.200.2,02572a07-8923-4ea3-9ee9-f9aa10344379,ehealth.sundhed.dk"
* item[0].answer.valueString = "Ja"
* item[+].linkId = "1.2.208.176.7.200.2,0c8a7cbd-1dc9-4553-a0f3-9b3d046486a7,ehealth.sundhed.dk"
* item[=].answer.valueString = "Ja"
* item[+].linkId = "1.2.208.176.7.200.2,898d7b4b-bbb8-45d9-9a1b-956b11d2547b,ehealth.sundhed.dk"
* item[=].answer.valueString = "En del"
* item[+].linkId = "1.2.208.176.7.200.2,a5cc4f01-d9f7-4599-a0a6-e4522dbc8797,ehealth.sundhed.dk"
* item[=].answer.valueString = "Lidt"
* item[+].linkId = "1.2.208.176.7.200.2,9d68396f-62f1-4cd7-9d64-3f0284e07d98,ehealth.sundhed.dk"
* item[=].answer.valueString = "Grønligt (4)"
* item[+].linkId = "1.2.208.176.7.200.2,45c31bc2-27f9-43b8-afb1-be483dfc4b62,ehealth.sundhed.dk"
* item[=].answer.valueString = "En del"
* item[+].linkId = "1.2.208.176.7.200.2,c3cc4571-16ec-4325-9781-681521c3ebee,ehealth.sundhed.dk"
* item[=].answer.valueString = "Ja"
// Answered "Ja" above, so the comment item is enabled and must be filled in.
* item[+].linkId = "1.2.208.176.7.200.2,f3fc74d3-1231-4356-87c5-433204e73f1e,ehealth.sundhed.dk"
* item[=].answer.valueString = "Jeg har haft det dårligere de seneste dage og er begyndt på både Prednisolon og Antibiotika."
