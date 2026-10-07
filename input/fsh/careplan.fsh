// CarePlan for the OPEN episode — the plan definition as delivered to this patient.
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
// ServiceRequest.basedOn is 0..0, so the plan points at the requests and never the reverse.
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
// differs from the episode's. The service writes the history itself on each status change.

Instance: p01-cp2
InstanceOf: ehealth-careplan
Usage: #example
Title: "Care plan (active)"
Description: "The monitoring plan as delivered under the open episode of care. Normally created by $apply, which would also create one ServiceRequest per activity."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference(p01-eoc2)
* extension[statusHistory][0].extension[status].valueCodeableConcept = $request-status#draft
* extension[statusHistory][=].extension[period].valuePeriod.start = "2026-01-08T09:05:00+00:00"
* extension[statusHistory][=].extension[period].valuePeriod.end = "2026-01-08T09:05:01+00:00"
* extension[statusHistory][+].extension[status].valueCodeableConcept = $request-status#active
* extension[statusHistory][=].extension[period].valuePeriod.start = "2026-01-08T09:05:01+00:00"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam)
* extension[teamHistory].extension[period].valuePeriod.start = "2026-01-08T09:05:00+00:00"
* instantiatesCanonical = Canonical(plandefinition)
* status = #active
* intent = #order
* subject = Reference(p01)
* period.start = "2026-01-08T09:05:00+00:00"
* careTeam = Reference(careteam)
* addresses = Reference(p01-eoc2-cond)
// One entry per activity, in the order the plan runs them. See servicerequest.fsh.
* activity[0].reference = Reference(p01-cp2-sr-head)
* activity[+].reference = Reference(p01-cp2-sr-intro)
* activity[+].reference = Reference(p01-cp2-sr-sat-pulse-intro)
* activity[+].reference = Reference(p01-cp2-sr-sat-pulse-prep)
* activity[+].reference = Reference(p01-cp2-sr-sat-pulse)
* activity[+].reference = Reference(p01-cp2-sr-saturation)
* activity[+].reference = Reference(p01-cp2-sr-pulse)
* activity[+].reference = Reference(p01-cp2-sr-questionnaire)
* activity[+].reference = Reference(p01-cp2-sr-closing)
* activity[+].reference = Reference(p01-cp2-sr-extra-head)
* activity[+].reference = Reference(p01-cp2-sr-extra-sat-pulse)
* activity[+].reference = Reference(p01-cp2-sr-extra-saturation)
* activity[+].reference = Reference(p01-cp2-sr-extra-pulse)
* activity[+].reference = Reference(p01-cp2-sr-extra-questionnaire)
