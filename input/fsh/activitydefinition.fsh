// ActivityDefinitions for the COPD monitoring plan — LOADABLE.
//
// Fourteen activities, nine in the scheduled branch and five in the unscheduled extra branch.
// Four kinds, distinguished by `code`:
//
//     HA          head activity — a visual container with no content of its own
//     SDG         same device group — one device reading, several values, no content of its own
//     409073007   Instruktion — guidance text only, carried as base64 markdown in relatedArtifact
//     273586006   Master Questionnaire, composed-of a questionnaire
//     NPU03011    oxygen saturation
//     NPU21692    heart rate
//
// ONLY THE ACTIVITIES THAT PRODUCE A VALUE CARRY A LIBRARY. The saturation and pulse point at the
// absolute-threshold rule, the questionnaires at the answer-significance rule; the containers and
// the guidance carry none, because there is nothing to triage. That holds in the extra branch as
// well as the scheduled one — an unscheduled measurement is triaged exactly like a scheduled one.
//
// ABSOLUTE THRESHOLDS, the same on the scheduled and extra copies:
//
//     saturation  RAL <= 85 %        GAL 85.0000001 - 88 %       green > 88 %
//     pulse       RAL <= 50 /min     GAL 50.0000001 - 60 /min
//                 RAL >= 130 /min    GAL 110 - 129.9999999 /min  green 60 - 110 /min
//
// GAL is a yellow alarm, RAL a red one. The odd endpoints — .0000001 and .9999999 — express an
// open bound with a closed comparison, so that 85.0 is red and anything above it is not.
// These are ABSOLUTE ranges, in the measurement's own unit, so no Goal is needed; that is the
// difference from a relative range, which is a delta on a baseline a Goal supplies.
//
// THE THRESHOLDS LIVE ON THE ACTIVITY AND ARE COPIED ONTO THE OBSERVATION. The triage rule reads
// them from the Observation it is given, not from the ServiceRequest, so a submitted measurement
// must carry them or it cannot be assessed.
//
// useContext is not uniform, by design: every activity carries the programme, but only the ones
// that do something also carry `focus`. The four containers — two head activities and two device
// groups — carry the programme alone.

RuleSet: Common
* extension[sharingPolicy].valueCodeableConcept = $measurement-sharing-policies#sharingAllowedDestinationNationalHealthData
* extension[modifierRole][0].extension[reference].valueReference = Reference(org-region-midtjylland)
* extension[modifierRole][0].extension[role].valueCodeableConcept = $modifier-role#owner
* extension[baseEnvironment].valueIdentifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[baseEnvironment].valueIdentifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* version = "1.0"
* status = #active
* useContext[0].code = $usage-context-type#program
* useContext[0].valueCodeableConcept = $ehealth-program#"${EHEALTH_PROGRAM}"
* jurisdiction = $jurisdiction#healthcare-act
* topic = $topic-type#self-treatment

// Every activity carries the programme context, but only the ones that actually do something also
// carry focus = DJ44. The four containers — two head activities and two device groups — carry the
// programme alone, so they do not insert this.
RuleSet: Focus
* useContext[+].code = $usage-context-type#focus
* useContext[=].valueCodeableConcept = urn:oid:1.2.208.176.2.4#DJ44 "Kronisk obstruktiv lungesygdom"

RuleSet: MeasurementPolicy
* extension[sharingApprovalPolicy].valueCodeableConcept = $measurement-sharing-approval-policies#manual

RuleSet: SaturationRanges
* extension[referenceRange][0].extension[high].valueQuantity = 85 '%' "%"
* extension[referenceRange][0].extension[type].valueCodeableConcept.coding[0] = $absolute-range#RAL
* extension[referenceRange][0].extension[type].valueCodeableConcept.coding[+] = $npu#NPU03011
* extension[referenceRange][1].extension[low].valueQuantity = 85.0000001 '%' "%"
* extension[referenceRange][1].extension[high].valueQuantity = 88 '%' "%"
* extension[referenceRange][1].extension[type].valueCodeableConcept.coding[0] = $absolute-range#GAL
* extension[referenceRange][1].extension[type].valueCodeableConcept.coding[+] = $npu#NPU03011

RuleSet: PulseRanges
* extension[referenceRange][0].extension[high].valueQuantity = 50 '1/min' "1/min"
* extension[referenceRange][0].extension[type].valueCodeableConcept.coding[0] = $absolute-range#RAL
* extension[referenceRange][0].extension[type].valueCodeableConcept.coding[+] = $npu#NPU21692
* extension[referenceRange][1].extension[low].valueQuantity = 50.0000001 '1/min' "1/min"
* extension[referenceRange][1].extension[high].valueQuantity = 60 '1/min' "1/min"
* extension[referenceRange][1].extension[type].valueCodeableConcept.coding[0] = $absolute-range#GAL
* extension[referenceRange][1].extension[type].valueCodeableConcept.coding[+] = $npu#NPU21692
* extension[referenceRange][2].extension[low].valueQuantity = 110 '1/min' "1/min"
* extension[referenceRange][2].extension[high].valueQuantity = 129.9999999 '1/min' "1/min"
* extension[referenceRange][2].extension[type].valueCodeableConcept.coding[0] = $absolute-range#GAL
* extension[referenceRange][2].extension[type].valueCodeableConcept.coding[+] = $npu#NPU21692
* extension[referenceRange][3].extension[low].valueQuantity = 130 '1/min' "1/min"
* extension[referenceRange][3].extension[type].valueCodeableConcept.coding[0] = $absolute-range#RAL
* extension[referenceRange][3].extension[type].valueCodeableConcept.coding[+] = $npu#NPU21692

// ---------------------------------------------------------------------------------------------
// Scheduled branch
// ---------------------------------------------------------------------------------------------

Instance: ad-head
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Head activity"
Description: "Container for the scheduled saturation, pulse and questionnaire."
* insert Common
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:66b7bb62-2c4e-4b94-8355-bab359b27e74"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Målinger og spørgeskema"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:a996d0cd-a36d-4f20-b58f-c6d2b1c95882"
* title = "Målinger og spørgeskema"
* code = $activitydefinition-code#HA

Instance: ad-intro
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Introduktion"
Description: "Opening guidance for a scheduled round."
* insert Common
* insert Focus
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:371c78a3-cfd1-4d05-9436-d4218353ba17"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Introduktion"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:bd470b20-6de0-4880-a9a7-5beeef3333ae"
* title = "Introduktion"
* relatedArtifact.type = #documentation
* relatedArtifact.document.contentType = #text/markdown
* relatedArtifact.document.data = "RHUgdmlsIG51IGJsaXZlIGJlZHQgb20gYXQgbGF2ZSBmb3Jza2VsbGlnZSBtw6VsaW5nZXIgb2cgc3ZhcmUgcMOlIGVuIHLDpmtrZSBzcMO4cmdzbcOlbAoKPGJyPgpUcnlrIHDDpSAidmlkZXJlIiBmb3IgYXQgZ8OlIHRpbCBmw7hyc3RlIG3DpWxpbmc="
* code = $activitydefinition-code#409073007

Instance: ad-sat-pulse-intro
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Måling af iltmætning og puls"
Description: "Guidance shown before the saturation and pulse measurement: warm the hands, and what the reading involves."
* insert Common
* insert Focus
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:70d3654c-fb75-4ec2-a9bc-02d062b8e6d8"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Måling af iltmætning og puls"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:06685e0e-b912-466a-a2ef-d5911bd4c00e"
* title = "Måling af iltmætning og puls"
* relatedArtifact.type = #documentation
* relatedArtifact.document.contentType = #text/markdown
* relatedArtifact.document.data = "RHUgc2thbCBudSBtw6VsZSBkaW4gaWx0bcOmdG5pbmcgb2cgcHVscy4KClN0YXJ0IG1lZCBhdCB0YWdlIGjDpW5kZW4gb3AgdGlsIGhhbHNlbiBvZyBtw6ZyayBvbSBkaW5lIGZpbmdyZSBlciB2YXJtZS4KCkh2aXMgZGluZSBmaW5ncmUgZXIga29sZGUsIHNrYWwgZHUgdmFybWUgZGVtIG9wIHZlZCBmLmVrcy4KCiogQXQgcGxhY2VyZSBow6VuZGVuIGkgYXJtaHVsZW4KKiBBdCBnbmlkZSBow6ZuZGVybmUgbW9kIGhpbmFuZGVuCgpOw6VyIGRpbmUgZmluZ3JlIGbDuGxlcyB2YXJtZSwga2FuIGR1IGZvcmV0YWdlIG3DpWxpbmdlbi4KCjxicj4KVHJ5ayBww6UgInZpZGVyZSI="
* code = $activitydefinition-code#409073007

Instance: ad-sat-pulse-prep
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Forberedelse"
Description: "Immediate preparation: sit still for five minutes beforehand and keep the hand steady during the reading."
* insert Common
* insert Focus
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:f11af78e-4841-4f6c-b254-f6a27e605673"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Forberedelse"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:713d6191-d8ed-4024-b2e9-feee2f77120c"
* title = "Forberedelse"
* relatedArtifact.type = #documentation
* relatedArtifact.document.contentType = #text/markdown
* relatedArtifact.document.data = "ClNpZCBpIHJvIGNhLiA1IG1pbiBmw7hyLCBhdCBkdSBiZWd5bmRlciBtw6VsaW5nZW4uCkh1c2sgYXQgaG9sZGUgZmluZ2VyZW4gaSBybyB1bmRlciBtw6VsaW5nZW4sIGzDpmcgZi5la3MuIGjDpW5kZW4gcMOlIGJvcmRldC4KClRyeWsgcMOlICJ2aWRlcmUi"
* code = $activitydefinition-code#409073007

Instance: ad-sat-pulse
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Iltmætning og pulsmåling (same device group)"
Description: "The same-device group: one pulse oximeter, one patient action, two values. Its children are the saturation and the pulse."
* insert Common
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:55239d11-3b90-4ee1-95d1-70d890f83a8d"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Iltmætning og pulsmåling"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:272e6a5a-0ba7-4bdd-97fc-439a857cc079"
* title = "Iltmætning og pulsmåling"
* description = "\nOverføres måling ikke via bluetooth, skal du vælge at indtaste målingen manuelt"
* relatedArtifact.id = "c83eefcc-73e5-4dbe-83f3-60b7ce7757c1"
* relatedArtifact.type = #documentation
* relatedArtifact.label = "[manual]"
* relatedArtifact.document.contentType = #text/markdown
* relatedArtifact.document.data = "U8OmdCBpbHRtw6VsZXJlbiBww6UgZmluZ2VyZW4gb2cgbcOlbCBkaW4gaWx0bcOmdG5pbmcgb2cgcHVscy4KT3ZlcmbDuHJlcyBtw6VsaW5nZW4gaWtrZSBhdXRvbWF0aXNrLCBza2FsIGR1IHbDpmxnZSBhdCBpbmR0YXN0ZSBtw6VsaW5nZW4gbWFudWVsdC4KClRyeWsgcMOlICJpbmR0YXN0IiBmb3IgYXQgZsOlIHRhc3RhdHVyZXQgZnJlbQoKTsOlciBkZSBrb3JyZWt0ZSBtw6VsaW5nZXIgc2VzIGkgZmVsdGV0LCB0cnlrIHDDpSAidmlkZXJlIg=="
* code = $activitydefinition-code#SDG

Instance: ad-saturation
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Iltmætning"
Description: "Oxygen saturation, triaged against absolute thresholds: red at or below 85%, yellow up to 88%, green above."
* insert Common
* insert Focus
* insert MeasurementPolicy
* insert SaturationRanges
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:11b62d04-4bb4-4839-8e5a-73638a38f136"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Iltmætning"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:9a7aee2f-18c0-412a-af8b-748c0e4f90ad"
* title = "Iltmætning"
* library = Canonical(library-observation-absolute-triage)
* code = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"

Instance: ad-pulse
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Puls"
Description: "Heart rate, triaged against absolute thresholds: red at or below 50 and at or above 130, yellow either side of the 60-110 green band."
* insert Common
* insert Focus
* insert MeasurementPolicy
* insert PulseRanges
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:6c6264e3-06d9-4f1b-a9a5-777a4e4845ef"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Puls"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:fab3ffd6-b78e-4783-8f5c-b5a253bb1991"
* title = "Puls"
* library = Canonical(library-observation-absolute-triage)
* code = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"

Instance: ad-questionnaire
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Spørgeskema"
Description: "Master Questionnaire activity presenting the symptom questionnaire, the single questionnaire of this plan."
* insert Common
* insert Focus
* insert MeasurementPolicy
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:fdd75fce-ac81-4272-86cd-15d79ae31619"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Spørgeskema om tilstand og symptomer"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:4631ba35-8f90-4407-8df7-3a824e125a66"
* title = "Spørgeskema om tilstand og symptomer"
* relatedArtifact.type = #composed-of
* relatedArtifact.display = "410_KOL spørgeskema"
* relatedArtifact.resource = Canonical(questionnaire)
* library = Canonical(library-questionnaire-triage)
* code = $activitydefinition-code#273586006

Instance: ad-closing
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Afrunding"
Description: "Closing guidance for a scheduled round."
* insert Common
* insert Focus
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:2bd8547d-e267-41ed-8ef8-d1d1a59cc4a2"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Afrunding"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:a10b1a43-be04-490e-bd03-b2de793846c8"
* title = "Afrunding"
* relatedArtifact.type = #documentation
* relatedArtifact.document.contentType = #text/markdown
* relatedArtifact.document.data = "ClRhayBmb3IgZGluIGJlc3ZhcmVsc2UuCgpWaSBrb250YWt0ZXIgZGlnLCBodmlzIHZpIHZ1cmRlcmVyLCBhdCBkZXIgcMOlIGJhZ2dydW5kIGFmIGRpbmUgbcOlbGluZ2VyIG9nIHJlZ2lzdHJlcmluZ2VyLCBlciBicnVnIGZvciBkZXR0ZS4="
* code = $activitydefinition-code#409073007

// ---------------------------------------------------------------------------------------------
// Extra branch — no schedule. This is where the dataset's submissions go.
// ---------------------------------------------------------------------------------------------

Instance: ad-extra-head
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Ekstra head activity"
Description: "Container for the unscheduled saturation, pulse and questionnaire."
* insert Common
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:7cae4b7f-86a6-417b-9aeb-c5b2416833e0"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Ekstra målinger og spørgeskema"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:b4799d74-f74f-4b82-8aa0-8e0d0f806fad"
* title = "Ekstra målinger og spørgeskema"
* code = $activitydefinition-code#HA

Instance: ad-extra-sat-pulse
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Ekstra iltmætning og pulsmåling (same device group)"
Description: "The unscheduled same-device group."
* insert Common
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:4c4d0b1a-f1bd-4b7f-95c2-b299d3b9f9be"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Iltmætning og pulsmåling"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:2bd24b55-2dbc-4e28-8660-2c18bc43f111"
* title = "Iltmætning og pulsmåling"
* description = "\nOverføres måling ikke via bluetooth, skal du vælge at indtaste målingen manuelt"
* relatedArtifact.type = #documentation
* relatedArtifact.label = "[manual]"
* relatedArtifact.document.contentType = #text/markdown
* relatedArtifact.document.data = "U8OmdCBpbHRtw6VsZXJlbiBww6UgZmluZ2VyZW4gb2cgbcOlbCBkaW4gaWx0bcOmdG5pbmcgb2cgcHVscy4KT3ZlcmbDuHJlcyBtw6VsaW5nZW4gaWtrZSBhdXRvbWF0aXNrLCBza2FsIGR1IHbDpmxnZSBhdCBpbmR0YXN0ZSBtw6VsaW5nZW4gbWFudWVsdC4KClRyeWsgcMOlICJpbmR0YXN0IiBmb3IgYXQgZsOlIHRhc3RhdHVyZXQgZnJlbQoKTsOlciBkZSBrb3JyZWt0ZSBtw6VsaW5nZXIgc2VzIGkgZmVsdGV0LCB0cnlrIHDDpSAidmlkZXJlIg=="
* code = $activitydefinition-code#SDG

Instance: ad-extra-saturation
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Ekstra iltmætning"
Description: "Unscheduled oxygen saturation, with the same absolute thresholds as the scheduled one."
* insert Common
* insert Focus
* insert MeasurementPolicy
* insert SaturationRanges
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:05b363e1-d75b-41d2-a1d9-9941100dd2eb"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Iltmætning"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:d7cb19bd-e35b-4c1d-bbe7-6255a6be51b7"
* title = "Iltmætning"
* library = Canonical(library-observation-absolute-triage)
* code = $npu#NPU03011 "Hb(Fe; O2-bind.; aB)—Oxygen(O2); mætn. = ?"

Instance: ad-extra-pulse
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Ekstra puls"
Description: "Unscheduled heart rate, with the same absolute thresholds as the scheduled one."
* insert Common
* insert Focus
* insert MeasurementPolicy
* insert PulseRanges
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:74d90f9f-8236-4243-aa0f-32a6b34f1635"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Puls"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:bd0067fe-5204-48ed-b67c-5fab075c81e1"
* title = "Puls"
* library = Canonical(library-observation-absolute-triage)
* code = $npu#NPU21692 "Hjerte—Systole; frekv. = ? × 1/min"

Instance: ad-extra-questionnaire
InstanceOf: ehealth-activitydefinition
Usage: #example
Title: "Ekstra spørgeskema"
Description: "Unscheduled Master Questionnaire activity, composed of the same questionnaire as the scheduled one."
* insert Common
* insert Focus
* insert MeasurementPolicy
* extension[base].valueIdentifier.system = "urn:ietf:rfc:3986"
* extension[base].valueIdentifier.value = "urn:uuid:1a85cf90-84aa-40d8-a231-315abe238f78"
* extension[base].valueIdentifier.assigner.identifier.system = "http://ehealth.sundhed.dk/id/ehealth-environment"
* extension[base].valueIdentifier.assigner.identifier.value = "dk.ehealth.sundhed.fhir.ig.testdata"
* extension[employeeTitle].valueString = "Spørgeskema om tilstand og symptomer"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:77bc2bc0-4d27-4fa6-a5fd-e9d1ac77f9aa"
* title = "Spørgeskema om tilstand og symptomer"
* relatedArtifact.type = #composed-of
* relatedArtifact.display = "410_KOL spørgeskema"
* relatedArtifact.resource = Canonical(questionnaire)
* library = Canonical(library-questionnaire-triage)
* code = $activitydefinition-code#273586006
