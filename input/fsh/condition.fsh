// Condition — LOADABLE.
//
// The diagnosis the episode of care addresses, and the reason the monitoring plan is in place.
// DJ44 Kronisk obstruktiv lungesygdom, from the Danish SKS classification — the same diagnosis the
// plan and its activities name in their `focus` use context, so the whole set agrees on what is
// being monitored.
//
// ONE CONDITION PER EPISODE, NOT ONE PER DIAGNOSIS. This is the open episode's. The completed
// episode has its own — condition-completed.fsh — recording the same DJ44 in the same patient.
// The duplication is forced by the model rather than chosen: extension[episodeOfCare] is 0..1, so
// a Condition names exactly one episode, while diagnosis.condition is 1..* in the other direction.
// Production does the same, creating a Condition alongside each episode.
//
// IT POINTS BACK AT ITS EPISODE while that episode's diagnosis.condition points here, so the pair
// is mutually referencing and neither can be created before the other in a plain dependency order
// — a transaction bundle resolves it, because references to `urn:uuid` entries are matched within
// the transaction.
//
// clinicalStatus is active: the condition is current. Closing an episode ends the monitoring, not
// the condition, which is why the completed episode's copy is active too.

Instance: p01-eoc2-cond
InstanceOf: ehealth-condition
Usage: #example
Title: "Kronisk obstruktiv lungesygdom"
Description: "The COPD diagnosis the episode of care addresses and the monitoring plan responds to."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
// The profile names this slice episodeOfCare, so use the slice rather than a raw url — mixing the
// two forms in one project is what produced empty extension stubs in the earlier conversion.
* extension[episodeOfCare].valueReference = Reference(p01-eoc2)
* clinicalStatus = $condition-clinical#active "active"
* code = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* subject = Reference(p01)
