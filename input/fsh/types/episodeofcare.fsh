// EpisodeOfCare — LOADABLE. Rule sets only; the instances are under data/.
//
// The episode everything patient-specific belongs to. A care plan built from the plan definition,
// the service requests it creates, and every measurement and questionnaire response submitted
// against them all carry a reference back to an episode; this is that anchor.
//
// TWENTY EPISODES, 13 ACTIVE AND 7 FINISHED, is what the customer's dataset requires. They are not
// two per patient: p01..p07 have a finished episode followed by an open one, which is the ordinary
// history, p08 and p09 have a single open episode, and p10 has four open at once. Two open
// episodes against the same plan definition is the odd case, so it is confined to p10.
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
// statusHistory TRACKS THE TRANSITIONS, each with the period it held. The careplan service
// maintains it: on create it writes a single entry for the current status, and on a status change
// it closes the open period and opens a new one. Authoring it by hand only takes effect through a
// load path that bypasses that logic — otherwise the service replaces whatever is supplied with
// one entry stamped at load time.
//
// THE TEAM IS RECORDED TWICE, the same way the managing organization is: once as the current
// value and once with the period it has held. See careteam.fsh.
//
// AN OPEN PERIOD — a start with no end — is what makes an episode current; a finished one carries
// both, and so do its managing-organization and team-history periods, because neither
// responsibility outlived the episode.
//
// "COMPLETED" IS `finished` HERE. EpisodeOfCare.status is bound to the R4 value set — planned,
// waitlist, active, onhold, finished, cancelled, entered-in-error — which has no completed code.
// CarePlan.status is bound to request-status, which does. One real-world state, two codes.
//
// THE FINISHED EPISODES ARE NOT LOADABLE AS THEY STAND. The careplan service stamps
// meta.lastUpdated from the wall clock and maintains statusHistory itself, so loading one produces
// an episode created and finished at load time rather than one that ran for months in 2025. The
// dates are the intent; putting them into the database is a step the loader cannot do through the
// FHIR API.

RuleSet: EpisodeActive(patient, cond, start, activeFrom)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[caremanagerOrganization].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[organisation].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[period].valuePeriod.start = "{start}"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam-placeholder)
* extension[teamHistory].extension[period].valuePeriod.start = "{start}"
* status = #active
* statusHistory[0].status = #planned
* statusHistory[=].period.start = "{start}"
* statusHistory[=].period.end = "{activeFrom}"
* statusHistory[+].status = #active
* statusHistory[=].period.start = "{activeFrom}"
* diagnosis.condition = Reference({cond})
* patient = Reference({patient})
* period.start = "{start}"
* team = Reference(careteam-placeholder)

// Written out rather than layered on EpisodeActive: the two differ in the middle of the status
// history, and patching an entry another rule set opened is what makes soft indices land wrong.
RuleSet: EpisodeFinished(patient, cond, start, activeFrom, end)
// PLACEHOLDER: the coexistence tag. See aliases.fsh.
* meta.tag = $ehealth-system#"${COEXISTENCE_TAG}"
* extension[caremanagerOrganization].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[organisation].valueReference = Reference(org-region-hovedstaden)
* extension[managingOrganization].extension[period].valuePeriod.start = "{start}"
* extension[managingOrganization].extension[period].valuePeriod.end = "{end}"
* extension[teamHistory].extension[careTeam].valueReference = Reference(careteam-placeholder)
* extension[teamHistory].extension[period].valuePeriod.start = "{start}"
* extension[teamHistory].extension[period].valuePeriod.end = "{end}"
* status = #finished
* statusHistory[0].status = #planned
* statusHistory[=].period.start = "{start}"
* statusHistory[=].period.end = "{activeFrom}"
* statusHistory[+].status = #active
* statusHistory[=].period.start = "{activeFrom}"
* statusHistory[=].period.end = "{end}"
* statusHistory[+].status = #finished
* statusHistory[=].period.start = "{end}"
* diagnosis.condition = Reference({cond})
* patient = Reference({patient})
* period.start = "{start}"
* period.end = "{end}"
* team = Reference(careteam-placeholder)
