// CareTeam — the clinicians responsible for the episode.
//
// Not created on the target environment. Like an Organization, a CareTeam is organization data
// that already exists there, and the loader resolves it by identifier to find the real resource
// id — so the identifier is a ${PLACEHOLDER} and the resource id used here is a local handle that
// never reaches the target. Everything else describes what the target is expected to hold.
//
// REFERENCED TWICE FROM THE EPISODE, and once from each care plan built under it:
//   EpisodeOfCare.team                     the team currently responsible
//   EpisodeOfCare.extension[teamHistory]   the same team with the period it has held that role
// The careplan service maintains the history the same way it maintains statusHistory, so a hand-
// authored one only survives a load path that bypasses that logic.
//
// ONE PARTICIPANT, AND ITS ROLE IS NOT AUTHORITATIVE HERE. Membership roles are administered
// outside FHIR and written into the CareTeam by Keycloak, so whatever this guide states will be
// replaced on the target environment. role is 1..* with a required binding, so it cannot be left
// empty or given a placeholder — a single plausible code has to stand in. monitoringAssistor is
// the one chosen because it is the role that bears on what this test data exercises, submitting
// and monitoring measurements, and it is among the most used in practice. Production participants
// typically hold three to seven roles, so treat this as the shape of a participant and not as a
// statement about permissions.
//
// period is set because every participant in practice carries one: all 4951 participants observed
// across 876 production CareTeams have role, member and period.
//
// The member is the Practitioner template — see practitioner.fsh. It is resolved on the target
// environment by identifier, like the team itself, and carries no personal data.
//
// reasonCode is REQUIRED (1..*) with a required binding to http://ehealth.sundhed.dk/vs/conditions
// and it is what makes this a KOL team: DJ44, the same diagnosis the Condition records and the
// plan and its activities name in their `focus`. So the whole set agrees on what is monitored.
//
// category is omitted. It is 0..* with a required binding, and no production CareTeam sets it.
//
// The period is open — a start with no end — which is what makes the team current. It starts
// before the episode does, because the team exists independently of any one episode.

Instance: careteam
InstanceOf: ehealth-careteam
Usage: #example
Title: "KOL care team"
Description: "The care team responsible for the COPD monitoring."
// PLACEHOLDERS: see aliases.fsh.
* extension[useContext].valueUsageContext.code = $usage-context-type#program "Program"
* extension[useContext].valueUsageContext.valueCodeableConcept = $ehealth-program#"${EHEALTH_PROGRAM}"
* identifier.use = #official
* identifier.system = "urn:ietf:rfc:3986"
// The scheme is OUTSIDE the placeholder on purpose. identifier.system is urn:ietf:rfc:3986, and
// dk-core requires the value to be a full URI — a bare "${CARETEAM_IDENTIFIER}" is rejected with
// "the identifier.value must be a full URI (e.g. start with a scheme)". Production values are
// urn:uuid, so the loader substitutes only the UUID.
* identifier.value = "urn:uuid:${CARETEAM_UUID}"
* status = #active
* name = "Telemedicinsk KOL-team"
* period.start = "2025-01-01T00:00:00+01:00"
// Maintained by Keycloak on the target environment — see the header.
* participant.role = $careteam-participant-role#monitoringAssistor "Monitoring assistor"
* participant.member = Reference(practitioner)
* participant.period.start = "2025-01-01T00:00:00+01:00"
* reasonCode = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* managingOrganization = Reference(org-region-hovedstaden)
