// CarePlan — the plan definition as delivered to one patient under one episode. Rule sets only;
// the instances are under data/.
//
// ONE PER EPISODE: 20 plans, 13 active and 7 completed.
//
// NORMALLY CREATED BY $apply, NOT AUTHORED. The careplan service takes a PlanDefinition and an
// episode and builds this resource plus one ServiceRequest per activity. Authoring it by hand is
// only meaningful through a load path that bypasses that operation — which is the point of this
// dataset, since $apply cannot produce a plan that ran in the past.
//
// THE ACTIVITY LIST IS ONE ENTRY PER ACTIVITY DEFINITION, each pointing at a ServiceRequest.
// Measured against a production plan with 9 activities: 9 `activity` entries, 9 ServiceRequests,
// covering the container activities and the instruction screens as well as the submittable ones.
// This plan has 14 activities, so 14 of each — see servicerequest.fsh. The link runs one way:
// ServiceRequest.basedOn is 0..0, so the plan points at the requests and never the reverse. Only
// p01's two plans carry the list so far; CarePlan.activity is 0..*, so the other 18 are valid
// without it until their requests are added.
//
// instantiatesCanonical IS A CANONICAL URL, not a reference. It names the plan definition by the
// canonical this guide publishes it at, the same form the plan's own action.definitionCanonical
// uses for its activities.
//
// addresses IS 1..1 — exactly one Condition per care plan, which is why each episode needs its own
// Condition. See condition.fsh.
//
// statusHistory BEGINS AT draft, not planned: CarePlan.status is bound to request-status
// (draft | active | on-hold | revoked | completed | entered-in-error | unknown), so the vocabulary
// differs from the episode's — a completed plan sits under a `finished` episode. The service
// writes the history itself on each status change.
//
// A COMPLETED PLAN'S period STAYS OPEN, deliberately. A production care plan with status completed
// carried a period with a start and no end: the service does not close it when the plan completes,
// though the episode's period is closed. Copying that matters more than internal tidiness, because
// this data is meant to look like what the environment produces.

RuleSet: CarePlanActive(patient, eoc, cond, start, activeFrom)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference({eoc})
* extension[statusHistory][0].extension[status].valueCodeableConcept = $request-status#draft
* extension[statusHistory][=].extension[period].valuePeriod.start = "{start}"
* extension[statusHistory][=].extension[period].valuePeriod.end = "{activeFrom}"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#active
* extension[statusHistory][=].extension[period].valuePeriod.start = "{activeFrom}"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam-placeholder)
* extension[teamHistory].extension[period].valuePeriod.start = "{start}"
* instantiatesCanonical = Canonical(plandefinition)
* status = #active
* intent = #order
* subject = Reference({patient})
* period.start = "{start}"
* careTeam = Reference(careteam-placeholder)
* addresses = Reference({cond})

RuleSet: CarePlanCompleted(patient, eoc, cond, start, activeFrom, completedAt)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference({eoc})
* extension[statusHistory][0].extension[status].valueCodeableConcept = $request-status#draft
* extension[statusHistory][=].extension[period].valuePeriod.start = "{start}"
* extension[statusHistory][=].extension[period].valuePeriod.end = "{activeFrom}"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#active
* extension[statusHistory][=].extension[period].valuePeriod.start = "{activeFrom}"
* extension[statusHistory][=].extension[period].valuePeriod.end = "{completedAt}"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#completed
* extension[statusHistory][=].extension[period].valuePeriod.start = "{completedAt}"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam-placeholder)
* extension[teamHistory].extension[period].valuePeriod.start = "{start}"
* extension[teamHistory].extension[period].valuePeriod.end = "{completedAt}"
* instantiatesCanonical = Canonical(plandefinition)
* status = #completed
* intent = #order
* subject = Reference({patient})
* period.start = "{start}"
* careTeam = Reference(careteam-placeholder)
* addresses = Reference({cond})
