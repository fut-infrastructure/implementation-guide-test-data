// Patients — TEN CONCRETE TEST IDENTITIES, taken from the target environment's own samples.
//
// Not created on the target. The loader resolves a Patient by CPR, so the CPR is the one value
// that has to match something already there — and these ten do, because they were read back from
// the environment rather than invented.
//
// SYNTHETIC PEOPLE, NOT ANONYMISED ONES. An earlier version of this file held a single template
// with ${PLACEHOLDER}s in every identifying element, because inventing a person is not acceptable
// and naming a real one less so. These ten are test identities that already exist, so the real
// values can be used: that removes the placeholders, removes the CPR regex error they caused, and
// gives the ten distinct CPRs the dataset needs. The addresses do not always agree with their
// postcodes — Hasselvej in Nuuk, Weidekampsgade in the Faroes — which is itself a sign the data is
// generated rather than real.
//
//
// generalPractitioner IS A LOGICAL REFERENCE — an identifier with no reference, keyed by
// Ydernummer (urn:oid:1.2.208.176.1.4), which the core IG defines as a NamingSystem. So it names a
// practice without needing a resource in this guide to point at.
//
// GENERATED ONCE from the environment's samples, then maintained here by hand.

Instance: p01
InstanceOf: ehealth-patient
Usage: #example
Title: "Hakob Joumøller"
Description: "Test patient 01, CPR 0908899393."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "0908899393"
* name[official].family = "Joumøller"
* name[official].given = "Hakob"
* telecom[NemSMS]
* gender = #male
* birthDate = "1989-08-09"
* address[officialHomeAddress]
  * type = #postal
  * line = "Helgolandsgade 354"
  * city = "Terndrup"
  * postalCode = "9575"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0420
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-83
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p02
InstanceOf: ehealth-patient
Usage: #example
Title: "Stine Rasmussen"
Description: "Test patient 02, CPR 2406799436."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "2406799436"
* active = true
* name[official].family = "Rasmussen"
* name[official].given = "Stine"
* gender = #female
* birthDate = "1979-06-24"
* address[officialHomeAddress]
  * type = #postal
  * line = "Weidekampsgade 38"
  * city = "Frederiksberg C"
  * postalCode = "1951"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0740
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-82
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p03
InstanceOf: ehealth-patient
Usage: #example
Title: "Fie Møller"
Description: "Test patient 03, CPR 2105018404."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "2105018404"
* name[official].family = "Møller"
* name[official].given = "Fie"
* gender = #female
* birthDate = "2001-05-21"
* address[officialHomeAddress]
  * type = #postal
  * line = "Dronninggårds Allé 331"
  * city = "København K"
  * postalCode = "1216"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0575
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-83
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p04
InstanceOf: ehealth-patient
Usage: #example
Title: "Line Rasmussen"
Description: "Test patient 04, CPR 1007850448."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "1007850448"
* name[official].family = "Rasmussen"
* name[official].given = "Line"
* gender = #female
* birthDate = "1985-07-10"
* address[officialHomeAddress]
  * type = #postal
  * line = "Hasselvej 171"
  * city = "Nuuk"
  * postalCode = "3900"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0740
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-82
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p05
InstanceOf: ehealth-patient
Usage: #example
Title: "Adrian Bach"
Description: "Test patient 05, CPR 0108720417."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "0108720417"
* name[official].family = "Bach"
* name[official].given = "Adrian"
* gender = #male
* birthDate = "1972-08-01"
* address[officialHomeAddress]
  * type = #postal
  * line = "Hasselvej 405"
  * city = "København K"
  * postalCode = "1360"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0710
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-82
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p06
InstanceOf: ehealth-patient
Usage: #example
Title: "Bente Bach"
Description: "Test patient 06, CPR 1406612674."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "1406612674"
* active = true
* name[official].family = "Bach"
* name[official].given = "Bente"
* gender = #female
* birthDate = "1961-06-14"
* address[officialHomeAddress]
  * type = #postal
  * line = "Frodesgade 164"
  * city = "Frederiksberg C"
  * postalCode = "1958"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0190
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-84
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p07
InstanceOf: ehealth-patient
Usage: #example
Title: "Anne Pedersen"
Description: "Test patient 07, CPR 2307684902."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "2307684902"
* active = true
* name[official].family = "Pedersen"
* name[official].given = "Anne"
* gender = #female
* birthDate = "1968-07-23"
* address[officialHomeAddress]
  * type = #postal
  * line = "Lønvejen 305"
  * city = "København K"
  * postalCode = "1410"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0461
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-83
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p08
InstanceOf: ehealth-patient
Usage: #example
Title: "Jeppe Jørgensen"
Description: "Test patient 08, CPR 1210669643."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "1210669643"
* active = true
* name[official].family = "Jørgensen"
* name[official].given = "Jeppe"
* gender = #male
* birthDate = "1966-10-12"
* address[officialHomeAddress]
  * type = #postal
  * line = "Kroghsgade 168"
  * city = "Blokhus"
  * postalCode = "9492"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0175
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-84
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p09
InstanceOf: ehealth-patient
Usage: #example
Title: "Jakob Rasmussen"
Description: "Test patient 09, CPR 0209723123."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "0209723123"
* active = true
* name[official].family = "Rasmussen"
* name[official].given = "Jakob"
* gender = #male
* birthDate = "1972-09-02"
* address[officialHomeAddress]
  * type = #postal
  * line = "Højgårdsparken 468"
  * city = "København K"
  * postalCode = "1220"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0330
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-85
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"

Instance: p10
InstanceOf: ehealth-patient
Usage: #example
Title: "Ina Pedersen"
Description: "Test patient 10, CPR 0306909622."
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "0306909622"
* active = true
* name[official].family = "Pedersen"
* name[official].given = "Ina"
* gender = #female
* birthDate = "1990-06-03"
* address[officialHomeAddress]
  * type = #postal
  * line = "Weidekampsgade 215"
  * city = "Nes, Eysturoy"
  * postalCode = "0655"
  * country = "DK"
  * extension[municipalityCode].valueCodeableConcept = $dk-municipality-codes#0751
  * extension[regionalSubDivisionCodes].valueCodeableConcept = $iso3166-2#DK-82
* maritalStatus = $v3-MaritalStatus#U "unmarried"
* generalPractitioner.identifier.system = "urn:oid:1.2.208.176.1.4"
* generalPractitioner.identifier.value = "077704"
