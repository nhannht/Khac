// chrono-runner.mjs - runs chrono-node over a benchmark corpus and emits the
// same JSONL record shape as the Swift BenchRunner, so one scorer reads both.
//
// chrono is the reference implementation Khac was ported from. It is here as a
// yardstick, not as a same-platform alternative: a Swift app cannot use it
// without shipping a JavaScript runtime.
//
// Usage:
//   node chrono-runner.mjs --corpus <path> --reference <iso8601> --tz <id>
//   node chrono-runner.mjs --corpus <path> --reference <iso8601> --tz <id> --throughput 5

import fs from "node:fs";
import * as chrono from "chrono-node";

function argument(name) {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 && i + 1 < process.argv.length ? process.argv[i + 1] : undefined;
}

function fail(message) {
  process.stderr.write(`chrono-runner: ${message}\n`);
  process.exit(1);
}

const corpusPath = argument("corpus") ?? fail("missing --corpus");
const referenceISO = argument("reference") ?? fail("missing --reference");
const tz = argument("tz") ?? fail("missing --tz");
const throughputRounds = Number(argument("throughput") ?? "0");

const referenceInstant = new Date(referenceISO);
if (Number.isNaN(referenceInstant.getTime())) fail(`bad --reference ${referenceISO}`);

// chrono takes a numeric UTC offset rather than a zone name. Asia/Ho_Chi_Minh
// has no DST, but compute it from the zone anyway so a DST zone stays correct
// at the reference instant.
function offsetMinutes(zone, instantMs) {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat("en-US", {
      timeZone: zone, hour12: false,
      year: "numeric", month: "2-digit", day: "2-digit",
      hour: "2-digit", minute: "2-digit", second: "2-digit",
    })
      .formatToParts(new Date(instantMs))
      .map((p) => [p.type, p.value])
  );
  const asUTC = Date.UTC(
    +parts.year, +parts.month - 1, +parts.day,
    +parts.hour % 24, +parts.minute, +parts.second
  );
  return (asUTC - instantMs) / 60000;
}

const tzOffset = offsetMinutes(tz, referenceInstant.getTime());

const cases = fs
  .readFileSync(corpusPath, "utf8")
  .split("\n")
  .map((s) => s.trim())
  .filter((s) => s.length && !s.startsWith("//"))
  .map((s) => JSON.parse(s));

// chrono exposes one parser per locale and has no language detection of its
// own, so it is always run in oracle mode: told which language the text is.
// That is its most favourable configuration.
function parserFor(lang) {
  const p = chrono[lang];
  if (!p) fail(`chrono has no locale "${lang}"`);
  return p;
}

const reference = { instant: referenceInstant, timezone: tzOffset };

function run(c) {
  return parserFor(c.lang)
    .parse(c.text, reference, {})
    .map((r) => ({
      text: r.text,
      index: r.index,
      start: r.start.date().toISOString().replace(/\.\d{3}Z$/, "Z"),
      end: r.end ? r.end.date().toISOString().replace(/\.\d{3}Z$/, "Z") : null,
    }));
}

if (throughputRounds > 0) {
  let bestNanos = Infinity;
  for (let round = 0; round < throughputRounds; round++) {
    const started = process.hrtime.bigint();
    for (const c of cases) run(c);
    const elapsed = Number(process.hrtime.bigint() - started);
    bestNanos = Math.min(bestNanos, elapsed);
  }
  const seconds = bestNanos / 1e9;
  console.log(
    JSON.stringify({
      bestSeconds: seconds,
      cases: cases.length,
      engine: "chrono-node",
      mode: "throughput",
      parsesPerSecond: cases.length / seconds,
      rounds: throughputRounds,
      usPerParse: (seconds * 1e6) / cases.length,
    })
  );
  process.exit(0);
}

for (const c of cases) {
  const started = process.hrtime.bigint();
  const results = run(c);
  const ns = Number(process.hrtime.bigint() - started);
  console.log(
    JSON.stringify({
      detectedLang: null,
      engine: "chrono-node",
      id: c.id,
      lang: c.lang,
      ns,
      results,
    })
  );
}
