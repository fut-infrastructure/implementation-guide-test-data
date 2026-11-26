Instance: p03-cp1
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 1 (completed)"
Description: "The monitoring plan as delivered under episode of care 1."
* insert CarePlanCompleted(p03, p03-eoc1, p03-eoc1-cond, 2025-08-04T09:05:00+00:00, 2025-08-04T09:05:01+00:00, 2025-12-15T11:55:00+00:00)
* insert CarePlanActivities(p03-cp1)

Instance: p03-cp2
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 2 (active)"
Description: "The monitoring plan as delivered under episode of care 2."
* insert CarePlanActive(p03, p03-eoc2, p03-eoc2-cond, 2026-09-28T09:05:00+00:00, 2026-09-28T09:05:01+00:00)
* insert CarePlanActivities(p03-cp2)
