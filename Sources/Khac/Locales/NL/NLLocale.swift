// NLLocale.swift - Dutch locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Values cross-checked against wanasit/chrono v2.10.1's actual
// nl/ source (constants.ts + all 11 parsers under src/locales/nl/ - see
// NOTICE), never chrono's test code, only its behavior.
//
// One chrono construction is NOT reachable with the current engine and is
// deferred with individually-reasoned XCTExpectFailure in NLOracleTests.swift
// rather than patched around here - same root cause as German's day+period+
// month gap, a different symptom: the day token's own ordinal SUFFIX shape in
// MonthNameParser.swift is hardcoded to English "st/nd/rd/th", with no locale
// slot for Dutch "ste"/"de" ("12de juli", "31ste maart"). Reported to engine.

import Foundation

public struct NLLocale: KhacLocale {
    public let id: LocaleID = .dutch

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
            eraMarkers: Self.eraMarkers,
            fullTimeUnitNames: Self.fullTimeUnitNames,
            casualQuantifiers: Self.casualQuantifiers
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            timePrefixWords: ["om"],
            clockHourWords: ["uur"],
            relativePastWords: ["geleden", "eerder", "voor"],
            // "voor" is BOTH a past suffix (above, "15 minuten voor" = 15
            // minutes before) and a future prefix (here, "voor 5 minuten" =
            // for/wait for 5 minutes) - direction comes from POSITION, not the
            // word, and the two generic alternatives (past-suffix vs
            // future-prefix) never compete for the same span, so the word
            // safely lives in both tables. Source-confirmed: nl_time_units_ago
            // and nl_time_units_within both use "voor", in the two positions.
            // "binnen de" is the "binnen" alternative WITH the article, kept as
            // its own multi-word entry (not composed) since the alternation
            // only ever sees the whole prefix as ONE token. "voor" here too,
            // alongside "binnen"/"over"/"in" - oracle: "wait voor 5 minuten".
            relativeFutureWords: ["binnen", "binnen de", "over", "in", "voor"],
            futureSuffixWords: ["later", "vanaf nu", "uit"],
            rangeConnectorWords: ["tot"],
            nowWords: ["nu"],
            // Oracle-confirmed: "op dinsdag" / "op volgende week vrijdag" keep
            // "op" IN the matched span.
            weekdayPrefixWords: ["op"],
            // The day-token suffix glued directly to the digits, no whitespace
            // tolerance: "12de", "31ste". This is the fix for the ordinal
            // gap flagged at checkpoint 1 - engine reads it as data now,
            // the same mechanism that fixed DE's "10." period suffix.
            //
            // NOT set: monthPrefixWords / bareMonthPrefixWords. Every Dutch
            // oracle case with a leading preposition before a month date
            // EXCLUDES it from the match span ("In januari" -> matched text
            // is "januari", not "In januari"; "Op 23 MRT. 2022" -> matched
            // text is "23 MRT. 2022") - the opposite of what German's "am"
            // needs. Leaving both fields at their empty default is what
            // reproduces that, verified against the oracle rather than
            // assumed once the fields existed to check.
            dayOrdinalSuffixes: ["de", "ste"],
            // "'s avonds"/"'s ochtends" etc. attach directly to a stated hour
            // with no connector between them ("23:00 's avonds"); "in de
            // namiddag" is matched as a literal multi-word key in `meridiem`
            // below instead, the same technique DE uses for "in der nacht".
            timeOfDayConnectorWords: [],
            yearMarkerWords: ["voor christus", "na christus"],
            // "voor"/"na" (before/after) let a date-like result ("morgen")
            // glue to a following time-like one across them, mirroring EN's own
            // "before"/"after" in this same field - oracle: "morgen voor
            // 16:00", "morgen na 16:00".
            dateTimeGlueWords: ["om", "op", "voor", "na"]
        )
    }

    // Dutch: day-month numeric order (3/4 = April 3rd), week starts Monday.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2)
    }

    /// "gisterenochtend"/"morgenavond"/"vanmiddag" etc: a day anchor and a time
    /// of day GLUED into one word with no space at all - chrono's own dedicated
    /// NLCasualDateTimeParser.ts (`(gisteren|morgen|van)(ochtend|middag|
    /// namiddag|avond|nacht)`, no `\s*` between the groups at all).
    ///
    /// This did NOT need a bespoke parser: the generic CasualDateParser's own
    /// anchor+atod alternative already allows ZERO width between the anchor and
    /// the time-of-day word (`\s{0,3}`, and 0 is a valid match count), so a
    /// dayReference/relativeModifier-zero anchor immediately followed by a
    /// timeOfDay word already produces the glued reading with no engine change.
    /// "van" itself is not a real standalone day word (unlike "vandaag") - it
    /// only ever carries "this" meaning as this bound prefix, added to
    /// `relativeModifiers` as value 0 for exactly that purpose. Verified
    /// against the oracle rather than assumed.
    public var additionalParsers: [Parser] { [] }
}

// MARK: - Vocabulary data

private extension NLLocale {
    static let weekdays: [String: Int] = [
        "zondag": 0, "zon": 0, "zon.": 0, "zo": 0, "zo.": 0,
        "maandag": 1, "ma": 1, "ma.": 1,
        "dinsdag": 2, "din": 2, "din.": 2, "di": 2, "di.": 2,
        "woensdag": 3, "woe": 3, "woe.": 3, "wo": 3, "wo.": 3,
        "donderdag": 4, "dond": 4, "dond.": 4, "do": 4, "do.": 4,
        "vrijdag": 5, "vrij": 5, "vrij.": 5, "vr": 5, "vr.": 5,
        "zaterdag": 6, "zat": 6, "zat.": 6, "za": 6, "za.": 6,
    ]

    static let months: [String: Int] = [
        "januari": 1, "jan": 1, "jan.": 1,
        "februari": 2, "feb": 2, "feb.": 2,
        "maart": 3, "mar": 3, "mar.": 3, "mrt": 3, "mrt.": 3,
        "april": 4, "apr": 4, "apr.": 4,
        "mei": 5,
        "juni": 6, "jun": 6, "jun.": 6,
        "juli": 7, "jul": 7, "jul.": 7,
        "augustus": 8, "aug": 8, "aug.": 8,
        "september": 9, "sep": 9, "sep.": 9, "sept": 9, "sept.": 9,
        "oktober": 10, "okt": 10, "okt.": 10,
        "november": 11, "nov": 11, "nov.": 11,
        "december": 12, "dec": 12, "dec.": 12,
    ]

    /// Cardinals 1-12, covering spelled-out relative counts ("afgelopen twee
    /// weken").
    static let integerWords: [String: Int] = [
        "een": 1, "twee": 2, "drie": 3, "vier": 4, "vijf": 5, "zes": 6,
        "zeven": 7, "acht": 8, "negen": 9, "tien": 10, "elf": 11, "twaalf": 12,
    ]

    /// Ordinal WORDS 1st-31st, needed for a spelled-out day of month
    /// ("vierentwintigste mei", "achtste tot elfde mei 2010"). Distinct from
    /// the "12de"/"31ste" NUMERIC ordinal suffix, which is the deferred gap -
    /// see the file header and MonthNameLittleEndianCases deferrals.
    static let ordinals: [String: Int] = [
        "eerste": 1, "tweede": 2, "derde": 3, "vierde": 4, "vijfde": 5,
        "zesde": 6, "zevende": 7, "achtste": 8, "negende": 9, "tiende": 10,
        "elfde": 11, "twaalfde": 12, "dertiende": 13, "veertiende": 14,
        "vijftiende": 15, "zestiende": 16, "zeventiende": 17, "achttiende": 18,
        "negentiende": 19, "twintigste": 20,
        "eenentwintigste": 21, "tweeëntwintigste": 22, "drieentwintigste": 23,
        "vierentwintigste": 24, "vijfentwintigste": 25, "zesentwintigste": 26,
        "zevenentwintigste": 27, "achtentwintig": 28, "negenentwintig": 29,
        "dertigste": 30, "eenendertigste": 31,
    ]

    /// "u" is the single-letter clock/duration abbreviation ("2u5min" = 2h5m);
    /// "jr" the year abbreviation. "minuutje" (a diminutive, "a little minute")
    /// is real casual Dutch and chrono's own dictionary, not an invented form.
    static let timeUnits: [String: Calendar.Component] = [
        "sec": .second, "second": .second, "seconden": .second,
        "min": .minute, "mins": .minute, "minute": .minute, "minuut": .minute,
        "minuten": .minute, "minuutje": .minute,
        "h": .hour, "hr": .hour, "hrs": .hour, "uur": .hour, "u": .hour, "uren": .hour,
        "dag": .day, "dagen": .day,
        "week": .weekOfYear, "weken": .weekOfYear,
        "maand": .month, "maanden": .month,
        "jaar": .year, "jr": .year, "jaren": .year,
    ]

    /// The spelled-out time units, so strict mode can refuse shorthand -
    /// oracle-confirmed by the two `mode: .strict` cases in
    /// NlTimeUnitsLaterCases, both spelling "minuten" out in full.
    static let fullTimeUnitNames: Set<String> = [
        "second", "seconden", "minute", "minuut", "minuten", "minuutje",
        "uur", "uren", "dag", "dagen", "week", "weken", "maand", "maanden",
        "jaar", "jaren",
    ]

    /// Three word families share this table, same reasoning as DE's:
    /// WeekdayParser's prefix slot (deze/vorige/volgende, oracle: "vorige
    /// vrijdag"), RelativeUnitParser's modifier-prefix and bare-modifier slots
    /// (dit/deze/komend(e)/aankomend(e)/volgend(e)/afgelopen/vorig(e), oracle:
    /// "komende 2 weken", "deze week", "afgelopen twee weken"), and the
    /// week-postfix-INSIDE-a-prefix construction unique to Dutch: "op volgende
    /// week vrijdag" states the week word BEFORE the weekday, the reverse of
    /// German's "Freitag nächste Woche". WeekdayParser's own prefix slot
    /// already accepts a multi-word key verbatim, so "volgende week" (and its
    /// deze/vorige siblings, source-confirmed by NLWeekdayParser.ts's own
    /// `(deze|vorige|volgende)\s*(?:week\s*)?` - the week word is optional
    /// after ANY of the three, not just "volgende") is added as ITS OWN key
    /// rather than composed, exactly like DE's "in der nacht".
    ///
    /// "van" is not a real standalone day word (see additionalParsers doc) -
    /// it exists here purely so the CasualDateParser anchor+atod alternative
    /// recognizes it as a same-day anchor for the glued compounds
    /// ("vanochtend", "vanavond").
    static let relativeModifiers: [String: Int] = [
        "dit": 0, "deze": 0, "van": 0,
        "deze week": 0,
        "vorig": -1, "vorige": -1, "afgelopen": -1,
        "vorige week": -1,
        "komend": 1, "komende": 1, "aankomend": 1, "aankomende": 1,
        "volgend": 1, "volgende": 1,
        "volgende week": 1,
    ]

    /// "morgend" is chrono's own alternate spelling of "morgen" (tomorrow),
    /// source-confirmed in NLCasualDateParser.ts, not a typo.
    static let dayReferences: [String: Int] = [
        "vandaag": 0,
        "morgen": 1, "morgend": 1,
        "gisteren": -1,
    ]

    /// Flat am/pm words attaching to a STATED hour ("23:00 's avonds", "6:00
    /// 's ochtends"). "middag"/"'s middags" -> AM is chrono's own noon quirk,
    /// the same internal-math oddity as EN's "noon" and DE's "mittag(s)".
    /// "in de namiddag" is a full multi-word key (matched literally, single
    /// spaces, same technique as DE's "in der nacht") rather than a connector -
    /// simpler, since Dutch has no equivalent to DE's decorative bare "Uhr"
    /// needing a separate connector slot.
    ///
    /// "'s avonds'" is source EXCLUDED on purpose: chrono's own
    /// NLCasualTimeParser.ts switch has a typo (`case "'s avonds'":` with a
    /// stray trailing quote) that can never match its own regex capture
    /// (`'s avonds`, no trailing quote) - dead code in chrono itself, and no
    /// oracle case exercises the phrase standalone (only "vanavond" is), so
    /// there is nothing to reproduce here. The correct value (PM) is what
    /// "'s avonds" gets below regardless, since Khac does not carry chrono's
    /// bug forward into working code.
    static let meridiem: [String: Meridiem] = [
        "'s ochtends": .am,
        "'s middags": .am,
        "'s namiddags": .pm,
        "'s avonds": .pm,
        "in de namiddag": .pm,
    ]

    /// Bare casual nominal words, standalone ("middag") or anchored ("deze
    /// ochtend", and glued via CasualDateParser's zero-width anchor+atod for
    /// "vanochtend" etc - see additionalParsers doc). Source:
    /// NLCasualTimeParser.ts / NLCasualDateTimeParser.ts's own switches, both
    /// agree on the same five hours.
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "ochtend": (6, .am),
        "middag": (12, .am),
        "namiddag": (15, .pm),
        "avond": (20, .pm),
        "middernacht": (0, .am),
    ]

    /// "voor Christus"/"na Christus" are the FULL phrase forms, matched
    /// verbatim (multi-word keys, single spaces) - chrono's own YEAR_PATTERN
    /// has no abbreviated form for Dutch, unlike DE's alphabet-soup of era
    /// abbreviations.
    static let eraMarkers: [String: Int] = [
        "voor christus": -1,
        "na christus": 1,
    ]

    /// Vague counts, source-verified against chrono's own parseNumberPattern:
    /// "paar" (a couple/a few) is 2, "half"/"halve" is 0.5.
    static let casualQuantifiers: [String: Double] = [
        "half": 0.5, "halve": 0.5,
        "paar": 2,
    ]
}
