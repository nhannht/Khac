# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Khắc is a natural-language date and time parser: a Swift package, no dependencies,
fourteen locales. `README.md` covers the public API, the measured behavior, and the
known limitations. This file covers the invariants a change breaks by accident.

## Commands

```bash
swift build
swift test                                              # 365 tests, 0 failures

swift test --filter FROracleTests                       # one test class
swift test --filter "KhacTests.FROracleTests/testWeekdayCases"   # one test method
swift test --filter Scoreboard                          # all 13 locale scoreboards
```

`swift test --filter Scoreboard` is the progress instrument: it prints each locale's
oracle pass count and asserts its ratchet floor. Run it after any
change to a parser, a refiner, or the overlap ordering, because those are the changes
that move numbers in locales you were not editing.

The manifest pins `swift-tools-version:5.10`. Do not raise it for a language feature:
the suite is expected green on Linux under Swift 5.10 and 6.3, and that portability is
tested behavior, not a nice-to-have.

## The benchmark is the only independent measure

`swift test` cannot tell you whether a change made Khắc better or worse in the
real world. The oracle IS chrono's suite, so it measures fidelity to the library
Khắc was ported from and nothing else. A performance change can leave all 365
tests green and still break text nobody ported.

`Benchmarks/` holds 1000 cases in 14 languages, authored by people who never read
this source, frozen and hashed. It is the check the suite structurally cannot be.

```bash
cd Benchmarks
./run.sh                     # every engine, scored; results/<timestamp>/
./stability.sh               # does the verdict depend on the day it runs?
node score/validate.mjs corpus/parts/*.jsonl
./corpus/assemble.sh         # validate, concatenate, re-freeze the hash
```

Run `./run.sh` before and after any change to matching, resolution, or
performance, and compare `RESULTS.md`. Green tests are necessary and not
sufficient.

Invariants worth knowing before touching it, each of which was a hand-applied
convention that silently rotted before it was made a check:

- **`score.mjs` is the only component that decides right from wrong.** Runners
  report what an engine returned and nothing else, so no engine can be
  advantaged by how its own output is judged. Keep it that way.
- **Every results table stamps the corpus hash it scored.** If it disagrees with
  `corpus/CORPUS.sha256`, the table is stale. This was asserted in prose for a
  while with nothing enforcing it, and a stale run went unnoticed.
- **Month-end clamps, and the dispute is derived.** Khắc and SwiftyChrono clamp
  "a month after 31 January" to 28 February; chrono rolls to 3 March. The scorer
  once rolled, which silently marked Khắc wrong on any run near a month end.
- **A crash is a result.** An engine that traps is recorded, resumed past, and
  counted against - never dropped from the comparison.
- **The corpus discloses its own biases by case id** in `corpus/AUTHORING.md`.
  Three separate channels leaked this repository's material into it, all through
  the authoring spec rather than any author. Do not quietly remove a disclosed
  case; a disclosed bias can be measured around and a hidden one cannot.

## Architecture

### One pipeline

`Engine.run` is the only assembly path. `Khac.parse` and every oracle test both call
it, so a green test proves the real engine and never a parallel one. Do not add a
second path.

```
  per locale:   normalize once
                -> genericParsers + locale.additionalParsers
                -> mergeRefiners + locale.additionalRefiners
                -> per-locale OverlapFilterRefiner
                -> stamp localeRank
  across:       concatenate -> one final OverlapFilterRefiner -> sort by index
```

`localeRank` is stamped AFTER the per-locale pipeline, so within-locale ranking never
sees it. Only the cross-locale filter compares differing ranks.

### Locales are data, not code

A `KhacLocale` supplies `Vocabulary`, `PatternSet`, and `LocaleOptions`. The shared
generic parsers read everything from `context.locale`, so no locale literal belongs in
engine code and adding a language means filling tables. `additionalParsers` /
`additionalRefiners` are the escape hatch for genuinely bespoke grammar (CJK numerals,
JA and ZH date forms), not a shortcut around a missing data field.

`Locale.swift` states a freeze contract, and it still holds:

- `KhacLocale`, `Parser`, `Refiner`, and `ParserResult` are a hard freeze. Names and
  signatures do not change.
- `Vocabulary`, `PatternSet`, `LocaleOptions` grow ADDITIVELY only. Every stored
  property has a default and the memberwise init defaults every parameter, so a new
  field never breaks an existing locale.

When a locale needs behavior the engine lacks, add a defaulted data field that the
generic parser consumes. A per-locale parser for a shape another locale already
expresses as data is the failure mode this design exists to prevent.

`allLocales()` in `Khac.swift` is the availability gate. A locale type that exists but
is not listed there is unreachable through `Khac(locales:)` and parses nothing for
every caller who does not name the instance directly. `PublicAPITests` resolves every
`LocaleID` through `Khac(locales:)` to catch that.

## Invariants that fail silently

These produce wrong output rather than an error. Read the cited comment before
touching any of them.

- **Overlap order is a lexicographic tuple, never a scalar sum.** score desc,
  matchLength desc, index asc, parserRank asc, localeRank asc, stableSignature asc
  (`ParsedResult.isPreferred(over:)`). The signature makes the order total, so a
  winner never depends on parser registration order. A green suite does not license
  reordering these keys.
- **`score` counts CERTAIN components, not what the writer typed.** A casual day word
  resolving off the reference marks year, month and day certain without a character
  stating any of them. That has already cost one wrong answer.
- **`Engine.mergeRefiners` order is load-bearing.** It is chrono's own refiner order
  with every unshift/push resolved, and several behaviors exist only in that sequence.
  The reasons are in the comment above the array.
- **The NFC boundary.** Matching runs on NFC-normalized text; `index`, `matchLength`
  and `rangeEnd` are ORIGINAL-text UTF-16 offsets. A refiner that re-parses a result
  must read `result.normalizedText`, never `result.text` - patterns are folded to NFC
  and real macOS input often is not, so matching a pattern against `text` silently
  finds nothing. `NormalizedText` translates in both directions.
- **`.withTransparentBounds` on the resume scan is required explicitly**
  (`Engine.runParser`). Apple's NSRegularExpression treats sub-range bounds as
  transparent by default; swift-corelibs-foundation defaults to OPAQUE. Without the
  flag, every parser's lookbehind boundary guard goes blind and Linux admits 111
  oracle divergences.
- **`interval` is the only safe route to a `DateInterval`.** A backwards range is a
  real reading of text like "August 22 - 10, 2012" and is reported as written.
  `DateInterval(start:end:)` traps when end precedes start, so never build one from
  `start` and `end`.
- **`PreparedLocale` is the pattern cache**, keyed by (parser type, mode, forwardDate).
  A pattern must stay a pure function of that key: never let one depend on the input
  text or the reference instant. Patterns are built OUTSIDE the lock deliberately,
  because `pattern()` calls into consumer-supplied locale code.

## Test conventions

- **The oracle holds ported case DATA only** - inputs, reference dates, and expected
  values from wanasit/chrono's own tests. chrono's test code is never copied. See
  `Tests/KhacTests/Oracle/README.md` and the root `NOTICE`.
- **`*Cases.swift` files are generated** and marked `GENERATED FILE`. Do not hand-edit
  them. The extraction pipeline is not in this repo; a re-port is re-derived the same
  way. Each locale directory carries an `extraction-report.json` naming every excluded
  case and its reason, so the counts are checkable rather than asserted.
- **Ratchet floors only go up.** Thirteen `static let floor` constants, one per locale
  scoreboard. Raise one after an improvement; never lower one to accommodate a
  regression.
- **A case that cannot pass yet is DEFERRED, never deleted or skipped.** Add it to that
  locale's `knownDeferrals`, keyed by the exact input string, with a written reason
  naming the engine gap. Deferrals run through `expectKnownFailure`, not
  `XCTExpectFailure` directly: corelibs-xctest has never implemented the latter, so
  naming it breaks the Linux BUILD and takes the whole test target with it.
- **Every oracle runner pins a fixed Gregorian/UTC calendar**, so cases are
  deterministic regardless of the machine.
- **Reporting is per CASE, not per asserted field.** One case that gets four components
  wrong is one failure carrying four reasons. A field-level count cannot be read as
  progress.
- Negative cases carry the same weight as positive ones. `"2019 to 2020"` is two years
  and not a range; `"10 - 10.1"` is two version numbers. Both must keep producing
  nothing.

## Source markers

Comments reference design decisions by shorthand. The decisions are recorded outside
this repository, so treat the marker as a warning that the surrounding code is
load-bearing rather than as a lookup you can follow here.

- `SPEC 3a-H0` and similar - a rule the code implements deliberately, most often about
  overlap ordering or normalization.
- `KHAC-N` - a numbered engine gap or fix, also used as the reason tag on oracle
  deferrals.
- `KHAC-FIX` - a deliberate divergence from chrono, where chrono's behavior for that
  locale is wrong. All five are in `VILocale`, verified by a native speaker and listed
  in the README; engine code cites them by the same tag where a divergence constrains a
  shared parser.
