// Vendor xc — programme fob.

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
