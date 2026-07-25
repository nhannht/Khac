// ESLocale.swift - Spanish locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Values are ported from wanasit/chrono's own Spanish source
// (src/locales/es/constants.ts, ESWeekdayParser.ts, ESCasualDateParser.ts,
// ESCasualTimeParser.ts, ESTimeExpressionParser.ts,
// ESMonthNameLittleEndianParser.ts, ESTimeUnitWithinFormatParser.ts,
// ESMergeDateTimeRefiner.ts, ESMergeDateRangeRefiner.ts - see NOTICE), cross-
// checked against the 75-case ES oracle (Tests/KhacTests/Oracle/ES/).

import Foundation

public struct ESLocale: KhacLocale {
    public let id: LocaleID = .spanish

    public init() {}

    public var vocabulary: Vocabulary {
        Vocabulary(
            weekdays: Self.weekdays,
            months: Self.months,
            integerWords: Self.integerWords,
            ordinals: [:],
            timeUnits: Self.timeUnits,
            relativeModifiers: Self.relativeModifiers,
            dayReferences: Self.dayReferences,
            meridiem: Self.meridiem,
            timeOfDay: Self.timeOfDay,
            eraMarkers: Self.eraMarkers,
            fullMonthNames: Self.fullMonthNames,
            casualQuantifiers: Self.casualQuantifiers
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            // chrono's ESTimeExpressionParser.primaryPrefix:
            // `(?:(?:aslas|deslas|las?|al?|de|del)\s*)?`. The concatenated
            // "aslas"/"deslas" forms look like a regex-authoring artifact in
            // chrono itself (nobody writes those as one word), so they are not
            // ported - "la"/"las" (from las?) and "a"/"al" (from al?) are listed
            // as separate single words instead, matching chrono's real
            // decomposition.
            //
            // This split is load-bearing, not cosmetic: fusing "a las" into one
            // token was tried first and broke the reported match span. Chrono's
            // own "a las 6.13 AM" oracle case expects text "las 6.13 AM" (index
            // AFTER "a "), because chrono's prefix tries "a" alone, fails to
            // find a digit immediately after (next is "las", not a number), and
            // the engine resumes at "las" where the "las" alternative succeeds.
            // A fused "a las" entry succeeds where chrono's decomposed one
            // fails, consuming "a" into the match and shifting the index/text
            // away from the oracle's expectation. Keeping "a" and "las" as
            // separate options reproduces chrono's actual behavior instead of
            // just its word list.
            timePrefixWords: ["a", "al", "la", "las", "de", "del"],
            // "10 de enero", "10 de Agosto de 2012" (also the connector before
            // the trailing year in a month-name date).
            dateConnectorWords: ["de"],
            // ESTimeUnitWithinFormatParser: `(?:en|por|durante|de|dentro de)`.
            relativeFutureWords: ["en", "por", "durante", "de", "dentro de"],
            // Covers both a bare time range ("de 6:30pm a 11:00pm") and a
            // same-month day range ("10 a 22 Agosto 2012"); hyphen is built in.
            rangeConnectorWords: ["a"],
            nowWords: ["ahora"],
            // "Julio de 2013": the marker before a trailing year in a month-name
            // date, mirroring VI's "năm". Needed even when the day and month
            // themselves are directly adjacent with no connector ("3 Julio").
            yearMarkerWords: ["de"],
            // "ayer de noche" (yesterday at night): "ayer" anchors, "de" is the
            // particle before the time-of-day word, "noche" supplies the clock.
            // Same mechanism as VI's "buổi" - see CasualDateParser's todPrefix.
            timeOfDayPrefixWords: ["de"]
        )
    }

    // Spanish: day-month numeric order ("8/2/2016" = 8 Feb 2016, confirmed by
    // the ES oracle's slash cases), week starts Monday.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2)
    }
}

// MARK: - Vocabulary data

private extension ESLocale {
    static let weekdays: [String: Int] = [
        "domingo": 0, "dom": 0,
        "lunes": 1, "lun": 1,
        "martes": 2,
        // "mar" is ALSO an abbreviation for March in `months` below - a real
        // collision chrono's own dictionaries carry too (WEEKDAY_DICTIONARY and
        // MONTH_DICTIONARY are separate tables, each read by its own parser, so
        // there is no runtime conflict - only two parsers that can both offer a
        // reading for a bare "mar" and let the overlap resolution pick). No
        // oracle case exercises bare "mar", so this is recorded, not solved.
        "mar": 2,
        // Both spellings current; chrono lists both.
        "miércoles": 3, "miercoles": 3, "mié": 3, "mie": 3,
        "jueves": 4, "jue": 4,
        "viernes": 5, "vie": 5,
        "sábado": 6, "sabado": 6, "sáb": 6, "sab": 6,
    ]

    static let months: [String: Int] = [
        "enero": 1, "ene": 1, "ene.": 1,
        "febrero": 2, "feb": 2, "feb.": 2,
        "marzo": 3, "mar": 3, "mar.": 3,
        "abril": 4, "abr": 4, "abr.": 4,
        "mayo": 5, "may": 5, "may.": 5,
        "junio": 6, "jun": 6, "jun.": 6,
        "julio": 7, "jul": 7, "jul.": 7,
        "agosto": 8, "ago": 8, "ago.": 8,
        // "setiembre" is a standard, still-current variant spelling of
        // "septiembre" (both in chrono's own MONTH_DICTIONARY), not a typo.
        "septiembre": 9, "setiembre": 9, "sep": 9, "sep.": 9,
        "octubre": 10, "oct": 10, "oct.": 10,
        "noviembre": 11, "nov": 11, "nov.": 11,
        "diciembre": 12, "dic": 12, "dic.": 12,
    ]

    /// chrono's INTEGER_WORD_DICTIONARY stops at 13 - Spanish duration counts in
    /// the oracle never spell out anything larger ("cinco días", "dos semanas").
    static let integerWords: [String: Int] = [
        "uno": 1, "dos": 2, "tres": 3, "cuatro": 4, "cinco": 5, "seis": 6,
        "siete": 7, "ocho": 8, "nueve": 9, "diez": 10, "once": 11, "doce": 12,
        "trece": 13,
    ]

    /// chrono's TIME_UNIT_DICTIONARY. "día"/"días" is the only accented key -
    /// chrono provides no unaccented duplicate for it (unlike `weekdays` above,
    /// where it gives both spellings itself), so none is added here either.
    static let timeUnits: [String: Calendar.Component] = [
        "sec": .second, "segundo": .second, "segundos": .second,
        "min": .minute, "mins": .minute, "minuto": .minute, "minutos": .minute,
        "h": .hour, "hr": .hour, "hrs": .hour, "hora": .hour, "horas": .hour,
        "día": .day, "días": .day,
        "semana": .weekOfYear, "semanas": .weekOfYear,
        "mes": .month, "meses": .month,
        "cuarto": .quarter, "cuartos": .quarter,
        "año": .year, "años": .year,
    ]

    /// chrono's parseNumberPattern buckets: the exact-match branch (`un`/`una`/
    /// `uno`) returns 1 before the regex branches are even tried, so "uno" is
    /// carried by `integerWords` above and only the two indefinite-article forms
    /// that are NOT in that dictionary live here. `algunos?`/`unos?` both bucket
    /// to 3 ("some"/"a few"); chrono's NUMBER_PATTERN also lists a bare French
    /// "demi-?" among the Spanish alternatives, which is not a Spanish word and
    /// is not ported - almost certainly leftover from chrono's own pattern reuse
    /// across locales, not something a Spanish speaker would ever type here.
    /// "medio" is chrono's own /media?/ regex missing the masculine form of the
    /// exact same word (medio/media are pure gender agreement, not two
    /// different values) - added as a small, low-risk KHAC extension since no
    /// oracle case is affected either way.
    static let casualQuantifiers: [String: Double] = [
        "un": 1, "una": 1,
        "algunos": 3, "unos": 3,
        "media": 0.5, "medio": 0.5,
    ]

    /// "mañana" is deliberately in BOTH this table (tomorrow) and `timeOfDay`
    /// below (morning, hour 6) - a genuine one-word collision in Spanish itself,
    /// not a modeling gap. CasualDateParser's alternative order already resolves
    /// it correctly without any extra field: the day-anchored branch
    /// ("esta mañana") is tried before the bare-day-reference branch, which is
    /// tried before the bare-time-of-day branch, so "esta mañana" reads as
    /// anchor+time-of-day (morning, today) while bare "mañana"/"Mañana" reads as
    /// the day reference (tomorrow) - both confirmed against the oracle.
    static let dayReferences: [String: Int] = [
        "hoy": 0,
        "mañana": 1,
        "ayer": -1,
    ]

    /// chrono itself has no MERIDIEM dictionary for Spanish - AbstractTimeExpressionParser
    /// inlines am/pm into its own generic regex. Khac reads am/pm through
    /// locale data instead, so real entries are needed here; dotted forms added
    /// for robustness the same way ENLocale does, though the oracle only
    /// exercises the bare forms ("5PM", "AM").
    static let meridiem: [String: Meridiem] = [
        "am": .am, "a.m": .am, "a.m.": .am,
        "pm": .pm, "p.m": .pm, "p.m.": .pm,
    ]

    /// Hours from chrono's ESCasualTimeParser.ts switch statement, verified
    /// against the oracle:
    /// - "tarde" (afternoon) = 15/.pm, "noche" (night) = 22/.pm, "mañana"
    ///   (morning) = 6/.am: each oracle-tested standalone ("esta tarde", "esta
    ///   noche", "esta mañana").
    /// - "mediodía"/"mediodia" (noon) = 12/.am: NOT .pm. Matches EN's own
    ///   "noon"/"midday" = (12, .am) quirk - chrono's noon() implies AM as an
    ///   internal artifact of its 12-hour math, not a linguistic claim about
    ///   noon, and ESCasualTimeParser routes both spellings to that same
    ///   function. Oracle-confirmed ("el mediodía" -> hour 12).
    /// - "medianoche" (midnight) = (0, nil): no day-shift field needed. The
    ///   engine's existing hour==0 rollover in CasualDateParser (allowDayRoll,
    ///   fires when the reference's own hour > 2) already reproduces chrono's
    ///   ESCasualTimeParser "medianoche" behavior of rolling to the coming
    ///   night generically - confirmed against the oracle ("la medianoche" at
    ///   reference 11:00 resolves to hour 0 the NEXT day).
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "mañana": (6, .am),
        "tarde": (15, .pm),
        "noche": (22, .pm),
        "mediodía": (12, .am),
        "mediodia": (12, .am),
        "medianoche": (0, nil),
    ]

    /// ESWeekdayParser.ts: `(este|esta|pasado|pr[oó]ximo)`, mapped to modifiers
    /// "this"/"this"/"this"/"next" in chrono's OWN source (chrono literally
    /// routes "pasado" to the SAME branch as "este"/"esta" - `norm == "pasado"`
    /// sets `modifier = "this"`, not "last"). That reads as a chrono bug: no
    /// native speaker takes "el lunes pasado" (last Monday) to mean this coming
    /// Monday. Correctness wins over chrono parity when the two conflict (the
    /// same call VI's "này" fix already made) - "pasado" maps to -1 here. This
    /// is untested by any oracle case (grep-confirmed: no case exercises
    /// "pasado" or "próximo"/"proximo"), so the deviation costs nothing against
    /// the ratchet and is recorded so it reads as deliberate, not missed.
    static let relativeModifiers: [String: Int] = [
        "este": 0, "esta": 0,
        "próximo": 1, "proximo": 1,
        "pasado": -1,
    ]

    /// Bare month names, so a 3-character abbreviation ("mar", "jun", "ago") is
    /// not mistaken for a date on its own - the same length-based guard EN uses
    /// for "mar"/"jan" versus "may". Not oracle-tested (no ES case is a bare
    /// month-only match), included because the same real-word-abbreviation risk
    /// EN's own field exists for is present in Spanish too ("mar" is also a
    /// weekday abbreviation and the word for "sea").
    static let fullMonthNames: Set<String> = [
        "enero", "febrero", "marzo", "abril", "mayo", "junio",
        "julio", "agosto", "septiembre", "setiembre", "octubre", "noviembre", "diciembre",
    ]

    /// chrono's YEAR_PATTERN era suffix: `\s*[a|d]\.?\s*c\.?` (BC = "a.c.",
    /// AD/CE = "d.c.", both optionally dotted/spaced). Only the BC form
    /// actually negates in chrono's parseYear ("a.c." branch); the AD form is
    /// still a real word to recognize and consume into the match span - the
    /// oracle case "10 Agosto 88 d. C." asserts the WHOLE phrase including
    /// "d. C." as the match text, so it must be a real vocabulary entry even
    /// though it leaves the year's sign unchanged. "234 AC" (no dots) is the
    /// other oracle-tested spelling.
    static let eraMarkers: [String: Int] = [
        "ac": -1, "a.c.": -1, "a. c.": -1,
        "dc": 1, "d.c.": 1, "d. c.": 1,
    ]
}
