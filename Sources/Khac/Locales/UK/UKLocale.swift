// UKLocale.swift - Ukrainian locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Ported from wanasit/chrono v2.10.1's Ukrainian source
// (src/locales/uk/constants.ts and parsers/*.ts) as a correctness oracle - the
// FACTS about which words carry which values are ported, chrono's own parser
// CODE is not copied (see NOTICE and Tests/KhacTests/Oracle/README.md).
//
// Ukrainian's grammar is the same SHAPE as Russian's (Slavic sibling: case
// inflection on months/cardinals/ordinals, prefix-agreement modifiers, glued
// half-unit quantifiers, elided counts) - see RULocale.swift's header comment
// for the full account of the gaps this shape exposes. All the same gaps
// recur here, confirming they are engine gaps and not something specific to
// one locale's data. Differences from Russian, where they matter, are called
// out inline rather than repeating RULocale's comments wholesale.
//
// The prefix/suffix gaps reported under KHAC-6 have since landed centrally
// and are wired below with Ukrainian's own words: dayReferencePrefixWords
// (з/із/від), monthPrefixWords and bareMonthPrefixWords (в/у, split the same
// way RU's are - see RULocale.swift's comment on why one shared field broke
// English), dayOrdinalSuffixes (го/ого/е), yearSuffixWords, and
// dayShiftPrefixes (минулого, the flat half of "минулого вечора").
//
// Two gaps remain open, both in UKOracleTests's deferral list with the full
// reason recorded at each case:
//   - DurationExpression's glued-quantifier whitespace requirement blocks
//     "півгодини" (half an hour, one word).
//   - options.elidesDurationCount would read "через тиждень"-style elided
//     counts correctly, but Ukrainian hits the EXACT SAME regression Russian
//     does when it is turned on: its own 0-valued phrase modifiers ("цього",
//     "минулого" bare) collide with RelativeUnitParser's modifierAlt through
//     the same mechanism - see RULocale.swift's `options` comment for the
//     full account. Left off here too, for the same reason.

import Foundation

public struct UKLocale: KhacLocale {
    public let id: LocaleID = .ukrainian

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
            // Empty for the same reason as RU: "ранку"/"вечора" adjust an
            // ATTACHED numeric hour by rule, not by fixed meaning - see
            // meridiemHourRules below.
            meridiem: [:],
            timeOfDay: Self.timeOfDay,
            meridiemHourRules: Self.meridiemHourRules,
            // Empty for the same reason as RU: chrono's own UK year parser
            // recognizes "н.е."/"до н.е." inline inside its own
            // YEAR_PATTERN/parseYearPattern, and no ported case exercises it.
            eraMarkers: [:],
            eraOffsets: [:],
            fullMonthNames: Self.fullMonthNames,
            casualQuantifiers: Self.casualQuantifiers,
            // "минулого" (genitive "last", agreeing with masculine/neuter
            // вечір) written BEFORE a time-of-day word - "минулого вечора" is
            // always yesterday evening, no reference-hour threshold. The flat
            // half of the night-compound problem; see RULocale.swift's
            // dayShiftPrefixes comment for why "минулої" (the fem form used in
            // "минулої ночі") stays off this table.
            dayShiftPrefixes: Self.dayShiftPrefixes
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            // UKTimeExpressionParser.ts's own primaryPrefix:
            // `(?:(?:в|у|о|об|з|із|від)\s*)??` - a wider set than Russian's
            // в/с. Oracle-confirmed: "об 11 ранку" (об), "в 11 вечора" (в),
            // "з 10 до 11 ранку" (з), "із 10 до 11 вечора" (із), "о 12" (о).
            timePrefixWords: ["в", "у", "о", "об", "з", "із", "від"],
            dateConnectorWords: [],
            clockHourWords: [],
            clockMinuteWords: [],
            clockSecondWords: [],
            // "тому" (ago) - UKTimeUnitAgoFormatParser.ts's own literal.
            relativePastWords: ["тому"],
            // "через"/"після" from UKTimeUnitCasualRelativeFormatParser.ts's
            // own prefix set (both NOT reversed there, i.e. future-reading);
            // "протягом"/"на протязі"/"упродовж"/"впродовж" from
            // UKTimeUnitWithinFormatParser.ts's own required prefix (its
            // forwardDate branch only makes this optional, never removes it
            // as a valid reading - same fit as RU's "в течение").
            relativeFutureWords: ["через", "після", "протягом", "на протязі", "упродовж", "впродовж"],
            futureSuffixWords: [],
            // "і до" / "і по" / "до" / "по" from UKMergeDateRangeRefiner.ts's
            // patternBetween (bare hyphen handled by the engine's own
            // fallback). Oracle-confirmed: "з 10 до 11 ранку",
            // "із 10 по 22 серпня 2012" (the "із" prefix itself is the
            // reported dayReferencePrefixWords/monthPrefixWords gap, not this
            // field's job).
            rangeConnectorWords: ["і до", "і по", "до", "по"],
            // "зараз" - UKCasualTimeParser.ts's own literal check.
            nowWords: ["зараз"],
            // "в" and "у" both prefix a weekday in UKWeekdayParser.ts (two
            // separate optional groups there, `(?:в\s*?)?(?:у\s*?)?` - one
            // shared optional slot here covers both, since no oracle case
            // needs both at once). Oracle-confirmed: "у п'ятницю" (у),
            // "в минулий четвер" (в), "в наступний вівторок" (в).
            weekdayPrefixWords: ["в", "у"],
            // "з"/"із"/"від" lead a bare day reference ("від сьогодні") -
            // UKCasualDateParser.ts's own optional prefix. Oracle-confirmed:
            // "Подія від сьогодні і до післязавтра" keeps "від" in the match.
            dayReferencePrefixWords: ["з", "із", "від"],
            // "з"/"із" lead a FULL month-name date
            // (UKMonthNameLittleEndianParser.ts's own `(?:з|із)?` prefix).
            // Oracle-confirmed: "із 10 по 22 серпня 2012". Kept separate from
            // bareMonthPrefixWords below for the same reason RU's are split -
            // see RULocale.swift's comment on monthPrefixWords.
            monthPrefixWords: ["з", "із"],
            // "в"/"у" lead a month with NO day (UkMonthNameParser.ts's own
            // `(?:в|у)?` prefix). Oracle-confirmed: "в січні", "у вересні 2012".
            bareMonthPrefixWords: ["в", "у"],
            // ORDINAL_NUMBER_PATTERN's own suffix set: `[0-9]{1,2}(?:го|ого|е)?`
            // - one fewer form than Russian's (no "ое").
            dayOrdinalSuffixes: ["го", "ого", "е"],
            // The mirror of yearMarkerWords, matching RU's own trailing suffix
            // exactly: chrono's own YEAR_PATTERN accepts an optional TRAILING
            // "року"/"рік"/"р"/"р." after the digits. Source-confirmed (the
            // same `const year = "(?:\s+(?:року|рік|р|р.))?"` shape RU has),
            // though no case in the ported uk oracle happens to exercise it.
            yearSuffixWords: ["року", "рік", "р.", "р"],
            timeOfDayConnectorWords: [],
            // Same as RU: no PRECEDING year-marker word (the trailing one is
            // yearSuffixWords above).
            yearMarkerWords: [],
            weekdaySuffixExclusionWords: [],
            dayMarkerWords: [],
            // Empty, unlike RU: Ukrainian's "at noon"/"at midnight" are
            // ALREADY ONE FUSED WORD - "опівдні" ("о" + "півдні"), "опівночі"
            // ("о" + "півночі") - not a separate preposition plus noun the
            // way Russian's "в полдень"/"в полночь" are two words. No prefix
            // hook needed; these are ordinary flat timeOfDay keys below.
            timeOfDayPrefixWords: [],
            // "близько"/"приблизно" from TIME_UNITS_PATTERN's own filler;
            // "приблизно"/"орієнтовно" from UKTimeUnitWithinFormatParser.ts's
            // own filler - union of both, source-confirmed, no oracle case
            // exercises this (same as RU's "около"/"примерно").
            durationFillerWords: ["близько", "приблизно", "орієнтовно"],
            durationConnectorWords: [],
            dateTimeGlueWords: []
        )
    }

    // Ukrainian numeric dates are day.month.year ("10.08.2012" - confirmed by
    // UkMonthNameLittleEndianCases's identical case to RU's), week starts
    // Monday (Foundation convention, Monday = 2).
    //
    // elidesDurationCount is OFF, for the identical reason RULocale documents
    // at length on its own `options`: Ukrainian ALSO has 0-valued phrase
    // modifiers ("цього", bare "минулого"), and turning the flag on lets
    // RelativeUnitParser's modifierAlt claim "цього тижня"-shaped text before
    // bareModifierAlt gets a turn, then reject it for offset 0 with no
    // fallback. Verified empirically here too, not assumed from ru's result -
    // flipping the flag reproduces the same regression on uk's own oracle.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2, elidesDurationCount: false)
    }

    /// Bespoke grammar the data tables cannot express - see UKParsers.swift.
    /// Same shape as RU's RUCasualNightEveningParser and EN's
    /// ENCasualCompoundParser: a nonzero modifier fused onto a time-of-day
    /// word, which CasualDateParser's generic anchor mechanism does not reach.
    public var additionalParsers: [Parser] {
        [UKCasualNightEveningParser()]
    }
}

// MARK: - Vocabulary data

private extension UKLocale {
    // "минулого" only - see the doc comment on the call site for why
    // "минулої" (the form "минулої ночі" needs) is deliberately absent.
    static let dayShiftPrefixes: [String: Int] = [
        "минулого": -1,
    ]

    // Chrono/JS weekday numbering (Sunday = 0), matching WEEKDAY_DICTIONARY.
    static let weekdays: [String: Int] = [
        "неділя": 0, "неділі": 0, "неділю": 0, "нд": 0, "нд.": 0,
        "понеділок": 1, "понеділка": 1, "пн": 1, "пн.": 1,
        "вівторок": 2, "вівторка": 2, "вт": 2, "вт.": 2,
        "середа": 3, "середи": 3, "середу": 3, "ср": 3, "ср.": 3,
        "четвер": 4, "четверга": 4, "четвергу": 4, "чт": 4, "чт.": 4,
        "п'ятниця": 5, "п'ятниці": 5, "п'ятницю": 5, "пт": 5, "пт.": 5,
        "субота": 6, "суботи": 6, "суботу": 6, "сб": 6, "сб.": 6,
    ]

    // FULL_MONTH_NAME_DICTIONARY (nominative/genitive/locative) plus
    // MONTH_DICTIONARY's abbreviations. "серп"/"серп."/"сер"/"cер." are FOUR
    // distinct abbreviation spellings chrono lists for August (note the last
    // one's Latin "c" - a typo already present in chrono's own source, kept
    // here so the same input string it accepts still matches; the folded
    // lookup is by exact string so a Latin "c" and Cyrillic "с" are genuinely
    // different keys, not a duplicate).
    static let months: [String: Int] = [
        "січень": 1, "січня": 1, "січні": 1, "січ": 1, "січ.": 1,
        "лютий": 2, "лютого": 2, "лютому": 2, "лют": 2, "лют.": 2,
        "березень": 3, "березня": 3, "березні": 3, "бер": 3, "бер.": 3,
        "квітень": 4, "квітня": 4, "квітні": 4, "квіт": 4, "квіт.": 4,
        "травень": 5, "травня": 5, "травні": 5, "трав": 5, "трав.": 5,
        "червень": 6, "червня": 6, "червні": 6, "черв": 6, "черв.": 6,
        "липень": 7, "липня": 7, "липні": 7, "лип": 7, "лип.": 7,
        "серпень": 8, "серпня": 8, "серпні": 8, "серп": 8, "серп.": 8, "сер": 8, "cер.": 8,
        "вересень": 9, "вересня": 9, "вересні": 9, "вер": 9, "вер.": 9, "верес": 9, "верес.": 9,
        "жовтень": 10, "жовтня": 10, "жовтні": 10, "жовт": 10, "жовт.": 10,
        "листопад": 11, "листопада": 11, "листопаду": 11, "листоп": 11, "листоп.": 11,
        "грудень": 12, "грудня": 12, "грудні": 12, "груд": 12, "груд.": 12,
    ]

    // INTEGER_WORD_DICTIONARY: nominative and oblique forms.
    static let integerWords: [String: Int] = [
        "один": 1, "одна": 1, "одної": 1, "одну": 1,
        "два": 2, "дві": 2, "двох": 2,
        "три": 3, "трьох": 3,
        "чотири": 4, "чотирьох": 4,
        "п'ять": 5, "п'яти": 5,
        "шість": 6, "шести": 6,
        "сім": 7, "семи": 7,
        "вісім": 8, "восьми": 8,
        "дев'ять": 9, "дев'яти": 9,
        "десять": 10, "десяти": 10,
        "одинадцять": 11, "одинадцяти": 11,
        "дванадцять": 12, "дванадцяти": 12,
    ]

    // ORDINAL_WORD_DICTIONARY: nominative and genitive per number 1-31.
    // "чотинрнадцятого" (14, genitive) is chrono's own spelling - kept
    // byte-exact rather than "corrected" to "чотирнадцятого", since the
    // engine only needs to recognize whatever chrono's own test inputs use.
    static let ordinals: [String: Int] = [
        "перше": 1, "першого": 1,
        "друге": 2, "другого": 2,
        "третє": 3, "третього": 3,
        "четверте": 4, "четвертого": 4,
        "п'яте": 5, "п'ятого": 5,
        "шосте": 6, "шостого": 6,
        "сьоме": 7, "сьомого": 7,
        "восьме": 8, "восьмого": 8,
        "дев'яте": 9, "дев'ятого": 9,
        "десяте": 10, "десятого": 10,
        "одинадцяте": 11, "одинадцятого": 11,
        "дванадцяте": 12, "дванадцятого": 12,
        "тринадцяте": 13, "тринадцятого": 13,
        "чотирнадцяте": 14, "чотинрнадцятого": 14,
        "п'ятнадцяте": 15, "п'ятнадцятого": 15,
        "шістнадцяте": 16, "шістнадцятого": 16,
        "сімнадцяте": 17, "сімнадцятого": 17,
        "вісімнадцяте": 18, "вісімнадцятого": 18,
        "дев'ятнадцяте": 19, "дев'ятнадцятого": 19,
        "двадцяте": 20, "двадцятого": 20,
        "двадцять перше": 21, "двадцять першого": 21,
        "двадцять друге": 22, "двадцять другого": 22,
        "двадцять третє": 23, "двадцять третього": 23,
        "двадцять четверте": 24, "двадцять четвертого": 24,
        "двадцять п'яте": 25, "двадцять п'ятого": 25,
        "двадцять шосте": 26, "двадцять шостого": 26,
        "двадцять сьоме": 27, "двадцять сьомого": 27,
        "двадцять восьме": 28, "двадцять восьмого": 28,
        "двадцять дев'яте": 29, "двадцять дев'ятого": 29,
        "тридцяте": 30, "тридцятого": 30,
        "тридцять перше": 31, "тридцять першого": 31,
    ]

    // TIME_UNIT_DICTIONARY. Note "година" (hour) is spelled entirely
    // differently from Russian "час" - false friends across the two
    // languages, not a shared root, so nothing is reused from RULocale here.
    // "доба"/"добу" (a full day-and-night) join "день"/"дня" under .day,
    // mirroring RU's "сутки"/"суток" - both real words for the same unit.
    static let timeUnits: [String: Calendar.Component] = [
        "сек": .second, "секунда": .second, "секунд": .second, "секунди": .second,
        "секунду": .second, "секундочок": .second, "секундочки": .second, "секундочку": .second,
        "хв": .minute, "хвилина": .minute, "хвилин": .minute, "хвилини": .minute,
        "хвилину": .minute, "хвилинок": .minute, "хвилинки": .minute, "хвилинку": .minute,
        "хвилиночок": .minute, "хвилиночки": .minute, "хвилиночку": .minute,
        "год": .hour, "година": .hour, "годин": .hour, "години": .hour,
        "годину": .hour, "годинка": .hour, "годинок": .hour, "годинки": .hour, "годинку": .hour,
        "день": .day, "дня": .day, "днів": .day, "дні": .day, "доба": .day, "добу": .day,
        "тиждень": .weekOfYear, "тижню": .weekOfYear, "тижня": .weekOfYear,
        "тижні": .weekOfYear, "тижнів": .weekOfYear,
        "місяць": .month, "місяців": .month, "місяці": .month, "місяця": .month,
        "квартал": .quarter, "кварталу": .quarter, "квартала": .quarter,
        "кварталів": .quarter, "кварталі": .quarter,
        "рік": .year, "року": .year, "році": .year, "років": .year, "роки": .year,
    ]

    // Every "last/next/this" word Ukrainian uses, across the same three
    // constructs RU's own table documents in full - see RULocale.swift's
    // `relativeModifiers` comment for why one shared table serves all three
    // and why a form is listed even where chrono's own bespoke regex only
    // wired it into ONE of the two WeekdayParser positions.
    //
    //   1. Weekday adjective agreement (UKWeekdayParser.ts): цей (this,
    //      prefix); минулого/минулий/попередній/попереднього (last, prefix -
    //      FOUR synonyms, "попередній"/"попереднього" literally "previous",
    //      source-confirmed, not a Khac guess the way EN's own "previous"
    //      extension is); наступного/наступний (next, prefix). Postfix
    //      (with на/у/в ... тижні): цьому/минулому/наступному.
    //   2. "This/next/last <week/month/year/quarter>" phrase modifiers
    //      (UKRelativeDateFormatParser.ts): unlike Russian, Ukrainian's own
    //      regex lists the BARE genitive form ("минулого", "наступного",
    //      "цього") as a fourth alternative alongside each prefixed phrase -
    //      oracle-confirmed ("цього місяця", "минулого місяця",
    //      "наступного року" all appear with NO leading preposition at all,
    //      next to "на цьому тижні"/"у минулому році" which DO have one).
    //   3. Counted-duration modifiers (UKTimeUnitCasualRelativeFormatParser.ts):
    //      "останні"/"минулі" (last, reversed); "майбутні"/"наступні"/"ці"
    //      (next/this, NOT reversed - chrono's own switch only reverses
    //      "останні"/"минулі"/"-").
    static let relativeModifiers: [String: Int] = [
        // "цієї" (genitive feminine, agreeing with "ніч") is the form
        // CasualDateParser's anchor mechanism needs to read "цієї ночі"
        // (oracle-confirmed) - a fourth grammatical form of "this" beyond the
        // three UKWeekdayParser.ts/UKRelativeDateFormatParser.ts themselves
        // use, the same class of minimal addition as RU's own "этим".
        "цей": 0, "цього": 0, "цьому": 0, "цієї": 0,
        "на цьому": 0, "в цьому": 0, "у цьому": 0,
        "минулого": -1, "минулий": -1, "попередній": -1, "попереднього": -1, "минулому": -1,
        "останні": -1, "минулі": -1,
        "в минулому": -1, "у минулому": -1, "на минулому": -1,
        "наступного": 1, "наступний": 1, "наступному": 1,
        "майбутні": 1, "наступні": 1, "ці": 1,
        "на наступному": 1, "в наступному": 1, "у наступному": 1,
    ]

    // UKCasualDateParser.ts's own literal switch. "з"/"із"/"від" prefixing
    // these is the reported dayReferencePrefixWords gap; the words
    // themselves are complete data regardless.
    static let dayReferences: [String: Int] = [
        "сьогодні": 0,
        "завтра": 1,
        "вчора": -1,
        "післязавтра": 2,
        "післяпіслязавтра": 3,
        "позавчора": -2,
        "позапозавчора": -3,
    ]

    // Standalone casual times of day (bare or anchored - "ввечері", "цього
    // ранку" - never attached to a stated hour). "ранку"/"вечора" also serve
    // meridiemHourRules below for the attached-hour case; both readings
    // coexist without conflict, the same as RU's "утра"/"вечера" and EN's own
    // "night" precedent. "опівдні" and "опівночі" are single fused words in
    // Ukrainian (see the empty timeOfDayPrefixWords note in `patterns`
    // above), unlike Russian's separately-prefixed "в полдень"/"в полночь".
    //
    // "ночі" (bare genitive "of night") is a SEPARATE word from "вночі"
    // (fused "at night") - Ukrainian uses it only as the second half of a
    // this/last/next compound ("цієї ночі", "минулої ночі", "наступної
    // ночі"), never fused with "в" the way the bare adverb is. It needs its
    // own entry for CasualDateParser's anchor mechanism to read "цієї ночі"
    // ("цієї" + "ночі"): oracle-confirmed, "Дедлайн цієї ночі" resolves to
    // midnight of the reference day exactly like "вночі" does.
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "вранці": (6, .am), "ранку": (6, .am), "зранку": (6, .am),
        "ввечері": (20, .pm), "вечора": (20, .pm),
        "опівдні": (12, .am),
        "опівночі": (0, .am), "вночі": (0, .am), "ночі": (0, .am),
    ]

    // Hour-dependent suffixes attached to a STATED numeric hour
    // (UKTimeExpressionParser.ts's extractPrimaryTimeComponents override) -
    // same shape and same untested-edge judgment calls as RU's "утра"/"вечера"
    // (see RULocale.swift's own comment on this table for the full reasoning;
    // Ukrainian's "ранку"/"вечора" follow byte-identical hour thresholds in
    // chrono's own source, just spelled differently).
    static let meridiemHourRules: [String: MeridiemHourRule] = [
        "ранку": MeridiemHourRule(baseline: .am, overrides: [12: 12]),
        "вечора": MeridiemHourRule(baseline: .am, overrides: [
            6: 18, 7: 19, 8: 20, 9: 21, 10: 22, 11: 23, 12: 12,
        ]),
    ]

    // The full (non-abbreviated) spellings from FULL_MONTH_NAME_DICTIONARY,
    // all three inflected forms. Ukrainian's abbreviations are all 3-4
    // characters and none collide with a full month name the way RU's "май"
    // does, but the set is still supplied for the same "reject a bare match
    // of at most 3 characters unless it is a full name" guard - "сер" (8,
    // abbreviation) is exactly 3 characters and must NOT be mistaken for one
    // of these.
    static let fullMonthNames: Set<String> = [
        "січень", "січня", "січні",
        "лютий", "лютого", "лютому",
        "березень", "березня", "березні",
        "квітень", "квітня", "квітні",
        "травень", "травня", "травні",
        "червень", "червня", "червні",
        "липень", "липня", "липні",
        "серпень", "серпня", "серпні",
        "вересень", "вересня", "вересні",
        "жовтень", "жовтня", "жовтні",
        "листопад", "листопада", "листопаду",
        "грудень", "грудня", "грудні",
    ]

    // From NUMBER_PATTERN's own vague-count alternatives: "декілька" = 2
    // (chrono's parseNumberPattern literal - NOTE this differs from Russian's
    // "несколько" = 3; the two languages' vague-count words carry different
    // values in chrono's own source, not a copy-paste of RU's table), "пару"
    // = 2 (only the accusative form - chrono's own pattern is `пар(?:у)`, not
    // the three-way пара/пару/пари RU lists), "пів" = 0.5. "пів" is complete,
    // correct data - the glued-quantifier gap (RULocale.swift's header,
    // finding 5) is in DurationExpression's whitespace requirement, not here.
    static let casualQuantifiers: [String: Double] = [
        "декілька": 2,
        "пару": 2,
        "пів": 0.5,
    ]
}
