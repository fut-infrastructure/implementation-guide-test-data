// Practitioners — the placeholder only. The concrete ones are one per vendor, under
// vendor/<code>/practitioner.fsh.
//
// EVERY VALUE IS SYNTHETIC. The names are Test${EHEALTH_PROGRAM} Testesen, the identifiers are UUIDs,
// and the authorisation numbers are test authorization numbers.
//
// WHAT EACH IDENTIFIER IS:
//   identifier                  the LDAP uid, under urn:oid:0.9.2342.19200300.100.1.1. 
//   qualification.identifier    the authorisation number in Styrelsen for Patientsikkerhed's
//                               register.
//   qualification.code          profession group 7170, Læge.

// The practitioner the placeholder team lists.
Instance: practitioner-placeholder
InstanceOf: ehealth-practitioner
Usage: #example
Title: "Practitioner (placeholder)"
Description: "Stands in for a practitioner on the care team the scenario runs under. The loader substitutes a real one."
* identifier.system = $practitioner-uid
* identifier.value = "${PRACTITIONER_IDENTIFIER}"
* active = true
* name.family = "Testesen"
* name.given[0] = "Test"
* name.given[+] = "${EHEALTH_PROGRAM}"
* qualification[officialHealthAuthorization].identifier.system = $autreg
* qualification[officialHealthAuthorization].identifier.value = "00100"
* qualification[officialHealthAuthorization].code = $profession-group#7170 "Læge"
