// Patients — THE TEN FUT-IN-A-BOX TEST CITIZENS, users FUT076 to FUT085.
//
// Not created on the target. The loader resolves a Patient by CPR, so the CPR is the one value
// that has to match something already there — and these ten do, because they are the citizens the
// environment issues for exactly this purpose. They log in with MitID; the simulator identity that
// goes with each is in the test-citizen document, not here, because it is a login credential
// rather than patient data.
//
// SYNTHETIC PEOPLE, NOT ANONYMISED ONES. An earlier version of this file held a single template
// with ${PLACEHOLDER}s in every identifying element, because inventing a person is not acceptable
// and naming a real one less so. These ten are test identities that already exist, so the real
// values can be used.
//
// THREE CPRs CARRY A RESTORED LEADING ZERO. p01, p05 and p10 render as nine digits in the source
// document, which is numeric formatting dropping the zero: dk-core's cpr invariant requires the
// day to match 0[1-9]|1[0-9]|2[0-9]|3[0-1], and 50/51 are not days. All ten match once restored.
//
// gender AND birthDate ARE DERIVED FROM THE CPR, not supplied: the last digit gives the sex, odd
// male and even female, and the first six give the date with the century taken from the seventh.
// The derived sex agrees with all ten names, which is the check that the reading is right.
//
// NO ADDRESS, maritalStatus OR generalPractitioner. The previous ten had them, read back from the
// environment; the test-citizen document carries only CPR and name, and those fields are not
// derivable from a CPR. They are left out rather than invented — the profile requires only
// identifier and gender. Read them off the environment and add them here if the dataset needs an
// address to exercise something.

RuleSet: TestCitizen(cpr, family, given, sex, born)
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "{cpr}"
* name[official].family = "{family}"
* name[official].given = "{given}"
* telecom[NemSMS]
* gender = #{sex}
* birthDate = "{born}"

// FUT076 · Sonja Knudsen
Instance: p01
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 01"
Description: "Test patient 01, CPR 0508754760."
* insert TestCitizen(0508754760, Knudsen, Sonja, female, 1975-08-05)

// FUT077 · Ulrik Møller
Instance: p02
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 02"
Description: "Test patient 02, CPR 1501989971."
* insert TestCitizen(1501989971, Møller, Ulrik, male, 1998-01-15)

// FUT078 · Mette Kristensen
Instance: p03
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 03"
Description: "Test patient 03, CPR 2412589206."
* insert TestCitizen(2412589206, Kristensen, Mette, female, 1958-12-24)

// FUT079 · Thomas Bonde
Instance: p04
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 04"
Description: "Test patient 04, CPR 1311633801."
* insert TestCitizen(1311633801, Bonde, Thomas, male, 1963-11-13)

// FUT080 · Grete Kristensen
Instance: p05
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 05"
Description: "Test patient 05, CPR 0512894992."
* insert TestCitizen(0512894992, Kristensen, Grete, female, 1989-12-05)

// FUT081 · Andreas Bonde
Instance: p06
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 06"
Description: "Test patient 06, CPR 1207969563."
* insert TestCitizen(1207969563, Bonde, Andreas, male, 1996-07-12)

// FUT082 · Karl Larsen
Instance: p07
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 07"
Description: "Test patient 07, CPR 1509829345."
* insert TestCitizen(1509829345, Larsen, Karl, male, 1982-09-15)

// FUT083 · Line Sørensen
Instance: p08
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 08"
Description: "Test patient 08, CPR 1512543258."
* insert TestCitizen(1512543258, Sørensen, Line, female, 1954-12-15)

// FUT084 · Ane Larsen
Instance: p09
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 09"
Description: "Test patient 09, CPR 1905839388."
* insert TestCitizen(1905839388, Larsen, Ane, female, 1983-05-19)

// FUT085 · Martin Kristensen
Instance: p10
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient 10"
Description: "Test patient 10, CPR 0510049527."
* insert TestCitizen(0510049527, Kristensen, Martin, male, 2004-10-05)
