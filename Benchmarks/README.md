# Khắc benchmark

A reproducible comparison of Khắc against the alternatives a developer would
actually pick instead of it. Run it yourself; every number below is produced by
the scripts in this directory and nothing is quoted from a vendor's own claims.

```bash
./run.sh                                   # smoke corpus, Asia/Ho_Chi_Minh
./run.sh corpus/corpus.jsonl Europe/Berlin # full corpus, another zone
```

## Engines measured

| Engine | Version | Languages | Reference date | Notes |
|---|---|---|---|---|
| `khac-oracle` | this checkout | 14 | yes | told which language the text is |
| `khac-auto` | this checkout | 14 | yes | `NLLanguageRecognizer` picks the language |
| `nsdatadetector` | system Foundation | ICU, uneven | **no** | Apple's built-in, free on every device |
| `swiftychrono` | `0d5da73` | 7 | yes | the other Swift natural-language date parser |
| `chrono-node` | 2.10.1 | 14 | yes | the JavaScript library Khắc was ported from |

`khac-auto` is the headline configuration, not `khac-oracle`. Khắc parses one
language at a time by design, so the setup its README recommends is a language
identifier in front of it, and that is also the only like-for-like comparison
against NSDataDetector, which auto-detects. `khac-oracle` is reported alongside
it to show what language detection costs.

SwiftyChrono is run in its most favourable configuration: where it ships the
corpus language it is told which one it is, rather than being made to detect.
chrono-node has no detection of its own and is always told.

chrono-node is a yardstick, not a same-platform alternative. A Swift app cannot
use it without shipping a JavaScript runtime.

## What is measured

- **Primary: top-1 resolved-instant accuracy.** Does the first expression the
  engine returns resolve to the right moment? Day granularity when the case
  states no time, minute granularity when it does.
- **Secondary: false positives.** How often does an engine invent a date in text
  that contains none? Rarely measured elsewhere, and it is what decides whether
  a capture box can be trusted to run on everything a user types.
- **Diagnostic: throughput**, and accuracy broken out by language and by
  capability.

Accuracy is reported per capability rather than per language alone, because a
blanket claim dies to one counterexample. NSDataDetector parses a Vietnamese
numeric date range correctly and fails on `sáng mai`; "we beat Apple on
Vietnamese" is false and "we beat Apple on casual and relative Vietnamese" is
not.

Span exactness is deliberately **not** primary. Engines disagree about where a
match starts and ends, and NSDataDetector models a range as a start plus a
duration rather than as two endpoints. Scoring spans would measure convention
mismatch instead of capability.

## Why gold labels are rules, not timestamps

NSDataDetector has no reference-date API. It always resolves relative
expressions against the system clock, and there is no way to hand it a fixed
instant. Excluding it was not an option: it is free, it is already on every
Apple device, and "why not just use NSDataDetector" is the first question any
Swift developer asks.

So the corpus stores each answer as a rule evaluated at scoring time against one
shared reference instant, which the harness sets to the wall clock at launch.
Every engine is given that same instant. The runner refuses to start if the
process time zone disagrees with `--tz`, because NSDataDetector and SwiftyChrono
read the process zone rather than taking one as a parameter.

Rules whose answer moves with the clock (`in 3 hours`) are scored with a
one-minute window, applied to every engine equally. Every other rule is scored
exactly.

## Corpus format

One JSON object per line.

```json
{
  "id": "en-c-0007",
  "lang": "en",
  "stratum": "constructed",
  "capability": "weekday",
  "text": "next Friday at 5pm",
  "gold": {
    "kind": "instant",
    "start": {"rule": "weekday", "name": "fri", "dir": "next", "time": "17:00"},
    "granularity": "minute"
  },
  "conventionSensitive": true
}
```

- `stratum` is `constructed`, `wild`, or `negative`.
  - `constructed` cases are generated from templates whose answer is correct by
    calendar arithmetic from the reference instant. No parser was ever consulted
    to produce a label.
  - `wild` cases are realistic text, hand adjudicated.
  - `negative` cases contain no date at all.
- `capability` is one of `numeric_absolute`, `month_name`, `weekday`,
  `casual_relative`, `time_of_day`, `interval`, `timezone`, `none`.
- `gold.kind` is `instant`, `interval`, or `none`.
- `gold.granularity` is `day` or `minute`.
- `conventionSensitive: true` marks a case where engines legitimately disagree,
  such as whether "next Friday" means the coming Friday or the one after.
  Results are reported both including and excluding these.

Gold rules:

| Rule | Meaning |
|---|---|
| `{"rule":"abs","dt":"2012-08-10T17:00"}` | a fixed wall-clock time in the pinned zone |
| `{"rule":"ref","time":"17:00"}` | the reference day at that time |
| `{"rule":"offset","days":1,"time":"09:00"}` | also `weeks`, `months`, `years` |
| `{"rule":"offset","hours":3}` | also `minutes`; scored with the one-minute window |
| `{"rule":"weekday","name":"fri","dir":"next"}` | `dir` is `next`, `this`, or `last` |

Constructed absolute cases always carry an explicit year. Month-and-day without
a year resolves by a heuristic that differs between engines, so scoring it in
the constructed stratum would measure convention rather than capability.

## Guarding against a rigged corpus

Khắc's own test suite is ported from chrono. Scoring Khắc against those cases
would prove nothing, because Khắc was built to pass them. The benchmark corpus is
therefore authored independently, by people and tools that did not read Khắc's
source, and it is frozen and hashed before any engine is tuned against it.

`corpus/CORPUS.sha256` records the hash. If a result table cites a corpus hash
that does not match the corpus in the repo, the table is stale and should not be
believed.

## Layout

```
Benchmarks/
  run.sh                    drives every engine and scores the output
  Package.swift             separate package, so Khac itself stays dependency-free
  Sources/BenchRunner/      the four Swift-reachable engines
  node/chrono-runner.mjs    chrono-node, emitting the same record shape
  score/score.mjs           the only component that decides right from wrong
  corpus/                   cases and their hash
  results/<timestamp>/      raw output, RESULTS.md, failures.json
```

`failures.json` lists every case each engine got wrong, with what it returned.
It is written on every run, deliberately: a benchmark that does not let you read
its own failures is a marketing document.
