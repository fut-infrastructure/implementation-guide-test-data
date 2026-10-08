// Condition for the COMPLETED episode — LOADABLE.
//
// A SECOND CONDITION RECORDING THE SAME DIAGNOSIS, because the back-reference does not stretch to
// two episodes. extension[episodeOfCare] is 0..1, so a Condition names exactly one episode. The
// open episode and the completed one therefore each need their own Condition, and each names its
// own. That is also what the environment does: a production episode's diagnosis.condition points
// at a Condition created alongside it, not at one shared with an earlier episode.
//
// SAME CODE, SAME PATIENT, DIFFERENT EPISODE. Nothing clinical distinguishes it from condition.fsh
// — it is the same DJ44 in the same person. The duplication is a consequence of how the episode
// link is modelled, not a statement that the patient has two diagnoses.
//
// clinicalStatus STAYS active even though the episode is finished. COPD is chronic: the monitoring
// ended in June 2025, the disease did not. Marking it resolved would say something untrue about
// the patient, and nothing in the profile ties clinicalStatus to the episode's status.

Instance: p01-eoc1-cond
InstanceOf: ehealth-condition
Usage: #example
Title: "Chronic obstructive pulmonary disease (completed episode)"
Description: "The COPD diagnosis as recorded under the completed episode of care. The same diagnosis as the other Condition: each episode carries its own, because a Condition can reference only one episode."
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[episodeOfCare].valueReference = Reference(p01-eoc1)
* clinicalStatus = $condition-clinical#active "active"
* code = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* subject = Reference(p01)
