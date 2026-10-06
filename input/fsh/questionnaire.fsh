// The symptom questionnaire — LOADABLE.
//
// The single questionnaire of the COPD monitoring plan, referenced by both of its Master
// Questionnaire activities. Eight items: two treatment questions, three symptom scales, the
// sputum-colour question, a summary question, and a comment enabled only by that summary.
//
// THE ANSWER SIGNIFICANCE MAPPING IS WHAT MAKES IT TRIAGEABLE. Eighteen mappings across three
// colours, which is what the answer-significance rule reads to assess a submitted response:
//
//     S04/S05/S07   Slet ikke -> green, Lidt -> yellow, En del -> red, Meget -> red
//     S06 sputum    Klart, Hvidligt -> green;  Lysegult, Grønligt, Mørkegult -> red
//     S08 summary   Ja -> yellow
//
// S02 and S03 carry no significance at all, deliberately: they record what treatment the patient
// is currently on, they do not score it. S09 is free text and carries none either.
//
// S06 asks the patient to name the colour of their sputum from five graded options, having spat
// on a white surface. Each option label carries both the colour name and its position on the
// five-point scale, so the answer stands on its own.
//
// ITEMS ARE CHOICES AND FREE TEXT ONLY. Nothing numeric: a value a patient measures belongs in an
// Observation with a code and a unit, not in a questionnaire answer, where it would carry neither
// and would be assessed by the wrong rule.
//
// The linkIds are the `<oid>,<uuid>,<authority>` triple the platform uses, and a
// QuestionnaireResponse must quote them exactly — they are how an answer is matched back to its
// question, and how the significance mapping above is found.

Instance: questionnaire
InstanceOf: ehealth-questionnaire
Usage: #example
Title: "KOL spørgeskema"
Description: "COPD symptom questionnaire: treatment status, three symptom scales, sputum colour and a conditional comment. Eighteen answer-significance mappings across green, yellow and red."
* extension[type].valueCodeableConcept = $questionnaire-types#TBD
* extension[modifierRole][0].extension[reference].valueReference = Reference(org-region-midtjylland)
* extension[modifierRole][0].extension[role].valueCodeableConcept = $modifier-role#owner
* extension[employeeTitle].valueString = "KOL spørgeskema"
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:e2f2b865-2cad-4dea-a404-456986414316"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[baseEnvironment].valueIdentifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[baseEnvironment].valueIdentifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:453c523b-78a0-41f3-bc02-b4e0ee4f4710"
* version = "1.0"
* title = "KOL spørgeskema"
* status = #active
// Legal act, not a country — see the note in library.fsh. Set explicitly so the IG Publisher does
// not fill it in from the IG's own jurisdiction, which uses ISO 3166 country codes.
* jurisdiction = $jurisdiction#healthcare-act "Danish healthcare act"
* publisher = "Den telemedicinske infrastruktur (eHealth Infrastructure)"
* description = "Test spørgeskema"
* useContext.code = $usage-context-type#focus
* useContext.valueCodeableConcept = urn:oid:1.2.208.176.2.4#DJ44 "Kronisk obstruktiv lungesygdom"
* approvalDate = "2025-09-02"

// S02 — Er du i behandling med Prednisolon pga. forværring af din KOL?
* item[0].extension[shortText].valueString = "Er du i behandling med Prednisolon pga. forværring af din KOL?"
* item[0].extension[itemControl].valueCodeableConcept = $questionnaire-item-control#radio-button
* item[0].linkId = "1.2.208.176.7.200.2,02572a07-8923-4ea3-9ee9-f9aa10344379,ehealth.sundhed.dk"
* item[0].prefix = "S02"
* item[0].text = "Er du i behandling med Prednisolon pga. forværring af din KOL?"
* item[0].text.extension[xhtml].valueString = "<p>Er du i behandling med Prednisolon pga. forværring af din KOL?</p>"
* item[0].type = #choice
* item[0].required = true
* item[0].answerOption[0].valueString = "Ja"
* item[0].answerOption[0].valueString.extension[xhtml].valueString = "Ja"
* item[0].answerOption[1].valueString = "Nej"
* item[0].answerOption[1].valueString.extension[xhtml].valueString = "<p>Nej</p>"

// S03 — Er du i behandling med Antibiotika pga. forværring af din KOL?
* item[1].extension[shortText].valueString = "Er du i behandling med Antibiotika pga. forværring af din KOL?"
* item[1].extension[itemControl].valueCodeableConcept = $questionnaire-item-control#radio-button
* item[1].linkId = "1.2.208.176.7.200.2,0c8a7cbd-1dc9-4553-a0f3-9b3d046486a7,ehealth.sundhed.dk"
* item[1].prefix = "S03"
* item[1].text = "Er du i behandling med Antibiotika pga. forværring af din KOL?"
* item[1].text.extension[xhtml].valueString = "<p>Er du i behandling med Antibiotika pga. forværring af din KOL?</p>"
* item[1].type = #choice
* item[1].required = true
* item[1].answerOption[0].valueString = "Ja"
* item[1].answerOption[0].valueString.extension[xhtml].valueString = "<p>Ja</p>"
* item[1].answerOption[1].valueString = "Nej"
* item[1].answerOption[1].valueString.extension[xhtml].valueString = "<p>Nej</p>"

// S04 — Oplever du mere åndenød inden for de seneste 24 timer?
* item[2].extension[shortText].valueString = "Oplever du mere åndenød inden for de seneste 24 timer?"
* item[2].extension[answerSignificance][0].extension[answerCondition][0].extension[value].valueString = "Slet ikke"
* item[2].extension[answerSignificance][0].extension[answerCondition][0].extension[operator].valueCode = #=
* item[2].extension[answerSignificance][0].extension[significance].valueCoding = $questionnaire-item-significance-indicator#green
* item[2].extension[answerSignificance][1].extension[answerCondition][0].extension[value].valueString = "Lidt"
* item[2].extension[answerSignificance][1].extension[answerCondition][0].extension[operator].valueCode = #=
* item[2].extension[answerSignificance][1].extension[significance].valueCoding = $questionnaire-item-significance-indicator#yellow
* item[2].extension[answerSignificance][2].extension[answerCondition][0].extension[value].valueString = "En del"
* item[2].extension[answerSignificance][2].extension[answerCondition][0].extension[operator].valueCode = #=
* item[2].extension[answerSignificance][2].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[2].extension[answerSignificance][3].extension[answerCondition][0].extension[value].valueString = "Meget"
* item[2].extension[answerSignificance][3].extension[answerCondition][0].extension[operator].valueCode = #=
* item[2].extension[answerSignificance][3].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[2].extension[itemControl].valueCodeableConcept = $questionnaire-item-control#radio-button
* item[2].linkId = "1.2.208.176.7.200.2,898d7b4b-bbb8-45d9-9a1b-956b11d2547b,ehealth.sundhed.dk"
* item[2].prefix = "S04"
* item[2].text = "Oplever du mere åndenød inden for de seneste 24 timer?"
* item[2].text.extension[xhtml].valueString = "<p><br/>Oplever du mere åndenød inden for de seneste 24 timer?<br/></p>"
* item[2].type = #choice
* item[2].required = true
* item[2].answerOption[0].valueString = "Slet ikke"
* item[2].answerOption[0].valueString.extension[xhtml].valueString = "<p>Slet ikke</p>"
* item[2].answerOption[1].valueString = "Lidt"
* item[2].answerOption[1].valueString.extension[xhtml].valueString = "<p>Lidt</p>"
* item[2].answerOption[2].valueString = "En del"
* item[2].answerOption[2].valueString.extension[xhtml].valueString = "<p>En del</p>"
* item[2].answerOption[3].valueString = "Meget"
* item[2].answerOption[3].valueString.extension[xhtml].valueString = "<p>Meget</p>"

// S05 — Oplever du mere hoste inden for de seneste 24 timer?
* item[3].extension[shortText].valueString = "Oplever du mere hoste inden for de seneste 24 timer?"
* item[3].extension[answerSignificance][0].extension[answerCondition][0].extension[value].valueString = "Slet ikke"
* item[3].extension[answerSignificance][0].extension[answerCondition][0].extension[operator].valueCode = #=
* item[3].extension[answerSignificance][0].extension[significance].valueCoding = $questionnaire-item-significance-indicator#green
* item[3].extension[answerSignificance][1].extension[answerCondition][0].extension[value].valueString = "Lidt"
* item[3].extension[answerSignificance][1].extension[answerCondition][0].extension[operator].valueCode = #=
* item[3].extension[answerSignificance][1].extension[significance].valueCoding = $questionnaire-item-significance-indicator#yellow
* item[3].extension[answerSignificance][2].extension[answerCondition][0].extension[value].valueString = "En del"
* item[3].extension[answerSignificance][2].extension[answerCondition][0].extension[operator].valueCode = #=
* item[3].extension[answerSignificance][2].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[3].extension[answerSignificance][3].extension[answerCondition][0].extension[value].valueString = "Meget"
* item[3].extension[answerSignificance][3].extension[answerCondition][0].extension[operator].valueCode = #=
* item[3].extension[answerSignificance][3].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[3].extension[itemControl].valueCodeableConcept = $questionnaire-item-control#radio-button
* item[3].linkId = "1.2.208.176.7.200.2,a5cc4f01-d9f7-4599-a0a6-e4522dbc8797,ehealth.sundhed.dk"
* item[3].prefix = "S05"
* item[3].text = "Oplever du mere hoste inden for de seneste 24 timer?"
* item[3].text.extension[xhtml].valueString = "<p><br/>Oplever du mere hoste inden for de seneste 24 timer?<br/></p>"
* item[3].type = #choice
* item[3].required = true
* item[3].answerOption[0].valueString = "Slet ikke"
* item[3].answerOption[0].valueString.extension[xhtml].valueString = "<p>Slet ikke</p>"
* item[3].answerOption[1].valueString = "Lidt"
* item[3].answerOption[1].valueString.extension[xhtml].valueString = "<p>Lidt</p>"
* item[3].answerOption[2].valueString = "En del"
* item[3].answerOption[2].valueString.extension[xhtml].valueString = "<p>En del</p>"
* item[3].answerOption[3].valueString = "Meget"
* item[3].answerOption[3].valueString.extension[xhtml].valueString = "<p>Meget</p>"

// S06 — Hvilken farve har dit slim?
* item[4].extension[shortText].valueString = "Hvilken farve har dit slim?"
* item[4].extension[answerSignificance][0].extension[answerCondition][0].extension[value].valueString = "Klart (1)"
* item[4].extension[answerSignificance][0].extension[answerCondition][0].extension[operator].valueCode = #=
* item[4].extension[answerSignificance][0].extension[significance].valueCoding = $questionnaire-item-significance-indicator#green
* item[4].extension[answerSignificance][1].extension[answerCondition][0].extension[value].valueString = "Hvidligt (2)"
* item[4].extension[answerSignificance][1].extension[answerCondition][0].extension[operator].valueCode = #=
* item[4].extension[answerSignificance][1].extension[significance].valueCoding = $questionnaire-item-significance-indicator#green
* item[4].extension[answerSignificance][2].extension[answerCondition][0].extension[value].valueString = "Lysegult (3)"
* item[4].extension[answerSignificance][2].extension[answerCondition][0].extension[operator].valueCode = #=
* item[4].extension[answerSignificance][2].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[4].extension[answerSignificance][3].extension[answerCondition][0].extension[value].valueString = "Grønligt (4)"
* item[4].extension[answerSignificance][3].extension[answerCondition][0].extension[operator].valueCode = #=
* item[4].extension[answerSignificance][3].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[4].extension[answerSignificance][4].extension[answerCondition][0].extension[value].valueString = "Mørkegult (5)"
* item[4].extension[answerSignificance][4].extension[answerCondition][0].extension[operator].valueCode = #=
* item[4].extension[answerSignificance][4].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[4].extension[itemControl].valueCodeableConcept = $questionnaire-item-control#radio-button
* item[4].linkId = "1.2.208.176.7.200.2,9d68396f-62f1-4cd7-9d64-3f0284e07d98,ehealth.sundhed.dk"
* item[4].prefix = "S06"
* item[4].text = "Hvilken farve har dit slim?\nVær opmærksom på at du skal spytte på et hvidt underlag - eksempelvis en lommeserviet."
* item[4].text.extension[xhtml].valueString = "<p>Hvilken farve har dit slim?</p><p>Vær opmærksom på at du skal spytte på et hvidt underlag - eksempelvis en lommeserviet.</p>"
* item[4].type = #choice
* item[4].required = true
* item[4].answerOption[0].valueString = "Klart (1)"
* item[4].answerOption[0].valueString.extension[xhtml].valueString = "<p>Klart (1)&nbsp;</p>"
* item[4].answerOption[1].valueString = "Hvidligt (2)"
* item[4].answerOption[1].valueString.extension[xhtml].valueString = "<p>Hvidligt (2)</p>"
* item[4].answerOption[2].valueString = "Lysegult (3)"
* item[4].answerOption[2].valueString.extension[xhtml].valueString = "<p>Lysegult (3)</p>"
* item[4].answerOption[3].valueString = "Grønligt (4)"
* item[4].answerOption[3].valueString.extension[xhtml].valueString = "<p>Grønligt (4)</p>"
* item[4].answerOption[4].valueString = "Mørkegult (5)"
* item[4].answerOption[4].valueString.extension[xhtml].valueString = "<p>Mørkegult (5)</p>"

// S07 — Har du hostet mere slim op inden for de seneste 24 timer?
* item[5].extension[shortText].valueString = "Har du hostet mere slim op inden for de seneste 24 timer?"
* item[5].extension[answerSignificance][0].extension[answerCondition][0].extension[value].valueString = "Slet ikke"
* item[5].extension[answerSignificance][0].extension[answerCondition][0].extension[operator].valueCode = #=
* item[5].extension[answerSignificance][0].extension[significance].valueCoding = $questionnaire-item-significance-indicator#green
* item[5].extension[answerSignificance][1].extension[answerCondition][0].extension[value].valueString = "Lidt"
* item[5].extension[answerSignificance][1].extension[answerCondition][0].extension[operator].valueCode = #=
* item[5].extension[answerSignificance][1].extension[significance].valueCoding = $questionnaire-item-significance-indicator#yellow
* item[5].extension[answerSignificance][2].extension[answerCondition][0].extension[value].valueString = "En del"
* item[5].extension[answerSignificance][2].extension[answerCondition][0].extension[operator].valueCode = #=
* item[5].extension[answerSignificance][2].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[5].extension[answerSignificance][3].extension[answerCondition][0].extension[value].valueString = "Meget"
* item[5].extension[answerSignificance][3].extension[answerCondition][0].extension[operator].valueCode = #=
* item[5].extension[answerSignificance][3].extension[significance].valueCoding = $questionnaire-item-significance-indicator#red
* item[5].extension[itemControl].valueCodeableConcept = $questionnaire-item-control#radio-button
* item[5].linkId = "1.2.208.176.7.200.2,45c31bc2-27f9-43b8-afb1-be483dfc4b62,ehealth.sundhed.dk"
* item[5].prefix = "S07"
* item[5].text = "Har du hostet mere slim op inden for de seneste 24 timer?"
* item[5].text.extension[xhtml].valueString = "<p><br/>Har du hostet mere slim op inden for de seneste 24 timer?<br/></p>"
* item[5].type = #choice
* item[5].required = true
* item[5].answerOption[0].valueString = "Slet ikke"
* item[5].answerOption[0].valueString.extension[xhtml].valueString = "<p>Slet ikke</p>"
* item[5].answerOption[1].valueString = "Lidt"
* item[5].answerOption[1].valueString.extension[xhtml].valueString = "<p>Lidt</p>"
* item[5].answerOption[2].valueString = "En del"
* item[5].answerOption[2].valueString.extension[xhtml].valueString = "<p>En del&nbsp;</p>"
* item[5].answerOption[3].valueString = "Meget"
* item[5].answerOption[3].valueString.extension[xhtml].valueString = "<p>Meget</p>"

// S08 — Har du noget at tilføje til dine målinger eller besvarelse?
* item[6].extension[shortText].valueString = "Har du noget at tilføje til dine målinger eller besvarelse?"
* item[6].extension[answerSignificance][0].extension[answerCondition][0].extension[value].valueString = "Ja"
* item[6].extension[answerSignificance][0].extension[answerCondition][0].extension[operator].valueCode = #=
* item[6].extension[answerSignificance][0].extension[significance].valueCoding = $questionnaire-item-significance-indicator#yellow
* item[6].extension[itemControl].valueCodeableConcept = $questionnaire-item-control#radio-button
* item[6].linkId = "1.2.208.176.7.200.2,c3cc4571-16ec-4325-9781-681521c3ebee,ehealth.sundhed.dk"
* item[6].prefix = "S08"
* item[6].text = "Har du noget at tilføje til dine målinger eller besvarelse?"
* item[6].text.extension[xhtml].valueString = "<p><br/></p><p>Har du noget at tilføje til dine målinger eller besvarelse?<br/></p>"
* item[6].type = #choice
* item[6].required = true
* item[6].answerOption[0].valueString = "Ja"
* item[6].answerOption[0].valueString.extension[xhtml].valueString = "<p>Ja</p>"
* item[6].answerOption[1].valueString = "Nej"
* item[6].answerOption[1].valueString.extension[xhtml].valueString = "<p>Nej</p>"

// S09 — Kommentar
* item[7].extension[shortText].valueString = "Angiv kommentar"
* item[7].linkId = "1.2.208.176.7.200.2,f3fc74d3-1231-4356-87c5-433204e73f1e,ehealth.sundhed.dk"
* item[7].prefix = "S09"
* item[7].text = "Kommentar"
* item[7].text.extension[xhtml].valueString = "<p><br/></p><p><b>Kommentar</b></p><br/><p></p><p><br/></p>"
* item[7].type = #text
* item[7].required = true
* item[7].enableWhen.question = "1.2.208.176.7.200.2,c3cc4571-16ec-4325-9781-681521c3ebee,ehealth.sundhed.dk"
* item[7].enableWhen.operator = #=
* item[7].enableWhen.answerString = "Ja"
* item[7].enableBehavior = #any
