// ENLocale.swift - English locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. No parsing logic lives here - the 8 generic parsers in
// Sources/Khac/Parsers/ consume this data; ENLocale only fills the tables.
//
// Values that are not obvious from general English knowledge were checked
// against wanasit/chrono's own EN test oracle (Tests/KhacTests/Oracle/EN/,
// ported from chrono's test/en/*.test.ts - see NOTICE) AND, after review-code
// found a case the oracle alone couldn't catch (bare "night" - the oracle only
// ever exercises it inside the compound "last night", never alone), directly
// against chrono's production source (src/common/casualReferences.ts,
// src/locales/en/parsers/ENCasualTimeParser.ts, src/locales/en/constants.ts).
// Oracle silence is not verification - see the comment on `timeOfDay` below.

import Foundation

public struct ENLocale: KhacLocale {
    public let id: LocaleID = .english

    public init() {}

    public var vocabulary: Vocabulary {
        Vocabulary(
            weekdays: Self.weekdays,
            months: Self.months,
            integerWords: Self.integerWords,
            ordinals: Self.ordinals,
            timeUnits: Self.timeUnits,
            relativeModifiers: Self.relativeModifiers,
            dayReferences: Self.dayReferences,
            meridiem: Self.meridiem,
            timeOfDay: Self.timeOfDay,
            meridiemHourRules: Self.meridiemHourRules,
            eraMarkers: Self.eraMarkers,
            eraOffsets: Self.eraOffsets,
            fullMonthNames: Self.fullMonthNames,
            fullTimeUnitNames: Self.fullTimeUnitNames,
            casualQuantifiers: Self.casualQuantifiers
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            timePrefixWords: ["at", "@"],
            dateConnectorWords: ["of"],
            // "h" is deliberately NOT here. In chrono's constants.ts it is only
            // ever a duration abbreviation, never a clock-hour marker. Listing it
            // made "1h ago" parse as the clock time 01:00 with hour AND minute
            // certain, which then beat the correct, longer "1h ago" duration
            // match, because certain-count outranks match length in the H0 order.
            clockHourWords: ["o'clock", "oclock", "o clock"],
            clockMinuteWords: ["min", "mins", "minute", "minutes"],
            clockSecondWords: ["sec", "secs", "second", "seconds"],
            // "earlier" means PAST despite living in chrono's "later" test file:
            // "15 minutes earlier" is -15 minutes, confirmed by the arithmetic in
            // both the ago and later oracle files.
            relativePastWords: ["ago", "before", "earlier"],
            relativeFutureWords: ["in", "within", "for"],
            futureSuffixWords: ["later", "from now", "after", "out"],
            rangeConnectorWords: ["to", "until", "till", "through"],
            nowWords: ["now"],
            weekdayPrefixWords: ["on"],
            // Both of these were spelled out inside MonthNameParser until the
            // Phase 2 locales needed their own: "on" led a month-name date, and
            // st/nd/rd/th tailed a day's digits. Russian wants "в"/"с" and
            // "го"/"ого", German a bare "." Stating English here changes nothing
            // about English and stops the parser asserting it for everyone.
            monthPrefixWords: ["on"],
            dayOrdinalSuffixes: ["st", "nd", "rd", "th"],
            timeOfDayConnectorWords: ["at", "in the"],
            durationFillerWords: ["around", "about", "~"],
            durationConnectorWords: ["and"],
            // chrono's ENMergeDateTimeRefiner glue set, minus the punctuation the
            // merge handles structurally: ^\s*(T|at|after|before|on|of|,|-|.|∙|:)?\s*$.
            // "at" is also a timePrefixWord; listing it twice is harmless.
            dateTimeGlueWords: ["at", "after", "before", "on", "of", "t"]
        )
    }

    // English: month-day numeric order (3/4 = March 4th), week starts Sunday.
    // weekStart uses Foundation's convention (1 = Sunday ... 7 = Saturday), per
    // LocaleOptions' own doc comment - a DIFFERENT convention from `weekdays`
    // below, which uses chrono/JS numbering (Sunday=0...Saturday=6), per
    // engine's correction (Locale.swift's own doc comment - Monday=1...Sunday=7 -
    // was wrong and would have failed the oracle; do not "fix" weekdays back to
    // that documented-but-incorrect convention without re-checking with engine).
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .monthDay, weekStart: 1)
    }

    /// Bespoke grammar the data tables cannot express - see ENParsers.swift.
    public var additionalParsers: [Parser] {
        [ENWeekendParser(), ENCasualCompoundParser()]
    }

    /// English-lexical filtering ("may" the modal verb, "the second" the
    /// ordinal) - see ENRefiners.swift. Runs after every merge, chrono's slot
    /// for ENUnlikelyFormatFilter.
    public var additionalRefiners: [Refiner] {
        [ENUnlikelyFormatFilter()]
    }
}

// MARK: - Vocabulary data

private extension ENLocale {
    // Dotted forms ("mon.", "jan.") added to match chrono's constants.ts
    // WEEKDAY_DICTIONARY/MONTH_DICTIONARY exactly, found during the source audit
    // review-code prompted. "tues"/"weds" are our own harmless extra synonyms
    // beyond chrono - not in its dictionary, low collision risk.
    static let weekdays: [String: Int] = [
        "sunday": 0, "sun": 0, "sun.": 0,
        "monday": 1, "mon": 1, "mon.": 1,
        "tuesday": 2, "tue": 2, "tue.": 2, "tues": 2,
        "wednesday": 3, "wed": 3, "wed.": 3, "weds": 3,
        "thursday": 4, "thu": 4, "thu.": 4, "thur": 4, "thur.": 4, "thurs": 4, "thurs.": 4,
        "friday": 5, "fri": 5, "fri.": 5,
        "saturday": 6, "sat": 6, "sat.": 6,
    ]

    static let months: [String: Int] = [
        "january": 1, "jan": 1, "jan.": 1,
        "february": 2, "feb": 2, "feb.": 2,
        "march": 3, "mar": 3, "mar.": 3,
        "april": 4, "apr": 4, "apr.": 4,
        "may": 5,
        "june": 6, "jun": 6, "jun.": 6,
        "july": 7, "jul": 7, "jul.": 7,
        "august": 8, "aug": 8, "aug.": 8,
        "september": 9, "sep": 9, "sep.": 9, "sept": 9, "sept.": 9,
        "october": 10, "oct": 10, "oct.": 10,
        "november": 11, "nov": 11, "nov.": 11,
        "december": 12, "dec": 12, "dec.": 12,
    ]

    /// Cardinals 1-30, plus round numbers, covering spelled-out day-of-month
    /// ("May twenty-fourth" - the "twenty" half of a compound; see `ordinals`
    /// for the whole compound word) and spelled-out relative counts ("five
    /// days ago"). Both forms verified present in the oracle.
    static let integerWords: [String: Int] = [
        "one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7,
        "eight": 8, "nine": 9, "ten": 10, "eleven": 11, "twelve": 12, "thirteen": 13,
        "fourteen": 14, "fifteen": 15, "sixteen": 16, "seventeen": 17, "eighteen": 18,
        "nineteen": 19, "twenty": 20, "twenty-one": 21, "twenty-two": 22, "twenty-three": 23,
        "twenty-four": 24, "twenty-five": 25, "twenty-six": 26, "twenty-seven": 27,
        "twenty-eight": 28, "twenty-nine": 29, "thirty": 30, "thirty-one": 31,
        "forty": 40, "fifty": 50, "sixty": 60, "hundred": 100,
    ]

    /// Ordinal words 1st-31st, the full range a day-of-month can take.
    /// "twenty-fourth" etc. verified present in the oracle (en_month_name_*).
    /// Space-separated compound forms ("twenty first", no hyphen) added to match
    /// chrono's ORDINAL_WORD_DICTIONARY, which keys both spellings separately -
    /// found during the source audit review-code prompted.
    static let ordinals: [String: Int] = [
        "first": 1, "second": 2, "third": 3, "fourth": 4, "fifth": 5, "sixth": 6,
        "seventh": 7, "eighth": 8, "ninth": 9, "tenth": 10, "eleventh": 11, "twelfth": 12,
        "thirteenth": 13, "fourteenth": 14, "fifteenth": 15, "sixteenth": 16,
        "seventeenth": 17, "eighteenth": 18, "nineteenth": 19, "twentieth": 20,
        "twenty-first": 21, "twenty first": 21,
        "twenty-second": 22, "twenty second": 22,
        "twenty-third": 23, "twenty third": 23,
        "twenty-fourth": 24, "twenty fourth": 24,
        "twenty-fifth": 25, "twenty fifth": 25,
        "twenty-sixth": 26, "twenty sixth": 26,
        "twenty-seventh": 27, "twenty seventh": 27,
        "twenty-eighth": 28, "twenty eighth": 28,
        "twenty-ninth": 29, "twenty ninth": 29,
        "thirtieth": 30,
        "thirty-first": 31, "thirty first": 31,
    ]

    /// "quarter"/"quarters" added to match chrono's TIME_UNIT_DICTIONARY - found
    /// during the source audit review-code prompted. Foundation's
    /// Calendar.Component has a native .quarter case, confirmed compiling.
    /// Single-letter and short forms are chrono's own TIME_UNIT_DICTIONARY
    /// ("3w later", "-3y", "+1m", "in 1 mon"). Note "m" is MINUTE and "mo"/"mon"
    /// are month - the longest-first alternation keeps them apart. "h" is a
    /// duration abbreviation here and, per chrono, is NOT a clock-hour marker;
    /// see the note on `clockHourWords`.
    static let timeUnits: [String: Calendar.Component] = [
        "second": .second, "seconds": .second, "sec": .second, "secs": .second, "s": .second,
        "minute": .minute, "minutes": .minute, "min": .minute, "mins": .minute, "m": .minute,
        "hour": .hour, "hours": .hour, "hr": .hour, "hrs": .hour, "h": .hour,
        "day": .day, "days": .day, "d": .day,
        "week": .weekOfYear, "weeks": .weekOfYear, "w": .weekOfYear,
        "month": .month, "months": .month, "mo": .month, "mon": .month, "mos": .month,
        "quarter": .quarter, "quarters": .quarter, "qtr": .quarter,
        "year": .year, "years": .year, "yr": .year, "yrs": .year, "y": .year,
    ]

    /// Vague counts, all confirmed against chrono's own parseNumberPattern
    /// constants rather than inferred from case arithmetic: an article is 1,
    /// a couple is 2, a few is 3, several is 7, half is 0.5.
    ///
    /// Multi-word keys are listed outright rather than composed, since the
    /// alternation is built longest-first and picks "a couple of" over "a".
    /// "half an hour" is the only fraction any oracle case exercises; it becomes
    /// 30 minutes through the cascade in RelativeDuration.
    ///
    /// "the" counts as one, as chrono's own NUMBER_PATTERN has it: "the min
    /// before" is one minute back and "the day after tomorrow" anchors a one-day
    /// shift. It is safe here ONLY because a duration never stands alone - every
    /// consuming branch demands a direction marker or prefix, so "the year
    /// ended Dec. 2021" (no marker) never parses - and because the one
    /// remaining false positive, "in THE SECOND half of 2025", is culled by
    /// ENUnlikelyFormatFilter exactly as chrono culls it.
    static let casualQuantifiers: [String: Double] = [
        "a": 1, "an": 1, "the": 1,
        "half": 0.5, "half a": 0.5, "half an": 0.5,
        "a couple of": 2, "a couple": 2, "couple of": 2, "couple": 2,
        "a few": 3, "few": 3,
        "several": 7,
    ]

    /// The spelled-out time units, so strict mode can refuse shorthand. Every
    /// strict oracle negative in this family is an abbreviation - "5m ago",
    /// "5 h ago", "15s later", "in 15m", "5hr before" - and every strict
    /// positive spells the unit out.
    static let fullTimeUnitNames: Set<String> = [
        "second", "seconds", "minute", "minutes", "hour", "hours",
        "day", "days", "week", "weeks", "month", "months",
        "quarter", "quarters", "year", "years",
    ]

    /// Source: ENWeekdayParser.ts's own modifier resolution recognizes exactly
    /// four words - "this"/"last"/"past"/"next" (`modifierWord == "last" ||
    /// modifierWord == "past"` collapse to one modifier; "next" and "this" are
    /// their own branches). "past" as a "last" synonym is therefore
    /// SOURCE-CONFIRMED (also independently oracle-confirmed: "past Friday" ==
    /// "last Friday" in en_weekday.test.ts). "coming" (as a "next" synonym) and
    /// "previous" (as a "last" synonym) are NOT in chrono's source at all -
    /// KHAC'S OWN EXTENSION, safe unambiguous standard English, not oracle- or
    /// source-backed.
    /// "after this" is source-confirmed: chrono's ENRelativeDateFormatParser
    /// pattern is `(this|last|past|next|after\s*this)` and routes anything
    /// starting with "after" through the SAME branch as "next", so "after this
    /// year" is next year, NOT this year anchored to its start. Listed as its own
    /// key so the longest-match ordering picks it over bare "this".
    /// Bare "after" is +1 per ENTimeUnitCasualRelativeFormatParser's prefix set
    /// `(this|last|past|next|after|\+|-)`: "after a year" is one year out. In
    /// chrono that reading exists only for counted durations; sharing the table
    /// lets it reach the weekday parser too ("after Monday" as the coming
    /// Monday) - KHAC'S OWN harmless superset, same class as "coming".
    static let relativeModifiers: [String: Int] = [
        "next": 1, "coming": 1, "after this": 1, "after": 1,
        "last": -1, "past": -1, "previous": -1,
        "this": 0,
    ]

    /// "tmr"/"tmrw" and "overmorrow" added to match chrono's ENCasualDateParser.ts
    /// PATTERN - found during the systematic source audit, zero oracle cases
    /// exercise any of the three, so their absence was invisible to oracle testing.
    /// Source: `case "tomorrow": case "tmr": case "tmrw": component =
    /// references.tomorrow(...)` (all three are literal synonyms, +1 day) and
    /// `case "overmorrow": component = references.theDayAfter(reference, 2)`
    /// (+2 days, the day after tomorrow). "now"/"tonight"/"last night" are also
    /// in that same chrono PATTERN but already have a home elsewhere in Khac:
    /// "now" -> PatternSet.nowWords, "tonight" -> Vocabulary.timeOfDay (hour 22,
    /// oracle- and source-confirmed), "last night" -> no Vocabulary home, flagged
    /// to engine separately (same class of gap as weekend/weekday).
    static let dayReferences: [String: Int] = [
        "today": 0,
        "tomorrow": 1, "tmr": 1, "tmrw": 1,
        "yesterday": -1,
        "overmorrow": 2,
    ]

    /// Source: AbstractTimeExpressionParser.ts inlines AM/PM directly into its
    /// own time regex rather than a lookup dictionary -
    /// `(a\.m\.|p\.m\.|am?|pm?)` (case-insensitive). That literal alternation
    /// matches: "a.m.", "p.m." (both dots, both required), "am"/"a" (no dots),
    /// "pm"/"p" (no dots). It never matches a single-dot form ("a.m", "p.m").
    /// Verified against the EN oracle corpus (grep across all 563 inputs):
    /// bare "am"/"AM"/"pm"/"PM" and dotted "p.m." (both dots) appear as real
    /// inputs ("24 October, 9 p.m."); no case exercises a single-dot form or a
    /// bare single-letter "a"/"p".
    /// - "a.m"/"p.m" (single dot) below are therefore KHAC'S OWN EXTENSION, not
    ///   chrono-sourced and not oracle-exercised - harmless superset, kept for
    ///   robustness (chrono itself would never produce these forms as output,
    ///   so accepting them as input costs nothing chrono users depend on).
    /// - bare "a"/"p": chrono DOES accept these (via `am?`/`pm?`), but no oracle
    ///   case exercises them and they are NOT added here - reported to engine as
    ///   an open coordination question (whether TimeExpressionParser applies the
    ///   same `(?=\W|$)` word-boundary guard chrono's own pattern relies on
    ///   before consuming a bare single-letter meridiem word), not decided
    ///   unilaterally in Vocabulary.
    static let meridiem: [String: Meridiem] = [
        "am": .am, "a.m": .am, "a.m.": .am,
        "pm": .pm, "p.m": .pm, "p.m.": .pm,
    ]

    /// Hours cross-checked against BOTH the EN oracle and chrono's actual source
    /// (src/common/casualReferences.ts + ENCasualTimeParser.ts's switch statement) -
    /// do not adjust without re-checking both, and see the "night" note below for
    /// why the oracle alone is not sufficient.
    ///
    /// - morning=6/.am, afternoon=15/.pm, evening=20/.pm, midnight=0/nil, tonight=22/.pm:
    ///   each is directly oracle-tested standalone (not only inside a compound
    ///   modifier phrase) and matches casualReferences.ts exactly.
    /// - night=20/.pm: NOT 0. review-code caught this - the oracle only ever tests
    ///   "night" inside the compound "last night" (hour 0), never bare, so the
    ///   compound's value was wrongly generalized to the bare word. Chrono's
    ///   ENCasualTimeParser.ts literally routes `case "night":` to the SAME
    ///   function as `case "evening":` (casualReferences.evening(), hour 20). The
    ///   "last night" -> hour 0 result comes from a wholly separate mechanism (an
    ///   ENCasualDateParser compound literal with a reference-hour-dependent day
    ///   rollback: rolls back a day only when the reference's OWN clock hour > 6),
    ///   not from composing relativeModifiers["last"] with this table. That
    ///   compound has no home in Vocabulary's word->value dictionaries (same class
    ///   of gap as "weekend"/"weekday" - flagged to engine, not modeled here).
    /// - noon=12/.am, midday=12/.am: NOT nil. Also confirmed via source - chrono's
    ///   noon() implies Meridiem.AM (an internal quirk of its 12-hour math, not a
    ///   linguistic fact about noon), and ENCasualTimeParser routes "midday" to
    ///   the identical noon() function.
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "morning": (6, .am),
        "noon": (12, .am),
        "midday": (12, .am),
        "afternoon": (15, .pm),
        "evening": (20, .pm),
        "night": (20, .pm),
        "tonight": (22, .pm),
        "midnight": (0, nil),
    ]

    /// The twelve full month names, so a bare ABBREVIATION can be rejected as a
    /// date on its own. "may" is here and survives standing alone; "mar", "jan"
    /// and the rest are abbreviations and do not. Source: chrono's
    /// FULL_MONTH_NAME_DICTIONARY, used by the same length-based guard.
    static let fullMonthNames: Set<String> = [
        "january", "february", "march", "april", "may", "june",
        "july", "august", "september", "october", "november", "december",
    ]

    /// "night" attached to a STATED hour is a threshold rule, not a flat pm.
    /// Source: ENTimeExpressionParser.ts - an hour in [6,12) gains 12 and reads
    /// pm, an hour below 6 keeps its value and reads am. So "11 at night" is
    /// 23:00 but "1 at night" stays 1:00, which a flat pm would turn into 13:00.
    ///
    /// "night" stays in the flat `timeOfDay` table as well, for the BARE word
    /// with no hour attached ("tonight", "at night" alone). The two tables are
    /// read by different parsers and do not conflict: TimeExpressionParser checks
    /// these rules first, and CasualDateParser only ever reads `timeOfDay`. VI's
    /// "trưa"/"đêm" already use this same dual registration.
    static let meridiemHourRules: [String: MeridiemHourRule] = [
        "night": MeridiemHourRule(baseline: .am, overrides: [6: 18, 7: 19, 8: 20, 9: 21, 10: 22, 11: 23]),
    ]

    /// Both dotted and undotted forms kept even though the oracle only exercises
    /// undotted "AD"/"BC"/"BCE"/"CE" - dotted forms are standard English and safe
    /// to accept in addition.
    static let eraMarkers: [String: Int] = [
        "ad": 1, "a.d.": 1, "ce": 1,
        "bc": -1, "b.c.": -1, "bce": -1,
    ]

    /// Buddhist era: a plain -543 offset, chrono's parseYear rule ("2555 BE" is
    /// 2012 CE). An offset cannot live in the sign-based eraMarkers table.
    static let eraOffsets: [String: Int] = [
        "be": -543, "b.e.": -543,
    ]
}
