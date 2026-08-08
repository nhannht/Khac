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

for engine in khac-oracle khac-auto nsdatadetector swiftychrono; do
  echo "running $engine"
  TZ="$TZ_ID" "$RUNNER" \
    --engine "$engine" --corpus "$CORPUS" \
    --reference "$REFERENCE" --tz "$TZ_ID" > "$OUT/$engine.jsonl"
done

echo "running chrono-node"
( cd "$HERE/node" && npm install --silent --no-audit --no-fund >/dev/null 2>&1 )
TZ="$TZ_ID" node "$HERE/node/chrono-runner.mjs" \
  --corpus "$CORPUS" --reference "$REFERENCE" --tz "$TZ_ID" > "$OUT/chrono-node.jsonl"

echo
echo "throughput"
for engine in khac-oracle khac-auto nsdatadetector swiftychrono; do
  TZ="$TZ_ID" "$RUNNER" \
    --engine "$engine" --corpus "$CORPUS" \
    --reference "$REFERENCE" --tz "$TZ_ID" --throughput 5 >> "$OUT/throughput.jsonl"
done
TZ="$TZ_ID" node "$HERE/node/chrono-runner.mjs" \
  --corpus "$CORPUS" --reference "$REFERENCE" --tz "$TZ_ID" --throughput 5 >> "$OUT/throughput.jsonl"

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
