// SVLocale.swift - Swedish locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Values cross-checked against wanasit/chrono v2.10.1's actual
// sv/ source (constants.ts + all 4 parsers under src/locales/sv/ - see NOTICE),
// never chrono's test code, only its behavior.
//
// Swedish has the smallest chrono parser set of the three Germanic locales in
// this batch - no SVTimeExpressionParser at all (chrono's SV registers no
// clock-time parser, common or bespoke), no era markers, and no reachable
// ordinal-word dictionary (chrono's own ORDINAL_WORD_DICTIONARY /
// ORDINAL_NUMBER_PATTERN in sv/constants.ts are never imported by any SV
// parser - dead code in chrono itself, confirmed by grep, not a gap here to
// port around). None of the 41 oracle cases exercises a numeric clock time, so
// this locale carries no TimeExpressionParser-related PatternSet fields at all.
//
// No wall found for Swedish - every ported case passes outright.

import Foundation

public struct SVLocale: KhacLocale {
    public let id: LocaleID = .swedish

    public init() {}

    public var vocabulary: Vocabulary {
        Vocabulary(
            weekdays: Self.weekdays,
            months: Self.months,
            integerWords: Self.integerWords,
            timeUnits: Self.timeUnits,
            relativeModifiers: Self.relativeModifiers,
            dayReferences: Self.dayReferences,
            timeOfDay: Self.timeOfDay
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            rangeConnectorWords: ["till"],
            nowWords: ["nu"],
            // Oracle-confirmed: "på måndag" keeps "på" IN the matched span.
            weekdayPrefixWords: ["på"],
            // Marks a following bare day number: "den 15 augusti".
            dayMarkerWords: ["den"],
            // Particle BEFORE a time-of-day word, consumed as part of the
            // token so a day anchor and the time stay one result ("idag på
            // morgonen"). "vid" is the alternate particle "midnatt" itself
            // uses ("idag vid midnatt") - source and oracle both confirm
            // "midnatt" never pairs with "på".
            timeOfDayPrefixWords: ["på", "vid"]
        )
    }

    // Swedish: day-month numeric order (3/4 = April 3rd), week starts Monday.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2)
    }
}

// MARK: - Vocabulary data

private extension SVLocale {
    static let weekdays: [String: Int] = [
        "söndag": 0, "sön": 0, "so": 0,
        "måndag": 1, "mån": 1, "må": 1,
        "tisdag": 2, "tis": 2, "ti": 2,
        "onsdag": 3, "ons": 3, "on": 3,
        "torsdag": 4, "tors": 4, "to": 4,
        "fredag": 5, "fre": 5, "fr": 5,
        "lördag": 6, "lör": 6, "lö": 6,
    ]

    static let months: [String: Int] = [
        "januari": 1, "jan": 1, "jan.": 1,
        "februari": 2, "feb": 2, "feb.": 2,
        "mars": 3, "mar": 3, "mar.": 3,
        "april": 4, "apr": 4, "apr.": 4,
        "maj": 5,
        "juni": 6, "jun": 6, "jun.": 6,
        "juli": 7, "jul": 7, "jul.": 7,
        "augusti": 8, "aug": 8, "aug.": 8,
        "september": 9, "sep": 9, "sep.": 9,
        "oktober": 10, "okt": 10, "okt.": 10,
        "november": 11, "nov": 11, "nov.": 11,
        "december": 12, "dec": 12, "dec.": 12,
    ]

    /// Cardinals 1-12 (plus the round tens/hundred/thousand chrono's own
    /// dictionary carries), covering spelled-out relative counts ("nästa två
    /// år"). No ordinal WORD table: see the file header - chrono's own
    /// ORDINAL_WORD_DICTIONARY is dead code in its SV locale, never read by
    /// any SV parser, and no oracle case needs a spelled-out day of month.
    static let integerWords: [String: Int] = [
        "en": 1, "ett": 1, "två": 2, "tre": 3, "fyra": 4, "fem": 5, "sex": 6,
        "sju": 7, "åtta": 8, "nio": 9, "tio": 10, "elva": 11, "tolv": 12,
        "tretton": 13, "fjorton": 14, "femton": 15, "sexton": 16, "sjutton": 17,
        "arton": 18, "nitton": 19, "tjugo": 20, "trettio": 30, "fyrtio": 40,
        "femtio": 50, "sextio": 60, "sjuttio": 70, "åttio": 80, "nittio": 90,
        "hundra": 100, "tusen": 1000,
    ]

    /// "tim" is the abbreviated form chrono's TIME_UNIT_DICTIONARY carries
    /// alongside "timme"/"timmar" ("hour"); "kvartаl" appears TWICE in
    /// chrono's own dictionary, once with a Cyrillic а (U+0430) look-alike
    /// - a copy-paste artifact in chrono's own source, not a real Swedish
    /// spelling, and not ported here.
    static let timeUnits: [String: Calendar.Component] = [
        "sek": .second, "sekund": .second, "sekunder": .second,
        "min": .minute, "minut": .minute, "minuter": .minute,
        "tim": .hour, "timme": .hour, "timmar": .hour,
        "dag": .day, "dagar": .day,
        "vecka": .weekOfYear, "veckor": .weekOfYear,
        "mån": .month, "månad": .month, "månader": .month,
        "år": .year,
        "kvartal": .quarter,
    ]

    /// Two word families share this table: WeekdayParser's prefix/postfix slot
    /// (förra/senaste=last, nästa/kommande=next, oracle: "nästa måndag",
    /// "förra måndag") and RelativeUnitParser's modifier-prefix and
    /// bare-modifier slots, which add "denna"/"den här" (this) and "passerade"
    /// (past) and "efter" (after, the same +1 "after" class as EN's own
    /// entry) - source: SVTimeUnitCasualRelativeFormatParser.ts. The
    /// week-postfix compounds ("förra vecka" etc.) are chrono-source-confirmed
    /// (SVWeekdayParser.ts's own postfix slot accepts any of the four modifiers
    /// before "vecka") though no oracle case exercises the postfix position for
    /// Swedish specifically - added for the same reason DE/NL's siblings were.
    static let relativeModifiers: [String: Int] = [
        "denna": 0, "den här": 0,
        "förra": -1, "senaste": -1, "passerade": -1,
        "förra vecka": -1, "senaste vecka": -1,
        "nästa": 1, "kommande": 1, "efter": 1,
        "nästa vecka": 1, "kommande vecka": 1,
    ]

    /// "i förrgår" is chrono's own alternate spelling of "förrgår" (day before
    /// yesterday, `i\s*förrgår` in its own pattern) - kept as its own key here.
    /// "imorn" is NOT ported: it appears in chrono's SVCasualDateParser.ts
    /// switch statement but never in that parser's own regex PATTERN, so it is
    /// unreachable dead code in chrono itself, the same class of finding as
    /// the ordinal dictionary in the file header.
    static let dayReferences: [String: Int] = [
        "idag": 0,
        "imorgon": 1,
        "igår": -1,
        "förrgår": -2, "i förrgår": -2,
    ]

    /// None of these carry a meridiem hint - source-verified against
    /// SVCasualDateParser.ts's own switch, which implies hour/minute/second/
    /// millisecond but NEVER implies a meridiem for any Swedish time-of-day
    /// word (unlike DE/NL/EN, which all imply am or pm here). "natt"/"natten"
    /// is 2, not the 20-22 range DE/NL/EN use for "night" - late night/early
    /// morning hours, a genuinely different native meaning, not a port slip.
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "morgon": (6, nil), "morgonen": (6, nil),
        "förmiddag": (9, nil), "förmiddagen": (9, nil),
        "middag": (12, nil), "middagen": (12, nil),
        "eftermiddag": (15, nil), "eftermiddagen": (15, nil),
        "kväll": (20, nil), "kvällen": (20, nil),
        "natt": (2, nil), "natten": (2, nil),
        "midnatt": (0, nil),
    ]
}
