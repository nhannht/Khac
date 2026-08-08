# How this corpus was authored

The rules every author followed. They exist so that a reader who distrusts the
results can check the method rather than take the numbers on faith.

## The one rule that matters

**No author read Khắc's source or its test suite.**

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

`name` is one of `sun mon tue wed thu fri sat`. Omitting `time` means the case is
scored at day granularity.

**A constructed case that states an absolute date always carries an explicit
year.** Month-and-day without a year resolves by a heuristic that differs between
engines, so scoring it here would measure convention rather than capability.

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
