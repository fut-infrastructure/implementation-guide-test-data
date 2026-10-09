// Vendor xc — programme fob.

Instance: careteam-xc
InstanceOf: ehealth-careteam
Usage: #example
Title: "KOL care team for fob"
Description: "The care team responsible for the COPD monitoring under fob."
* extension[useContext].valueUsageContext.code = $usage-context-type#program "Program"
* extension[useContext].valueUsageContext.valueCodeableConcept = $ehealth-program#fob
* identifier.use = #official
* identifier.system = "urn:ietf:rfc:3986"
// dk-core requires a full URI here, so the scheme is part of the value.
* identifier.value = "urn:uuid:5e7c232f-f94a-47f9-b792-2620caaed4ec"
* status = #active
* name = "Telemedicinsk KOL-team - fob"
* period.start = "2025-01-01T00:00:00+01:00"
* participant.role[0] = $careteam-participant-role#monitoring_adjuster "Monitoring adjuster"
* participant.role[+] = $careteam-participant-role#monitoringAssistor "Monitoring assistor"
* participant.role[+] = $careteam-participant-role#clinicalViewer "Clinical viewer"
* participant.role[+] = $careteam-participant-role#citizenEnroller "Citizen enroller"
* participant.member = Reference(practitioner-xc)
* participant.period.start = "2025-01-01T00:00:00+01:00"
* reasonCode = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* managingOrganization = Reference(org-region-hovedstaden)
