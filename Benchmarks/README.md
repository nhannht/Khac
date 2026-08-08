# Khắc benchmark

A reproducible comparison of Khắc against the parsers a developer would actually
pick instead of it. Run it yourself. Nothing here is quoted from a vendor's own
claims, and the losses are reported next to the wins.

```bash
./run.sh                                    # full corpus, Asia/Ho_Chi_Minh
./run.sh corpus/corpus.jsonl Europe/Berlin  # another zone
./stability.sh                              # does the answer depend on the day?
```

Results land in `results/<timestamp>/`: `RESULTS.md`, `summary.json`, and
`failures.json`, which lists every case each engine got wrong and what it
returned. That last file is written on every run deliberately - a benchmark that
will not show you its own failures is a marketing document.

## Results

Measured 2026-08-08 on Apple Silicon, macOS 26, Swift 6.3.3, Node 26.5.0,
release builds, `TZ=Asia/Ho_Chi_Minh`, corpus
`0ea145fd485f75b56b067cbbe5c9243a99bb6870c12be21ae7d2a45f5aac1c2a`.

Accuracy, 508 positive cases with convention-disputed ones excluded:

| Engine | Accuracy | False positives | Crashes | us/parse |
|---|---|---|---|---|
| **khac-oracle** | **71.9%** | 17.5% | 0 | 149 |
| **khac-auto** | **71.9%** | 17.5% | 0 | 426 |
| chrono-node | 68.3% | 15.1% | 0 | 12 |
| nsdatadetector | 36.0% | **4.4%** | 0 | 58 |
| swiftychrono | 31.9% | 27.4% | **5** | 2201 |

Read that honestly. Khắc leads accuracy and beats chrono on every capability
bucket. It also **invents dates in date-free text more often than chrono**, is
**2.7x slower than Apple's built-in detector**, and **loses Japanese 52.5% to
77.5%**. Portuguese and Spanish sit at 50% for both Khắc and chrono, which is a
shared gap rather than a competitive result.

`khac-auto` matching `khac-oracle` is the quietly useful number: language
detection costs essentially nothing, so the like-for-like figure against
NSDataDetector and the told-the-language ceiling are the same. Half of
`khac-auto`'s extra microseconds are Apple's `NLLanguageRecognizer`, not Khắc.

## Engines

| Engine | Version | Languages | Reference date | Why it is here |
|---|---|---|---|---|
| `khac-oracle` | this checkout | 14 | yes | told which language the text is |
| `khac-auto` | this checkout | 14 | yes | `NLLanguageRecognizer` picks - **the headline configuration** |
| `nsdatadetector` | system Foundation | ICU, uneven | **no** | free, already on every Apple device |
| `swiftychrono` | `0d5da73` | 7 | yes | the other Swift natural-language date parser |
| `chrono-node` | 2.10.1 | 14 | yes | the JavaScript library Khắc was ported from |

`khac-auto` is the headline, not `khac-oracle`. Khắc parses one language at a
time by design, so the setup its README recommends is a language identifier in
front of it, and that is also the only like-for-like comparison against
NSDataDetector, which auto-detects.

SwiftyChrono is run in its **most favourable** configuration: where it ships the
corpus language it is told which one, rather than made to detect. chrono has no
detection of its own and is always told. Neither is handicapped.

chrono-node is a yardstick, not a same-platform alternative - a Swift app cannot
use it without shipping a JavaScript runtime.

## What is measured

- **Primary: top-1 resolved-instant accuracy.** Does the first expression the
  engine returns resolve to the right moment? Day granularity when the case
  states no time, minute granularity when it does.
- **Secondary: false positives.** How often does an engine invent a date in text
  containing none? Rarely measured elsewhere, and it decides whether a capture
  box can be trusted to run on everything a user types.
- **Crashes.** Counted against the engine, never as a pass.
- **Diagnostic:** throughput, language-detection accuracy, and accuracy split by
  language and by capability.

Accuracy is bucketed by **capability**, not language alone, because a blanket
claim dies to one counterexample: NSDataDetector parses a Vietnamese numeric
date range correctly and fails on `sáng mai`.

**Span exactness is deliberately not primary.** Engines disagree about where a
match starts and ends, and NSDataDetector models a range as a start plus a
duration rather than two endpoints. Scoring spans would measure convention
instead of capability.

## Gold labels are rules, not timestamps

NSDataDetector has no reference-date API - it always resolves against the system
clock, and there is no way to hand it a fixed instant. Excluding it was not an
option: it is free, already installed everywhere, and "why not just use
NSDataDetector" is the first question any Swift developer asks.

So each answer is stored as a rule evaluated at scoring time against one shared
reference, which the harness sets to the wall clock at launch.

| Rule | Meaning |
|---|---|
| `{"rule":"abs","dt":"2027-03-14T17:00"}` | a fixed wall-clock time in the pinned zone |
| `{"rule":"ref","time":"17:00"}` | the reference day at that time |
| `{"rule":"offset","days":1,"time":"09:00"}` | also `weeks`, `months`, `years` |
| `{"rule":"offset","hours":3}` | also `minutes`; scored with a 90-second window |
| `{"rule":"weekday","name":"fri","dir":"next"}` | `dir` is `next`, `this`, or `last` |
| `{"rule":"monthDay","month":8,"day":10}` | a date with no year, resolved to the nearest occurrence |

Two mechanics keep this fair. The runner refuses to start when the process time
zone disagrees with `--tz`, because NSDataDetector and SwiftyChrono read the
process zone rather than taking a parameter. And its clock-skew guard (60s) is
strictly tighter than the scorer's clock-sensitive window (90s), so an accepted
run is always inside the tolerance it is judged by.

**Month-end is clamped, not rolled over.** "One month after 31 January" has no
agreed answer: Khắc and SwiftyChrono clamp to 28 February, chrono rolls to
3 March. Gold clamps, and any case where the two conventions differ is
automatically marked convention-disputed and excluded from the headline number.
That dispute is derived from the date, not trusted to a hand-applied flag.

## Crashes are results, not accidents

A Swift runtime trap cannot be caught in-process, so one bad input used to take
the whole run down and the engine could not be scored at all. Dropping it would
have hidden the most serious defect here.

The driver now records which input killed the engine, resumes after that case,
and counts it against that engine. SwiftyChrono dies on five:

```
２０１２／８／１０に到着予定です      full-width digits, default Japanese IME output
午後３時３０分に集合
下午３点半集合
Levering gepland op 9 feb. 2012.    plain Dutch
Leverans planerad till 9 feb 2012.  plain Swedish
```

The Dutch and Swedish ones matter most. An abbreviated month name is not exotic
input, and any app built on SwiftyChrono dies on it.

## Reproducibility across reference days

The reference instant is the wall clock, so a relative case is resolved against
whatever day you happen to run on. `stability.sh` scores the corpus at one
reference per weekday and reports every case whose verdict is not identical
across all seven.

Every case that moves is inside the convention-disputed set, and none is outside
it. **The excluded-conventions number is therefore reproducible on any day.**

That is established for **three engines by name** - `khac-oracle`, `khac-auto`,
`chrono-node`. NSDataDetector takes no reference date, so it is covered by the
clock-skew guard instead. SwiftyChrono is excluded because its crashes confound
the resume machinery, so its reference-day stability has never been tested in
either direction.

## The corpus

1000 cases, 14 languages, authored independently by people who did not read
Khắc's source or its test suite. That constraint is the whole point: Khắc's own
oracle is ported from chrono, so scoring Khắc against it would measure nothing.

```
  560 constructed   answer correct by calendar arithmetic from the reference
  280 negative      no date at all, measuring invented answers
  160 wild          realistic message text, EN and VI, hand adjudicated
```

`corpus/AUTHORING.md` is the method, and it is the file to read if you distrust
the numbers. It documents the strata, the capability taxonomy, the two known
gaps in the rule vocabulary, and - most importantly - **three ways the
specification leaked Khắc's own material into the corpus**, disclosed by case id
rather than quietly cleaned up:

1. Khắc's `CLAUDE.md` reaches an authoring agent automatically. Four cases trace
   to it, all backwards intervals; two were the cited example with only the year
   changed and had their dates replaced.
2. The spec's hard-negative examples (`10 - 10.1`, `2019 to 2020`) were lifted
   from Khắc's own documented test conventions, so **28 of 280 negatives are
   shapes Khắc was built to reject**. They carry `seededFromSubjectDocs` and the
   false-positive rate is reported with and without them. **Khắc scores worse on
   the unseeded set**, and that is the number to quote.
3. The spec's example year was chrono's canonical test instant, which seven
   languages copied. Measured: every engine scores slightly *worse* on those
   cases, so no engine is advantaged, and the corpus was left alone.

All three came from the specification, none from an author.

## Workflow

```bash
# 1. author or edit cases, one language per file
vim corpus/parts/vi.jsonl

# 2. validate one file, or all of them together
node score/validate.mjs corpus/parts/vi.jsonl
node score/validate.mjs corpus/parts/*.jsonl        # catches cross-author id collisions

# 3. assemble and freeze - validates everything, then writes the hash
./corpus/assemble.sh

# 4. run every engine and score
./run.sh corpus/corpus.jsonl Asia/Ho_Chi_Minh

# 5. confirm the answer does not depend on the day
./stability.sh
```

`validate.mjs` enforces the invariants rather than trusting them, because each
one was originally a hand-applied convention that rotted:

- a negative matching a seeded shape must carry `seededFromSubjectDocs` (error);
  a word-joined near-match only warns, since that pattern also hits IP addresses
  and currency and must never decide alone
- a `dir:"this"` weekday case must be convention-sensitive - measured, not
  assumed: engines disagree on 30% of those against 11% for `dir:"next"`
- a minute-granularity case whose rule names no time can never pass and is an
  error, not a mystery in the results

`score.mjs` stamps the corpus hash into `RESULTS.md` and `summary.json`. **If
that hash does not match `corpus/CORPUS.sha256`, the table is stale.** The
methodology used to assert this without any tool checking it, and a stale run
went unnoticed until someone compared file timestamps by hand.

## Layout

```
Benchmarks/
  run.sh                    drives every engine, resumes past crashes, scores
  stability.sh              scores at one reference per weekday
  Package.swift             a separate package, so Khac itself stays dependency-free
  Sources/BenchRunner/      the four Swift-reachable engines
  node/chrono-runner.mjs    chrono-node, emitting the same record shape
  score/score.mjs           the only component that decides right from wrong
  score/validate.mjs        schema and integrity invariants
  score/recordcrash.mjs     identifies the input that killed an engine
  corpus/AUTHORING.md       the method, and the disclosures
  corpus/assemble.sh        concatenates parts deterministically, freezes the hash
  corpus/parts/<lang>.jsonl one file per language
  corpus/corpus.jsonl       assembled, hashed in CORPUS.sha256
  results/<timestamp>/      raw output, RESULTS.md, failures.json (gitignored)
```

The benchmark is its own SwiftPM package. Khắc itself stays dependency-free;
only this package pulls in a competitor, and only to measure it.

## Known limitations

- **Recurrence and lunar dates are absent.** No engine in the field parses
  either, so cases would score zero for all five and measure nothing. Real gaps,
  but field-wide ones rather than Khắc results.
- **Two phrasings the rule vocabulary cannot express**, so cases of those shapes
  were dropped rather than mislabelled: weekday-plus-offset ("a week from
  Tuesday") and end-of-period ("end of next month").
- **A weekday named by its week** ("Friday of next week", `thứ sáu tuần sau`,
  `来週の金曜日`) differs from "next Friday" whenever the reference falls early in
  the week. Twenty cases were written this way and are excluded rather than
  scored against an approximation.
- **Idiomaticity was systematically reviewed for English and Vietnamese only.**
  The other twelve languages were read incidentally. Treat them as not examined
  rather than as clean.
- The corpus is a snapshot. Engines change; re-run rather than quoting these
  numbers indefinitely.

## Reporting a defect in a rival

SwiftyChrono's five crashes are reproducible from this repository. If you
maintain one of these libraries and want a minimal reproduction, every failing
input is in `corpus/corpus.jsonl` by id and in `failures.json` after a run.
