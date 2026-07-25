// DELocale.swift - German locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Values cross-checked against wanasit/chrono v2.10.1's actual
// de/ source (constants.ts + all 8 parsers + both refiners under
// src/locales/de/ - see NOTICE), never chrono's test code, only its behavior.
//
// Two chrono constructions are NOT reachable with the current engine and are
// deferred with individually-reasoned XCTExpectFailure in DEOracleTests.swift
// rather than patched around here - reported to engine at checkpoint 1:
//   - "10. August 2012" / "15.Sep" (day + literal period + month): the day-month
//     separator in MonthNameParser.swift is hardcoded to hyphen/slash/"of", with
//     no locale slot for a period glued directly to the day digits.
//   - "30 vorangegangenen Tagen" (NUMBER-MODIFIER-UNIT): RelativeUnitParser's six
//     alternatives cover modifier-before-duration but not a modifier landing
//     between the number and the unit word.

import Foundation

public struct DELocale: KhacLocale {
    public let id: LocaleID = .german

    public init() {}

    public var vocabulary: Vocabulary {
        Vocabulary(
            weekdays: Self.weekdays,
            months: Self.months,
            integerWords: Self.integerWords,
            timeUnits: Self.timeUnits,
            relativeModifiers: Self.relativeModifiers,
            dayReferences: Self.dayReferences,
            meridiem: Self.meridiem,
            timeOfDay: Self.timeOfDay,
            meridiemHourRules: Self.meridiemHourRules,
            eraMarkers: Self.eraMarkers,
            eraOffsets: Self.eraOffsets,
            casualQuantifiers: Self.casualQuantifiers
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            timePrefixWords: ["um", "von"],
            // "h" is a genuine clock-hour marker in German ("um 16h" = 16:00,
            // "6h30" = 6:30 - DESpecificTimeExpressionParser.ts), unlike English
            // where "h" is ONLY ever a duration abbreviation (see ENLocale's own
            // comment on the same word). German overloads "h" for both roles too
            // (TIME_UNIT_DICTIONARY has "h": "hour"), but no DE oracle case pairs
            // a bare "Nh" duration against a clashing clock reading, so there is
            // nothing here forcing the same exclusion EN needed.
            clockHourWords: ["uhr", "h"],
            relativePastWords: ["vor"],
            // "für"/"während" (for/during) are chrono's DETimeUnitWithinFormatParser
            // prefix set alongside "in" - the same unification EN's own "for"
            // already performs for its within-duration cases.
            relativeFutureWords: ["in", "für", "während"],
            rangeConnectorWords: ["bis"],
            nowWords: ["jetzt"],
            // Oracle-confirmed: "am Donnerstag" keeps "am" IN the matched span.
            // Chrono's own DEWeekdayParser accepts "an" too (`a[mn]`), not
            // exercised by any ported case but harmless to admit alongside "am".
            weekdayPrefixWords: ["am", "an"],
            // Preposition leading a FULL month-name date (day AND month):
            // oracle-confirmed, "Die Deadline ist am 10. August" keeps "am" IN
            // the span. Deliberately not shared with weekdayPrefixWords or a
            // bare-month field - see PatternSet's own doc on monthPrefixWords
            // for why English needed the split (a shared field let "on" claim
            // "on Sept 2" as "on Sept").
            monthPrefixWords: ["am"],
            // The day-token suffix glued directly to the digits, no whitespace
            // tolerance: "10." in "10. August", "15." in "15.Sep". This is
            // THE fix for the day+period+month construction flagged at
            // checkpoint 1 - engine now reads it as data instead of hardcoding
            // English's "of".
            dayOrdinalSuffixes: ["."],
            // "uhr" as a CONNECTOR (distinct from its clockHourWords role, just
            // below the field that reads it): a colon-separated time already
            // has its minute stated ("11:00"), so "Uhr" cannot attach via the
            // clockBody hour+minute slot - there's no hour left to fill. It
            // shows up instead as a bare decorative word between the stated
            // time and a trailing meridiem ("11:00 Uhr vormittags"). Checked
            // this could NOT break the sibling shape before adding it: "8 Uhr
            // abends" is unaffected, because there "Uhr" is consumed by the
            // clockHourWords hw-slot first (no colon present), so the
            // connector position is never even reached for that input - the
            // two shapes only ever compete for the same word when a colon
            // time already claimed "Uhr" as decoration rather than as an hour
            // marker. Traced by hand rather than assumed; this field was
            // nearly reported as an engine gap before the trace turned up an
            // existing hook that already covered it.
            timeOfDayConnectorWords: ["uhr"],
            // Marks a following bare day number: "den 10. Januar". Optional -
            // "Di, 10. Januar" has no marker at all and still matches.
            dayMarkerWords: ["den"],
            // DEMergeDateTimeRefiner.ts's own glue set, beyond the whitespace/
            // punctuation the merge already treats as free: "um" is also a
            // timePrefixWord (listed here too is harmless), "am" is the weekday
            // prefix and needs a home here as well so a weekday result can still
            // glue to a following time across it.
            dateTimeGlueWords: ["um", "am"]
        )
    }

    // German: day-month numeric order (3/4 = April 3rd), week starts Monday
    // (ISO 8601 / German convention, matching VI's own weekStart=2).
    //
    // dotIsUnambiguousDateSeparator: true - German's decimal mark is a comma
    // (6,5 kilograms), not a period, so a dotted triple like "30.12.16" can
    // never collide with a decimal or version number the way "1.1.3" would in
    // English. This is the fix for the "30.12.16"/"Freitag 30.12.16" gap
    // flagged at checkpoint 1 (the engine's 4-digit-year guard, now opt-out
    // per locale rather than universal).
    //
    // monthNameForms: .dayFirst - chrono's own DE parser list
    // (src/locales/de/index.ts) registers exactly one month-name parser,
    // DEMonthNameLittleEndianParser, day-first only. No bare month+year
    // fallback exists in chrono for German, which is exactly what let "32.
    // Oktober 2015" (an invalid day) surface the bare month "Oktober 2015"
    // instead of the noMatch chrono itself produces - flagged at checkpoint 1,
    // fixed now that the option exists to say a locale simply lacks the form.
    public var options: LocaleOptions {
        LocaleOptions(
            dateOrder: .dayMonth, weekStart: 2,
            dotIsUnambiguousDateSeparator: true,
            monthNameForms: .dayFirst
        )
    }

    /// "letzte Nacht" (last night): hour 0, rolled back a day only when the
    /// reference's own clock is past 6 AM - source-verified against
    /// DECasualDateParser.ts's own inline rule, `targetDate.getHours() > 6`,
    /// the SAME threshold and SAME idiom as EN's own ENCasualCompoundParser.
    /// Mirrors that parser exactly - flagged to engine at checkpoint 1 before
    /// building, per protocol, not because the mechanism itself needed a
    /// decision.
    public var additionalParsers: [Parser] {
        [DECasualCompoundParser()]
    }
}

// MARK: - Vocabulary data

private extension DELocale {
    static let weekdays: [String: Int] = [
        "sonntag": 0, "so": 0,
        "montag": 1, "mo": 1,
        "dienstag": 2, "di": 2,
        "mittwoch": 3, "mi": 3,
        "donnerstag": 4, "do": 4,
        "freitag": 5, "fr": 5,
        "samstag": 6, "sa": 6,
    ]

    /// Includes the Austrian variants chrono itself carries: "jänner"/"janner"
    /// (January) and "feber" (February) - both real, current Austrian German,
    /// not typos.
    static let months: [String: Int] = [
        "januar": 1, "jänner": 1, "janner": 1, "jan": 1, "jan.": 1,
        "februar": 2, "feber": 2, "feb": 2, "feb.": 2,
        "märz": 3, "maerz": 3, "mär": 3, "mär.": 3, "mrz": 3, "mrz.": 3,
        "april": 4, "apr": 4, "apr.": 4,
        "mai": 5,
        "juni": 6, "jun": 6, "jun.": 6,
        "juli": 7, "jul": 7, "jul.": 7,
        "august": 8, "aug": 8, "aug.": 8,
        "september": 9, "sep": 9, "sep.": 9, "sept": 9, "sept.": 9,
        "oktober": 10, "okt": 10, "okt.": 10,
        "november": 11, "nov": 11, "nov.": 11,
        "dezember": 12, "dez": 12, "dez.": 12,
    ]

    /// Cardinals 1-12, covering spelled-out relative counts ("in drei Wochen").
    /// "fünf"/"fuenf" and "zwölf"/"zwoelf" are the same word with and without
    /// the umlaut, both current spellings (the second common wherever umlauts
    /// are awkward to type) - both source-confirmed in chrono's
    /// INTEGER_WORD_DICTIONARY, not a Khac invention.
    static let integerWords: [String: Int] = [
        "eins": 1, "eine": 1, "einem": 1, "einen": 1, "einer": 1,
        "zwei": 2, "drei": 3, "vier": 4, "fünf": 5, "fuenf": 5,
        "sechs": 6, "sieben": 7, "acht": 8, "neun": 9, "zehn": 10,
        "elf": 11, "zwölf": 12, "zwoelf": 12,
    ]

    /// "a"/"j"/"jr" are Latin/German single-letter year abbreviations chrono
    /// itself lists; kept even though no oracle case exercises them bare,
    /// exactly as EN kept its own single-letter set. "monats" (genitive) is
    /// real German ("Anfang des Monats") and is in chrono's own dictionary
    /// alongside monat/monate/monaten.
    static let timeUnits: [String: Calendar.Component] = [
        "sek": .second, "sekunde": .second, "sekunden": .second,
        "min": .minute, "minute": .minute, "minuten": .minute,
        "h": .hour, "std": .hour, "stunde": .hour, "stunden": .hour,
        "tag": .day, "tage": .day, "tagen": .day,
        "woche": .weekOfYear, "wochen": .weekOfYear,
        "monat": .month, "monate": .month, "monaten": .month, "monats": .month,
        "quartal": .quarter, "quartals": .quarter, "quartale": .quarter, "quartalen": .quarter,
        "a": .year, "j": .year, "jr": .year,
        "jahr": .year, "jahre": .year, "jahren": .year, "jahres": .year,
    ]

    /// Two independent word families share this one table, because Khac's
    /// generic parsers all read the same `relativeModifiers` dictionary:
    ///
    /// - WeekdayParser's prefix/postfix slot ("letzten Freitag", "am Freitag
    ///   nächste Woche"). Chrono's own DEWeekdayParser.ts regex requires the
    ///   dative/accusative suffix here - `diese[mn]|letzte[mn]|n(ä|ae)chste[mn]`
    ///   - so bare "diese"/"letzte"/"nächste" are NOT valid weekday modifiers on
    ///   their own; only the -m/-n forms are.
    /// - RelativeUnitParser's modifier-prefix and bare-modifier slots ("letzte
    ///   acht Minuten", "kommende Woche", "vorangegangenen Tagen"). Chrono's own
    ///   DETimeUnitAgoFormatParser.ts regex allows the SAME stems with an
    ///   OPTIONAL suffix (any one of s/n/m/r, or none), and adds four stems the
    ///   weekday parser does not know: kommende (coming), folgende (following),
    ///   vergangene (past), vorige (previous), vor(her|an)gegangene (preceding).
    ///
    /// Every entry below is either DIRECTLY oracle-tested (see the case's own
    /// input text) or a same-stem declension chrono's regex also accepts; none
    /// is invented. "diese"/"dieses"/"dieser" bare are deliberately absent -
    /// chrono's weekday regex never accepts them suffixless, and no other
    /// parser's source lists "diese" at all.
    static let relativeModifiers: [String: Int] = [
        // this (weekday only, oracle: none directly, but "diesen"/"diesem" is
        // the only pair chrono's own regex admits)
        "diesem": 0, "diesen": 0,
        // last / past / preceding, across both word families
        "letzten": -1, "letztem": -1,                         // weekday, oracle: "letzten Freitag"
        "letzte": -1, "letztes": -1, "letzter": -1,           // relative-unit, oracle: "letztes Quartal", "die letzten acht Minuten"
        "vergangene": -1, "vergangenen": -1, "vergangenes": -1, // oracle: "die vergangenen 24 Stunden"
        "vorige": -1, "vorigen": -1,                           // chrono source, not oracle-tested
        "vorangegangene": -1, "vorangegangenen": -1,           // oracle: "30 vorangegangenen Tagen" (deferred, see engine note)
        "vorhergegangene": -1, "vorhergegangenen": -1,         // chrono's other spelling of the same stem
        // next / coming / following, across both word families
        "nächsten": 1, "nächstem": 1,                          // weekday, oracle: "am Freitag nächste Woche" (post form, see below)
        "naechsten": 1, "naechstem": 1,                        // ae-spelling twin
        "nächste": 1, "nächstes": 1, "nächster": 1,            // relative-unit, oracle: none direct but same stem
        "naechste": 1, "naechstes": 1, "naechster": 1,
        "kommende": 1, "kommenden": 1, "kommendes": 1,         // oracle: "kommende Woche", "kommendes Jahr"
        "folgende": 1, "folgenden": 1, "folgendes": 1,         // oracle: "die folgenden 90 sekunden"
    ]

    /// "jetzt" lives in patterns.nowWords, not here - see VI's own precedent for
    /// why "now" gets its own field (different certainty semantics than a day
    /// reference). "übermorgen"/"uebermorgen" are the same word with and without
    /// the umlaut; both are current spellings and both are chrono-confirmed.
    static let dayReferences: [String: Int] = [
        "heute": 0,
        "morgen": 1,
        "übermorgen": 2, "uebermorgen": 2,
        "gestern": -1,
        "vorgestern": -2,
    ]

    /// Flat am/pm words that attach to a STATED hour ("8 Uhr abends", "um 7
    /// morgens", "11 am Abend"). Source: DESpecificTimeExpressionParser.ts's
    /// AM_PM_HOUR_GROUP pattern - `morgens|vormittags|nachmittags|abends|nachts|
    /// am\s+(?:Morgen|Vormittag|Nachmittag|Abend)|in\s+der\s+Nacht`. "nachts"/"in
    /// der nacht" are excluded here and live in meridiemHourRules instead - they
    /// are hour-DEPENDENT (see below), unlike the other four which chrono always
    /// reads as a flat am/pm regardless of the stated hour.
    ///
    /// These are DISTINCT from the bare casual nominal forms in `timeOfDay`
    /// below ("morgen", "abend" with no -s and no stated hour) - German marks
    /// the adverbial/attached form with -s or an "am " prefix, and chrono's own
    /// two parsers (DECasualTimeParser vs DESpecificTimeExpressionParser) never
    /// share a word between these two tables.
    static let meridiem: [String: Meridiem] = [
        "morgens": .am, "am morgen": .am,
        "vormittags": .am, "am vormittag": .am,
        "nachmittags": .pm, "am nachmittag": .pm,
        "abends": .pm, "am abend": .pm,
    ]

    /// Bare casual nominal words used standalone ("heute Abend", "gestern
    /// Nachmittag") or after a day anchor, all via CasualDateParser. Source:
    /// DECasualTimeParser.ts's own switch. "mittag"/"mittags" both map to noon
    /// with meridiem .am - chrono's own quirk (mirrors EN's identical "noon"=
    /// (12,.am) oddity, confirmed by the same kind of internal 12-hour math, not
    /// a linguistic claim about midday). "mitternacht" is (0, .am); the engine's
    /// own CasualDateParser.applyTimeOfDay handles its day-roll generically.
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "morgen": (6, .am),
        "vormittag": (9, .am),
        "mittag": (12, .am),
        "mittags": (12, .am),
        "nachmittag": (15, .pm),
        "abend": (18, .pm),
        "nacht": (22, .pm),
        "mitternacht": (0, .am),
    ]

    /// "nacht" attached to a STATED hour is hour-DEPENDENT, not flat pm - source:
    /// DESpecificTimeExpressionParser.ts's own switch (`ampm.match(/nacht/)`):
    /// hour 12 reads as AM/0 (midnight), hour <6 stays AM as-is, hour 6-11 gains
    /// 12 and reads PM. Same shape and same NUMBERS as EN's own "night" rule -
    /// baseline .am handles the 12->0 and <6-keeps-as-is cases for free, only
    /// 6-11 need an explicit override. "in der nacht" is the same rule under a
    /// second surface form (multi-word key, matched literally with single
    /// spaces exactly like EN's "in the" / VI's multi-word entries elsewhere).
    static let meridiemHourRules: [String: MeridiemHourRule] = [
        "nachts": MeridiemHourRule(baseline: .am, overrides: [6: 18, 7: 19, 8: 20, 9: 21, 10: 22, 11: 23]),
        "in der nacht": MeridiemHourRule(baseline: .am, overrides: [6: 18, 7: 19, 8: 20, 9: 21, 10: 22, 11: 23]),
    ]

    /// Every spelling ported directly from chrono's own YEAR_PATTERN regex
    /// (constants.ts), enumerated as literal keys rather than ported as a regex -
    /// Vocabulary's era tables are flat word lookups, and the oracle only ever
    /// exercises these exact spellings, so there is no need to reproduce every
    /// combinatorial variant the regex could in principle accept (see chrono's
    /// own pattern for the full generative grammar if a case is ever found that
    /// needs a spelling not listed here).
    ///
    /// "v." family (BC-equivalent, sign -1): v.Chr. / v. Chr. (Christ, both WITH
    /// and WITHOUT the internal space - both spellings are separately
    /// oracle-tested), v.u.Z./v.d.Z. (both "before our/the era", secular),
    /// v.d.g.Z. ("before our common era"). The bare "n"/no-prefix family
    /// (AD-equivalent, sign +1) is everything else: n. Chr. (WITH the space,
    /// oracle-tested), nC, nuZ, uZ (no leading n at all - chrono's pattern has a
    /// whole second alternative with no [vn] group), d.g.Z., ndZ, ndgZ.
    ///
    /// These land inside MonthNameParser's yearGroup, whose era slot allows only
    /// `\s{0,2}` BETWEEN the year digits and the era word - so an internal space
    /// WITHIN the era word itself ("v. Chr.") must be part of the dictionary key,
    /// not treated as inter-token whitespace the engine trims for you.
    static let eraMarkers: [String: Int] = [
        "v.chr.": -1, "v.chr": -1, "v. chr.": -1, "v. chr": -1,
        "v.u.z.": -1, "v.u.z": -1,
        "v.d.z.": -1, "v.d.z": -1,
        "v.d.g.z.": -1, "v.d.g.z": -1,
        "nc": 1,
        "n. chr.": 1, "n. chr": 1,
        "nuz": 1,
        "uz": 1,
        "d.g.z.": 1, "d.g.z": 1,
        "ndz": 1,
        "ndgz": 1,
    ]

    static let eraOffsets: [String: Int] = [:]

    /// Vague counts, source-verified against chrono's own parseNumberPattern
    /// (constants.ts): "halb(e)" is 0.5, "einige(n)" is 3, "wenige(n)" is 2,
    /// "mehrere(n)" is 7. chrono's NUMBER_PATTERN also admits a bare "hal" (the
    /// regex `halb?` makes the final "b" optional), which is not ported: it is
    /// not a real German word, parseNumberPattern's own `/halb/` match test
    /// would not even recognize it (it lacks the "b"), and no oracle case
    /// exercises it - a latent quirk in chrono's regex, not a behavior to
    /// reproduce.
    static let casualQuantifiers: [String: Double] = [
        "halb": 0.5, "halbe": 0.5,
        "einige": 3, "einigen": 3,
        "wenige": 2, "wenigen": 2,
        "mehrere": 7, "mehreren": 7,
    ]
}
