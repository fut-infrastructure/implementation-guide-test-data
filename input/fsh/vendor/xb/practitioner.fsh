// Vendor xb — programme kpro.

Instance: practitioner-xb
InstanceOf: ehealth-practitioner
Usage: #example
Title: "Practitioner kpro"
Description: "Practitioner for kpro, assigned on a care team for kpro."
* identifier.system = $practitioner-uid
* identifier.value = "ebf319ef-fcd7-4757-80df-0611f11bb618"
* active = true
* name.family = "Testesen"
* name.given[0] = "Test"
* name.given[+] = "kpro"
* qualification[officialHealthAuthorization].identifier.system = $autreg
* qualification[officialHealthAuthorization].identifier.value = "00102"
* qualification[officialHealthAuthorization].code = $profession-group#7170 "Læge"
