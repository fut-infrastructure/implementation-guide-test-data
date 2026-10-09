#!/usr/bin/env node
// Regenerates the `groups:` block of sushi-config.yaml from the built output.
//
// These groups drive the SECTIONS of the rendered artifacts page and nothing else. The data loader
// never reads them — it decides what to create and what to resolve from the resource type.
// Without them the IG Publisher puts every example in one flat list sorted by title.
//
// Resources are grouped by their FHIR R4 module, read from the structuredefinition-category
// extension on each core StructureDefinition rather than assigned by hand, so the taxonomy is the
// spec's and stays right if resource types are added. Note the spec's categories (Base.*,
// Clinical.*, Specialized.*) are finer than the module names on the FHIR website.
//
// MODE:
//   'category'       one section per R4 category                     (5 sections here)
//   'type'           one section per resource type                   (8 sections here)
//   'category-type'  one per type, labelled and ordered by category  (8 sections here)
//
// USE 'category'. The template overlay in ig-template/ already subdivides every grouping by
// resource type to give the artifacts page a second heading level, so the two type modes label
// each section with a type and then repeat that type as the only subheading inside it. The type
// modes are kept because they are what you want without the overlay.
//
// Order is significant: SUSHI writes definition.grouping in the order emitted here.
//
// Usage: sushi . && node scripts/make-groups.js . && sushi .
const fs = require('fs');
const path = require('path');

const REPO = process.argv[2] || '.';
const MODE = process.argv[3] || 'category';
const RES = path.join(REPO, 'fsh-generated', 'resources');
const CORE = path.join(process.env.HOME || process.env.USERPROFILE, '.fhir', 'packages',
  'hl7.fhir.r4.core#4.0.1', 'package');

// R4 categories in the order the spec presents the modules: foundations, then the clinical
// record, then the definitional artefacts that describe care rather than record it.
const CATEGORY_ORDER = [
  ["Base.Individuals", "The people the test data is about."],
  ["Base.Entities", "Organizations the definitions refer to."],
  ["Base.Management", "The episode of care the plan is delivered under, and that every record of care refers back to."],
  ["Clinical.Care Provision", "The plan as delivered to the patient: the care plan, the service requests it consists of, and the care team responsible."],
  ["Clinical.Diagnostics", "What the patient submitted: the measurements and the questionnaire responses."],
  ["Clinical.Summary", "The clinical record: the diagnosis each episode addresses, and the triage result of each submission. The impressions are not loaded — automated processing creates them, and the ones here record what it should produce."],
  ["Foundation.Security", "One Provenance per submission, naming the resources submitted together. This is what triggers automated processing."],
  ["Base.Workflow", "The assessment task raised with each triage result. Not loaded either, and its priority is the triage colour."],
  ["Specialized.Definitional Artifacts", "The plan, the activities it is built from, the questionnaire and the automated-processing rules."],
];

// Deliberate departures from the spec's taxonomy. Keep this list short and say why for each:
// the point of reading structuredefinition-category is that the grouping is not a matter of
// opinion, so every entry here is a place we have decided otherwise on purpose.
const CATEGORY_OVERRIDE = {
  // R4 files Library under Base.Management, alongside EpisodeOfCare. In this project a Library is
  // an automated-processing rule that a plan's activities point at — it belongs with the
  // PlanDefinition, ActivityDefinitions and Questionnaire it is deployed with, not with the
  // episode. Reading the artifacts page, you want the whole definitional set in one place.
  Library: 'Specialized.Definitional Artifacts',
};

// One description per resource type, in the order the sections should render within a module.
// In 'type' and 'category-type' modes a group IS a type, so the module's description would be
// wrong — it describes the whole module, and would repeat under every type in it.
const TYPE_ORDER = [
  ['Patient', 'The ten patients the test data is about, each a concrete test identity from the target environment. p01 carries the full scenario; the rest are patients only.'],
  ['Practitioner', 'The practitioner on the care team.'],
  ['EpisodeOfCare', 'The episode everything patient-specific hangs off: the plan is delivered under it, and every measurement and response refers back to it.'],
  ['Condition', 'The diagnosis the episode addresses, and the reason the plan is in place.'],
  ['CarePlan', 'The plan definition as delivered to the patient, one per episode. Normally created by $apply, which would also create one ServiceRequest per activity.'],
  ['ServiceRequest', 'One per activity of a care plan, created by $apply alongside it. A measurement or questionnaire response is submitted against one of these, and the measurement ones carry the reference ranges triage compares a value against.'],
  ['CareTeam', 'The clinicians responsible for the episode.'],
  ['Observation', 'The measurements submitted, two per submission. Their values are chosen to produce a known triage colour against the reference ranges they carry.'],
  ['QuestionnaireResponse', 'The questionnaire answered as part of each submission. The answers are chosen to produce a known triage colour through the answer significance the questionnaire defines.'],
  ['Provenance', 'One per submission, naming the resources submitted together. This is what triggers automated processing, so triage runs because one of these appeared.'],
  ['ClinicalImpression', 'The triage result for each submitted resource. NOT loaded — automated processing creates these, and the ones here record what it should produce.'],
  ['Task', 'The assessment task raised with each triage result. NOT loaded either; its priority is the triage colour, so red gives asap and yellow urgent.'],
  ['PlanDefinition', 'The monitoring plan: its branches, how each is scheduled, and the order its activities run in.'],
  ['ActivityDefinition', 'One per step of the plan — the containers that group them, the guidance screens, the measurements and the questionnaire activity.'],
  ['Questionnaire', 'The questionnaire the plan collects, carrying the answer significance its triage rule reads.'],
  ['Library', 'The automated-processing rules the measurement and questionnaire activities point at.'],
  ['Organization', 'Organizations the definitions refer to.'],
];
const typeRank = (t) => {
  const i = TYPE_ORDER.findIndex(([x]) => x === t);
  if (i === -1) {
    console.error(`ERROR: resource type ${t} is not in TYPE_ORDER in this script. Add it — the order there is the order the type subheadings render in.`);
    process.exit(1);
  }
  return i;
};
const typeDescription = (t) => {
  const row = TYPE_ORDER.find(([x]) => x === t);
  if (!row) {
    console.error(`ERROR: no description for resource type ${t}. Add one to TYPE_ORDER in this script.`);
    process.exit(1);
  }
  return row[1];
};

const categoryOf = (type) => {
  if (CATEGORY_OVERRIDE[type]) return CATEGORY_OVERRIDE[type];
  const f = path.join(CORE, `StructureDefinition-${type}.json`);
  if (!fs.existsSync(f)) return null;
  const sd = JSON.parse(fs.readFileSync(f, 'utf8'));
  const e = (sd.extension || []).find((x) => x.url.endsWith('structuredefinition-category'));
  return e ? e.valueString : null;
};

if (!fs.existsSync(RES)) { console.error(`No ${RES}. Run "sushi ." first.`); process.exit(1); }
const byType = new Map();
for (const f of fs.readdirSync(RES)) {
  if (!f.endsWith('.json') || f.startsWith('ImplementationGuide-')) continue;
  const r = JSON.parse(fs.readFileSync(path.join(RES, f), 'utf8'));
  if (!byType.has(r.resourceType)) byType.set(r.resourceType, []);
  byType.get(r.resourceType).push(`${r.resourceType}/${r.id}`);
}

const cats = new Map();
const uncategorised = [];
for (const type of [...byType.keys()].sort()) {
  const c = categoryOf(type);
  if (!c) { uncategorised.push(type); continue; }
  if (!cats.has(c)) cats.set(c, []);
  cats.get(c).push(type);
}
if (uncategorised.length) { console.error(`ERROR: no R4 category for: ${uncategorised.join(', ')}`); process.exit(1); }
const unordered = [...cats.keys()].filter((c) => !CATEGORY_ORDER.some(([x]) => x === c));
if (unordered.length) { console.error(`ERROR: category not in CATEGORY_ORDER: ${unordered.join(', ')}`); process.exit(1); }

const id = (s) => s.replace(/[^A-Za-z0-9]/g, '');
const plural = (t) => t.replace(/y$/, 'ie') + 's';
const lines = ['groups:'];
const summary = [];
for (const [cat, description] of CATEGORY_ORDER) {
  const types = cats.get(cat);
  if (!types) continue;
  if (MODE === 'category') {
    // Ordered by type, then by id within a type — NOT a flat sort of ids, so that the generated
    // artifacts page below renders the plan first, then the activities it is built from, then the
    // questionnaire and the rules. A flat sort would put ActivityDefinition before the
    // PlanDefinition it belongs to.
    const ids = [...types].sort((a, b) => typeRank(a) - typeRank(b)).flatMap((t) => byType.get(t).sort());
    lines.push(`  ${id(cat)}:`, `    name: ${JSON.stringify(cat)}`, `    description: ${JSON.stringify(description)}`, '    resources:');
    ids.forEach((r) => lines.push(`      - ${r}`));
    summary.push(`${cat} (${ids.length})`);
  } else {
    for (const t of [...types].sort((a, b) => typeRank(a) - typeRank(b))) {
      const ids = byType.get(t).sort();
      const name = MODE === 'category-type' ? `${cat}: ${plural(t)}` : plural(t);
      lines.push(`  ${id(cat) + t}:`, `    name: ${JSON.stringify(name)}`, `    description: ${JSON.stringify(typeDescription(t))}`, '    resources:');
      ids.forEach((r) => lines.push(`      - ${r}`));
      summary.push(`${name} (${ids.length})`);
    }
  }
}

// ─── the generated pages ─────────────────────────────────────────────────────────────────────────
// Three kinds, split on the coexistence tag:
//   shared.md        resources with no tag — the definitions and the organization data
//   patients.md      the roster
//   patient-NN.md    one per patient, holding that patient's tagged resources
//
// A tagged resource is one the loader creates for a particular patient, so it repeats per patient
// and cannot share a page with the others. Everything untagged is shared by all of them.
//
// Headings start at h3: h2 is the page itself and the publisher gives it no counter, so sections
// number x.1 and x.1.1 only from h3 down.

// Titles and descriptions come from the generated ImplementationGuide, not from the resources: an
// Instance's Title and Description in FSH are IG metadata, and r.name on a Patient is a HumanName.
const resourceMeta = new Map();
const igFile = fs.readdirSync(RES).find((f) => f.startsWith('ImplementationGuide-') && f.endsWith('.json'));
if (!igFile) { console.error(`No ImplementationGuide-*.json in ${RES}. Run "sushi ." first.`); process.exit(1); }
for (const r of JSON.parse(fs.readFileSync(path.join(RES, igFile), 'utf8')).definition.resource || []) {
  const ref = r.reference && r.reference.reference;
  if (!ref) continue;
  resourceMeta.set(ref, { title: r.name || ref, description: r.description || '' });
}

const tagged = new Set();
const patientOf = new Map();
const patients = [];
for (const f of fs.readdirSync(RES)) {
  if (!f.endsWith('.json') || f.startsWith('ImplementationGuide-')) continue;
  const r = JSON.parse(fs.readFileSync(path.join(RES, f), 'utf8'));
  const ref = `${r.resourceType}/${r.id}`;
  if (((r.meta || {}).tag || []).some((t) => /ehealth-system/.test(t.system || ''))) {
    tagged.add(ref);
    const m = r.id.match(/^(p\d\d)\b/);
    if (!m) { console.error(`ERROR: tagged resource ${ref} has no pNN prefix, so it cannot be placed on a patient page.`); process.exit(1); }
    patientOf.set(ref, m[1]);
  }
  if (r.resourceType === 'Patient') patients.push(r.id);
}
patients.sort();

const row = (ref) => {
  const m = resourceMeta.get(ref);
  if (!m) { console.error(`ERROR: ${ref} is not in the ImplementationGuide's definition.resource.`); process.exit(1); }
  const href = `${ref.replace('/', '-')}.html`;
  return `|[${m.title}](${href})|${m.description.replace(/\s+/g, ' ').replace(/\|/g, '\\|')}|`;
};

// one section per module, one subsection per type, over whichever refs are given
const sections = (refs) => {
  const out = [];
  const keep = new Set(refs);
  for (const [cat, description] of CATEGORY_ORDER) {
    const types = (cats.get(cat) || []).filter((t) => byType.get(t).some((r) => keep.has(r)));
    if (!types.length) continue;
    out.push(`### ${cat}`, '', description, '');
    for (const t of [...types].sort((a, b) => typeRank(a) - typeRank(b))) {
      const ids = byType.get(t).filter((r) => keep.has(r)).sort();
      if (!ids.length) continue;
      out.push(`#### ${plural(t)}`, '', typeDescription(t), '', '|Name|Description|', '|---|---|');
      ids.forEach((r) => out.push(row(r)));
      out.push('');
    }
  }
  return out;
};

// The page for pNN is patient-NN, not patient-pNN: the publisher refuses to generate two files
// whose names differ only by case, and Patient-p01.html is already taken by the resource itself.
const pageOf = (id) => `patient-${id.replace(/^p/, '')}`;

const GEN = '<!-- GENERATED by scripts/make-groups.js — do not hand-edit. -->';
const write = (name, lines) => {
  const f = path.join(REPO, 'input', 'pagecontent', name);
  fs.writeFileSync(f, [GEN, '', ...lines].join('\n') + '\n');
  return name;
};

const all = [...byType.values()].flat();
const written = [];

written.push(write('shared.md', [
  'Everything every patient shares: the plan and the activities it is built from, the questionnaire,',
  'the automated-processing rules, and the organizations, care teams and practitioners the',
  'definitions refer to. None of it carries a coexistence tag.',
  '',
  ...sections(all.filter((r) => !tagged.has(r))),
]));

written.push(write('patients.md', [
  `${patients.length} patients. Each has its own page holding the episodes, care plans, service`,
  'requests, submissions and triage results recorded for that patient.',
  '',
  '|Patient|Name|CPR|Resources|',
  '|---|---|---|---|',
  ...patients.map((id) => {
    const m = resourceMeta.get(`Patient/${id}`);
    const r = JSON.parse(fs.readFileSync(path.join(RES, `Patient-${id}.json`), 'utf8'));
    const nm = (r.name || [{}])[0];
    const name = [...(nm.given || []), nm.family].filter(Boolean).join(' ');
    const cpr = ((r.identifier || [{}])[0] || {}).value || '';
    const n = [...patientOf.entries()].filter(([, p]) => p === id).length;
    return `|[${m.title}](${pageOf(id)}.html)|${name}|${cpr}|${n || '—'}|`;
  }),
]));

for (const id of patients) {
  const mine = all.filter((r) => patientOf.get(r) === id);
  const m = resourceMeta.get(`Patient/${id}`);
  written.push(write(`${pageOf(id)}.md`, mine.length ? [
    `The ${mine.length} resources recorded for [${m.title}](Patient-${id}.html). Every one carries a`,
    'coexistence tag, which is what makes it this patient\'s rather than shared.',
    '',
    ...sections(mine),
  ] : [
    `No episodes recorded for [${m.title}](Patient-${id}.html) yet. When there are, the episodes,`,
    'care plans, service requests, submissions and triage results appear here.',
  ]));
}

console.error(`wrote ${written.length} pages: ${written.join(', ')}`);

const cfgPath = path.join(REPO, 'sushi-config.yaml');
const cfg = fs.readFileSync(cfgPath, 'utf8');
const eol = cfg.includes('\r\n') ? '\r\n' : '\n';
const body = cfg.split(/\r?\n/);
const start = body.findIndex((l) => /^groups:\s*$/.test(l));
let out = body;
if (start !== -1) {
  let end = body.length;
  for (let i = start + 1; i < body.length; i++) if (/^[A-Za-z#]/.test(body[i])) { end = i; break; }
  out = body.slice(0, start).concat(body.slice(end));
}
// Drop every previously generated header block. Keyed on the marker this script writes, and
// looped: an earlier version searched for a word the header does not contain, so each run stacked
// another copy.
for (;;) {
  const hdr = out.findIndex((l) => l.startsWith('# GENERATED by scripts/make-groups.js'));
  if (hdr === -1) break;
  let e = hdr;
  while (e < out.length && out[e].startsWith('#')) e++;
  out = out.slice(0, hdr).concat(out.slice(e));
}
// Written in front of parameters: when there is one, otherwise at the end. findIndex returning
// -1 must not fall through to slice(0, -1), which drops the config's last line.
const found = out.findIndex((l) => /^parameters:/.test(l));
const at = found === -1 ? out.length : found;
const header = [
  '# GENERATED by scripts/make-groups.js — do not hand-edit.',
  `# Sections of the rendered artifacts page (mode: ${MODE}).`,
  ...(MODE === 'category'
    ? ['# One section per FHIR R4 module.']
    : ['# One section per resource type, the sections ordered by FHIR R4 module.']),
  '# The module comes from structuredefinition-category on each core StructureDefinition, so the',
  '# taxonomy is the spec\'s own, not a local choice.',
  '# The data loader does not read any of this. Order below is the order the sections render in.',
];
fs.writeFileSync(cfgPath, out.slice(0, at).concat(header, lines, '', out.slice(at)).join(eol));
console.error(`mode=${MODE}: ${summary.length} group(s) covering ${[...byType.values()].flat().length} resources`);
summary.forEach((s) => console.error('  ' + s));
