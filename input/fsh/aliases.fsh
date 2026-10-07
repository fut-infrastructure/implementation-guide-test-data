// Aliases for the systems referenced by the test data. Values are taken from the core IG's
// NamingSystem and CodeSystem definitions rather than from its example instances — several of
// those examples use identifier systems that are not what their surrounding context suggests.

// Identifier systems the data loader uses to resolve reference resources on the target.
// NamingSystem-sor: Sundhedsvæsenets Organisationsregister (SOR)
Alias: $sor = urn:oid:1.2.208.176.1.1
// KOMBIT Støttesystem (STS) Organisation — fixed by dk-core-kombit-org-identifier on the
// KOMBIT-ORG-ID slice
Alias: $kombit-sts-org = https://kombit.dk/sts/organisation

// Organization terminology
Alias: $organization-source = http://ehealth.sundhed.dk/cs/organization-source
Alias: $organization-synchronization-status = http://ehealth.sundhed.dk/cs/organization-synchronization-status
Alias: $oio-organization-type = http://ehealth.sundhed.dk/cs/oio-organization-type

// Plan and activity terminology
Alias: $usage-context-type = http://terminology.hl7.org/CodeSystem/usage-context-type
Alias: $ehealth-program = http://ehealth.sundhed.dk/cs/ehealth-program
Alias: $jurisdiction = http://ehealth.sundhed.dk/cs/jurisdiction
Alias: $topic-type = http://ehealth.sundhed.dk/cs/topic-type
Alias: $activitydefinition-code = http://ehealth.sundhed.dk/cs/activitydefinition-code
Alias: $modifier-role = http://ehealth.sundhed.dk/cs/modifier-role
Alias: $measurement-sharing-policies = http://ehealth.sundhed.dk/cs/measurement-sharing-policies
Alias: $measurement-sharing-approval-policies = http://ehealth.sundhed.dk/cs/measurement-sharing-approval-policies

// Observation codes, and the reference-range systems the triage rules read
// NPU — the Danish laboratory code system used for most observation codes
Alias: $npu = urn:oid:1.2.208.176.2.1
// Absolute (therapeutic) reference-range types: GAL is a yellow alarm, RAL a red one
Alias: $absolute-range = urn:oid:1.2.208.184.100.1
// Relative reference-range types, measured against a Goal's baseline
Alias: $reference-range-type = http://ehealth.sundhed.dk/cs/reference-range-type

// Questionnaire terminology
Alias: $questionnaire-types = http://ehealth.sundhed.dk/cs/questionnaire-types
Alias: $questionnaire-item-control = http://hl7.org/fhir/questionnaire-item-control
Alias: $questionnaire-item-significance-indicator = http://ehealth.sundhed.dk/cs/questionnaire-item-significance-indicator

// Library terminology
Alias: $library-type = http://ehealth.sundhed.dk/cs/library-type

// ---------------------------------------------------------------------------------------------
// PLACEHOLDERS
//
// Values written as ${NAME} are substituted by the data loader when it creates these resources on
// a target environment. They are deliberately not real codes, and a build-time check reports every
// one so none is discovered only at load time.
//
//   ${EHEALTH_PROGRAM}    the programme these definitions belong to, a code from
//                         http://ehealth.sundhed.dk/cs/ehealth-program. It names the deployment
//                         the plan is being loaded for, so it cannot be fixed here.
//
//   ${COEXISTENCE_TAG}    the coexistence tag in meta.tag, a code from
//                         http://ehealth.sundhed.dk/cs/ehealth-system. It marks which deployment
//                         owns the record, so it too belongs to the environment rather than here.
//                         Only the patient-specific resources carry it; the definitions do not.
//
//   ${CARETEAM_UUID}      the UUID part of the CareTeam's identifier, which the target environment
//                         already holds. The loader resolves the team by it, exactly as it
//                         resolves an Organization. Only the UUID is substituted: the value is
//                         written "urn:uuid:${CARETEAM_UUID}" because dk-core requires a full URI.
//
//   ${PRACTITIONER_IDENTIFIER}
//   ${PRACTITIONER_FAMILY_NAME}
//   ${PRACTITIONER_GIVEN_NAME}
//   ${PROFESSION_GROUP}   the practitioner on the care team. Resolved by identifier like the team
//                         itself, and anonymous for the same reason the patient is. The identifier
//                         and both name parts are free; ${PROFESSION_GROUP} is a code and costs an
//                         error. The authorisation number has no placeholder at all — it cannot
//                         hold one. See practitioner.fsh.
//
//   THE PATIENTS HAVE NONE. They were placeholders once, a single template with ${CPR} and the
//   name and address substituted per patient. There are now ten concrete test identities read
//   back from the target environment, so nothing needs substituting — and the ${CPR} placeholder
//   is gone along with the regex error it caused.
//
// NOTE THE DIFFERENCE IN COST — and do not assume a string element is free. Three cases:
//
//   free        a plain string with no further constraint: the practitioner's name and
//               identifier, the care team's UUID.
//
//   one error   a coded element, where the validator cannot find the code in its code system:
//   per use     ${EHEALTH_PROGRAM}, ${COEXISTENCE_TAG}, ${PROFESSION_GROUP}. A regex-constrained
//               string counts too — that is what ${CPR} used to cost before the patients became
//               concrete, via dk-core-cpr-identifier.
//
//   impossible  a string constrained so tightly that no placeholder fits. The practitioner's
//               authorisation number is 5 characters of consonants, Y and digits, and "${X}" is
//               already 4. Leave the element out instead — see practitioner.fsh.
//
// And where the constraint only dictates shape, put the placeholder inside it rather than giving
// up: the care team's identifier is "urn:uuid:${CARETEAM_UUID}" because dk-core demands a URI.
//
// None of these errors can be suppressed; the publisher's file covers warnings and hints only.
// ---------------------------------------------------------------------------------------------

// Danish SNOMED CT extension, version 20150731 — the code system the core IG ships as
// CodeSystem/snomed-20150731, used for organization type codings
Alias: $sct-dk-20150731 = http://snomed.info/sct/554471000005108/version/20150731

// Patient terminology
// NamingSystem-cpr: Det Centrale Personregister (CPR)
Alias: $cpr = urn:oid:1.2.208.176.1.2
// Practitioner terminology
// The LDAP uid OID, which is the system the environment identifies a practitioner by
Alias: $practitioner-uid = urn:oid:0.9.2342.19200300.100.1.1
// No alias for Styrelsen for Patientsikkerhed's authorisation register (https://autregweb.sst.dk).
// The practitioner's qualification carries only a profession, not an authorisation — see
// practitioner.fsh for why that slice cannot be used anonymously.
Alias: $profession-group = http://hl7.dk/fhir/core/CodeSystem/DkCoreProfessionGroupCodes
Alias: $careteam-participant-role = http://ehealth.sundhed.dk/cs/careteam-participant-role
// CarePlan.status, and the status recorded in each careplan statusHistory entry
Alias: $request-status = http://hl7.org/fhir/request-status
// Submitted measurements and responses
// Codes: Resolved, Unresolved, Adhoc, Extra — a submission against the unscheduled branch is Extra
Alias: $resolved-timing-type = http://ehealth.sundhed.dk/cs/resolved-timing-type
Alias: $ehealth-identifier = http://ehealth.sundhed.dk/id/ehealth-identifier

// Automated-processing results: what triage writes when a submission arrives
Alias: $sct = http://snomed.info/sct
Alias: $clinicalimpression-codes = http://ehealth.sundhed.dk/cs/clinicalimpression-codes
Alias: $clinicalimpression-finding-codes = http://ehealth.sundhed.dk/cs/clinicalimpression-finding-codes
Alias: $clinicalimpression-investigation-item-codes = http://ehealth.sundhed.dk/cs/clinicalimpression-investigation-item-codes
Alias: $task-category = http://ehealth.sundhed.dk/cs/task-category
Alias: $restriction-category = http://ehealth.sundhed.dk/cs/restriction-category
// Back in use now that the patients are concrete test identities rather than one anonymised
// template — all three are coded, so they could not have held a placeholder. See patient.fsh.
Alias: $dk-municipality-codes = http://hl7.dk/fhir/core/CodeSystem/dk-core-municipality-codes
Alias: $iso3166-2 = urn:iso:std:iso:3166:-2
Alias: $v3-MaritalStatus = http://terminology.hl7.org/CodeSystem/v3-MaritalStatus

// Episode and condition terminology
Alias: $ehealth-system = http://ehealth.sundhed.dk/cs/ehealth-system
Alias: $condition-clinical = http://terminology.hl7.org/CodeSystem/condition-clinical
// SKS, the Danish classification the diagnosis codes come from
Alias: $sks = urn:oid:1.2.208.176.2.4
