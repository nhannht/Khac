# How this corpus was authored

The rules every author followed. They exist so that a reader who distrusts the
results can check the method rather than take the numbers on faith.

## The one rule that matters

**No author read Khắc's source or its test suite.**

## What leaked anyway, disclosed

Two channels defeated that rule in part. Both are recorded here rather than
quietly cleaned up, because a disclosed bias can be measured around and a hidden
one cannot.

**1. The subject's engine documentation reached every author automatically.**
Khắc's repository `CLAUDE.md` is injected into an agent's context by the tooling,
not opened by choice. It describes architecture and invariants - overlap
ordering, the NFC boundary, how a backwards interval is reported - and names no
vocabulary, no patterns, and no test data. Its practical effect was small and
visible. Asked to list every case whose content it shaped, the English author
named exactly three, and volunteered the most damaging one unprompted:

- `en-c-0038` - a backwards interval. Khắc's documentation gives "August 22 - 10,
  2012" as its own example of that invariant, and the case was the same month and
  the same two days with only the year changed. That is the cited example
  re-skinned, so its dates were replaced. The shape was kept, because a backwards
  range is a legitimate input and dropping it would lose real coverage.
- `en-w-0078` - the same shape with different months and days, reached by knowing
  the invariant exists rather than by copying it. Kept as written.
- `en-n-0001` and `en-n-0008` - covered by the seeding disclosure below.

No other author reported a case shaped by it. The Japanese and Chinese author
disclosed the same automatic injection and stated it changed no case, having
drawn its vocabulary from the language rather than from the file.

**2. The worse one, and it came from this document.** Earlier drafts of the
hard-negative list below used `10 - 10.1` and `2019 to 2020` as examples. Both
were lifted from Khắc's own documented test conventions, which name exactly those
two strings. Every author used them, so **21 of 280 negatives, 8%, are shapes the
subject was specifically built to reject** - and the measured consequence is real:
Khắc rejects `10-10.1` while chrono and SwiftyChrono both false-positive on it.

That is flattering selection in a headline metric, introduced by the spec rather
than by any author. Rather than delete the cases, which are perfectly good
negatives, they carry `"seededFromSubjectDocs": true` and the scorer reports the
false-positive rate twice: over all negatives, and over the unseeded ones only.
The second number is the one to trust.

Khắc's oracle cases are ported from wanasit/chrono. A corpus written by someone
looking at Khắc's vocabulary tables would contain exactly the phrasings Khắc
already knows, and scoring Khắc against it would prove nothing at all. Authors
worked from their own knowledge of the language and from realistic text, and
were given the schema but never the parser.

The corpus is frozen and hashed in `CORPUS.sha256` before any engine is tuned
against it. A results table citing a different hash is stale.

## The second rule

**Write cases that plausibly break a parser, not cases that confirm one works.**

A corpus the subject scores 100% on is not evidence of quality, it is evidence
the corpus is easy. Authors were told to reach for the awkward forms real people
type: abbreviations, missing punctuation, mixed separators, a date buried in the
middle of a clause, ordinals, bare month-day, times without a meridiem.

## Strata

| Stratum | Per language | What it is |
|---|---|---|
| `constructed` | 40 | Generated from templates. The answer is correct by calendar arithmetic from the reference instant, so a label cannot be wrong; a reviewer only checks that the surface text is natural in that language. |
| `negative` | 20 | Contains no date at all. Measures whether an engine invents one. |
| `wild` | 80, EN and VI only | Realistic text, hand adjudicated. This is where a critic cannot say "you tested your own templates". |

1000 cases total across 14 languages.

Constructed cases are spread across capabilities: 6 `numeric_absolute`,
6 `month_name`, 6 `weekday`, 10 `casual_relative`, 6 `time_of_day`, 6 `interval`.

**`month_name` means the MARKED form of a date, not literally a month's name.**
Japanese and Chinese write months as ordinals, so 八月 is "eighth month" and
there is no name to read. The distinction that actually carries across all 14
languages is marked against unmarked: `month_name` is the form carrying a
locale marker (August, ottobre, and equally the 年月日 morphemes, since 月 is
what names the month), while `numeric_absolute` is the separator-driven form
with no marker at all (2012/8/10, 2012.8.10).

This was got wrong twice before it was got right. The first draft mapped
`month_name` onto kanji and hanzi numerals, which conflated numeral FORM with
date form. The correction, which came from the Japanese and Chinese author
overruling the instruction it had been given, is the axis above: it keeps every
language populating the same buckets, which is the only way the by-capability
table stays comparable. Kanji-numeral dates (二千十二年八月十日) therefore sit in
`month_name` alongside 2012年8月10日, because both are the marked form.

**Negatives are the point, not filler.** Plain prose with no numbers is a weak
negative that every engine passes. The hard ones, and what every author was
asked to include: version numbers (`upgrade to 10 - 10.1`), room and seat numbers
(`Room 204`), match scores (`we won 3-1`), prices, phone numbers, ISBNs, model
numbers, percentage ranges, and `2019 to 2020` written to mean two separate
years rather than a range.

## Labels are computed, never parsed

**No author ran any parser to produce a label.** Every gold value is arithmetic
from the reference instant. A label produced by running an engine would encode
that engine's convention as ground truth, which is the same circularity in a
different coat.

Labels are stored as RULES, not timestamps, because NSDataDetector has no
reference-date API and always resolves against the system clock. The rule is
evaluated at scoring time against one instant shared by every engine.

| Rule | Meaning |
|---|---|
| `{"rule":"abs","dt":"2012-08-10T17:00"}` | a fixed wall-clock time in the pinned zone |
| `{"rule":"ref","time":"17:00"}` | the reference day at that time |
| `{"rule":"offset","days":1,"time":"09:00"}` | also `weeks`, `months`, `years` |
| `{"rule":"offset","hours":3}` | also `minutes`; scored with a one-minute window |
| `{"rule":"weekday","name":"fri","dir":"next"}` | `dir` is `next`, `this`, or `last` |
| `{"rule":"monthDay","month":8,"day":10}` | a date with no year stated, resolved to the occurrence nearest the reference |

`name` is one of `sun mon tue wed thu fri sat`. Omitting `time` means the case is
scored at day granularity.

**A constructed case that states an absolute date always carries an explicit
year.** Month-and-day without a year resolves by a heuristic that differs between
engines, so scoring it in the constructed stratum would measure convention rather
than capability.

The `wild` stratum is the exception, and deliberately so. Real people write "see
you Aug 10" constantly, and a wild stratum that banned it would not be wild. Those
cases use the `monthDay` rule and carry `conventionSensitive: true`, so they are
measured but never counted in the headline number.

### Known gaps: phrasings this rule vocabulary cannot express

Two authors hit these independently, so they are recorded rather than left to be
rediscovered. Cases of these shapes were DROPPED rather than labelled with a rule
that does not mean what the text means.

- **Weekday plus offset.** "a week from Tuesday", "the Monday after next". These
  need "the next occurrence of X, then shift", and no rule composes.
- **End of a period.** "end of next month", "end of the quarter". `offset` with
  `months: 1` lands on the same day-number in the next month, not on its last day.

Both are real phrasings and their absence is a real gap in coverage. Neither was
worth adding mid-flight: they would have arrived after most languages were already
written, so only the last few would have carried them, and an unevenly populated
capability makes the by-language table incomparable, which costs more than the
gap does. Worth adding before a second edition, with every language covered.

## Convention-sensitive cases

`"conventionSensitive": true` marks a case where engines legitimately disagree -
whether "next Friday" means the coming Friday or the one after, whether "this
Saturday" on a Saturday means today. These are real inputs and stay in the
corpus, but results are reported both including and excluding them, so a
convention difference is never sold as a capability gap.

## Schema

One JSON object per line, no trailing commas, UTF-8, NFC.

```json
{"id":"vi-c-0007","lang":"vi","stratum":"constructed","capability":"weekday","text":"thứ sáu tuần sau lúc 5 giờ chiều","gold":{"kind":"instant","start":{"rule":"weekday","name":"fri","dir":"next","time":"17:00"},"granularity":"minute"},"conventionSensitive":true}
```

| Field | Values |
|---|---|
| `id` | `<lang>-<c\|w\|n>-<4 digits>`, unique across the whole corpus. Authors use `0001`-`0999`; `9xxx` is reserved for the smoke corpus. |
| `lang` | `en vi de es fi fr it ja nl pt ru sv uk zh` |
| `stratum` | `constructed` `wild` `negative` |
| `capability` | `numeric_absolute` `month_name` `weekday` `casual_relative` `time_of_day` `interval` `timezone` `none` |
| `text` | what a person would actually type. Not a textbook sentence. |
| `gold.kind` | `instant` `interval` `none` |
| `gold.granularity` | `day` or `minute`. Required unless `kind` is `none`. |
| `gold.end` | required when `kind` is `interval` |

Negatives use `"capability":"none"` and `"gold":{"kind":"none"}`.

## Validate before reporting done

```bash
node Benchmarks/score/validate.mjs Benchmarks/corpus/parts/<lang>.jsonl
```

The validator is not a formality. It catches the failure that is otherwise
invisible until scoring: a rule that names a field it does not have, an id that
collides with another author's, a negative carrying a gold value.
