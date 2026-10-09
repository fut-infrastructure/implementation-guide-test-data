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
