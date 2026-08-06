// ITLocale.swift - Italian locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Values are ported from wanasit/chrono's own Italian source
// (src/locales/it/constants.ts and its ~20 parser/refiner files - see NOTICE),
// cross-checked against the 168-case IT oracle (Tests/KhacTests/Oracle/IT/),
// the largest single-locale corpus in this port.
//
// Italian's "ago"/"later"/"within" relative-duration words are all
// SUFFIX/PREFIX forms Khac already has fields for (fa/prima = past suffix,
// dopo/più tardi/da adesso/da ora = future suffix, entro/tra/fra/in/per =
// future prefix) - unlike French's "il y a", Italian needed no new mechanism
// there. "weekend"/"fine settimana" IS a bespoke grammar rule in chrono's own
// ITWeekdayParser (weekend = the coming Saturday, "scorso weekend" = last
// Sunday) but no oracle case exercises it, so it is not modeled - a real gap,
// left open rather than guessed at.

import Foundation

public struct ITLocale: KhacLocale {
    public let id: LocaleID = .italian

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
            eraOffsets: Self.eraOffsets,
            fullMonthNames: Self.fullMonthNames,
            fullTimeUnitNames: Self.fullTimeUnitNames,
            casualQuantifiers: Self.casualQuantifiers
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            // ITTimeExpressionParser.primaryPrefix: `(?:(?:alle?|dalle?)\s*)??`.
            // The real words are "alle"/"dalle" ("alle 6:00", "dalle 6:00 alle
            // 9:00") - chrono's own truncated "all"/"dall" alternatives look
            // like the same kind of regex-authoring shorthand ES's "aslas" was
            // (not real standalone Italian words), so only the full forms are
            // ported, matching the ES precedent of decomposing into the words
            // people actually type rather than fusing chrono's own pattern
            // shorthand.
            timePrefixWords: ["alle", "dalle"],
            // "10 di agosto"-shape: ITMonthNameLittleEndianParser's own
            // hardcoded day-month connector is `(?:-|/|\s{0,3}(?:di)?\s{0,3})` -
            // "di", not "de"/"of".
            dateConnectorWords: ["di"],
            relativePastWords: ["fa", "prima"],
            relativeFutureWords: ["entro", "tra", "fra", "in", "per"],
            futureSuffixWords: ["dopo", "più tardi", "da adesso", "da ora"],
            // ITMergeDateRangeRefiner / ITTimeExpressionParser.followingPhase:
            // "a" (time ranges, "1pm a 3"), "alle" (also a time range
            // connector distinct from its prefix role, "dalle 6:00 ALLE
            // 9:00"), "al"/"fino a" (ITMonthNameLittleEndianParser's internal
            // day-range connector, once MonthNameParser reads this field - see
            // the KHAC-6 report on that connector being hardcoded to English
            // words).
            rangeConnectorWords: ["a", "al", "alle", "fino a"],
            nowWords: ["adesso", "ora"],
            // "il 10 agosto": the oracle asserts "il" as part of the matched
            // text ("La scadenza è il 10 agosto" -> text "il 10 agosto"),
            // matching VI's "ngày" mechanism exactly.
            dayMarkerWords: ["il"],
            // "a mezzanotte", "a mezzogiorno", "Domani A mezzogiorno" - bare
            // article before a time-of-day word with no anchor, same
            // mechanism as ES's "de" in "ayer de noche".
            timeOfDayPrefixWords: ["a"],
            // ITTimeUnitWithinFormatParser / TIME_UNITS_PATTERN: "circa"/
            // "approssimativamente" ("about"/"approximately"), chrono's own
            // filler words, direct counterpart to EN's "around"/"about".
            durationFillerWords: ["circa", "approssimativamente"],
            // TIME_UNIT_CONNECTOR_PATTERN: `\s{0,5},?(?:\s*e)?\s{0,5}` - "e"
            // ("and") joins duration clauses ("5 giorni e 12 ore fa").
            durationConnectorWords: ["e"]
        )
    }

    // Italian: day-month numeric order ("2012/8/10" = 10 Aug 2012, confirmed
    // by ItYearMonthDayCases; ITMonthNameLittleEndianParser is the primary
    // month-name form), week starts Monday.
    //
    // weekdaySuffixModifier: true - ITWeekdayParser's "scorso"/"prossimo" are
    // a direct SUFFIX on the weekday with no week-word ("lunedì scorso" = last
    // Monday), the same shape FR's option exists for.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2, weekdaySuffixModifier: true)
    }
}

// MARK: - Vocabulary data

private extension ITLocale {
    static let weekdays: [String: Int] = [
        "domenica": 0, "dom": 0, "dom.": 0,
        "lunedì": 1, "lunedi": 1, "lun": 1, "lun.": 1,
        "martedì": 2, "martedi": 2,
        // "mar" is ALSO an abbreviation for "marzo" (March) in `months` below -
        // the same real, chrono-inherited collision ES/FR/PT all carry.
        "mar": 2, "mar.": 2,
        "mercoledì": 3, "mercoledi": 3, "mer": 3, "mer.": 3,
        "giovedì": 4, "giovedi": 4, "gio": 4, "gio.": 4,
        "venerdì": 5, "venerdi": 5, "ven": 5, "ven.": 5,
        "sabato": 6, "sab": 6, "sab.": 6,
    ]

    static let months: [String: Int] = [
        "gennaio": 1, "gen": 1, "gen.": 1,
        "febbraio": 2, "feb": 2, "feb.": 2,
        "marzo": 3, "mar.": 3,
        "aprile": 4, "apr": 4, "apr.": 4,
        "maggio": 5, "mag": 5, "mag.": 5,
        "giugno": 6, "giu": 6, "giu.": 6,
        "luglio": 7, "lug": 7, "lug.": 7,
        "agosto": 8, "ago": 8, "ago.": 8,
        "settembre": 9, "set": 9, "set.": 9, "sett": 9, "sett.": 9,
        "ottobre": 10, "ott": 10, "ott.": 10,
        "novembre": 11, "nov": 11, "nov.": 11,
        "dicembre": 12, "dic": 12, "dic.": 12,
    ]

    /// chrono's INTEGER_WORD_DICTIONARY - unlike ES/FR/PT, Italian's own
    /// dictionary already carries "un"/"una" alongside "uno" (all = 1), so no
    /// separate casualQuantifiers entry is needed for the indefinite article.
    static let integerWords: [String: Int] = [
        "uno": 1, "una": 1, "un": 1,
        "due": 2, "tre": 3, "quattro": 4, "cinque": 5, "sei": 6,
        "sette": 7, "otto": 8, "nove": 9, "dieci": 10, "undici": 11, "dodici": 12,
    ]

    /// chrono's ORDINAL_WORD_DICTIONARY, ported in full: Italian marks day
    /// ordinals with real WORDS ("primo maggio", "secondo agosto" - both
    /// oracle-tested) or a digit plus a degree/ordinal mark ("1°"/"1ª"), never
    /// English-style st/nd/rd/th - so, unlike French's "1er" (a hardcoded-to-
    /// English suffix gap reported to main), Italian's day ordinals are fully
    /// expressible as plain Vocabulary data today. "secondo" collides with
    /// `timeUnits`' "second" - the same class of cross-table collision ES's
    /// "mar" (Tuesday/March) already carries; separate tables, separate
    /// parsers, no runtime conflict.
    static let ordinals: [String: Int] = [
        "primo": 1, "prima": 1, "1°": 1, "1ª": 1,
        "secondo": 2, "seconda": 2, "2°": 2, "2ª": 2,
        "terzo": 3, "terza": 3, "3°": 3, "3ª": 3,
        "quarto": 4, "quarta": 4, "4°": 4, "4ª": 4,
        "quinto": 5, "quinta": 5, "5°": 5, "5ª": 5,
        "sesto": 6, "sesta": 6, "6°": 6, "6ª": 6,
        "settimo": 7, "settima": 7, "7°": 7, "7ª": 7,
        "ottavo": 8, "ottava": 8, "8°": 8, "8ª": 8,
        "nono": 9, "nona": 9, "9°": 9, "9ª": 9,
        "decimo": 10, "decima": 10, "10°": 10, "10ª": 10,
        "undicesimo": 11, "undicesima": 11, "11°": 11, "11ª": 11,
        "dodicesimo": 12, "dodicesima": 12, "12°": 12, "12ª": 12,
        "tredicesimo": 13, "tredicesima": 13, "13°": 13, "13ª": 13,
        "quattordicesimo": 14, "quattordicesima": 14, "14°": 14, "14ª": 14,
        "quindicesimo": 15, "quindicesima": 15, "15°": 15, "15ª": 15,
        "sedicesimo": 16, "sedicesima": 16, "16°": 16, "16ª": 16,
        "diciassettesimo": 17, "diciassettesima": 17, "17°": 17, "17ª": 17,
        "diciottesimo": 18, "diciottesima": 18, "18°": 18, "18ª": 18,
        "diciannovesimo": 19, "diciannovesima": 19, "19°": 19, "19ª": 19,
        "ventesimo": 20, "ventesima": 20, "20°": 20, "20ª": 20,
        "ventunesimo": 21, "ventunesima": 21, "21°": 21, "21ª": 21,
        "ventiduesimo": 22, "ventiduesima": 22, "22°": 22, "22ª": 22,
        "ventitreesimo": 23, "ventitreesima": 23, "23°": 23, "23ª": 23,
        "ventiquattresimo": 24, "ventiquattresima": 24, "24°": 24, "24ª": 24,
        "venticinquesimo": 25, "venticinquesima": 25, "25°": 25, "25ª": 25,
        "ventiseiesimo": 26, "ventiseiesima": 26, "26°": 26, "26ª": 26,
        "ventisettesimo": 27, "ventisettesima": 27, "27°": 27, "27ª": 27,
        "ventottesimo": 28, "ventottesima": 28, "28°": 28, "28ª": 28,
        "ventinovesimo": 29, "ventinovesima": 29, "29°": 29, "29ª": 29,
        "trentesimo": 30, "trentesima": 30, "30°": 30, "30ª": 30,
        "trentunesimo": 31, "trentunesima": 31, "31°": 31, "31ª": 31,
    ]

    /// chrono's TIME_UNIT_DICTIONARY (abbreviated forms included: s/sec, m/min,
    /// h, g/gg, sett, trim). The unabbreviated subset is repeated verbatim in
    /// `fullTimeUnitNames` below for strict mode.
    static let timeUnits: [String: Calendar.Component] = [
        "s": .second, "sec": .second, "secondo": .second, "secondi": .second,
        "m": .minute, "min": .minute, "minuto": .minute, "minuti": .minute,
        "h": .hour, "ora": .hour, "ore": .hour,
        "g": .day, "gg": .day, "giorno": .day, "giorni": .day,
        "sett": .weekOfYear, "settimana": .weekOfYear, "settimane": .weekOfYear,
        "mese": .month, "mesi": .month,
        "trim": .quarter, "trimestre": .quarter, "trimestri": .quarter,
        "anno": .year, "anni": .year,
    ]

    /// chrono's TIME_UNIT_DICTIONARY_NO_ABBR - the exact set its own STRICT
    /// parsers (ITTimeUnitAgoFormatParser etc.) restrict to.
    static let fullTimeUnitNames: Set<String> = [
        "secondo", "secondi", "minuto", "minuti", "ora", "ore",
        "giorno", "giorni", "settimana", "settimane", "mese", "mesi",
        "trimestre", "trimestri", "anno", "anni",
    ]

    /// chrono's parseNumberPattern quantifier branches beyond the integer
    /// dictionary (which already carries un/una/uno - see `integerWords`):
    /// "qualche" = 3 ("some"/"a few"), "mezzo"/"mezza" = 0.5 ("half", both
    /// genders - chrono's own `/mezz/` regex matches either), "paio" = 2 ("a
    /// couple"), "alcuni" = 7 ("several").
    static let casualQuantifiers: [String: Double] = [
        "qualche": 3,
        "mezzo": 0.5, "mezza": 0.5,
        "paio": 2,
        "alcuni": 7,
    ]

    /// chrono's ITCasualDateParser: "oggi"=0, "domani"=1, "dopodomani"=2 (the
    /// day after tomorrow), "ieri"=-1. "adesso"/"ora" (now) are NOT here -
    /// routed through `patterns.nowWords`, the same split ES/PT/VI all make.
    /// "stasera"/"stanotte" are NOT day references either - they carry their
    /// own implied hour directly and live in `timeOfDay` below, the same way
    /// EN's "tonight" does.
    static let dayReferences: [String: Int] = [
        "oggi": 0,
        "domani": 1,
        "dopodomani": 2,
        "ieri": -1,
    ]

    /// chrono has no MERIDIEM dictionary for Italian either - inlined into its
    /// generic time regex. Dotted forms added for robustness, matching
    /// ES/EN/PT; the oracle only exercises the bare forms ("6:00 PM"/"AM").
    static let meridiem: [String: Meridiem] = [
        "am": .am, "a.m": .am, "a.m.": .am,
        "pm": .pm, "p.m": .pm, "p.m.": .pm,
    ]

    /// Two chrono parsers feed this table, and their VALUES do not always
    /// agree for what looks like the same word:
    /// - ITCasualTimeParser (bare/compound words, all via casualReferences):
    ///   "mattina"/"stamattina"/"stamani" = morning() = 6/.am; "pomeriggio" =
    ///   afternoon() = 15/.pm; "sera"/"notte" (bare, optionally with "questa")
    ///   = evening() = 20/.pm; "mezzanotte" = midnight() = (0, nil);
    ///   "mezzogiorno" = noon() = 12/.am (the same EN/ES/FR/PT noon-implies-AM
    ///   quirk, chrono's own 12-hour-math artifact).
    /// - ITCasualDateParser separately routes "stasera"/"stanotte" through
    ///   tonight() = 22/.pm, NOT evening()'s 20 - a DIFFERENT value than bare
    ///   "sera"/"notte" get from the other parser. This is not a guess: the
    ///   oracle directly confirms it ("La scadenza era stasera" -> hour 22,
    ///   while "questa sera" -> hour 20), so "stasera"/"stanotte" and bare
    ///   "sera"/"notte" are kept as genuinely DIFFERENT table entries rather
    ///   than unified.
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "mattina": (6, .am), "stamattina": (6, .am), "stamani": (6, .am),
        "pomeriggio": (15, .pm),
        "sera": (20, .pm), "notte": (20, .pm),
        "stasera": (22, .pm), "stanotte": (22, .pm),
        "mezzanotte": (0, nil),
        "mezzogiorno": (12, .am),
    ]

    /// ITWeekdayParser: `(questo|questa|quest'|scorso|scorsa|prossimo|prossima)`,
    /// mapped in chrono's OWN source to "this"/"last"/"next" respectively -
    /// CORRECTLY, unlike ES's "pasado" and PT's "passado", which chrono itself
    /// mis-maps to "this". Italian needs no correctness fix here.
    /// "dopo" ("after") does double duty, exactly the way EN's own "after"
    /// does: it is ALSO a futureSuffixWords entry (`patterns.futureSuffixWords`,
    /// "5 minuti dopo" = 5 minutes later) via
    /// ITTimeUnitCasualRelativeFormatParser's bare-modifier form ("dopo
    /// settimana"-shaped), which shares this table with the weekday/duration
    /// modifier slot.
    static let relativeModifiers: [String: Int] = [
        "questo": 0, "questa": 0, "quest'": 0,
        "prossimo": 1, "prossima": 1, "dopo": 1,
        "scorso": -1, "scorsa": -1,
    ]

    /// chrono's FULL_MONTH_NAME_DICTIONARY - used for the same length-based
    /// bare-abbreviation guard EN/ES/FR/PT all have.
    static let fullMonthNames: Set<String> = [
        "gennaio", "febbraio", "marzo", "aprile", "maggio", "giugno",
        "luglio", "agosto", "settembre", "ottobre", "novembre", "dicembre",
    ]

    /// chrono's YEAR_PATTERN reuses ENGLISH era abbreviations directly for
    /// Italian (`BE|AD|BC|BCE|CE`, not "a.C."/"d.C." the way ES/FR/PT spell
    /// their own era markers) - not an oracle-tested class for IT (no
    /// ItYearCases/ItMonth* case exercises BC/AD/BE), but ported for
    /// completeness and consistency with EN's identical set, at zero risk
    /// since nothing here is exercised either way.
    static let eraMarkers: [String: Int] = [
        "ad": 1, "ce": 1,
        "bc": -1, "bce": -1,
    ]

    /// Buddhist era offset, same -543 constant EN uses.
    static let eraOffsets: [String: Int] = [
        "be": -543,
    ]
}
