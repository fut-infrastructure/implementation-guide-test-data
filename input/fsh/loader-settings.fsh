Instance: loader-settings
InstanceOf: Parameters
Usage: #example
Title: "Loader settings"
Description: "Read by the loader, never loaded. anchorDate is the day the scenario is written for: it maps to the load date, and every date in the data shifts by the same number of days. One vendor parameter per coexistence tag this dataset is loadable for, pairing the tag with the programme it runs: the loader substitutes ${COEXISTENCE_TAG} and ${EHEALTH_PROGRAM} together, making one copy of the vendor-scoped data per vendor listed here."
* parameter[+].name = "anchorDate"
* parameter[=].valueDate = "2026-10-01"

// Both sides are codings rather than strings, so the tag is checked against ehealth-system, and programme against ehealth-program.
// The Vendors page tabulates these parameters, and make-groups.js fails the build if a vendor's care team names a different programme.
* parameter[+].name = "vendor"
* parameter[=].part[0].name = "systemTag"
* parameter[=].part[=].valueCoding = $ehealth-system#xa
* parameter[=].part[+].name = "programme"
* parameter[=].part[=].valueCoding = $ehealth-program#telma

* parameter[+].name = "vendor"
* parameter[=].part[0].name = "systemTag"
* parameter[=].part[=].valueCoding = $ehealth-system#xb
* parameter[=].part[+].name = "programme"
* parameter[=].part[=].valueCoding = $ehealth-program#kpro

* parameter[+].name = "vendor"
* parameter[=].part[0].name = "systemTag"
* parameter[=].part[=].valueCoding = $ehealth-system#xc
* parameter[=].part[+].name = "programme"
* parameter[=].part[=].valueCoding = $ehealth-program#fob

* parameter[+].name = "vendor"
* parameter[=].part[0].name = "systemTag"
* parameter[=].part[=].valueCoding = $ehealth-system#xd
* parameter[=].part[+].name = "programme"
* parameter[=].part[=].valueCoding = $ehealth-program#telesaar
