// Condition — LOADABLE. Rule set only; the instances are under data/.
//
// The diagnosis the episode of care addresses, and the reason the monitoring plan is in place.
// DJ44 Kronisk obstruktiv lungesygdom, from the Danish SKS classification — the same diagnosis the
// plan and its activities name in their `focus` use context, so the whole set agrees on what is
// being monitored.
//
// ONE CONDITION PER EPISODE, NOT ONE PER DIAGNOSIS, so p10 carries four Conditions recording the
// same DJ44. The duplication is forced by the model rather than chosen: extension[episodeOfCare]
// is 0..1, so a Condition names exactly one episode, while diagnosis.condition is 1..* in the
// other direction. Production does the same, creating a Condition alongside each episode.
//
// IT POINTS BACK AT ITS EPISODE while that episode's diagnosis.condition points here, so the pair
// is mutually referencing and neither can be created before the other in a plain dependency order
// — a transaction bundle resolves it, because references to `urn:uuid` entries are matched within
// the transaction.
//
// clinicalStatus IS active ON THE FINISHED EPISODES' CONDITIONS TOO. COPD is chronic: closing an
// episode ends the monitoring, not the disease, and nothing in the profile ties clinicalStatus to
// the episode's status.

RuleSet: EpisodeCondition(patient, eoc)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference({eoc})
* clinicalStatus = $condition-clinical#active "active"
* code = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* subject = Reference({patient})
