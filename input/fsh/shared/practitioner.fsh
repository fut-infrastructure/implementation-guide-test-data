// Practitioners — one per programme, currently: kpro, telma and fob.
//
// EVERY VALUE IS SYNTHETIC. The names are Test <programme> Testesen, the identifiers are UUIDs,
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
* name.given = "Test"
* qualification[officialHealthAuthorization].identifier.system = $autreg
* qualification[officialHealthAuthorization].identifier.value = "00100"
* qualification[officialHealthAuthorization].code = $profession-group#7170 "Læge"

Instance: practitioner-kpro
InstanceOf: ehealth-practitioner
Usage: #example
Title: "Practitioner kpro"
Description: "Practitioner for kpro, assigned on a care team for kpro."
* identifier.system = $practitioner-uid
* identifier.value = "19a67fa3-f91e-45e6-bedb-a737845329a4"
* active = true
* name.family = "Testesen"
* name.given[0] = "Test"
* name.given[+] = "kpro"
* qualification[officialHealthAuthorization].identifier.system = $autreg
* qualification[officialHealthAuthorization].identifier.value = "00101"
* qualification[officialHealthAuthorization].code = $profession-group#7170 "Læge"

Instance: practitioner-telma
InstanceOf: ehealth-practitioner
Usage: #example
Title: "Practitioner telma"
Description: "Practitioner for telma, assigned on a care team for telma."
* identifier.system = $practitioner-uid
* identifier.value = "ebf319ef-fcd7-4757-80df-0611f11bb618"
* active = true
* name.family = "Testesen"
* name.given[0] = "Test"
* name.given[+] = "telma"
* qualification[officialHealthAuthorization].identifier.system = $autreg
* qualification[officialHealthAuthorization].identifier.value = "00102"
* qualification[officialHealthAuthorization].code = $profession-group#7170 "Læge"

Instance: practitioner-fob
InstanceOf: ehealth-practitioner
Usage: #example
Title: "Practitioner fob"
Description: "Practitioner for fob, assigned on a care team for fob."
* identifier.system = $practitioner-uid
* identifier.value = "55c30f5e-efb5-4e84-8212-cbf89477ce46"
* active = true
* name.family = "Testesen"
* name.given[0] = "Test"
* name.given[+] = "fob"
* qualification[officialHealthAuthorization].identifier.system = $autreg
* qualification[officialHealthAuthorization].identifier.value = "00103"
* qualification[officialHealthAuthorization].code = $profession-group#7170 "Læge"
