// recordcrash.mjs - an engine died mid-run. Work out which case killed it,
// append a record saying so, and print that case's id so the driver can resume
// after it.
//
//   node recordcrash.mjs <corpus.jsonl> <engine-output.jsonl> <engine-name>
//
// A crash is a RESULT, not an accident to be routed around quietly. A parser
// that traps on text a user can type is telling you something about itself, and
// the scorer counts it against the engine rather than dropping the case.

import fs from "node:fs";

const [corpusPath, outPath, engine] = process.argv.slice(2);
if (!corpusPath || !outPath || !engine) {
  process.stderr.write("usage: node recordcrash.mjs <corpus> <output> <engine>\n");
  process.exit(2);
}

const corpus = fs
  .readFileSync(corpusPath, "utf8")
  .split("\n")
  .map((s) => s.trim())
  .filter((s) => s.length && !s.startsWith("//"))
  .map((s) => JSON.parse(s));

// Only whole lines count. A trap can cut the final line in half even with line
// buffering, and a half-record must not be mistaken for a completed case.
const done = new Set();
for (const line of fs.readFileSync(outPath, "utf8").split("\n")) {
  const s = line.trim();
  if (!s) continue;
  try {
    const r = JSON.parse(s);
    if (r.id) done.add(r.id);
  } catch {
    // truncated tail, stop trusting anything past here
    break;
  }
}

const victim = corpus.find((c) => !done.has(c.id));
if (!victim) {
  process.stderr.write("recordcrash: every case already has a record, so the death is unexplained\n");
  process.exit(1);
}

// Rewrite the file without any truncated tail, then append the crash record.
const clean = [];
for (const line of fs.readFileSync(outPath, "utf8").split("\n")) {
  const s = line.trim();
  if (!s) continue;
  try {
    JSON.parse(s);
    clean.push(s);
  } catch {
    break;
  }
}
clean.push(
  JSON.stringify({
    crashed: true,
    detectedLang: null,
    engine,
    id: victim.id,
    lang: victim.lang,
    ns: 0,
    results: [],
  })
);
fs.writeFileSync(outPath, clean.join("\n") + "\n");

process.stdout.write(victim.id + "\n");
