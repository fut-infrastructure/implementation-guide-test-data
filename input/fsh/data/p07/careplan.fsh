Instance: p07-cp1
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 1 (completed)"
Description: "The monitoring plan as delivered under episode of care 1."
* insert CarePlanCompleted(p07, p07-eoc1, p07-eoc1-cond, 2025-12-01T09:05:00+00:00, 2025-12-01T09:05:01+00:00, 2026-04-13T11:55:00+00:00)
* insert CarePlanActivities(p07-cp1)

Instance: p07-cp2
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 2 (active)"
Description: "The monitoring plan as delivered under episode of care 2."
* insert CarePlanActive(p07, p07-eoc2, p07-eoc2-cond, 2026-09-28T09:05:00+00:00, 2026-09-28T09:05:01+00:00)
* insert CarePlanActivities(p07-cp2)
