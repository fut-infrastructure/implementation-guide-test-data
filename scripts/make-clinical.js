#!/usr/bin/env node
// Writes the clinical data for p02..p10. p01 is hand-written and stays that way: it is the worked
// example, and most blocks here are a rewrite of one of its blocks rather than something composed
// from a table. A table would have to restate the 14 activities, their codes, titles and reference
// ranges, and any transcription slip would be copied 18 times. Rewriting p01 cannot drift from p01.
//
// THE QUESTIONNAIRE RESPONSES ARE THE EXCEPTION. Copying p01's two would give 20 responses with
// two answer sets between them, leaving four of the sixteen scored options never exercised and no
// response that triages yellow. So each episode gets its own answer set from the table below, and
// the triage findings are DERIVED from those answers: the Questionnaire declares a significance
// for every option, so the colours are read off it rather than maintained by hand. Change an
// answer and its finding follows.
//
// TWO AXES, NOT ONE. p01 couples them: cp1 is finished AND carries a red submission, cp2 is open
// AND green. They are independent here — service requests come from the template matching the
// episode's STATUS, measurements and their triage from the template matching its COLOUR, and the
// questionnaire from its own answer set.
//
// Usage: sushi . ; node scripts/make-clinical.js . ; sushi .   (then make-groups.js)
const fs = require('fs');
const path = require('path');

const REPO = process.argv[2] || '.';
const RES = path.join(REPO, 'fsh-generated', 'resources');
const DATA = path.join(REPO, 'input', 'fsh', 'data');
if (!fs.existsSync(RES)) { console.error(`No ${RES}. Run "sushi ." first.`); process.exit(1); }

// ─── the answers, one set per episode ────────────────────────────────────────────────────────────
// Columns follow the questionnaire's own item order: prednisolone, antibiotics, breathlessness,
// cough, sputum colour, more sputum, anything to add. The first two carry no significance, so they
// vary freely — somebody can be on treatment and report no symptoms. A trailing comment is only
// legal when the last answer is "Ja"; its enableWhen requires it.
//
// p01's two are the templates and are not generated. Of the other eighteen the seven in RED must
// triage red, and the rest are split between yellow and green. Between them the twenty cover every
// scored option the questionnaire declares.
const COMMENT = 'Jeg har haft det dårligere de seneste dage og er begyndt på både Prednisolon og Antibiotika.';
const MILD = 'Jeg har det stort set som jeg plejer.';
const ANSWERS = {
  // red
  'p02-cp2': ['Ja', 'Ja', 'Meget', 'En del', 'Mørkegult (5)', 'Meget', 'Ja', COMMENT],
  'p04-cp1': ['Ja', 'Nej', 'En del', 'Meget', 'Lysegult (3)', 'Lidt', 'Nej'],
  'p05-cp2': ['Nej', 'Ja', 'Meget', 'Slet ikke', 'Grønligt (4)', 'En del', 'Ja', COMMENT],
  'p07-cp1': ['Ja', 'Ja', 'En del', 'Lidt', 'Mørkegult (5)', 'Meget', 'Nej'],
  'p10-cp1': ['Nej', 'Nej', 'Lidt', 'Meget', 'Klart (1)', 'Lidt', 'Ja', MILD],
  'p10-cp3': ['Ja', 'Nej', 'Meget', 'Meget', 'Lysegult (3)', 'Slet ikke', 'Nej'],
  // yellow
  'p02-cp1': ['Nej', 'Nej', 'Lidt', 'Slet ikke', 'Klart (1)', 'Slet ikke', 'Nej'],
  'p03-cp2': ['Nej', 'Nej', 'Slet ikke', 'Lidt', 'Hvidligt (2)', 'Slet ikke', 'Nej'],
  'p04-cp2': ['Ja', 'Nej', 'Slet ikke', 'Slet ikke', 'Klart (1)', 'Lidt', 'Nej'],
  'p06-cp1': ['Nej', 'Nej', 'Lidt', 'Lidt', 'Hvidligt (2)', 'Lidt', 'Nej'],
  'p08-cp1': ['Nej', 'Nej', 'Slet ikke', 'Slet ikke', 'Klart (1)', 'Slet ikke', 'Ja', MILD],
  'p10-cp2': ['Nej', 'Nej', 'Slet ikke', 'Lidt', 'Klart (1)', 'Slet ikke', 'Nej'],
  // green
  'p03-cp1': ['Nej', 'Nej', 'Slet ikke', 'Slet ikke', 'Klart (1)', 'Slet ikke', 'Nej'],
  'p05-cp1': ['Ja', 'Ja', 'Slet ikke', 'Slet ikke', 'Hvidligt (2)', 'Slet ikke', 'Nej'],
  'p06-cp2': ['Nej', 'Ja', 'Slet ikke', 'Slet ikke', 'Klart (1)', 'Slet ikke', 'Nej'],
  'p07-cp2': ['Nej', 'Nej', 'Slet ikke', 'Slet ikke', 'Hvidligt (2)', 'Slet ikke', 'Nej'],
  'p09-cp1': ['Ja', 'Nej', 'Slet ikke', 'Slet ikke', 'Klart (1)', 'Slet ikke', 'Nej'],
  'p10-cp4': ['Nej', 'Nej', 'Slet ikke', 'Slet ikke', 'Hvidligt (2)', 'Slet ikke', 'Nej'],
};

// Which episodes carry an exacerbation: the measurements follow this, the questionnaire follows
// its own answers, and the two are checked against each other below.
const RED = new Set(['p01-cp1', 'p02-cp2', 'p04-cp1', 'p05-cp2', 'p07-cp1', 'p10-cp1', 'p10-cp3']);

// ─── the questionnaire, read from the built output ───────────────────────────────────────────────
const q = JSON.parse(fs.readFileSync(path.join(RES, 'Questionnaire-questionnaire.json'), 'utf8'));
const items = (q.item || []).map((it) => {
  const sig = new Map();
  for (const e of (it.extension || []).filter((x) => /answerSignificance/.test(x.url))) {
    const cond = e.extension.find((c) => /answer-Condition/.test(c.url));
    sig.set(cond.extension.find((c) => c.url === 'value').valueString,
      e.extension.find((c) => c.url === 'significance').valueCoding.code);
  }
  return { linkId: it.linkId, sig, options: (it.answerOption || []).map((o) => o.valueString) };
});
if (items.length < 8) { console.error(`ERROR: expected at least 8 questionnaire items, found ${items.length}.`); process.exit(1); }

const WORST = ['green', 'yellow', 'red'];
const overall = (colours) => colours.reduce((a, c) => (WORST.indexOf(c) > WORST.indexOf(a) ? c : a), 'green');
const PRIORITY = { green: 'routine', yellow: 'urgent', red: 'asap' };

// A rule-set argument closes on ) and separates on , so both are escaped; ( is not.
const fshArg = (s) => s.replace(/([,)])/g, '\\$1');

// ─── the episodes ────────────────────────────────────────────────────────────────────────────────
const episodes = [];
for (const f of fs.readdirSync(RES)) {
  if (!/^EpisodeOfCare-/.test(f)) continue;
  const e = JSON.parse(fs.readFileSync(path.join(RES, f), 'utf8'));
  const [, patient, n] = e.id.match(/^(p\d\d)-eoc(\d+)$/);
  episodes.push({
    patient, n: +n, id: e.id, careplan: `${patient}-cp${n}`,
    finished: e.status === 'finished', start: e.period.start, end: e.period.end,
    activeFrom: (e.statusHistory.find((h) => h.status === 'active') || {}).period.start,
  });
}
episodes.sort((a, b) => a.patient.localeCompare(b.patient) || a.n - b.n);

for (const ep of episodes) {
  if (ep.patient === 'p01') continue;
  if (!ANSWERS[ep.careplan]) { console.error(`ERROR: no answer set for ${ep.careplan}. Add one to ANSWERS.`); process.exit(1); }
}

const DAY = 86400000;
const iso = (ms) => new Date(ms).toISOString().replace(/\.\d{3}Z$/, '+00:00');
const shift = (at, seconds) => iso(new Date(at).getTime() + seconds * 1000);

// anchorDate is "now": on load every date shifts by (load time - anchor), so nothing may be dated
// after it. A finished plan's submission sits 60% of the way through the course it ran; an open
// plan's sits a few days before the anchor, because an open episode's latest measurement should
// look recent on a freshly loaded environment. Read from loader-settings rather than repeated.
const settings = JSON.parse(fs.readFileSync(path.join(RES, 'Parameters-loader-settings.json'), 'utf8'));
const ANCHOR = (settings.parameter.find((p) => p.name === 'anchorDate') || {}).valueDate;
if (!ANCHOR) { console.error('ERROR: no anchorDate in Parameters/loader-settings.'); process.exit(1); }
const SUBMISSION_AFTER_OPEN_DAYS = 1;
const submissionAt = (ep, tplAt) => {
  const start = new Date(ep.start).getTime();
  const at = ep.finished
    ? start + Math.round(0.6 * (new Date(ep.end).getTime() - start))
    : start + SUBMISSION_AFTER_OPEN_DAYS * DAY;
  // An open episode starts days before the anchor, so three days in is still before it. Assert it
  // rather than assume: a submission after the anchor arrives in the future on every load.
  if (at > new Date(`${ANCHOR}T23:59:59Z`).getTime()) {
    console.error(`ERROR: ${ep.careplan}'s submission would fall on ${iso(at).slice(0, 10)}, after the anchor ${ANCHOR}.`);
    process.exit(1);
  }
  return `${iso(at).slice(0, 10)}T${tplAt.slice(11)}`;
};

// ─── p01's blocks, as templates ──────────────────────────────────────────────────────────────────
// A section separator (// ───) describes the file and must not travel: "the completed episode: an
// exacerbation, red" would be a lie on a green episode.
const blocksOf = (file, prefix) => fs.readFileSync(path.join(DATA, 'p01', file), 'utf8')
  .split(/\n(?=(?:\/\/[^\n]*\n)*Instance: )/)
  .filter((b) => new RegExp(`^(?:\\/\\/[^\\n]*\\n)*Instance: ${prefix}`).test(b))
  .map((b) => b.split('\n').filter((l) => !/^\/\/ ─/.test(l)).join('\n').replace(/^\n+|\s+$/g, ''));

const STATUS_TPL = {
  finished: { careplan: 'cp1', episode: 'eoc1', activeFrom: '2025-06-02T09:05:00+00:00', boundsEnd: '2025-10-13T11:55:00+00:00' },
  active: { careplan: 'cp2', episode: 'eoc2', activeFrom: '2026-09-28T09:05:00+00:00', boundsEnd: null },
};
const COLOUR_TPL = {
  red: { careplan: 'cp1', episode: 'eoc1', at: '2025-08-20T10:00:00+00:00' },
  green: { careplan: 'cp2', episode: 'eoc2', at: '2026-09-29T08:30:00+00:00' },
};

const rename = (block, tpl, ep) => block
  .split(`p01-${tpl.careplan}`).join(ep.careplan)
  .split(`p01-${tpl.episode}`).join(ep.id)
  .replace(/insert (\w+)\(p01, /g, `insert $1(${ep.patient}, `);

const retimeSubmission = (s, tpl, ep) => {
  const at = submissionAt(ep, tpl.at);
  for (const d of [10, 5, 0]) s = s.split(shift(tpl.at, d)).join(shift(at, d));
  const want = ep.finished ? 'completed episode' : 'open episode';
  return s.split('completed episode').join(want).split('open episode').join(want);
};

// ─── build ───────────────────────────────────────────────────────────────────────────────────────
const out = new Map();
const add = (ep, file, lines) => {
  const key = `${ep.patient}/${file}`;
  if (!out.has(key)) out.set(key, []);
  out.get(key).push(...lines);
};

const srTpl = { finished: blocksOf('servicerequest.fsh', 'p01-cp1-'), active: blocksOf('servicerequest.fsh', 'p01-cp2-') };
const obsTpl = { red: blocksOf('observation.fsh', 'p01-cp1-'), green: blocksOf('observation.fsh', 'p01-cp2-') };
const provTpl = { red: blocksOf('provenance.fsh', 'p01-cp1-'), green: blocksOf('provenance.fsh', 'p01-cp2-') };
const dcTpl = { red: blocksOf('clinicalimpression.fsh', 'p01-cp1-dc-'), green: blocksOf('clinicalimpression.fsh', 'p01-cp2-dc-') };
const measCiTpl = {
  red: blocksOf('clinicalimpression.fsh', 'p01-cp1-ci-').filter((b) => !/-ci-qr$/m.test(b.match(/Instance: (\S+)/)[1])),
  green: blocksOf('clinicalimpression.fsh', 'p01-cp2-ci-').filter((b) => !/-ci-qr$/m.test(b.match(/Instance: (\S+)/)[1])),
};
const taskTpl = { red: blocksOf('task.fsh', 'p01-cp1-'), green: blocksOf('task.fsh', 'p01-cp2-') };

for (const [k, n] of [['servicerequest', 14], ['observation', 2], ['provenance', 1], ['dc', 3], ['measCi', 2], ['task', 3]]) {
  const t = { servicerequest: srTpl, observation: obsTpl, provenance: provTpl, dc: dcTpl, measCi: measCiTpl, task: taskTpl }[k];
  for (const key of Object.keys(t)) {
    if (t[key].length !== n) { console.error(`ERROR: expected ${n} ${k} block(s) for ${key}, found ${t[key].length}.`); process.exit(1); }
  }
}

let qrColours = [];
for (const ep of episodes) {
  if (ep.patient === 'p01') continue;
  const colour = RED.has(ep.careplan) ? 'red' : 'green';
  const state = ep.finished ? 'finished' : 'active';
  const sTpl = STATUS_TPL[state];
  const cTpl = COLOUR_TPL[colour];
  const at = submissionAt(ep, cTpl.at);
  const status = ep.finished ? 'completed' : 'open';

  // service requests — status axis
  add(ep, 'servicerequest.fsh', [`// ─── ${ep.careplan} ───`, ...srTpl[state].map((b) => {
    let s = rename(b, sTpl, ep).split(sTpl.activeFrom).join(ep.activeFrom);
    if (sTpl.boundsEnd) s = s.split(sTpl.boundsEnd).join(shift(ep.end, -300));
    return s;
  })]);

  // measurements, their provenance and their triage — colour axis
  for (const [file, tpl] of [['observation.fsh', obsTpl], ['provenance.fsh', provTpl]]) {
    add(ep, file, [`// ─── ${ep.careplan} ───`, ...tpl[colour].map((b) => retimeSubmission(rename(b, cTpl, ep), cTpl, ep))]);
  }

  // the questionnaire response — built from its own answer set
  const answers = ANSWERS[ep.careplan];
  const scored = [];
  const qrLines = [
    `Instance: ${ep.careplan}-qr`,
    'InstanceOf: ehealth-questionnaireresponse',
    'Usage: #example',
  ];
  const body = [`* insert SubmittedQR(${ep.patient}, ${ep.id},${ep.careplan}-sr-extra-questionnaire, ${at})`];
  answers.forEach((a, i) => {
    const it = items[i];
    body.push(i === 0 ? `* item[0].linkId = "${it.linkId}"` : `* item[+].linkId = "${it.linkId}"`);
    body.push(i === 0 ? `* item[0].answer.valueString = "${a}"` : `* item[=].answer.valueString = "${a}"`);
    if (it.sig.has(a)) scored.push({ linkId: it.linkId, answer: a, colour: it.sig.get(a) });
  });
  if (answers.length === 7) body.push('// item[7] Kommentar is not answered: its enableWhen requires the answer above to be "Ja".');
  const qrColour = overall(scored.map((s) => s.colour));
  qrColours.push({ careplan: ep.careplan, colour: qrColour });
  const tally = ['red', 'yellow', 'green'].map((c) => [c, scored.filter((s) => s.colour === c).length])
    .filter(([, n]) => n).map(([c, n]) => `${n} ${c}`).join(', ');
  qrLines.push(
    `Title: "Questionnaire response, ${qrColour === 'green' ? 'no symptoms' : qrColour === 'yellow' ? 'mild symptoms' : 'exacerbation'} (${status} episode)"`,
    `Description: "A symptom questionnaire answered under the ${status} episode. ${scored.length} scored answers — ${tally} — so triage returns ${qrColour} and the resulting task is ${PRIORITY[qrColour]}."`,
    ...body,
  );
  add(ep, 'questionnaireresponse.fsh', [`// ─── ${ep.careplan} ───`, qrLines.join('\n')]);

  // triage: the contained decision contexts, the two measurement impressions, and the
  // questionnaire impression whose findings are derived from the answers above
  const ciLines = dcTpl[colour].map((b) => rename(b, cTpl, ep));
  ciLines.push(...measCiTpl[colour].map((b) => retimeSubmission(rename(b, cTpl, ep), cTpl, ep)));
  const basis = scored.map((s, i) => `* insert FindingBasis(${i}, ${fshArg(s.linkId)}, ${fshArg(s.answer)}, ${s.colour}-question-answer, ${s.colour} question and answer combination, ${s.colour})`);
  ciLines.push([
    `Instance: ${ep.careplan}-ci-qr`,
    'InstanceOf: ehealth-clinicalimpression',
    'Usage: #example',
    `Title: "Triage of the questionnaire response — ${qrColour}"`,
    `Description: "Triage result for the questionnaire response submitted under the ${status} episode. ${scored.length} scored answers — ${tally} — so the overall assessment is ${qrColour}. Carries no description: the questionnaire rule does not set one."`,
    `* insert TriageCI(${ep.patient}, ${ep.id},${ep.careplan},${ep.careplan}-dc-qr, ${shift(at, 10)})`,
    `* contained[0] = ${ep.careplan}-dc-qr`,
    `* insert Investigated(${ep.careplan}-qr)`,
    `* finding.itemCodeableConcept.coding = $clinicalimpression-finding-codes#${qrColour} "${qrColour[0].toUpperCase()}${qrColour.slice(1)} overall assessment"`,
    ...basis,
  ].join('\n'));
  add(ep, 'clinicalimpression.fsh', [`// ─── ${ep.careplan} ───`, ...ciLines]);

  // tasks — the two measurement ones follow the colour template, the questionnaire one its triage
  const tasks = taskTpl[colour].map((b) => retimeSubmission(rename(b, cTpl, ep), cTpl, ep))
    .map((b) => (/-task-qr$/m.test(b.match(/Instance: (\S+)/)[1])
      ? b.replace(/, (routine|urgent|asap), /, `, ${PRIORITY[qrColour]}, `)
        .replace(/— (routine|urgent|asap)"/, `— ${PRIORITY[qrColour]}"`)
      : b));
  add(ep, 'task.fsh', [`// ─── ${ep.careplan} ───`, ...tasks]);
}

const GEN = `// GENERATED by scripts/make-clinical.js. Do not hand-edit.
// p01's own files are the templates and are maintained by hand.`;
for (const [key, blocks] of [...out].sort()) {
  const f = path.join(DATA, key);
  fs.mkdirSync(path.dirname(f), { recursive: true });
  fs.writeFileSync(f, `${GEN}\n\n${blocks.join('\n\n')}\n`);
}

// ─── the care plans need their activity list ─────────────────────────────────────────────────────
let patched = 0;
for (const ep of episodes) {
  if (ep.patient === 'p01') continue;
  const f = path.join(DATA, ep.patient, 'careplan.fsh');
  let s = fs.readFileSync(f, 'utf8');
  const insert = `* insert CarePlanActivities(${ep.careplan})`;
  if (s.includes(insert)) continue;
  const re = new RegExp(`(^\\* insert CarePlan(?:Active|Completed)\\(${ep.patient}, ${ep.id},[^\\n]*$)`, 'm');
  if (!re.test(s)) { console.error(`ERROR: no CarePlan insert for ${ep.careplan} in ${f}.`); process.exit(1); }
  fs.writeFileSync(f, s.replace(re, `$1\n${insert}`));
  patched++;
}

// ─── report, and hold the answers to the colour they were designed for ───────────────────────────
for (const { careplan, colour } of qrColours) {
  const wanted = RED.has(careplan) ? 'red' : null;
  if (wanted && colour !== wanted) { console.error(`ERROR: ${careplan} is designated red but its answers triage ${colour}.`); process.exit(1); }
  if (!wanted && colour === 'red') { console.error(`ERROR: ${careplan} is not designated red but its answers triage red.`); process.exit(1); }
}
const used = new Set();
for (const a of Object.values(ANSWERS)) a.forEach((v, i) => items[i] && items[i].sig.has(v) && used.add(`${i}:${v}`));
const all = items.flatMap((it, i) => [...it.sig.keys()].map((v) => `${i}:${v}`));
const missed = all.filter((k) => !used.has(k));
const tally = (c) => qrColours.filter((x) => x.colour === c).length;
console.log(`${[...out.values()].reduce((a, b) => a + b.filter((x) => !x.startsWith('// ─')).length, 0)} instances across ${out.size} files; ${patched} care plans patched`);
console.log(`questionnaire triage, p02..p10: ${tally('red')} red, ${tally('yellow')} yellow, ${tally('green')} green`);
console.log(missed.length ? `  scored options never used: ${missed.join(', ')}` : '  every scored option the questionnaire declares is used at least once');
