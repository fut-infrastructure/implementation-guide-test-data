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
