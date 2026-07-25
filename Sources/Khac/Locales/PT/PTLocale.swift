// PTLocale.swift - Portuguese locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Values are ported from wanasit/chrono's own Portuguese source
// (src/locales/pt/constants.ts, PTWeekdayParser.ts, PTCasualDateParser.ts,
// PTCasualTimeParser.ts, PTTimeExpressionParser.ts,
// PTMonthNameLittleEndianParser.ts, PTMergeDateTimeRefiner.ts,
// PTMergeDateRangeRefiner.ts - see NOTICE), cross-checked against the 60-case
// PT oracle (Tests/KhacTests/Oracle/PT/).
//
// chrono's own PT locale has NO relative-duration parsers at all (no
// TimeUnitAgoFormatParser, no TimeUnitWithinFormatParser - constants.ts
// carries no INTEGER_WORD_DICTIONARY, no TIME_UNIT_DICTIONARY, no
// NUMBER_PATTERN) and the oracle has no fr_time_units_*-style file. So
// `integerWords`, `timeUnits`, `casualQuantifiers`, `relativeFutureWords`,
// `relativePastWords`, and `futureSuffixWords` are correctly EMPTY here - not
// an oversight, a faithful match to what chrono itself has for this locale.

import Foundation

public struct PTLocale: KhacLocale {
    public let id: LocaleID = .portuguese

    public init() {}

    public var vocabulary: Vocabulary {
        Vocabulary(
            weekdays: Self.weekdays,
            months: Self.months,
            ordinals: [:],
            relativeModifiers: Self.relativeModifiers,
            dayReferences: Self.dayReferences,
            meridiem: Self.meridiem,
            timeOfDay: Self.timeOfDay,
            eraMarkers: Self.eraMarkers,
            fullMonthNames: Self.fullMonthNames
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            // PTTimeExpressionParser.primaryPrefix: `(?:(?:ao?|às?|das|da|de|do)\s*)?`.
            // Decomposed into single words rather than chrono's fused
            // "ao?"/"às?" groups - the ES port found that fusing a prefix into
            // one multi-char alternative (there, "a las") changes which match
            // wins the leftmost position and shifts the reported index/text
            // away from the oracle's expectation; listing "a"/"ao" and
            // "às"/"as" separately reproduces chrono's actual decomposition.
            timePrefixWords: ["a", "ao", "às", "as", "das", "da", "de", "do"],
            // "10 de janeiro", "Agosto de 2012".
            dateConnectorWords: ["de"],
            // PTMergeDateRangeRefiner: `(-)`. Also covers
            // PTMonthNameLittleEndianParser's own day-range connector
            // (`desde|de|-|–|ao?|\s`) once MonthNameParser reads this field -
            // see the KHAC-6 report on the day-range connector being hardcoded
            // to English words. "a"/"ao" also serve PTTimeExpressionParser's
            // own time-range connector (`a(?:o)?`).
            rangeConnectorWords: ["a", "ao"],
            nowWords: ["agora"],
            // "Agosto de 2012": the marker before a trailing year in a
            // month-name date, mirroring ES's identical "de" and VI's "năm".
            yearMarkerWords: ["de"],
            // "ontem à noite" (yesterday at night): "ontem" anchors, "à" is
            // the particle before the time-of-day word - same mechanism as
            // ES's "de". "ao meio-dia" / "a meia-noite" need the bare forms
            // too, since chrono bakes the article into those two idioms
            // directly (`ao?\s*meio-dia`-shaped in chrono's own source);
            // decomposed here the same way ES decomposed "a midi"/"a las".
            timeOfDayPrefixWords: ["à", "ao", "a"]
        )
    }

    // Portuguese: day-month numeric order ("8/2/2016" = 8 Feb 2016, confirmed
    // by the PT oracle's slash cases), week starts Monday.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2)
    }
}

// MARK: - Vocabulary data

private extension PTLocale {
    static let weekdays: [String: Int] = [
        "domingo": 0, "dom": 0,
        "segunda": 1, "segunda-feira": 1, "seg": 1,
        "terça": 2, "terça-feira": 2, "ter": 2,
        "quarta": 3, "quarta-feira": 3, "qua": 3,
        "quinta": 4, "quinta-feira": 4, "qui": 4,
        "sexta": 5, "sexta-feira": 5, "sex": 5,
        // Both spellings current; chrono lists both.
        "sábado": 6, "sabado": 6, "sab": 6,
    ]

    static let months: [String: Int] = [
        "janeiro": 1, "jan": 1, "jan.": 1,
        "fevereiro": 2, "fev": 2, "fev.": 2,
        "março": 3, "mar": 3, "mar.": 3,
        "abril": 4, "abr": 4, "abr.": 4,
        "maio": 5, "mai": 5, "mai.": 5,
        "junho": 6, "jun": 6, "jun.": 6,
        "julho": 7, "jul": 7, "jul.": 7,
        "agosto": 8, "ago": 8, "ago.": 8,
        "setembro": 9, "set": 9, "set.": 9,
        "outubro": 10, "out": 10, "out.": 10,
        "novembro": 11, "nov": 11, "nov.": 11,
        "dezembro": 12, "dez": 12, "dez.": 12,
    ]

    /// chrono's PTCasualDateParser: "agora" is NOT here - it is "now" (full
    /// clock precision), routed through `patterns.nowWords` instead, the same
    /// split ES and VI both make.
    static let dayReferences: [String: Int] = [
        "hoje": 0,
        "amanha": 1, "amanhã": 1,
        "ontem": -1,
    ]

    /// chrono has no MERIDIEM dictionary for Portuguese either - inlined into
    /// its generic time regex. Dotted forms added for robustness, matching
    /// ES/EN; the oracle only exercises the bare forms ("5PM").
    static let meridiem: [String: Meridiem] = [
        "am": .am, "a.m": .am, "a.m.": .am,
        "pm": .pm, "p.m": .pm, "p.m.": .pm,
    ]

    /// chrono's PTCasualTimeParser switch, oracle-confirmed standalone
    /// ("esta manhã", "esta tarde", "esta noite"):
    /// - "manha"/"manhã" (morning) = 6/.am, "tarde" (afternoon) = 15/.pm,
    ///   "noite" (night) = 22/.pm.
    /// - "meio-dia" (noon) = 12/.am: matches EN's/ES's own noon=am quirk
    ///   (chrono's noon() helper implies AM as an artifact of its 12-hour
    ///   math), and PTCasualTimeParser routes "meio-dia" through that same
    ///   function.
    /// - "meia-noite" (midnight) = (0, nil): no day-shift field needed - the
    ///   engine's existing hour==0 rollover in CasualDateParser already
    ///   reproduces chrono's "coming midnight" behavior generically, the same
    ///   way it did for ES's "medianoche" (oracle-confirmed: "a meia-noite" at
    ///   reference 11:00 resolves to hour 0 the NEXT day).
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "manha": (6, .am), "manhã": (6, .am),
        "tarde": (15, .pm),
        "noite": (22, .pm),
        "meio-dia": (12, .am),
        "meia-noite": (0, nil),
    ]

    /// PTWeekdayParser.ts: `(este|esta|passado|pr[oó]ximo)`, mapped in
    /// chrono's OWN source to modifiers "this"/"this"/"this"/"next" - chrono
    /// literally routes "passado" to the SAME branch as "este"/"esta"
    /// (`norm == "passado"` sets `modifier = "this"`, not "last"), the exact
    /// same bug ES's "pasado" has. Correctness wins over chrono parity when
    /// the two conflict (the same call VI's "này" fix and ES's "pasado" fix
    /// both already made) - "passado" maps to -1 here. Untested by any oracle
    /// case (no PT case exercises "passado"/"próximo"/"proximo"), so the
    /// deviation costs nothing against the ratchet.
    static let relativeModifiers: [String: Int] = [
        "este": 0, "esta": 0,
        "próximo": 1, "proximo": 1,
        "passado": -1,
    ]

    /// Bare month names, same length-based abbreviation guard as ES/EN/FR -
    /// not oracle-tested either way (no PT case is a bare month-only match).
    static let fullMonthNames: Set<String> = [
        "janeiro", "fevereiro", "março", "abril", "maio", "junho",
        "julho", "agosto", "setembro", "outubro", "novembro", "dezembro",
    ]

    /// chrono's YEAR_PATTERN/parseYear, identical shape to ES: only "a.c."
    /// negates (BC); "d.c." is a real word to recognize and consume into the
    /// match span (oracle: "10 Agosto 88 d. C." asserts the whole phrase as
    /// match text) even though it leaves the sign unchanged. "234 AC" is the
    /// other oracle-tested spelling.
    static let eraMarkers: [String: Int] = [
        "ac": -1, "a.c.": -1, "a. c.": -1,
        "dc": 1, "d.c.": 1, "d. c.": 1,
    ]
}
