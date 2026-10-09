Instance: p01-eoc1
InstanceOf: ehealth-episodeofcare
Usage: #example
Title: "Episode of care (completed)"
Description: "A completed episode of care for the same patient and the same COPD diagnosis, which ran from March to June 2025. Shows the closed period and the full status history that a finished episode carries."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[caremanagerOrganization].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[organisation].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[period].valuePeriod.start = "2025-03-03T09:00:00+00:00"
* extension[managingOrganization].extension[period].valuePeriod.end = "2025-06-30T12:00:00+00:00"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam-placeholder)
* extension[teamHistory].extension[period].valuePeriod.start = "2025-03-03T09:00:00+00:00"
* extension[teamHistory].extension[period].valuePeriod.end = "2025-06-30T12:00:00+00:00"
* status = #finished
* statusHistory[0].status = #planned
* statusHistory[=].period.start = "2025-03-03T09:00:00+00:00"
* statusHistory[=].period.end = "2025-03-03T09:05:00+00:00"
* statusHistory[+].status = #active
* statusHistory[=].period.start = "2025-03-03T09:05:00+00:00"
* statusHistory[=].period.end = "2025-06-30T12:00:00+00:00"
* statusHistory[+].status = #finished
* statusHistory[=].period.start = "2025-06-30T12:00:00+00:00"
// Its own Condition, not the open episode's — see condition.fsh in this directory.
* diagnosis.condition = Reference(p01-eoc1-cond)
* patient = Reference(p01)
* period.start = "2025-03-03T09:00:00+00:00"
* period.end = "2025-06-30T12:00:00+00:00"
* team = Reference(careteam-placeholder)

// ─── the other six patients ─────────────────────────────────────────────────────────────────────
// Written out rather than layered on EpisodeActive: the two differ in the middle of the status
// history, and patching an entry another rule set opened is what makes soft indices land wrong.

Instance: p01-eoc2
InstanceOf: ehealth-episodeofcare
Usage: #example
Title: "Episode of care"
Description: "The open episode of care the monitoring plan is delivered under, addressing the COPD diagnosis."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[caremanagerOrganization].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[organisation].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[period].valuePeriod.start = "2026-01-08T09:00:00+00:00"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam-placeholder)
* extension[teamHistory].extension[period].valuePeriod.start = "2026-01-08T09:00:00+00:00"
* status = #active
* statusHistory[0].status = #planned
* statusHistory[=].period.start = "2026-01-08T09:00:00+00:00"
* statusHistory[=].period.end = "2026-01-08T09:05:00+00:00"
* statusHistory[+].status = #active
* statusHistory[=].period.start = "2026-01-08T09:05:00+00:00"
* diagnosis.condition = Reference(p01-eoc2-cond)
* patient = Reference(p01)
* period.start = "2026-01-08T09:00:00+00:00"
* team = Reference(careteam-placeholder)

// ─── the other nine patients ────────────────────────────────────────────────────────────────────
// Same shape as p01-eoc2 above, as a rule set. Twelve more open episodes: one each for p02..p09,
// and four for p10, which is the only patient carrying more than one at a time.
