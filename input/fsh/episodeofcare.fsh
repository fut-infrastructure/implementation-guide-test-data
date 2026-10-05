// EpisodeOfCare — LOADABLE.
//
// The episode everything patient-specific belongs to. A care plan built from the plan definition,
// the service requests it creates, and every measurement and questionnaire response submitted
// against them all carry a reference back to an episode; this is that anchor.
//
// TWO EXTENSIONS ARE REQUIRED, and they record two different responsibilities:
//
//   caremanagerOrganization (1..1) names the organization that manages the patient's care — who
//   acts on what the monitoring produces.
//
//   managingOrganization (1..* as of core 10.0.2) names the organization that owns the episode
//   itself, with the period it held that ownership. It replaces the base
//   EpisodeOfCare.managingOrganization element, which the profile pins to 0..0, so that ownership
//   can change over time without losing the history. It is a complex extension: an `organisation`
//   reference and a `period` whose start is mandatory.
//
// Both point at the same organization here. They are the same body in this dataset; the profile
// keeps them separate because in general they need not be.
//
// careManager and account are constrained to 0..0 by the profile.
//
// statusHistory TRACKS THE TRANSITIONS, planned then active, each with the period it held. The
// careplan service maintains it: on create it writes a single entry for the current status, and on
// a status change it closes the open period and opens a new one. Authoring it by hand only takes
// effect through a load path that bypasses that logic — otherwise the service replaces whatever is
// supplied with one entry stamped at load time.
//
// THE TEAM IS RECORDED TWICE, the same way the managing organization is: once as the current
// value and once with the period it has held. `team` names the CareTeam responsible now, and
// extension[teamHistory] pairs that same team with its period. See careteam.fsh — the team is
// organization data that already exists on the target, resolved there by identifier.
//
// The period is open — a start with no end — which is what makes the episode current. Compare
// episodeofcare-completed.fsh: the same patient's earlier episode for the same condition, closed
// in June 2025, with status finished and a full status history. Two episodes per patient is what
// the customer's dataset requires, and this is the open one of the pair.

Instance: episodeofcare
InstanceOf: ehealth-episodeofcare
Usage: #example
Title: "Episode of care"
Description: "The open episode of care the monitoring plan is delivered under, addressing the COPD diagnosis."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[caremanagerOrganization].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[organisation].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[period].valuePeriod.start = "2026-01-08T09:00:00+00:00"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam)
* extension[teamHistory].extension[period].valuePeriod.start = "2026-01-08T09:00:00+00:00"
* status = #active
* statusHistory[0].status = #planned
* statusHistory[=].period.start = "2026-01-08T09:00:00+00:00"
* statusHistory[=].period.end = "2026-01-08T09:05:00+00:00"
* statusHistory[+].status = #active
* statusHistory[=].period.start = "2026-01-08T09:05:00+00:00"
* diagnosis.condition = Reference(condition)
* patient = Reference(patient)
* period.start = "2026-01-08T09:00:00+00:00"
* team = Reference(careteam)
