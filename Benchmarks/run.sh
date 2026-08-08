#!/usr/bin/env bash
# Runs every engine over a corpus and scores the results.
#
#   ./run.sh [corpus-path] [time-zone]
#
# The reference instant is the wall clock at launch, and it has to be:
# NSDataDetector takes no reference date, so the only instant every engine can
# be judged against is now. Gold labels are stored as rules and evaluated
# against this instant, which is what keeps the comparison fair.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORPUS="${1:-$HERE/corpus/smoke-en.jsonl}"
TZ_ID="${2:-Asia/Ho_Chi_Minh}"
REFERENCE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="$HERE/results/$STAMP"

mkdir -p "$OUT"

echo "corpus     $CORPUS"
echo "reference  $REFERENCE"
echo "time zone  $TZ_ID"
echo "output     $OUT"
echo

swift build --package-path "$HERE" -c release >/dev/null
RUNNER="$(swift build --package-path "$HERE" -c release --show-bin-path)/BenchRunner"

# An engine that traps on an input takes the whole process with it, and Swift
# runtime traps cannot be caught in-process. So a death is treated as a RESULT:
# record which case killed it, resume after that case, and carry on. A parser
# that crashes on text a user can type is reporting something a benchmark should
# measure, not something that should silently drop it from the comparison.
run_engine() {
  local engine="$1"
  local out="$OUT/$engine.jsonl"
  local resume=""
  local deaths=0

  : > "$out"
  while : ; do
    # Subshell so the shell's own "Trace/BPT trap" notice is suppressed too;
    # the death is already being reported deliberately below.
    if [ -z "$resume" ]; then
      ( TZ="$TZ_ID" "$RUNNER" --engine "$engine" --corpus "$CORPUS" \
          --reference "$REFERENCE" --tz "$TZ_ID" >> "$out" ) 2>/dev/null && break
    else
      ( TZ="$TZ_ID" "$RUNNER" --engine "$engine" --corpus "$CORPUS" \
          --reference "$REFERENCE" --tz "$TZ_ID" --resume-after "$resume" >> "$out" ) 2>/dev/null && break
    fi

    deaths=$((deaths + 1))
    if [ "$deaths" -gt 40 ]; then
      echo "  $engine died more than 40 times, giving up" >&2
      break
    fi

    resume="$(node "$HERE/score/recordcrash.mjs" "$CORPUS" "$out" "$engine")" || {
      echo "  $engine died and the crashing case could not be identified" >&2
      break
    }
    echo "  $engine died on $resume, resuming after it"
  done
  [ "$deaths" -gt 0 ] && echo "  $engine: $deaths case(s) killed the process"
  return 0
}

for engine in khac-oracle khac-auto nsdatadetector swiftychrono; do
  echo "running $engine"
  run_engine "$engine"
done

echo "running chrono-node"
( cd "$HERE/node" && npm install --silent --no-audit --no-fund >/dev/null 2>&1 )
TZ="$TZ_ID" node "$HERE/node/chrono-runner.mjs" \
  --corpus "$CORPUS" --reference "$REFERENCE" --tz "$TZ_ID" > "$OUT/chrono-node.jsonl"

echo
echo "throughput"
# Measured on the corpus MINUS every case that killed any engine, so all five
# time the identical workload. Timing one engine on inputs another cannot
# survive would not be a comparison.
THROUGHPUT_CORPUS="$OUT/throughput-corpus.jsonl"
node -e '
const fs = require("fs");
const [corpusPath, outDir, dest] = process.argv.slice(1);
const crashed = new Set();
for (const f of fs.readdirSync(outDir)) {
  if (!f.endsWith(".jsonl")) continue;
  for (const line of fs.readFileSync(outDir + "/" + f, "utf8").split("\n")) {
    if (!line.trim()) continue;
    try { const r = JSON.parse(line); if (r.crashed) crashed.add(r.id); } catch {}
  }
}
const kept = fs.readFileSync(corpusPath, "utf8").split("\n")
  .filter(l => l.trim())
  .filter(l => !crashed.has(JSON.parse(l).id));
fs.writeFileSync(dest, kept.join("\n") + "\n");
process.stderr.write(`  timing on ${kept.length} cases (${crashed.size} excluded as fatal to some engine)\n`);
' "$CORPUS" "$OUT" "$THROUGHPUT_CORPUS"

for engine in khac-oracle khac-auto nsdatadetector swiftychrono; do
  if ! ( TZ="$TZ_ID" "$RUNNER" \
      --engine "$engine" --corpus "$THROUGHPUT_CORPUS" \
      --reference "$REFERENCE" --tz "$TZ_ID" --throughput 5 >> "$OUT/throughput.jsonl" ) 2>/dev/null; then
    echo "  $engine could not be timed: it died even on the crash-free subset"
  fi
done
TZ="$TZ_ID" node "$HERE/node/chrono-runner.mjs" \
  --corpus "$THROUGHPUT_CORPUS" --reference "$REFERENCE" --tz "$TZ_ID" --throughput 5 >> "$OUT/throughput.jsonl"

echo
node "$HERE/score/score.mjs" \
  --corpus "$CORPUS" --reference "$REFERENCE" --tz "$TZ_ID" --out "$OUT" \
  "$OUT"/khac-oracle.jsonl "$OUT"/khac-auto.jsonl \
  "$OUT"/nsdatadetector.jsonl "$OUT"/swiftychrono.jsonl "$OUT"/chrono-node.jsonl

echo
echo "throughput (best of 5 rounds over the whole corpus)"
node -e '
const fs = require("fs");
const rows = fs.readFileSync(process.argv[1], "utf8").trim().split("\n").map(JSON.parse);
rows.sort((a, b) => b.parsesPerSecond - a.parsesPerSecond);
console.log("| Engine | Parses/sec | us per parse |");
console.log("|---|---|---|");
for (const r of rows) {
  console.log(`| ${r.engine} | ${Math.round(r.parsesPerSecond).toLocaleString("en-US")} | ${r.usPerParse.toFixed(1)} |`);
}
' "$OUT/throughput.jsonl" | tee "$OUT/THROUGHPUT.md"
