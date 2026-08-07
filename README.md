# Khắc

[![Swift versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnhannht%2FKhac%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/nhannht/Khac)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnhannht%2FKhac%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/nhannht/Khac)

A natural-language date and time parser for Swift. Fourteen languages.

Khắc reads free text and returns structured dates, intervals, and components. It
handles casual, relative, and absolute expressions in English, Vietnamese,
Chinese, Japanese, German, Dutch, Swedish, French, Spanish, Italian, Portuguese,
Finnish, Russian, and Ukrainian. It is built so that adding a language means
filling in data tables, not writing a new parser.

```swift
import Khac

let khac = Khac()

khac.parseDate("next Friday at 5pm")        // Date?
khac.parseDate("sáng mai")                  // Date?
khac.parse("from Aug 10 to Aug 14")         // [ParsedResult], each with .interval
```

## Install

Swift Package Manager:

```swift
.package(url: "https://github.com/nhannht/Khac.git", from: "0.1.0")
```

Then add `Khac` to your target's dependencies. Requires Swift 5.10, macOS 12,
iOS 15, tvOS 15, or watchOS 8.

## Usage

### Parsing

`parse` returns every date expression it finds in the text, in order.
`parseDate` is a convenience for the first resolved date.

```swift
let khac = Khac()

let results = khac.parse("meet Aug 10, then again on Sept 2")
// results[0].text == "Aug 10",  results[0].date == 2024-08-10 12:00
// results[1].text == "Sept 2",  results[1].date == 2024-09-02 12:00
// results[1].index == 27
```

Every result carries the matched substring and its offset in the original text,
so you can highlight it or slice it out:

```swift
for r in results {
    let range = NSRange(location: r.index, length: r.matchLength)
    print(r.text, r.date, range)
}
```

### The reference date

Relative expressions resolve against a reference point, which defaults to now.
Pass your own to make parsing deterministic, and to parse on behalf of a user in
another time zone.

```swift
let ref = ReferencePoint(instant: someDate, timeZone: TimeZone(identifier: "Asia/Ho_Chi_Minh")!)
khac.parseDate("tomorrow", reference: ref)
```

The reference is the only route for the caller's own time zone. A zone written
in the text itself is parsed separately and overrides it.

### Options

```swift
khac.parse(text, reference: .now, options: Options(mode: .strict))
```

`mode` is `.casual` by default, which accepts everyday phrasing. `.strict`
accepts only unambiguous absolute forms:

```swift
let strict = Options(mode: .strict)
khac.parse("tomorrow", options: strict)          // []
khac.parse("August 10, 2012", options: strict)   // 1 result
```

`forwardDate: true` pushes a bare date that could be past or future into the
future.

### Selecting locales

`Khac()` uses every built-in locale. Name them to narrow it, which is faster and
avoids cross-language false positives:

```swift
Khac(locales: [.english])
Khac(locales: [.vietnamese])
Khac(locales: [.english, .vietnamese])
```

Fourteen locales are built in: `.english`, `.vietnamese`, `.chinese`,
`.japanese`, `.german`, `.dutch`, `.swedish`, `.french`, `.spanish`, `.italian`,
`.portuguese`, `.finnish`, `.russian`, and `.ukrainian`.

### Ranges

A range result has an `end`, and `interval` gives you a `DateInterval`:

```swift
let r = khac.parse("December 31 2022 10:00 pm - 1:00 am").first!
r.date          // 2022-12-31 22:00
r.end?.date()   // 2023-01-01 01:00, the day rolls over
r.interval      // DateInterval, or nil if the range is malformed
```

Prefer `interval` over building your own from `start` and `end`. See Known
limitations.

## What it parses

Every line below is measured output, not an illustration. Reference is
Sunday 2024-06-09 12:00 UTC.

### English

```
  tomorrow                            2024-06-10 12:00
  tonight at 8                        2024-06-09 20:00
  next Friday at 5pm                  2024-06-14 17:00
  last night                          2024-06-08 00:00
  this weekend                        2024-06-15 12:00

  5 days from now                     2024-06-14 12:00
  2 weeks ago                         2024-05-26 12:00
  in 3 hours                          2024-06-09 15:00
  2 days after tomorrow               2024-06-12 12:00

  August 10, 2012                     2012-08-10 12:00
  10 Aug 2012                         2012-08-10 12:00
  8/10/2012                           2012-08-10 12:00
  2023-11-06T06:36:02Z                2023-11-06 06:36:02   tz=0

  Mon, 06 Nov 2023 06:36:02 -0500     2023-11-06 11:36:02   tz=-300
  06/Nov/2023:06:36:02 -0500          2023-11-06 11:36:02   tz=-300

  from Aug 10 to Aug 14               2024-08-10 12:00 .. 2024-08-14 12:00
  8 - 11pm                            2024-06-09 20:00 .. 2024-06-09 23:00
```

RFC 2822, RFC 3339, and Apache or nginx access-log timestamps all parse,
including negative UTC offsets.

### Vietnamese

```
  ngày 15 tháng 3 năm 2020            2020-03-15 12:00
  mùng 2 tháng 9                      2024-09-02 12:00
  sáng mai                            2024-06-10 09:00
  7 giờ sáng mai                      2024-06-10 07:00
  tối qua                             2024-06-08 19:00
  đêm qua                             2024-06-08 22:00
  thứ hai tới                         2024-06-10 12:00
  hai tuần trước                      2024-05-26 12:00
  12 giờ đêm                          2024-06-09 00:00
```

## Results

```
  swift test        364 tests, 0 failures, exit 0
  oracle total      1927 / 1988 cases across 13 locale oracles
  VI suite           91 tests, verified by a native speaker
```

Each locale's oracle is ported from wanasit/chrono's own test suite, case by
case. Every oracle holds a ratchet floor that only goes up, so a pass count can
never quietly regress. Per locale:

```
  EN   561 / 561     NL   211 / 214     DE   119 / 124
  ZH   168 / 168     RU   129 / 131     FI    77 /  77
  IT   147 / 168     UK   129 / 131     ES    75 /  75
  FR   126 / 154     JA    84 /  84     PT    60 /  60
                     SV    41 /  41
```

Every case not passing is held in the suite as an expected failure with a
written reason, never skipped. Most fall into three classes: named timezone
abbreviations ("2pm EST", "14 Uhr CET"), which no locale resolves yet; French
"il y a N jours" durations, which need a past-direction prefix slot the engine
does not have; and compact clock forms like "8h10m00".

The English oracle also reports per source file:

```
  en.test.ts                              14 / 14      en_time_exp.test.ts                    56 / 56
  en_casual.test.ts                       42 / 42      en_time_units_ago.test.ts              43 / 43
  en_inter_std.test.ts                     8 /  8      en_time_units_casual_relative.test.ts  26 / 26
  en_merging_relative_dates.test.ts        3 /  3      en_time_units_later.test.ts            38 / 38
  en_month.test.ts                        35 / 35      en_time_units_within.test.ts           48 / 48
  en_month_name_little_endian.test.ts     44 / 44      en_weekday.test.ts                     52 / 52
  en_month_name_middle_endian.test.ts     37 / 37      en_year.test.ts                         8 /  8
  en_relative.test.ts                     21 / 21      en_year_month_day.test.ts              17 / 17
  en_slash.test.ts                        32 / 32      negative_cases.test.ts                 37 / 37
```

Negative cases matter as much as positive ones. `"2019 to 2020"` is two years and
not a time range, and `"10 - 10.1"` is two version numbers. Both must keep
producing nothing.

An impossible day is treated two ways, deliberately, matching chrono. When the
day is MARKED, the whole match is rejected, because naming a specific day is a
clear claim and a wrong one should fail loudly. When it is unmarked, it is
ambiguous enough to drop:

```swift
khac.parse("ngày 0 tháng 4 năm 2000")   // [] - "ngày" marks the day
khac.parse("0 August")                  // "August", day dropped
```

Vietnamese is verified by a native speaker against chrono's own Vietnamese
source, not merely ported. Khắc deliberately diverges from chrono in five places
where chrono's Vietnamese is wrong, each marked KHAC-FIX in the source:

- `này` means this period, not next.
- `12 giờ đêm` is midnight, not noon.
- `1 giờ đêm` is 1am, not 13:00.
- `sáng mai` and its siblings resolve to tomorrow, with their own hour, and
  `tối qua` and its siblings resolve to yesterday. chrono has only the whole
  words `ngày mai` and `hôm qua`, so every bare compound answered TODAY.
- `và` lists, it does not range. `"thứ hai và thứ sáu"` is two days, not Monday
  through Friday. chrono lists it as a range connector; every other chrono locale
  shows that was a slip, since none of them accepts a bare "and" without a real
  to-word beside it.

## Known limitations

Stated plainly, because a parser that hides them is worse than one that does not
have the feature.

- **A day shift needs a time-of-day word before it.** `"7 giờ sáng mai"` resolves
  to 07:00 tomorrow, but `"8 giờ mai"` and `"15:30 mai"` answer today, because a
  bare clock is not a time-of-day word. The gate is deliberately narrow: it is
  what keeps `"chiều Mai đến"` from reading a person's name as a date.
- **Uncapitalized text can misread a name as a date.** Vietnamese `mai` is a day
  shift and `Mai` is a common given name, and only capitalization separates them.
  `"chiều Mai đến"` is handled, but `"chiều mai đến"` is genuinely ambiguous to a
  native reader too, and resolves as a date.
- **`qua` after a time of day is always read as "yesterday".** `"tối qua"` is
  last night, which is the far more common phrase, but `qua` is also the verb to
  cross or go over, and Vietnamese drops subjects freely. So `"sáng qua sông"`
  (in the morning, cross the river) reads as yesterday morning. The
  capitalization that separates `Mai` from `mai` does not help here, because
  `qua` is lowercase either way. Accepted deliberately, and asserted in the
  suite so it cannot be fixed by accident.
- **Vietnamese has no weekend concept.** `"cuối tuần này"` resolves as `"tuần
  này"`, this week, with `cuối` dropped from the match. English has a full
  weekend and weekday parser, so this is an internal asymmetry rather than a
  gap against chrono, whose Vietnamese has no weekend word either. Still open
  after Phase 2: there is nothing in chrono to port, so this needs original
  vocabulary work, and it stays on the list.
- **Always use `interval`, never build your own from `start` and `end`.**
  `"August 22 - 10, 2012"` really does resolve to a range whose end precedes its
  start, reported as written rather than silently reordered, because swapping the
  sides would assert the writer meant August 10 to 22 - a guess about a typo.
  chrono does the same, and in both libraries the range refiner repairs a
  reversal while the month-name parser does not. `interval` returns nil for
  exactly these, and that nil is the point: `DateInterval(start:end:)` TRAPS on
  end < start, a Swift hazard with no equivalent in the JavaScript original.
- **Named timezone abbreviations are not resolved.** `"2pm EST"` parses the
  time and leaves the offset nil. Numeric offsets (`-0500`, `+07:00`, `Z`) and
  the caller's reference time zone are honored. The boundary is the same in
  every locale, and the deferred oracle cases above are mostly this.
- **A malformed timestamp with month 13 can leave a stray time.**
  `"2023-13-01T10:00:00"` yields a spurious `00:00`. This behaviour is inherited
  from chrono.
- **Hold on to your `Khac` instance.** Patterns are compiled once per instance,
  on first use, and reused after that. A warm `parse` costs about 0.5 ms whether
  one locale is enabled or both. Constructing a fresh `Khac` for every call
  instead costs about 5 ms for one locale and 8.8 ms for two, because the
  compiled patterns are thrown away with the instance. Measured on an Apple M5,
  release build.

## Design

One shared engine, locales as DATA. A locale supplies vocabulary tables, pattern
words, and options. The generic parsers and refiners consume them, so no locale
literal appears in engine code and adding a language does not mean adding a
parser class. An escape hatch exists for genuinely bespoke grammar.

Other load-bearing choices:

- **Certain versus implied components.** `"August 10"` states a month and a day
  and implies a year. That distinction drives merging and overlap resolution.
- **NFC normalization in the core.** Matching runs on normalized text while
  offsets are reported in the ORIGINAL string, so decomposed input from macOS
  text fields and dictation resolves identically to composed input. This matters
  most for Vietnamese.
- **Deterministic overlap scoring.** When two matches overlap, the winner is
  chosen by a total order, so results never depend on dictionary iteration order.

## Status

Phase 1 built the core engine plus English and Vietnamese, with an adversarial
review closed and its findings fixed. Phase 2 added the remaining twelve locales
as data on that engine. Both are complete: built, measured, and their known
gaps written down above rather than discovered later.

This is a 0.x release. The API can still move before 1.0, and the limitations
section is the honest list of what a caller will hit.

## License

MIT. See `LICENSE` and `NOTICE`. Prior art and test oracle: wanasit/chrono (MIT).
