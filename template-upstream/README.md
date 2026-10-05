# Upstream copies

Unmodified `fhir.base.template` files, kept so the local overrides in `../ig-template/` can be
diffed against what they replace:

    diff template-upstream/createArtifactSummary.xslt ig-template/scripts/createArtifactSummary.xslt

They are deliberately OUTSIDE `ig-template/` — everything in there is copied into the built
template, and these are reference material, not template content.
