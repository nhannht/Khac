#!/usr/bin/env bash
# Assembles the per-language parts into one corpus and freezes it with a hash.
#
#   ./assemble.sh
#
# The order is sorted by filename, not whatever order the filesystem hands back,
# because the hash has to be reproducible on someone else's machine. A results
# table that cites a hash the corpus does not match is stale and should not be
# believed, which only works if the hash is stable.
#
# Validation runs BEFORE the hash is written. Freezing a corpus that does not
# validate would freeze the mistake.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARTS="$HERE/parts"
OUT="$HERE/corpus.jsonl"
HASH="$HERE/CORPUS.sha256"

shopt -s nullglob
files=("$PARTS"/*.jsonl)
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
  echo "assemble: no part files in $PARTS" >&2
  exit 1
fi

# Sorted, so the concatenation and therefore the hash are deterministic.
IFS=$'\n' sorted=($(printf '%s\n' "${files[@]}" | sort)); unset IFS

echo "parts (${#sorted[@]}):"
for f in "${sorted[@]}"; do
  printf '  %-12s %5d cases\n' "$(basename "$f")" "$(grep -c . "$f" || true)"
done
echo

echo "validating every part together, which is what catches an id collision"
echo "between two authors who each validated alone:"
node "$HERE/../score/validate.mjs" "${sorted[@]}"
echo

cat "${sorted[@]}" > "$OUT"
( cd "$HERE" && shasum -a 256 "$(basename "$OUT")" > "$HASH" )

echo "wrote $(basename "$OUT"): $(grep -c . "$OUT") cases"
echo "froze $(basename "$HASH"): $(cut -d' ' -f1 < "$HASH")"
