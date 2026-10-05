// Patient — A TEMPLATE, AND ANONYMOUS.
//
// Not created on the target environment. The data loader resolves a Patient by CPR identifier to
// find the real resource id there, exactly as it does for an Organization — see organization.fsh
// for the conventions that apply. The resource id used here is a local handle that never reaches
// the target.
//
// ONE PATIENT IS DEFINED HERE AND IT DESCRIBES NOBODY. The loader produces ten patients from this
// shape, substituting a CPR and the other personal details per copy. So every identifying element
// is either a ${PLACEHOLDER} or absent, and the resource's job is to show which elements a patient
// carries, not to carry values.
//
// WHY SOME ELEMENTS ARE PLACEHOLDERS AND OTHERS ARE OMITTED. A ${PLACEHOLDER} is only safe in an
// element typed as a plain string, where there is no binding and no pattern to violate. The
// elements left out are the ones where a placeholder would be invalid data rather than a marker:
//
//   birthDate       type `date`. "${BIRTHDATE}" is not a date and fails the type check. The
//                   element is 0..1, so leaving it out is clean, and a birth date is identifying
//                   in combination with anything else anyway.
//   maritalStatus   CodeableConcept, extensible binding, and the profile carries an invariant
//                   restricting which forms of marriage are permitted in the Danish context.
//                   0..1, so omitted.
//   address extensions
//                   municipalityCode and regionalSubDivisionCodes are CodeableConcepts with bound
//                   value sets, and they pin the patient to a municipality and a region. Omitted.
//
// GENDER IS THE EXCEPTION. It is 1..1 with a required binding, so it can be neither omitted nor
// given a placeholder. administrative-gender includes `unknown`, which is the honest value for a
// template that describes no one — it validates, and it says the real value is supplied elsewhere.
//
// SO THE CPR IS STILL THE ONLY FIELD THAT HAS TO BE RIGHT, and here it is not even that: it is the
// one value the loader must supply for the resolution to find anything.

Instance: patient
InstanceOf: ehealth-patient
Usage: #example
Title: "Patient (template)"
Description: "Template for a test patient. Carries no personal data: the loader substitutes a CPR and the remaining details for each patient it creates. Expected to pre-exist on the target environment; resolved by CPR identifier."
// PLACEHOLDERS: see aliases.fsh. These sit in string-typed elements, so they validate cleanly.
* identifier[cpr].use = #official
* identifier[cpr].system = $cpr
* identifier[cpr].value = "${CPR}"
* active = true
// name[official] is discriminated by a fixed use = #official, so SUSHI sets `use` itself.
// family is 1..1 within the slice; given is optional but kept, to show both parts.
* name[official].family = "${FAMILY_NAME}"
* name[official].given = "${GIVEN_NAME}"
// telecom[NemSMS] is discriminated by a fixed value = "NemSMS" with system patterned to #other; a
// path rule instantiates the slice and SUSHI fills both in. Neither is personal data — the slice
// records that the patient is reachable by NemSMS, it does not hold a number.
* telecom[NemSMS]
// 1..1 with a required binding: cannot be omitted, cannot take a placeholder. See the header.
* gender = #unknown
// address[officialHomeAddress] is discriminated by a fixed use = #home.
* address[officialHomeAddress]
  * type = #postal
  * line = "${ADDRESS_LINE}"
  * city = "${CITY}"
  * postalCode = "${POSTAL_CODE}"
  * country = "DK"
