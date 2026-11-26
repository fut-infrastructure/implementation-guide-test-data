# ehealth.dk.testdata.template

An OVERLAY on `fhir.base.template`, not a replacement. The publisher lays the base template down
first, then copies these files over the top, so only the files that need changing are here.

It exists because three defects in the base template affect the resources in this guide. Each is
reproducible and each silently degrades a page rather than failing a build, which is why they are
fixed here rather than worked around.

## scripts/createArtifactSummary.xslt

Two changes, both about the Artifacts Summary page.

**Content now starts at `h2`, not `h3`.** The published stylesheet numbers headings with CSS
counters: `h2:before` increments `section`, `h3:before` increments `sub-section`, and the content
is rendered as `prefix "." section "." sub-section`. Because the base template emitted `h3` for
every grouping and nothing above it, the `section` counter never incremented and every heading
numbered `2.0.1`, `2.0.2`, … The page title is an `h2` outside that counter scope, so it could not
supply the missing level. Starting at `h2` numbers them `2.1`, `2.2`, … as intended — and
`h2 { counter-reset: sub-section }` in the stylesheet then resets the child counter per section,
which is further evidence the stylesheet expected content to begin at `h2`.

**Groupings are subdivided by resource type.** The grouping list in an ImplementationGuide is flat
by construction — `definition.grouping` has no parent pointer and `resource.groupingId` is `0..1`,
so a resource belongs to exactly one grouping and groupings cannot nest. The hierarchy is therefore
built at render time: one `h2` per grouping, then one `h3` and one table per resource type within
it, with the type read from `resource.reference.reference` (`"ActivityDefinition/ad-head"`), which
the base template already carried but used only for the link tooltip. Grouping by FHIR R4 module in
`sushi-config.yaml` and subdividing by type here gives both levels without leaving the spec.
The contents list at the top of the page is nested to match.

## liquid/ActivityDefinition.liquid

**`relatedArtifact` of type `documentation` and `composed-of` were not rendered at all.** The base
template handled only `citation`, `depends-on`, `derived-from`, `successor` and `predecessor`, and
never looked at `relatedArtifact.document`, so inline guidance had no path to the page. Its sibling
`Library.liquid` handles all eight artifact types, so this was an omission rather than a design.

Two smaller fixes in the same file: the `citation` and `depends-on` rows were guarded on
`relatedArtifact.exists()` rather than on the filtered set, so a resource with neither emitted an
empty row; and a `{% if artifact.type == 'citation' %}` used `==`, which is not valid FHIRPath and
raised `Premature ExpressionNode termination at unexpected token "=="`.

## liquid/*.liquid — escaping the decoded payload

**`decode('base64')` emitted its result unescaped into the narrative XHTML.** Any payload
containing markup therefore destroyed the whole narrative for that resource — silently, with no
error and no narrative exception. A guidance document containing `<br>` and a Drools rule
containing `List<Observation…>` both triggered it. Every decode site now ends `.escape('html')`.

This affected the base template's own CQL block in `Library.liquid`, not just the `text/plain`
handling added here: CQL contains `<` in comparisons, so any guide publishing a CQL library through
the base template loses that page's narrative the same way.

## Note on a resource's own narrative

A Library carrying `text.div` shows that narrative instead of the generated table — the publisher
prefers supplied narrative over generated. That is correct behaviour, not a defect, and is why
some Library pages show no `Content:` section regardless of the fixes above.

## Upstream

`fhir.base.template` is end of life: its own `package-list.json` records 1.0.0 as the final
release, with development moved to `fhir.base.template2`, and the publisher warns that the package
is no longer considered secure. These fixes belong upstream against the successor rather than here;
until then, unmodified copies in ../template-upstream/ allow each change to be diffed.
