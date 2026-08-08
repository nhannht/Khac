// score.mjs - turns raw engine output into the benchmark result tables.
//
// The scorer is deliberately the only place that decides right from wrong. Every
// runner just reports what its engine returned, so no engine can be advantaged
// by how its own output is judged.
//
// Usage:
//   node score.mjs --corpus <path> --reference <iso8601> --tz <id> \
//                  --out <dir> results/*.jsonl

import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";

function argument(name) {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 && i + 1 < process.argv.length ? process.argv[i + 1] : undefined;
}

function fail(message) {
  process.stderr.write(`score: ${message}\n`);
  process.exit(1);
}

const corpusPath = argument("corpus") ?? fail("missing --corpus");
const referenceISO = argument("reference") ?? fail("missing --reference");
const tz = argument("tz") ?? fail("missing --tz");
const outDir = argument("out") ?? null;

const flagNames = new Set(["--corpus", "--reference", "--tz", "--out"]);
const resultFiles = process.argv.slice(2).filter((a, i, all) => {
  if (a.startsWith("--")) return false;
  const prev = all[i - 1];
  return !(prev && flagNames.has(prev));
});
if (!resultFiles.length) fail("no result files given");

const referenceMs = new Date(referenceISO).getTime();
if (Number.isNaN(referenceMs)) fail(`bad --reference ${referenceISO}`);

// ---------------------------------------------------------------------------
// Civil time in the pinned zone
// ---------------------------------------------------------------------------

const partsFormatter = new Intl.DateTimeFormat("en-US", {
  timeZone: tz, hour12: false,
  year: "numeric", month: "2-digit", day: "2-digit",
  hour: "2-digit", minute: "2-digit", second: "2-digit",
});

function localParts(ms) {
  const p = Object.fromEntries(
    partsFormatter.formatToParts(new Date(ms)).map((x) => [x.type, x.value])
  );
  return {
    y: +p.year, mo: +p.month, d: +p.day,
    h: +p.hour % 24, mi: +p.minute, s: +p.second,
  };
}

function offsetMinutes(ms) {
  const p = localParts(ms);
  return (Date.UTC(p.y, p.mo - 1, p.d, p.h, p.mi, p.s) - ms) / 60000;
}

// Wall-clock in the pinned zone back to an instant. Two passes so a DST zone
// resolves correctly; exact for a zone without DST.
function localToInstant(y, mo, d, h = 0, mi = 0) {
  const naive = Date.UTC(y, mo - 1, d, h, mi, 0);
  let ms = naive - offsetMinutes(naive) * 60000;
  ms = naive - offsetMinutes(ms) * 60000;
  return ms;
}

function dayKey(ms) {
  const p = localParts(ms);
  return `${p.y}-${String(p.mo).padStart(2, "0")}-${String(p.d).padStart(2, "0")}`;
}

function weekdayIndex(ms) {
  // Day-of-week of the civil date in the pinned zone.
  const p = localParts(ms);
  return new Date(Date.UTC(p.y, p.mo - 1, p.d)).getUTCDay();
}

const WEEKDAYS = { sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6 };

// ---------------------------------------------------------------------------
// Gold rule evaluation
// ---------------------------------------------------------------------------

// Gold labels are rules rather than fixed instants because NSDataDetector has no
// reference-date API: it always resolves against the system clock. Rules let
// every engine be judged against one shared reference instant.
function splitTime(time) {
  if (!time) return { h: 0, mi: 0 };
  const [h, mi] = time.split(":").map(Number);
  return { h, mi };
}

// `notBefore` is supplied only for the END of an interval. Without it, a
// monthDay pair resolves each endpoint independently by nearest-occurrence, and
// "Dec 28 to Jan 3" scored from late June resolves the start into next December
// and the end into THIS January - a 359-day backwards interval that no engine
// could ever match and nothing would flag. The corpus has no such case today;
// it needs one ordinary future case and one ordinary run date to fire.
//
// Note this deliberately does NOT apply to `abs` endpoints. A backwards range is
// a real reading of text like "22 to 10 November" and the corpus tests it on
// purpose, so only the year-less rule gets chronology imposed on it.
function evalRule(rule, notBefore = null) {
  const ref = localParts(referenceMs);

  switch (rule.rule) {
    case "abs": {
      const m = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})$/.exec(rule.dt);
      if (!m) fail(`bad abs rule dt "${rule.dt}" (want YYYY-MM-DDTHH:mm)`);
      return { ms: localToInstant(+m[1], +m[2], +m[3], +m[4], +m[5]), clockSensitive: false };
    }
    case "ref": {
      const { h, mi } = splitTime(rule.time);
      return { ms: localToInstant(ref.y, ref.mo, ref.d, h, mi), clockSensitive: false };
    }
    case "offset": {
      // Sub-day offsets are arithmetic on the instant and move with the clock.
      // Everything coarser lands on a civil date and does not.
      if (rule.hours != null || rule.minutes != null) {
        const delta = (rule.hours ?? 0) * 3600000 + (rule.minutes ?? 0) * 60000;
        return { ms: referenceMs + delta, clockSensitive: true };
      }
      const days = (rule.days ?? 0) + (rule.weeks ?? 0) * 7;
      const months = rule.months ?? 0;
      const years = rule.years ?? 0;
      const { h, mi } = splitTime(rule.time);

      // "One month after 31 January" has no agreed answer and the engines here
      // genuinely split: Khắc and SwiftyChrono CLAMP to 28 February, chrono rolls
      // over to 3 March. An earlier version of this comment asserted they all
      // rolled over, and the scorer used Date.UTC, which rolls - so it silently
      // sided with chrono against the other two.
      //
      // Nothing caught it because the reference instant is the wall clock, and on
      // most days no offset case lands near a month end. Run this benchmark on the
      // 31st and it would have marked Khắc wrong for a convention, not a defect.
      //
      // So: clamp, which is what most date libraries and most people mean, and
      // report any case where the two conventions differ as convention-disputed,
      // so it is excluded from the headline number exactly like a hand-flagged one.
      // The dispute is a property of the DATE, not of the author's judgement, so
      // the scorer derives it rather than trusting a flag.
      const monthStart = new Date(Date.UTC(ref.y + years, ref.mo - 1 + months, 1));
      const targetYear = monthStart.getUTCFullYear();
      const targetMonth0 = monthStart.getUTCMonth();
      const daysInTarget = new Date(Date.UTC(targetYear, targetMonth0 + 1, 0)).getUTCDate();
      const shiftsMonth = months !== 0 || years !== 0;
      const overflows = shiftsMonth && ref.d > daysInTarget;
      const anchorDay = overflows ? daysInTarget : ref.d;

      const shifted = new Date(Date.UTC(targetYear, targetMonth0, anchorDay + days));
      return {
        ms: localToInstant(
          shifted.getUTCFullYear(), shifted.getUTCMonth() + 1, shifted.getUTCDate(), h, mi
        ),
        clockSensitive: false,
        conventionDisputed: overflows,
      };
    }
    case "monthDay": {
      // A date with no year stated ("Aug 10"), which is ordinary in real text.
      // Resolved as the occurrence nearest the reference, which is chrono's
      // documented behaviour and the only defensible reading. Engines differ
      // here, so every monthDay case is marked conventionSensitive and is
      // reported separately from the headline number.
      const { h, mi } = splitTime(rule.time);
      const years = [ref.y - 1, ref.y, ref.y + 1, ref.y + 2];
      const candidates = years.map((y) => localToInstant(y, rule.month, rule.day, h, mi));

      if (notBefore != null) {
        // Interval end: the first occurrence at or after the start, which is what
        // "Dec 28 to Jan 3" plainly means.
        const forward = candidates.filter((ms) => ms >= notBefore).sort((a, b) => a - b);
        if (!forward.length) {
          fail(`monthDay end ${rule.month}/${rule.day} has no occurrence at or after the interval start`);
        }
        return { ms: forward[0], clockSensitive: false };
      }

      const nearest = candidates.reduce((best, ms) =>
        Math.abs(ms - referenceMs) < Math.abs(best - referenceMs) ? ms : best
      );
      return { ms: nearest, clockSensitive: false };
    }
    case "weekday": {
      const target = WEEKDAYS[rule.name];
      if (target == null) fail(`bad weekday name "${rule.name}"`);
      const current = weekdayIndex(referenceMs);
      let delta;
      switch (rule.dir) {
        case "next":
          delta = (target - current + 7) % 7 || 7;
          break;
        case "this":
          delta = (target - current + 7) % 7;
          break;
        case "last":
          delta = -(((current - target + 7) % 7) || 7);
          break;
        default:
          fail(`bad weekday dir "${rule.dir}"`);
      }
      const { h, mi } = splitTime(rule.time);
      const shifted = new Date(Date.UTC(ref.y, ref.mo - 1, ref.d + delta));
      return {
        ms: localToInstant(
          shifted.getUTCFullYear(), shifted.getUTCMonth() + 1, shifted.getUTCDate(), h, mi
        ),
        clockSensitive: false,
      };
    }
    default:
      fail(`unknown gold rule "${rule.rule}"`);
  }
}

// A clock-sensitive gold gets a 90-SECOND window because NSDataDetector reads
// its own clock and cannot be handed the harness reference. The window applies
// to every engine equally, and the runner refuses to start when the process
// clock is more than 60s from the reference, so an accepted run is always
// inside this window.
function matches(actualMs, gold, granularity) {
  if (granularity === "day") return dayKey(actualMs) === dayKey(gold.ms);
  const tolerance = gold.clockSensitive ? 90000 : 0;
  return Math.abs(actualMs - gold.ms) <= tolerance;
}

// ---------------------------------------------------------------------------
// Load
// ---------------------------------------------------------------------------

function readJSONL(file) {
  return fs
    .readFileSync(file, "utf8")
    .split("\n")
    .map((s) => s.trim())
    .filter((s) => s.length && !s.startsWith("//"))
    .map((s) => JSON.parse(s));
}

const corpus = new Map(readJSONL(corpusPath).map((c) => [c.id, c]));

// Stamp the corpus hash into every artifact this produces. The methodology says
// a results table citing a different hash is stale - which is worth nothing
// unless the table actually cites one. It did not, and a stale run went
// unnoticed until someone compared file timestamps by hand.
const corpusHash = crypto.createHash("sha256").update(fs.readFileSync(corpusPath)).digest("hex");

const byEngine = new Map();
for (const file of resultFiles) {
  for (const record of readJSONL(file)) {
    if (record.mode === "throughput") continue;
    if (!byEngine.has(record.engine)) byEngine.set(record.engine, []);
    byEngine.get(record.engine).push(record);
  }
}
if (!byEngine.size) fail("result files contained no accuracy records");

// ---------------------------------------------------------------------------
// Judge
// ---------------------------------------------------------------------------

function judge(record) {
  const c = corpus.get(record.id);
  if (!c) fail(`result for unknown case id ${record.id}`);

  // The engine did not return a wrong answer here; it died. That is worse than
  // wrong and is counted separately, never as a pass.
  if (record.crashed) return { verdict: "crashed", case: c };

  const hits = record.results ?? [];

  if (c.gold.kind === "none") {
    return { verdict: hits.length === 0 ? "correct_negative" : "false_positive", case: c };
  }

  if (hits.length === 0) return { verdict: "missed", case: c };

  // Top-1 is the first expression in text order, which is what every engine
  // emits and what a caller taking `parseDate` would get.
  const top = hits[0];
  const goldStart = evalRule(c.gold.start);
  const startOK = matches(Date.parse(top.start), goldStart, c.gold.granularity);

  if (c.gold.kind === "interval") {
    // The end is resolved RELATIVE to the start when it is year-less, so the pair
    // cannot silently invert. See the note on evalRule.
    const goldEndForFlag = c.gold.end
      ? evalRule(c.gold.end, c.gold.end.rule === "monthDay" ? goldStart.ms : null)
      : null;
    const disputed = goldStart.conventionDisputed || goldEndForFlag?.conventionDisputed || false;
    if (!startOK) return { verdict: "wrong_value", case: c, disputed };
    if (top.end == null) return { verdict: "missing_end", case: c, disputed };
    return {
      verdict: matches(Date.parse(top.end), goldEndForFlag, c.gold.granularity) ? "correct" : "wrong_end",
      case: c,
      disputed,
    };
  }

  return {
    verdict: startOK ? "correct" : "wrong_value",
    case: c,
    disputed: goldStart.conventionDisputed || false,
  };
}

const CORRECT = new Set(["correct", "correct_negative"]);

function blankBucket() {
  return {
    total: 0, correct: 0, missed: 0, wrong: 0,
    falsePositive: 0, wrongEnd: 0, missingEnd: 0, crashed: 0,
  };
}

function tally(bucket, verdict) {
  bucket.total++;
  if (CORRECT.has(verdict)) bucket.correct++;
  if (verdict === "missed") bucket.missed++;
  if (verdict === "wrong_value") bucket.wrong++;
  if (verdict === "false_positive") bucket.falsePositive++;
  if (verdict === "wrong_end") bucket.wrongEnd++;
  if (verdict === "missing_end") bucket.missingEnd++;
  if (verdict === "crashed") bucket.crashed++;
}

const report = {};
const failuresByEngine = {};

for (const [engine, records] of byEngine) {
  const positives = blankBucket();
  const positivesStable = blankBucket(); // convention-sensitive cases excluded
  const negatives = blankBucket();
  // Negatives whose SHAPE was seeded, via the authoring spec, from Khac's own
  // documented test conventions. They favour Khac by construction, so the
  // false-positive rate is reported with and without them.
  const negativesUnseeded = blankBucket();
  const byLang = {};
  const byCapability = {};
  const failures = [];
  let totalNs = 0;
  // Only meaningful for an engine that detects the language itself. Without it,
  // a khac-auto miss is unattributable: it could be the parser or it could be
  // NLLanguageRecognizer handing Khac the wrong locale to parse with.
  const detection = { total: 0, correct: 0, confusions: {} };

  for (const record of records) {
    const { verdict, case: c, disputed } = judge(record);
    totalNs += record.ns ?? 0;
    // Hand-flagged by the author, OR derived by the scorer because the engines
    // genuinely disagree about this particular date.
    const conventionSensitive = c.conventionSensitive || disputed;

    if (record.detectedLang != null) {
      detection.total++;
      if (record.detectedLang === c.lang) {
        detection.correct++;
      } else {
        const pair = `${c.lang} -> ${record.detectedLang}`;
        detection.confusions[pair] = (detection.confusions[pair] ?? 0) + 1;
      }
    }

    if (c.gold.kind === "none") {
      tally(negatives, verdict);
      if (!c.seededFromSubjectDocs) tally(negativesUnseeded, verdict);
    } else {
      tally(positives, verdict);
      if (!conventionSensitive) tally(positivesStable, verdict);
      byLang[c.lang] ??= blankBucket();
      tally(byLang[c.lang], verdict);
      byCapability[c.capability] ??= blankBucket();
      tally(byCapability[c.capability], verdict);
    }

    if (!CORRECT.has(verdict)) {
      failures.push({
        id: c.id, lang: c.lang, capability: c.capability, verdict,
        text: c.text,
        got: (record.results ?? [])[0] ?? null,
        detectedLang: record.detectedLang ?? null,
      });
    }
  }

  report[engine] = {
    positives, positivesStable, negatives, negativesUnseeded, byLang, byCapability, detection,
    meanUsPerCase: totalNs / Math.max(records.length, 1) / 1000,
  };
  failuresByEngine[engine] = failures;
}

// ---------------------------------------------------------------------------
// Render
// ---------------------------------------------------------------------------

const pct = (n, d) => (d === 0 ? "-" : `${((100 * n) / d).toFixed(1)}%`);
const engines = [...byEngine.keys()].sort();

const lines = [];
lines.push(`# Benchmark results`);
lines.push("");
lines.push(`Reference instant: \`${referenceISO}\`  `);
lines.push(`Time zone: \`${tz}\`  `);
lines.push(`Corpus: \`${path.basename(corpusPath)}\`, ${corpus.size} cases  `);
lines.push(`Corpus sha256: \`${corpusHash}\``);
lines.push("");
lines.push(
  `If that hash does not match \`corpus/CORPUS.sha256\` in the repository, this ` +
  `table was scored against a different corpus and should not be believed.`
);
lines.push("");

lines.push(`## Primary: top-1 resolved-instant accuracy`);
lines.push("");
lines.push(`| Engine | Cases | Correct | Accuracy | Missed | Wrong value | Wrong end |`);
lines.push(`|---|---|---|---|---|---|---|`);
for (const e of engines) {
  const p = report[e].positives;
  lines.push(
    `| ${e} | ${p.total} | ${p.correct} | **${pct(p.correct, p.total)}** | ${p.missed} | ${p.wrong} | ${p.wrongEnd + p.missingEnd} |`
  );
}
lines.push("");
lines.push(
  `Convention-sensitive cases excluded (cases where engines legitimately disagree, ` +
  `such as whether "next Friday" means the coming Friday or the one after). This ` +
  `is the number to quote: \`stability.sh\` scores the corpus at one reference per ` +
  `weekday, and every case whose verdict depends on the day the harness runs is ` +
  `inside the excluded set rather than this one.`
);
lines.push("");
lines.push(
  `That reproducibility is established for **three of the five engines** - ` +
  `\`khac-oracle\`, \`khac-auto\` and \`chrono-node\`. NSDataDetector cannot be given ` +
  `a reference date at all, so it is protected by the runner's clock-skew guard ` +
  `instead of by the sweep. SwiftyChrono is excluded from the sweep because its ` +
  `crashes confound the resume machinery, so its reference-day stability has ` +
  `never been tested in either direction.`
);
lines.push("");
lines.push(`| Engine | Cases | Accuracy |`);
lines.push(`|---|---|---|`);
for (const e of engines) {
  const p = report[e].positivesStable;
  lines.push(`| ${e} | ${p.total} | **${pct(p.correct, p.total)}** |`);
}
lines.push("");

const crashers = engines.filter(
  (e) => report[e].positives.crashed + report[e].negatives.crashed > 0
);
if (crashers.length) {
  lines.push(`## Crashes`);
  lines.push("");
  lines.push(
    `An engine that traps cannot be caught in-process, so the harness records ` +
    `which input killed it and resumes after that case. A crash is counted ` +
    `against the engine and never as a pass: a parser that dies on text a user ` +
    `can type is a more serious defect than one that answers wrongly.`
  );
  lines.push("");
  lines.push(`| Engine | Inputs that killed the process |`);
  lines.push(`|---|---|`);
  for (const e of engines) {
    const n = report[e].positives.crashed + report[e].negatives.crashed;
    lines.push(`| ${e} | ${n} |`);
  }
  lines.push("");
  for (const e of crashers) {
    const which = failuresByEngine[e].filter((f) => f.verdict === "crashed");
    for (const f of which.slice(0, 10)) {
      lines.push(`- \`${e}\` died on \`${f.id}\` (${f.lang}): ${JSON.stringify(f.text)}`);
    }
  }
  lines.push("");
}

lines.push(`## Secondary: false positives on text containing no date`);
lines.push("");
lines.push(`| Engine | Negative cases | Hallucinated a date | Rate |`);
lines.push(`|---|---|---|---|`);
for (const e of engines) {
  const n = report[e].negatives;
  lines.push(`| ${e} | ${n.total} | ${n.falsePositive} | **${pct(n.falsePositive, n.total)}** |`);
}
lines.push("");

const seededCount = report[engines[0]].negatives.total - report[engines[0]].negativesUnseeded.total;
if (seededCount > 0) {
  lines.push(
    `${seededCount} of those negatives use a shape the authoring spec seeded from ` +
    `Khắc's own documented test conventions, so they favour Khắc by construction. ` +
    `The same measurement with those cases removed:`
  );
  lines.push("");
  lines.push(`| Engine | Unseeded negatives | Hallucinated a date | Rate |`);
  lines.push(`|---|---|---|---|`);
  for (const e of engines) {
    const n = report[e].negativesUnseeded;
    lines.push(`| ${e} | ${n.total} | ${n.falsePositive} | **${pct(n.falsePositive, n.total)}** |`);
  }
  lines.push("");
}

const detectors = engines.filter((e) => report[e].detection.total > 0);
if (detectors.length) {
  lines.push(`## Language detection, for engines that pick the language themselves`);
  lines.push("");
  lines.push(
    `A miss here is not a parsing miss. It is the identifier handing the parser ` +
    `the wrong language to parse with, and it is reported separately so the two ` +
    `are never confused.`
  );
  lines.push("");
  lines.push(`| Engine | Cases | Language identified correctly | Accuracy |`);
  lines.push(`|---|---|---|---|`);
  for (const e of detectors) {
    const d = report[e].detection;
    lines.push(`| ${e} | ${d.total} | ${d.correct} | **${pct(d.correct, d.total)}** |`);
  }
  lines.push("");
  for (const e of detectors) {
    const worst = Object.entries(report[e].detection.confusions)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 8);
    if (!worst.length) continue;
    lines.push(`Most frequent confusions for \`${e}\`: ` +
      worst.map(([pair, n]) => `\`${pair}\` (${n})`).join(", "));
    lines.push("");
  }
}

const allLangs = [...new Set(Object.values(report).flatMap((r) => Object.keys(r.byLang)))].sort();
if (allLangs.length > 1) {
  lines.push(`## Accuracy by language`);
  lines.push("");
  lines.push(
    `Convention-sensitive cases are included here; see the note under the ` +
    `capability table.`
  );
  lines.push("");
  lines.push(`| Engine | ${allLangs.join(" | ")} |`);
  lines.push(`|---|${allLangs.map(() => "---").join("|")}|`);
  for (const e of engines) {
    const cells = allLangs.map((l) => {
      const b = report[e].byLang[l];
      return b ? pct(b.correct, b.total) : "-";
    });
    lines.push(`| ${e} | ${cells.join(" | ")} |`);
  }
  lines.push("");
}

const allCaps = [...new Set(Object.values(report).flatMap((r) => Object.keys(r.byCapability)))].sort();
lines.push(`## Accuracy by capability`);
lines.push("");
lines.push(
  `These per-capability and per-language tables include convention-sensitive ` +
  `cases, unlike the headline number above, which is reported both ways. The ` +
  `weekday and time_of_day columns carry the most of them.`
);
lines.push("");
lines.push(`| Engine | ${allCaps.join(" | ")} |`);
lines.push(`|---|${allCaps.map(() => "---").join("|")}|`);
for (const e of engines) {
  const cells = allCaps.map((c) => {
    const b = report[e].byCapability[c];
    return b ? pct(b.correct, b.total) : "-";
  });
  lines.push(`| ${e} | ${cells.join(" | ")} |`);
}
lines.push("");

const markdown = lines.join("\n");
process.stdout.write(markdown + "\n");

if (outDir) {
  fs.mkdirSync(outDir, { recursive: true });
  fs.writeFileSync(path.join(outDir, "RESULTS.md"), markdown + "\n");
  fs.writeFileSync(
    path.join(outDir, "summary.json"),
    JSON.stringify({ referenceISO, tz, corpus: path.basename(corpusPath), corpusHash, report }, null, 2) + "\n"
  );
  fs.writeFileSync(
    path.join(outDir, "failures.json"),
    JSON.stringify(failuresByEngine, null, 2) + "\n"
  );
}
