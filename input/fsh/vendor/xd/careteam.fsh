// Vendor xd — programme telesaar.
//
// telesaar is Telemedicinsk Sårvurdering, so a COPD team under it is a deliberate simplification:
// every vendor in this dataset runs the same KOL plan, and reasonCode stays DJ44.

Instance: careteam-xd
InstanceOf: ehealth-careteam
Usage: #example
Title: "KOL care team for telesaar"
Description: "The care team responsible for the COPD monitoring under telesaar."
* extension[useContext].valueUsageContext.code = $usage-context-type#program "Program"
* extension[useContext].valueUsageContext.valueCodeableConcept = $ehealth-program#telesaar
* identifier.use = #official
* identifier.system = "urn:ietf:rfc:3986"
// dk-core requires a full URI here, so the scheme is part of the value.
* identifier.value = "urn:uuid:e5e80e63-4a72-498f-8cc0-f881980fed3e"
* status = #active
* name = "Telemedicinsk KOL-team - telesaar"
* period.start = "2025-01-01T00:00:00+01:00"
* participant.role[0] = $careteam-participant-role#monitoring_adjuster "Monitoring adjuster"
* participant.role[+] = $careteam-participant-role#monitoringAssistor "Monitoring assistor"
* participant.role[+] = $careteam-participant-role#clinicalViewer "Clinical viewer"
* participant.role[+] = $careteam-participant-role#citizenEnroller "Citizen enroller"
* participant.member = Reference(practitioner-xd)
* participant.period.start = "2025-01-01T00:00:00+01:00"
* reasonCode = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* managingOrganization = Reference(org-region-nordjylland)
