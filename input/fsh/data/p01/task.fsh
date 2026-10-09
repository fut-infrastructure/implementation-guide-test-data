Instance: p01-cp2-task-sat
InstanceOf: ehealth-task
Usage: #example
Title: "Assess saturation triage — routine"
Description: "Task for the green saturation result under the open episode. Priority routine, because triage returned green."
* insert TriageTask(p01-eoc2,p01-cp2,p01-cp2-ci-sat, routine, 2026-01-12T08:30:10+00:00)
* description = "Måling til vurdering"

Instance: p01-cp2-task-pulse
InstanceOf: ehealth-task
Usage: #example
Title: "Assess pulse triage — routine"
Description: "Task for the green pulse result under the open episode. Priority routine, because triage returned green."
* insert TriageTask(p01-eoc2,p01-cp2,p01-cp2-ci-pulse, routine, 2026-01-12T08:30:10+00:00)
* description = "Måling til vurdering"

Instance: p01-cp2-task-qr
InstanceOf: ehealth-task
Usage: #example
Title: "Evaluate questionnaire response triage — routine"
Description: "Task for the green questionnaire result under the open episode. Carries the questionnaire wording rather than the measurement wording."
* insert TriageTask(p01-eoc2,p01-cp2,p01-cp2-ci-qr, routine, 2026-01-12T08:30:10+00:00)
* description = "Spørgeskemabesvarelse til evaluering"

// ─── the completed episode: asap, urgent, asap ──────────────────────────────────────────────────

Instance: p01-cp1-task-sat
InstanceOf: ehealth-task
Usage: #example
Title: "Assess saturation triage — asap"
Description: "Task for the red saturation result under the completed episode. Priority asap, because the value fell in a RAL range."
* insert TriageTask(p01-eoc1,p01-cp1,p01-cp1-ci-sat, asap, 2025-05-14T10:00:10+00:00)
* description = "Måling til vurdering"

Instance: p01-cp1-task-pulse
InstanceOf: ehealth-task
Usage: #example
Title: "Assess pulse triage — urgent"
Description: "Task for the yellow pulse result under the completed episode. Priority urgent, because the value fell in a GAL range."
* insert TriageTask(p01-eoc1,p01-cp1,p01-cp1-ci-pulse, urgent, 2025-05-14T10:00:10+00:00)
* description = "Måling til vurdering"

Instance: p01-cp1-task-qr
InstanceOf: ehealth-task
Usage: #example
Title: "Evaluate questionnaire response triage — asap"
Description: "Task for the red questionnaire result under the completed episode. Priority asap, because the highest answer significance was red."
* insert TriageTask(p01-eoc1,p01-cp1,p01-cp1-ci-qr, asap, 2025-05-14T10:00:10+00:00)
* description = "Spørgeskemabesvarelse til evaluering"
