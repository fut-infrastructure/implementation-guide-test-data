// Practitioner — A TEMPLATE, AND ANONYMOUS.
//
// Not created on the target environment. Like an Organization or a CareTeam, a Practitioner is
// organization data that already exists there, and the loader resolves it by identifier — so the
// identifier is a ${PLACEHOLDER} and the resource id used here is a local handle.
//
// ANONYMOUS FOR THE SAME REASON THE PATIENT IS. A practitioner is a real person, so the name, the
// environment identifier and the authorisation number are all placeholders. The profession is not
// personal data and stays real: it is what makes the template mean something.
//
// WHAT EACH IDENTIFIER IS:
//   identifier                  the environment identifies a practitioner by an LDAP uid, whose
//                               real values embed a CVR number and a RID. Both identify a person
//                               and the organisation they work for, so the value is a placeholder.
//   (no authorisation)          the practitioner's authorisation number in Styrelsen for
//                               Patientsikkerhed's register is absent entirely. It is personal,
//                               and it cannot be anonymised — see the note on the rules below.
//   qualification.code          the profession group. A placeholder too, so the template states
//                               no profession at all.
//
// THE PROFESSION PLACEHOLDER COSTS ONE VALIDATION ERROR, unlike the others here. The name and the
// two identifiers are string-typed, so a ${PLACEHOLDER} in them validates cleanly. This one sits
// in a coded element, so the validator reports an unknown code in
// http://hl7.dk/fhir/core/CodeSystem/DkCoreProfessionGroupCodes — the same unsuppressible kind of
// error as ${EHEALTH_PROGRAM}. The system is kept alongside it so that substituting the code
// yields a complete coding; the alternative, putting the placeholder in code.text and leaving out
// the coding, validates without error but gives the loader nowhere to write a real code.
//
// The binding is extensible and the code system holds 21 Danish profession groups, of which 5166
// Sygeplejerske is the one this team would have — telemedical COPD monitoring is nurse-led, which
// is also why the care team gives this practitioner monitoringAssistor. Since qualification is
// 0..*, leaving it out entirely is the other way to say nothing, and costs no error.
//
// name is 1..1 — the profile requires exactly one, so it cannot be left out the way the patient's
// birthDate was. Both parts are strings, so placeholders validate cleanly.

Instance: practitioner
InstanceOf: ehealth-practitioner
Usage: #example
Title: "Practitioner (template)"
Description: "Template for a practitioner on the care team. Carries no personal data: the loader substitutes the identifier, name and authorisation number."
// PLACEHOLDERS: see aliases.fsh. All sit in string-typed elements, so they validate cleanly.
* identifier.system = $practitioner-uid
* identifier.value = "${PRACTITIONER_IDENTIFIER}"
* active = true
* name.family = "${PRACTITIONER_FAMILY_NAME}"
* name.given = "${PRACTITIONER_GIVEN_NAME}"
// NO officialHealthAuthorization SLICE AT ALL — an unsliced qualification carrying only the
// profession. That slice is identified by identifier.system, and dk-core then requires
// identifier.value (1..1) to be exactly 5 characters drawn from the consonants, Y and the digits.
// No ${PLACEHOLDER} can fit in five characters, and the value cannot be left out, so the slice
// cannot be used anonymously at all. qualification itself only requires code.
// PLACEHOLDER in a coded element — this one does cost an error. See the header.
* qualification.code = $profession-group#"${PROFESSION_GROUP}"
