// Vendor xb — programme telma.

Instance: careteam-telma
InstanceOf: ehealth-careteam
Usage: #example
Title: "KOL care team for telma"
Description: "The care team responsible for the COPD monitoring under telma."
* extension[useContext].valueUsageContext.code = $usage-context-type#program "Program"
* extension[useContext].valueUsageContext.valueCodeableConcept = $ehealth-program#telma
* identifier.use = #official
* identifier.system = "urn:ietf:rfc:3986"
// dk-core requires a full URI here, so the scheme is part of the value.
* identifier.value = "urn:uuid:f974ea3c-4481-4651-808a-b270ff4795dd"
* status = #active
* name = "Telemedicinsk KOL-team - telma"
* period.start = "2025-01-01T00:00:00+01:00"
* participant.role[0] = $careteam-participant-role#monitoring_adjuster "Monitoring adjuster"
* participant.role[+] = $careteam-participant-role#monitoringAssistor "Monitoring assistor"
* participant.role[+] = $careteam-participant-role#clinicalViewer "Clinical viewer"
* participant.role[+] = $careteam-participant-role#citizenEnroller "Citizen enroller"
* participant.member = Reference(practitioner-telma)
* participant.period.start = "2025-01-01T00:00:00+01:00"
* reasonCode = $sks#DJ44 "Kronisk obstruktiv lungesygdom"
* managingOrganization = Reference(org-region-hovedstaden)
