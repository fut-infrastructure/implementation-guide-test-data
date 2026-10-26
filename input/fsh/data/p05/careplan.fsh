Instance: p05-cp1
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 1 (completed)"
Description: "The monitoring plan as delivered under episode of care 1."
* insert CarePlanCompleted(p05, p05-eoc1, p05-eoc1-cond, 2025-10-06T09:05:00+00:00, 2025-10-06T09:05:01+00:00, 2026-02-16T11:55:00+00:00)
* insert CarePlanActivities(p05-cp1)

Instance: p05-cp2
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 2 (active)"
Description: "The monitoring plan as delivered under episode of care 2."
* insert CarePlanActive(p05, p05-eoc2, p05-eoc2-cond, 2026-09-28T09:05:00+00:00, 2026-09-28T09:05:01+00:00)
* insert CarePlanActivities(p05-cp2)
