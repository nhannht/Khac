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
against it. A results table citing a different hash is stale, and every table
the scorer writes stamps the hash it scored so that claim can be checked.

## What leaked anyway, disclosed

Three channels defeated that rule in part, and all three trace back to this
document rather than to any author. They are recorded here rather than quietly
cleaned up, because a disclosed bias can be measured around and a hidden one
cannot.

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
two strings. Every author used them, so **28 of 280 negatives, 10%, are shapes the
subject was specifically built to reject** - and the measured consequence is real:
Khắc rejects all of them while chrono and SwiftyChrono false-positive on several.

That count reached 28 only after an adversarial reviewer read every negative by
hand. The automated check had been written to spot a DASH between the two version
numbers, which is how English writes it, and it silently missed the seven
languages that use a word instead: `10.0 auf 10.1`, `10 до 10.1`, `10から10.1`.
Those eight cases sat untagged inside the very metric the disclosure exists to
protect, quietly flattering Khắc by about 0.6 points and penalising chrono by the
same. The check is now two tiers, and the second only warns, because the broader
pattern also matches IP addresses and money and must never decide alone.

**3. The spec seeded a reference year too, and this one was invisible.** Seven of
fourteen languages use the year 2012 for nearly every constructed absolute date.
`2012-08-10` is chrono's canonical test instant, baked into every ported oracle
file in Khắc's test suite, so the clustering looks like authors having read the
suite they were told not to read. They had not. This document's own gold-rule
example is `{"rule":"abs","dt":"2027-03-14T17:00"}`, and `smoke-en.jsonl`, given
to every author as the format reference, is 2012 dates end to end. They copied
the year out of the spec. The five languages that did not cluster are precisely
the ones whose assignment pushed them elsewhere: the two with a wild stratum,
which forces realistic message text, and one author who chose near-future dates
deliberately.

Unlike the first two channels, this one **cost nothing measurable**, and that is
established rather than assumed. Comparing engine accuracy on the 115 cases dated
2012 against the 139 other constructed absolute-date cases, every engine scores
slightly WORSE on the 2012 subset - Khắc by 3.5 points, chrono by 5.4,
SwiftyChrono by 8.8, NSDataDetector by 2.9. A rule-based parser gets no
memorisation benefit from a literal calendar date appearing in its own fixtures,
and the numbers demonstrate it instead of asserting it.

The example year in this document has been changed so a future run cannot repeat
the effect. The corpus was left alone, because there is no bias to correct.

## How the seeded cases are handled

Channels 1 and 2 put flattering selection into a headline metric. Rather than
delete the cases, which are perfectly good negatives, they carry
`"seededFromSubjectDocs": true` and the scorer reports the false-positive rate
twice: over all negatives, and over the unseeded ones only. **The second number
is the one to trust, and it is worse for Khắc** - correcting the tagging inverted
the ordering, putting Khắc above chrono on invented dates rather than below it.

Cases traceable to channel 1 are disclosed by id above and kept, except where the
case was the cited example with only its year changed. Two were: `en-c-0038` and
`vi-c-0038`, both backwards intervals reusing Khắc's documented "August 22 - 10"
day pair. Both had their dates replaced and their shape kept, because a backwards
range is a legitimate input and losing the coverage would cost more than the
overlap did.

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
| `{"rule":"abs","dt":"2027-03-14T17:00"}` | a fixed wall-clock time in the pinned zone |
| `{"rule":"ref","time":"17:00"}` | the reference day at that time |
| `{"rule":"offset","days":1,"time":"09:00"}` | also `weeks`, `months`, `years` |
| `{"rule":"offset","hours":3}` | also `minutes`; scored with a 90-second window |
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
- **A weekday named by its WEEK.** Vietnamese "thứ sáu tuần sau", Japanese
  "来週の金曜日", Chinese "下周五", Spanish "el sábado pasado" - Friday *of next
  week*, not *next* Friday. Those differ whenever the reference day falls early
  in the week, and `{"rule":"weekday","dir":"next"}` expresses only the second
  one. Twenty cases across six languages were written with this phrasing and
  labelled with the approximation. They are now marked convention-sensitive and
  excluded from the headline number rather than scored against a rule that does
  not mean what the text means.

  This was found empirically, not by reading: `stability.sh` scores the corpus at
  one reference per weekday and reports any case whose verdict is not the same on
  all seven. Those twenty flipped. A label that is right on Tuesday and wrong on
  Saturday is not a label.
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
