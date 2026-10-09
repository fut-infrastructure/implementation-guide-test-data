Instance: p01-cp2-prov
InstanceOf: ehealth-provenance
Usage: #example
Title: "Submission under the open episode"
Description: "The submit record for the open episode: one questionnaire response and two observations, submitted together against the unscheduled branch. This is what triggers automated processing, which should triage all three green with routine tasks."
* insert SubmitProvenance(p01-eoc2,p01-cp2-qr,p01-cp2-sat,p01-cp2-pulse,p01-cp2-sr-extra-questionnaire,p01-cp2-sr-extra-saturation,p01-cp2-sr-extra-pulse, 2026-01-12T08:30:05+00:00)

Instance: p01-cp1-prov
InstanceOf: ehealth-provenance
Usage: #example
Title: "Submission under the completed episode"
Description: "The submit record for the completed episode, made while the plan was still active in May 2025. Triage should return red for the saturation and the questionnaire, and yellow for the pulse."
* insert SubmitProvenance(p01-eoc1,p01-cp1-qr,p01-cp1-sat,p01-cp1-pulse,p01-cp1-sr-extra-questionnaire,p01-cp1-sr-extra-saturation,p01-cp1-sr-extra-pulse, 2025-05-14T10:00:05+00:00)
