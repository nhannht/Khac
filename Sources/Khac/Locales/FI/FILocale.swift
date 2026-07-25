// FILocale.swift - Finnish locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Ported from wanasit/chrono v2.10.1's Finnish source
// (src/locales/fi/constants.ts and parsers/*.ts) as a correctness oracle - the
// FACTS about which words carry which values are ported, chrono's own parser
// CODE is not copied (see NOTICE and Tests/KhacTests/Oracle/README.md).
//
// Finnish's chrono support is a NARROW subset compared to Russian/Ukrainian
// (77 ported cases against 131 each) - there is no month-only parser
// ("syyskuussa" meaning "in September" is not chrono FI grammar at all, only
// a day+month little-endian form), no phrase-level "this/next/last week"
// parser, no vague quantifier word, and every duration case in the ported
// oracle states its count explicitly. So several of the gaps RU/UK hit do
// not recur here - not because Khac fixed them, but because chrono itself
// never asked Finnish to express that grammar. This is the checkpoint-1
// prediction (chrono's narrow fi suite implies a narrow subset) confirmed by
// actually reading the source and running the port.
//
// One gap DOES recur, in a fi-specific form: "15. elokuuta" (the 15th of
// August) needs a "." connector between the day number and the month name.
// That connector slot is Locale.swift's own `dateConnectorWords` field
// (doc-commented "Connector in '3rd of March': 'of'", already set by EN to
// ["of"]) - but grepping the parser sources shows it is never actually READ
// by MonthNameParser.swift, which hardcodes "of" literally instead. So the
// fix here may be simpler than a brand new field: wiring the existing,
// already-declared field into the connector it was written to serve. Reported
// to `main` under KHAC-6; the two affected cases are deferred below, not
// patched around.
//
// One bespoke parser is still needed, for "viime yönä" (last night) - see
// FIParsers.swift. Its own reference-hour threshold (>6) matches EN's inline
// rule exactly, not RU/UK's shared casualReferences.lastNight (<6) - a THIRD
// distinct threshold value for the "same" construct across three locales,
// which is itself confirmation that this genuinely cannot be one generic
// field; each locale's own source states its own number.

import Foundation

public struct FILocale: KhacLocale {
    public let id: LocaleID = .finnish

    public init() {}

    public var vocabulary: Vocabulary {
        Vocabulary(
            weekdays: Self.weekdays,
            months: Self.months,
            integerWords: Self.integerWords,
            // Empty: chrono's FI source has no spelled-out ordinal dictionary
            // at all - FIMonthNameLittleEndianParser reads the day as a plain
            // `parseInt`, never a word ("kahdeskymmenesviides" style ordinals
            // are not part of chrono's FI grammar). Nothing to port.
            ordinals: [:],
            timeUnits: Self.timeUnits,
            relativeModifiers: Self.relativeModifiers,
            dayReferences: Self.dayReferences,
            // Empty: Finnish has no flat am/pm word AT ALL in chrono's FI
            // source (no equivalent to Russian's "утра"/"вечера" attached to a
            // stated hour) - FITimeExpressionParser carries no
            // extractPrimaryTimeComponents override, unlike RU/UK's. Its only
            // time-of-day vocabulary lives in `timeOfDay` below, read by the
            // CASUAL parsers, never by TimeExpressionParser.
            meridiem: [:],
            timeOfDay: Self.timeOfDay,
            meridiemHourRules: [:],
            eraMarkers: [:],
            eraOffsets: [:],
            // Empty: chrono's FI month abbreviations ("tammi", "helmi", ...)
            // are all 4+ characters, and the one 3-character key that exists
            // ("loka", exactly 4 - actually every FI abbreviation checked is
            // >=4 characters) never collides with the "reject a bare match of
            // at most 3 characters" guard the way RU's "май"/EN's "may" do.
            // Turning the filter off is correct, not an oversight - Vocabulary's
            // own doc comment says exactly this is when to leave it empty.
            fullMonthNames: [],
            // TIME_UNIT_NO_ABBR_DICTIONARY in constants.ts is a SEPARATE,
            // explicit dictionary from TIME_UNIT_DICTIONARY - chrono's own
            // FI source draws exactly the line this field exists for (full
            // spelled forms only, no "s"/"min"/"t"/"pv"/"vk"/"kk" letter
            // abbreviations), used by FITimeUnitCasualRelativeFormatParser's
            // own `allowAbbreviations` flag. A clean, source-confirmed fit,
            // not inferred from EN's precedent.
            fullTimeUnitNames: Self.fullTimeUnitNames,
            casualQuantifiers: [:]
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            // FITimeExpressionParser.ts's own primaryPrefix: "klo"/"kello"
            // ("at", "o'clock"-ish). No "in"/"at" alternative beyond these two.
            timePrefixWords: ["klo", "kello"],
            // The "." connector FI needs between a day number and the month
            // name ("15. elokuuta") is documented as dateConnectorWords's own
            // slot, but that field is not yet wired into MonthNameParser's
            // connector construction (reported to main, KHAC-6) - setting it
            // here would have no effect until that lands, so it is left unset
            // and the two affected cases are deferred instead of silently
            // pretending this field already does the job.
            dateConnectorWords: [],
            clockHourWords: [],
            clockMinuteWords: [],
            clockSecondWords: [],
            // "sitten" (ago) - FITimeUnitAgoFormatParser.ts's own literal.
            relativePastWords: ["sitten"],
            // Empty: unlike Russian's "через"/UK's "через", Finnish has NO
            // PREFIX "in"/"within" word in chrono's own source at all - every
            // future "within" reading is a SUFFIX (see futureSuffixWords).
            relativeFutureWords: [],
            // "sisällä"/"kuluessa" (within, FITimeUnitWithinFormatParser.ts's
            // own suffix set) and "päästä" (later/from now,
            // same parser's third suffix alternative) - all three read a
            // duration BEFORE them, exactly the shape EN's own "later"/"from
            // now" already fill this field for. Oracle-confirmed: "5 päivää
            // sisällä", "yksi vuotta kuluessa", "5 minuuttia päästä" all put
            // the count+unit first, the direction word after.
            futureSuffixWords: ["sisällä", "kuluessa", "päästä"],
            // Empty: FIMergeDateRangeRefiner.ts's own patternBetween accepts
            // only a bare dash/en-dash, no word - already the engine's own
            // structural fallback, nothing to add here.
            rangeConnectorWords: [],
            // "nyt" - FICasualDateParser.ts's own literal (`case "nyt": return
            // references.now(...)`).
            nowWords: ["nyt"],
            // Empty: FIWeekdayParser.ts's own PATTERN has no leading
            // preposition slot at all (unlike RU/UK's "в"/"у") - a bare
            // weekday or a modifier+weekday matches with nothing before it.
            // Oracle-confirmed: "maanantai" and "ensi maanantai" both start
            // the match at index 0 with no consumed prefix.
            weekdayPrefixWords: [],
            timeOfDayConnectorWords: [],
            yearMarkerWords: [],
            weekdaySuffixExclusionWords: [],
            dayMarkerWords: [],
            timeOfDayPrefixWords: [],
            durationFillerWords: [],
            durationConnectorWords: [],
            // Empty: FIMergeDateTimeRefiner.ts's own patternBetween is
            // "T|klo|kello|,|-" - "klo"/"kello" are ALREADY timePrefixWords
            // above (accepted as glue per that field's own doc comment), so
            // nothing new is needed here, the same conclusion RU/UK reached.
            dateTimeGlueWords: []
        )
    }

    // Finnish numeric/little-endian dates are day-month-year ("15. elokuuta
    // 2012"), week starts Monday (Foundation convention, Monday = 2).
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2)
    }

    /// Bespoke grammar the data tables cannot express - see FIParsers.swift.
    /// Same shape as RU's/UK's own equivalent: a nonzero modifier fused onto a
    /// time-of-day word, outside CasualDateParser's generic anchor mechanism.
    public var additionalParsers: [Parser] {
        [FICasualLastNightParser()]
    }
}

// MARK: - Vocabulary data

private extension FILocale {
    // Chrono/JS weekday numbering (Sunday = 0), matching WEEKDAY_DICTIONARY.
    // Only three forms per day (full, inessive "-na", short) - Finnish's
    // weekday words do not inflect nearly as much as Russian's do.
    static let weekdays: [String: Int] = [
        "sunnuntai": 0, "sunnuntaina": 0, "su": 0,
        "maanantai": 1, "maanantaina": 1, "ma": 1,
        "tiistai": 2, "tiistaina": 2, "ti": 2,
        "keskiviikko": 3, "keskiviikkona": 3, "ke": 3,
        "torstai": 4, "torstaina": 4, "to": 4,
        "perjantai": 5, "perjantaina": 5, "pe": 5,
        "lauantai": 6, "lauantaina": 6, "la": 6,
    ]

    // MONTH_DICTIONARY: full nominative ("tammikuu"), partitive
    // ("tammikuuta"), genitive ("tammikuun"), and a short stem ("tammi") per
    // month - four spellings, all one value, same multi-key technique as
    // every other ported locale.
    static let months: [String: Int] = [
        "tammikuu": 1, "tammikuuta": 1, "tammikuun": 1, "tammi": 1,
        "helmikuu": 2, "helmikuuta": 2, "helmikuun": 2, "helmi": 2,
        "maaliskuu": 3, "maaliskuuta": 3, "maaliskuun": 3, "maalis": 3,
        "huhtikuu": 4, "huhtikuuta": 4, "huhtikuun": 4, "huhti": 4,
        "toukokuu": 5, "toukokuuta": 5, "toukokuun": 5, "touko": 5,
        "kesäkuu": 6, "kesäkuuta": 6, "kesäkuun": 6, "kesä": 6,
        "heinäkuu": 7, "heinäkuuta": 7, "heinäkuun": 7, "heinä": 7,
        "elokuu": 8, "elokuuta": 8, "elokuun": 8, "elo": 8,
        "syyskuu": 9, "syyskuuta": 9, "syyskuun": 9, "syys": 9,
        "lokakuu": 10, "lokakuuta": 10, "lokakuun": 10, "loka": 10,
        "marraskuu": 11, "marraskuuta": 11, "marraskuun": 11, "marras": 11,
        "joulukuu": 12, "joulukuuta": 12, "joulukuun": 12, "joulu": 12,
    ]

    // INTEGER_WORD_DICTIONARY: nominative and genitive for 1-6, nominative
    // only for 7-10 (chrono's own dictionary has no genitive listed for those
    // three - not an omission on Khac's part, the source dictionary itself
    // stops inflecting there).
    static let integerWords: [String: Int] = [
        "yksi": 1, "yhden": 1,
        "kaksi": 2, "kahden": 2,
        "kolme": 3, "kolmen": 3,
        "neljä": 4, "neljän": 4,
        "viisi": 5, "viiden": 5,
        "kuusi": 6, "kuuden": 6,
        "seitsemän": 7,
        "kahdeksan": 8,
        "yhdeksän": 9,
        "kymmenen": 10,
    ]

    // TIME_UNIT_DICTIONARY: a single-letter abbreviation, a genitive, a
    // partitive, and a nominative per unit (day/week/month use a 2-letter
    // abbreviation instead - "pv"/"vk"/"kk", chrono's own choice, not Khac's).
    static let timeUnits: [String: Calendar.Component] = [
        "s": .second, "sek": .second, "sekunti": .second, "sekuntia": .second, "sekunnin": .second,
        "min": .minute, "minuutti": .minute, "minuuttia": .minute, "minuutin": .minute,
        "t": .hour, "tunti": .hour, "tuntia": .hour, "tunnin": .hour,
        "pv": .day, "päivä": .day, "päivää": .day, "päivän": .day,
        "vk": .weekOfYear, "viikko": .weekOfYear, "viikkoa": .weekOfYear, "viikon": .weekOfYear,
        "kk": .month, "kuukausi": .month, "kuukautta": .month, "kuukauden": .month,
        "vuosi": .year, "vuotta": .year, "vuoden": .year,
    ]

    // TIME_UNIT_NO_ABBR_DICTIONARY verbatim - the full-word subset of
    // `timeUnits` above, used by strict mode exactly like every other locale's
    // fullTimeUnitNames.
    static let fullTimeUnitNames: Set<String> = [
        "sekunti", "sekuntia", "sekunnin",
        "minuutti", "minuuttia", "minuutin",
        "tunti", "tuntia", "tunnin",
        "päivä", "päivää", "päivän",
        "viikko", "viikkoa", "viikon",
        "kuukausi", "kuukautta", "kuukauden",
        "vuosi", "vuotta", "vuoden",
    ]

    // Every "last/next" word Finnish uses, across the two constructs that
    // read this table:
    //   1. Weekday adjective agreement (FIWeekdayParser.ts, both its prefix
    //      AND its postfix "viikolla" slot use the SAME three words each
    //      direction): viime/edellinen/edellisenä (last), ensi/seuraava/
    //      seuraavana (next).
    //   2. Counted-duration modifiers (FITimeUnitCasualRelativeFormatParser.ts):
    //      seuraava/seuraavat/seuraavien (next, NOT reversed);
    //      edellinen/edelliset/edellisten/viimeiset/viimeisten/kuluneet/
    //      kuluneiden (last, reversed - "kuluneet" literally "elapsed/past",
    //      "viimeiset" literally "last/final", both source-confirmed
    //      synonyms for "last", not a Khac guess).
    // No 0-valued ("this") entry: chrono's FI source has no "this week"/"this
    // month" phrase parser at all (confirmed by index.ts - there is no
    // FIRelativeDateFormatParser, unlike RU/UK), and "tänä" (the "this" prefix
    // FICasualTimeParser.ts allows before a bare time-of-day word) has no
    // oracle case exercising it, so it is not added here as an untested claim.
    static let relativeModifiers: [String: Int] = [
        "viime": -1, "edellinen": -1, "edellisenä": -1,
        "edelliset": -1, "edellisten": -1, "viimeiset": -1, "viimeisten": -1,
        "kuluneet": -1, "kuluneiden": -1,
        "ensi": 1, "seuraava": 1, "seuraavana": 1, "seuraavat": 1, "seuraavien": 1,
    ]

    // FICasualDateParser.ts's own DATE_GROUP literals (minus "nyt", which is
    // patterns.nowWords - full precision, not a day offset - and minus "viime
    // yönä", the bespoke FICasualLastNightParser's own phrase).
    static let dayReferences: [String: Int] = [
        "tänään": 0,
        "huomenna": 1,
        "ylihuomenna": 2,
        "eilen": -1,
        "toissapäivänä": -2,
    ]

    // FICasualTimeParser.ts's own switch, read both bare and anchored (as
    // TIME_GROUP inside FICasualDateParser's combined pattern - "tänään
    // aamulla"). Values verified against BOTH chrono's own switch AND every
    // hour the ported oracle asserts (6/9/12/15/18/22/0).
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "aamulla": (6, .am), "aamuna": (6, .am),
        "aamupäivällä": (9, .am),
        "päivällä": (12, .am),
        "iltapäivällä": (15, .pm),
        "illalla": (18, .pm),
        "yöllä": (22, .pm),
        "keskiyöllä": (0, .am),
    ]
}
