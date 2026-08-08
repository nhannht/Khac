#!/usr/bin/env bash
# Does the answer depend on the day you ask?
#
#   ./stability.sh [corpus-path] [time-zone]
#
# The reference instant is the wall clock at launch, so every relative case is
# resolved against whatever day the harness happened to run. A weekday case is
# the obvious exposure: "next Friday" is unambiguous on a Saturday and genuinely
# contested on a Thursday, so the same case can be scored differently on
# different days. That would give the published table a shelf life.
#
# This scores the corpus at one reference per weekday and reports any case whose
# verdict is not the same on all seven.
#
# NSDataDetector is absent because it cannot be given a reference date at all -
# the one engine whose stability cannot be measured this way, which is itself
# worth knowing. SwiftyChrono is absent because it traps on five inputs and the
# resume machinery would confound the comparison.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORPUS="${1:-$HERE/corpus/corpus.jsonl}"
TZ_ID="${2:-Asia/Ho_Chi_Minh}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

swift build --package-path "$HERE" -c release >/dev/null
RUNNER="$(swift build --package-path "$HERE" -c release --show-bin-path)/BenchRunner"

# Seven consecutive days, so every weekday is the reference exactly once.
BASE="2027-03-01"
ENGINES="khac-oracle khac-auto"

echo "corpus    $CORPUS"
echo "zone      $TZ_ID"
echo "references: 7 consecutive days from $BASE"
echo

for i in 0 1 2 3 4 5 6; do
  REF="$(node -e 'const d=new Date(process.argv[1]+"T05:00:00Z");d.setUTCDate(d.getUTCDate()+ +process.argv[2]);console.log(d.toISOString().replace(/\.\d{3}Z$/,"Z"))' "$BASE" "$i")"
  DAY="$(node -e 'console.log(new Date(process.argv[1]).toUTCString().slice(0,3))' "$REF")"
  mkdir -p "$WORK/$i"
  for engine in $ENGINES; do
    TZ="$TZ_ID" "$RUNNER" --engine "$engine" --corpus "$CORPUS" \
      --reference "$REF" --tz "$TZ_ID" > "$WORK/$i/$engine.jsonl" 2>/dev/null
  done
  TZ="$TZ_ID" node "$HERE/node/chrono-runner.mjs" --corpus "$CORPUS" \
    --reference "$REF" --tz "$TZ_ID" > "$WORK/$i/chrono-node.jsonl"
  node "$HERE/score/score.mjs" --corpus "$CORPUS" --reference "$REF" --tz "$TZ_ID" \
    --out "$WORK/$i" "$WORK/$i"/*.jsonl > /dev/null
  echo "  scored reference $REF ($DAY)"
done

echo
node -e '
const fs = require("fs");
const work = process.argv[1];
const corpus = new Map(
  fs.readFileSync(process.argv[2], "utf8").trim().split("\n")
    .map(JSON.parse).map(c => [c.id, c])
);

// A case is "failed" on a given day if it appears in that day s failures.json.
const days = [0,1,2,3,4,5,6];
const perEngine = {};
for (const d of days) {
  const f = JSON.parse(fs.readFileSync(`${work}/${d}/failures.json`, "utf8"));
  for (const [engine, fails] of Object.entries(f)) {
    perEngine[engine] ??= days.map(() => new Set());
    for (const x of fails) perEngine[engine][d].add(x.id);
  }
}

let anyFlip = false;
for (const [engine, sets] of Object.entries(perEngine)) {
  const ids = new Set(sets.flatMap(s => [...s]));
  const flipped = [...ids].filter(id => {
    const n = sets.filter(s => s.has(id)).length;
    return n > 0 && n < days.length;
  });
  const byCapability = {};
  for (const id of flipped) {
    const c = corpus.get(id);
    byCapability[c.capability] = (byCapability[c.capability] ?? 0) + 1;
  }
  console.log(`${engine}: ${flipped.length} case(s) change verdict across the seven reference days`);
  if (flipped.length) {
    anyFlip = true;
    console.log(`  by capability: ${JSON.stringify(byCapability)}`);
    const flaggedAlready = flipped.filter(id => corpus.get(id).conventionSensitive).length;
    console.log(`  of those, ${flaggedAlready} are already marked conventionSensitive and ${flipped.length - flaggedAlready} are NOT`);
    for (const id of flipped.slice(0, 12)) {
      const c = corpus.get(id);
      console.log(`    ${id} ${c.conventionSensitive ? "[CS]" : "[   ]"} ${JSON.stringify(c.text).slice(0, 62)}`);
    }
  }
}
if (!anyFlip) console.log("\nNo case changes verdict with the reference day. The table has no shelf life.");
' "$WORK" "$CORPUS"
