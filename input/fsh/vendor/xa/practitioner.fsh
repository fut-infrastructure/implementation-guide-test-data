// Vendor xa — programme telma.

Instance: practitioner-xa
InstanceOf: ehealth-practitioner
Usage: #example
Title: "Practitioner telma"
Description: "Practitioner for telma, assigned on a care team for telma."
* identifier.system = $practitioner-uid
* identifier.value = "19a67fa3-f91e-45e6-bedb-a737845329a4"
* active = true
* name.family = "Testesen"
* name.given[0] = "Test"
* name.given[+] = "telma"
* qualification[officialHealthAuthorization].identifier.system = $autreg
* qualification[officialHealthAuthorization].identifier.value = "00101"
* qualification[officialHealthAuthorization].code = $profession-group#7170 "Læge"
