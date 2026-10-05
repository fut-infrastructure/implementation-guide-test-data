// Organizations.
//
// These are not created on the target environment. Every one of them is expected to exist there
// already, and the data loader resolves each by IDENTIFIER to find its real resource id, rewriting
// the references in the loadable resources accordingly. The resource ids used here are local
// handles that never reach the target.
//
// NOTHING IN THIS FILE DECLARES THAT. The loader decides what to resolve and what to create from
// the resource TYPE, so neither the ids nor the titles mark it — a reader tells the two apart the
// same way the loader does.
//
// So the identifier is the only field that has to be right. Both organizations here are SOR
// organizations, and their identifiers go in the SOR-ID slice. Note the slice is NOT always that
// one: a municipal organization is a KOMBIT Støttesystem (STS) one, with source = STS-ORG and its
// identifier in the KOMBIT-ORG-ID slice instead. Use whichever slice matches the source; the
// loader resolves by the identifier it finds.
//
// TWO ORGANIZATIONS, SPLIT BY WHAT THEY DO RATHER THAN BY WHAT THEY OWN:
//
//   Region Midtjylland owns every definition — the plan, its activities, the questionnaire and the
//   automated-processing rules. It is named in the modifierRole extension on each of them.
//
//   Region Hovedstaden delivers the care. It is the episode's care manager and managing
//   organization, and the care team's managing organization.
//
// So the definitional artefacts are authored in one place and used in another, which is how these
// definitions work in practice: a plan is defined once and run by whoever delivers the monitoring.
//
// modifierRole is the only slice on a definition that refers to an organization at all — the
// optional intendedAudience and intendedOrganization slices are deliberately absent, which leaves
// these definitions available to every organization rather than restricted to a named few.
//
// The rest of each organization's content documents what the target is expected to hold.

Instance: org-region-midtjylland
InstanceOf: ehealth-organization
Usage: #example
Title: "Region Midtjylland"
Description: "Owner of the two automated-processing rules. Expected to pre-exist on the target; resolved by SOR identifier."
* extension[cvrNumber].valueString = "29190925"
* extension[regionCode].valueString = "1082"
* extension[municipalityCode].valueString = "0791"
* extension[source].valueCodeableConcept = $organization-source#SOR "Sundhedsvæsenets Organisationsregister"
* extension[synchronizationStatus].valueCodeableConcept = $organization-synchronization-status#EligibleForSynchronization
* identifier[SOR-ID].use = #official
* identifier[SOR-ID].system = $sor
* identifier[SOR-ID].value = "6081000016005"
* identifier[SOR-ID].period.start = "2007-08-29T00:00:00+00:00"
* active = true
* type = $sct-dk-20150731#550881000005103 "region"
* name = "Region Midtjylland"
* alias = "Region Midtjylland"
* telecom[+].system = #phone
* telecom[=].value = "87285000"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "kontakt@regionmidtjylland.dk"
* telecom[=].use = #work
* telecom[+].system = #fax
* telecom[=].value = "87285900"
* telecom[=].use = #work
* telecom[+].system = #url
* telecom[=].value = "https://www.regionmidtjylland.dk"
* telecom[=].use = #work
* address[+].use = #work
* address[=].type = #postal
* address[=].line = "Skottenborg 26"
* address[=].city = "Viborg"
* address[=].postalCode = "8800"
* address[=].country = "DK"
* address[+].use = #work
* address[=].type = #physical
* address[=].line = "Skottenborg 26"
* address[=].city = "Viborg"
* address[=].postalCode = "8800"
* address[=].country = "DK"

Instance: org-region-hovedstaden
InstanceOf: ehealth-organization
Usage: #example
Title: "Region Hovedstaden"
Description: "Owner and intended audience of the plan and its activities. Expected to pre-exist on the target; resolved by SOR identifier."
* extension[cvrNumber].valueString = "29190623"
* extension[regionCode].valueString = "1084"
* extension[municipalityCode].valueString = "0219"
* extension[source].valueCodeableConcept = $organization-source#SOR "Sundhedsvæsenets Organisationsregister"
* extension[synchronizationStatus].valueCodeableConcept = $organization-synchronization-status#EligibleForSynchronization
* identifier[SOR-ID].use = #official
* identifier[SOR-ID].system = $sor
* identifier[SOR-ID].value = "6111000016004"
* identifier[SOR-ID].period.start = "2007-08-29T00:00:00+00:00"
* active = true
* type = $sct-dk-20150731#550881000005103 "region"
* name = "Region Hovedstaden"
* alias = "Region Hovedstaden"
* telecom[0].system = #phone
* telecom[=].value = "48205000"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "regionh@regionh.dk"
* telecom[=].use = #work
* telecom[+].system = #url
* telecom[=].value = "https://www.regionhovedstaden.dk"
* telecom[=].use = #work
* address[0].use = #work
* address[=].type = #postal
* address[=].line = "Kongens Vænge 2"
* address[=].city = "Hillerød"
* address[=].postalCode = "3400"
* address[=].country = "DK"
* address[+].use = #work
* address[=].type = #physical
* address[=].line = "Kongens Vænge 2"
* address[=].city = "Hillerød"
* address[=].postalCode = "3400"
* address[=].country = "DK"
