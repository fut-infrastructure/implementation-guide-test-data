// Vendor xd — programme telesaar.

Instance: practitioner-xd
InstanceOf: ehealth-practitioner
Usage: #example
Title: "Practitioner telesaar"
Description: "Practitioner for telesaar, assigned on a care team for telesaar."
* identifier.system = $practitioner-uid
* identifier.value = "f0d64ae8-51b2-4c9f-b791-66acb4f0c28a"
* active = true
* name.family = "Testesen"
* name.given[0] = "Test"
* name.given[+] = "telesaar"
* qualification[officialHealthAuthorization].identifier.system = $autreg
* qualification[officialHealthAuthorization].identifier.value = "00104"
* qualification[officialHealthAuthorization].code = $profession-group#7170 "Læge"
