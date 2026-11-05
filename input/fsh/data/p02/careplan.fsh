Instance: p02-cp1
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 1 (completed)"
Description: "The monitoring plan as delivered under episode of care 1."
* insert CarePlanCompleted(p02, p02-eoc1, p02-eoc1-cond, 2025-07-07T09:05:00+00:00, 2025-07-07T09:05:01+00:00, 2025-11-17T11:55:00+00:00)
* insert CarePlanActivities(p02-cp1)

Instance: p02-cp2
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan 2 (active)"
Description: "The monitoring plan as delivered under episode of care 2."
* insert CarePlanActive(p02, p02-eoc2, p02-eoc2-cond, 2026-09-29T09:05:00+00:00, 2026-09-29T09:05:01+00:00)
* insert CarePlanActivities(p02-cp2)
