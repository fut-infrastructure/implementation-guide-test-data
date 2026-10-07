// EpisodeOfCare, COMPLETED — the same patient's earlier episode for the same diagnosis.
//
// A second episode on one patient, closed before the open one began: monitoring ran from March to
// June 2025, ended, and was started again in January 2026. Same patient, same diagnosis — but its
// OWN Condition, because a Condition can reference only one episode. This is the shape the
// customer's dataset needs, ten patients with two episodes each, and it is also the only way to
// get completed episodes into the data at all.
//
// "COMPLETED" IS `finished`. EpisodeOfCare.status is bound to the R4 value set, whose codes are
// planned, waitlist, active, onhold, finished, cancelled and entered-in-error. There is no
// "completed".
//
// THE PERIOD IS CLOSED, and period is 1..1 on the profile, so it is mandatory either way. Here it
// carries both a start and an end, which is what distinguishes this episode from the open one —
// see episodeofcare.fsh, where the end is absent.
//
// statusHistory RUNS THE WHOLE COURSE: planned, then active for the months it was delivered, then
// finished. Every entry but the last has a closed period; the last is the status still in force.
// The managing-organization and team-history periods are closed to the same dates, because
// neither responsibility outlived the episode.
//
// IT IS NOT LOADABLE AS IT STANDS, and that is worth being explicit about. The careplan service
// stamps meta.lastUpdated from the wall clock and maintains statusHistory itself, so loading this
// produces an episode that was created and finished at load time rather than one that ran for
// three months in 2025. The dates here are the intent; putting them into the database is a
// separate step the loader cannot do through the FHIR API.

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
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam)
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
// Its own Condition, not the open episode's — see condition-completed.fsh.
* diagnosis.condition = Reference(p01-eoc1-cond)
* patient = Reference(p01)
* period.start = "2025-03-03T09:00:00+00:00"
* period.end = "2025-06-30T12:00:00+00:00"
* team = Reference(careteam)
