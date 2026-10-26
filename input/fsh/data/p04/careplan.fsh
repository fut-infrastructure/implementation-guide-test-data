Instance: p04-cp1
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 1 (completed)"
Description: "The monitoring plan as delivered under episode of care 1."
* insert CarePlanCompleted(p04, p04-eoc1, p04-eoc1-cond, 2025-09-01T09:05:00+00:00, 2025-09-01T09:05:01+00:00, 2026-01-12T11:55:00+00:00)
* insert CarePlanActivities(p04-cp1)

Instance: p04-cp2
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 2 (active)"
Description: "The monitoring plan as delivered under episode of care 2."
* insert CarePlanActive(p04, p04-eoc2, p04-eoc2-cond, 2026-09-29T09:05:00+00:00, 2026-09-29T09:05:01+00:00)
* insert CarePlanActivities(p04-cp2)
