Instance: p06-cp1
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 1 (completed)"
Description: "The monitoring plan as delivered under episode of care 1."
* insert CarePlanCompleted(p06, p06-eoc1, p06-eoc1-cond, 2025-11-03T09:05:00+00:00, 2025-11-03T09:05:01+00:00, 2026-03-16T11:55:00+00:00)
* insert CarePlanActivities(p06-cp1)

Instance: p06-cp2
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 2 (active)"
Description: "The monitoring plan as delivered under episode of care 2."
* insert CarePlanActive(p06, p06-eoc2, p06-eoc2-cond, 2026-09-29T09:05:00+00:00, 2026-09-29T09:05:01+00:00)
* insert CarePlanActivities(p06-cp2)
