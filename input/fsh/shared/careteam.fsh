// CareTeams — the placeholder the scenario references. The concrete teams are one per vendor,
// under vendor/<code>/careteam.fsh: xa is kpro, xb telma, xc fob.
//
// reasonCode is 1..* bound to vs/conditions; DJ44 is what makes these KOL teams.
// Keycloak administers membership roles on the environment and replaces what is stated here.
// category is omitted: 0..* with a required binding, and no production CareTeam sets it.

// The team the scenario references. The loader substitutes a real one — for each program.
Instance: careteam-placeholder
InstanceOf: ehealth-careteam
Usage: #example
Title: "KOL care team (placeholder)"
Description: "Stands in for the care team the scenario runs under. The loader substitutes a real one."
* extension[useContext].valueUsageContext.code = $usage-context-type#program "Program"
* extension[useContext].valueUsageContext.valueCodeableConcept = $ehealth-program#"${EHEALTH_PROGRAM}"
* identifier.use = #official
* identifier.system = "urn:ietf:rfc:3986"
// dk-core requires a full URI here, so the scheme is part of the value.
* identifier.value = "urn:uuid:${CARETEAM_UUID}"
* status = #active
* name = "Telemedicinsk KOL-team"
* period.start = "2025-01-01T00:00:00+01:00"
* participant.role[0] = $careteam-participant-role#monitoring_adjuster "Monitoring adjuster"
* participant.role[+] = $careteam-participant-role#monitoringAssistor "Monitoring assistor"
* participant.role[+] = $careteam-participant-role#clinicalViewer "Clinical viewer"
* participant.role[+] = $careteam-participant-role#citizenEnroller "Citizen enroller"
* participant.member = Reference(practitioner-placeholder)
* participant.period.start = "2025-01-01T00:00:00+01:00"
* reasonCode = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* managingOrganization = Reference(org-region-hovedstaden)
