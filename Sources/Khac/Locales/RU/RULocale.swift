// RULocale.swift - Russian locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Ported from wanasit/chrono v2.10.1's Russian source
// (src/locales/ru/constants.ts and parsers/*.ts) as a correctness oracle - the
// FACTS about which words carry which values are ported, chrono's own parser
// CODE is not copied (see NOTICE and Tests/KhacTests/Oracle/README.md).
//
// Russian inflects its month/cardinal/ordinal words for grammatical case
// (nominative/genitive/prepositional), so a single month or number has several
// valid spellings. That is expressible as several extra keys pointing at the
// same value in Vocabulary's `[String: Int]` tables - the same technique VI
// uses for its own spelling variants ("tháng 3"/"tháng ba" both -> 3). No
// engine change needed for that part.
//
// Several engine gaps were found while building this locale and reported to
// `main` under KHAC-6. Most have since landed centrally and are wired below:
// dayReferencePrefixWords/monthPrefixWords/bareMonthPrefixWords (the missing
// prefix hooks on CasualDateParser and MonthNameParser), dayOrdinalSuffixes
// (the day-ordinal suffix that used to be hardcoded to English st/nd/rd/th),
// yearSuffixWords (a trailing year marker - "2020 года" - where the engine
// only had a LEADING one), and dayShiftPrefixes (a day shift written BEFORE
// the time of day, "прошлым вечером" - the generic mirror of VI's suffix-form
// dayShiftSuffixes).
//
// Two gaps remain open, both in RUOracleTests's deferral list with the full
// reason recorded at each case:
//   - DurationExpression requires real whitespace between a word-count and
//     its unit; Russian "получаса"/"полчаса" (half an hour) is ONE glued word
//     with none.
//   - options.elidesDurationCount exists and would fix "через неделю"-style
//     elided counts, but turning it on regresses 3 different, previously
//     passing cases through an interaction with RelativeUnitParser's
//     modifierAlt - see the long comment on `options` below for the
//     mechanism. Left off until that scoping fix lands.
//
// Still NOT wired: `Vocabulary.dayShiftPrefixes` only covers a FLAT prefix
// shift ("прошлым вечером" is always yesterday, no threshold). "прошлой ночью"
// (last night) is a DIFFERENT problem - the day shift depends on the
// REFERENCE's own clock hour - and main is holding a shared field for that
// across en/de/ru rather than have three locales hardcode it separately.
// RUCasualNightEveningParser (RUParsers.swift) still carries BOTH phrases
// pending that field; it is left exactly as built, per main's instruction,
// and will be migrated down to just the night rule once the field lands.

import Foundation

public struct RULocale: KhacLocale {
    public let id: LocaleID = .russian

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
            // Empty: Russian has no FLAT am/pm word. "утра" and "вечера" both
            // adjust an ATTACHED numeric hour by rule, not by a fixed meaning -
            // see meridiemHourRules below, and its own doc comment on why a word
            // cannot live in both tables at once.
            meridiem: [:],
            timeOfDay: Self.timeOfDay,
            meridiemHourRules: Self.meridiemHourRules,
            // Empty: chrono's RU year parser recognizes "н.э."/"до н.э." inline
            // inside its own YEAR_PATTERN/parseYear, not through a locale era
            // table, and no case in the ported oracle exercises it - nothing to
            // port here without inventing an untested claim.
            eraMarkers: [:],
            eraOffsets: [:],
            fullMonthNames: Self.fullMonthNames,
            casualQuantifiers: Self.casualQuantifiers,
            // "прошлым" (instrumental "last", agreeing with masculine/neuter
            // вечер) written BEFORE a time-of-day word - "прошлым вечером" is
            // always yesterday evening, no reference-hour threshold
            // (casualReferences.yesterdayEvening). This is the flat half of
            // the night-compound problem; see the header comment for why
            // "прошлой" (the fem form used in "прошлой ночью") is NOT here -
            // that construct needs a reference-hour-dependent rule this flat
            // field cannot express, and stays on the bespoke parser pending
            // main's shared field.
            dayShiftPrefixes: Self.dayShiftPrefixes
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            // "в" and "с" both prefix a numeric time expression in chrono's own
            // RUTimeExpressionParser.ts (`primaryPrefix(): (?:(?:в|с)\s*)??`).
            // Oracle-confirmed: "в 11 утра", "в 1", "в 12.30" all keep "в"
            // inside the matched text; "с 10 до 11 утра" keeps "с" as the
            // range's own leading edge. This is TimeExpressionParser's own
            // timePrefixWords hook, already data-driven - no gap here.
            timePrefixWords: ["в", "с"],
            dateConnectorWords: [],
            // RU numeric times are colon/dot separated ("20:32:13", "в 12.30"),
            // never a spelled clock-hour word - no chrono RU parser has a
            // "giờ"/"o'clock" equivalent, so these three stay empty.
            clockHourWords: [],
            clockMinuteWords: [],
            clockSecondWords: [],
            // "назад" (ago) is the ONLY past-suffix chrono's RU dictionary
            // knows (RUTimeUnitAgoFormatParser.ts).
            relativePastWords: ["назад"],
            // Prefix future-direction words. "через"/"спустя"/"после" are RU's
            // "in"/"within" reading in RUTimeUnitCasualRelativeFormatParser.ts's
            // own prefix alternation; "в течение"/"в течении" are RU's
            // "within" reading from RUTimeUnitWithinFormatParser.ts (which
            // REQUIRES this exact prefix when forwardDate is off - chrono has
            // no bare-duration-means-future option for Russian the way EN's
            // forwardDate optional-prefix branch does, so listing it here as
            // an ordinary future-prefix word, not a special case, is the
            // correct fit: RelativeUnitParser's own forwardDate branch only
            // makes the prefix OPTIONAL, it does not remove it as a valid
            // reading).
            relativeFutureWords: ["через", "спустя", "после", "в течение", "в течении"],
            // RU has no future-direction SUFFIX word (nothing plays English
            // "later"/"from now" after the duration) - chrono's own dictionary
            // has none, so this stays empty rather than guessing one.
            futureSuffixWords: [],
            // "и до" / "и по" / "до" / "по" from RUMergeDateRangeRefiner.ts's
            // patternBetween (a bare hyphen is handled by the engine's own
            // fallback, so it needs no entry here). Confirmed against
            // RUTimeExpCases ("с 10 до 11 утра") and
            // RuMonthNameLittleEndianCases ("с 10 по 22 августа 2012" -
            // matching this part; the case's own "с" prefix is a separate,
            // reported gap, not this field's job).
            rangeConnectorWords: ["и до", "и по", "до", "по"],
            // "сейчас" - RUCasualTimeParser.ts's own literal check
            // (`lowerText === "сейчас"` -> references.now()).
            nowWords: ["сейчас"],
            // "в" is RUWeekdayParser.ts's own optional leading preposition
            // (`(?:в\s*?)?` before the modifier+weekday). Oracle-confirmed:
            // "Дедлайн в пятницу..." keeps "в" inside the matched text
            // ("в пятницу"), and "Дедлайн в прошлый четверг!" keeps both "в"
            // AND the modifier ("в прошлый четверг").
            weekdayPrefixWords: ["в"],
            // "с"/"со" lead a bare day reference ("с сегодня") -
            // RUCasualDateParser.ts's own optional prefix.
            dayReferencePrefixWords: ["с", "со"],
            // "с" leads a FULL month-name date ("с 10 по 22 августа 2012") -
            // RUMonthNameLittleEndianParser.ts's own optional prefix. Kept
            // separate from bareMonthPrefixWords below on purpose: sharing one
            // field let the bare-month reading start earlier and swallow a
            // date that had a day (main's finding, reverted after the oracle
            // caught it on English "on Sept 2").
            monthPrefixWords: ["с"],
            // "в" leads a month with NO day ("в январе", "в сентябре 2012") -
            // RUMonthNameParser.ts's own optional prefix.
            bareMonthPrefixWords: ["в"],
            // ORDINAL_NUMBER_PATTERN's own suffix set: `[0-9]{1,2}(?:го|ого|е|ое)?`.
            dayOrdinalSuffixes: ["го", "ого", "е", "ое"],
            // The mirror of yearMarkerWords: chrono's own YEAR_PATTERN accepts
            // an optional TRAILING "года"/"году"/"год"/"г"/"г." after the
            // digits ("25 мая 2020 года"), parseYear strips it back off. This
            // used to have no home in the engine (only a leading marker
            // existed); now it does.
            yearSuffixWords: ["года", "году", "год", "г.", "г"],
            // RU's time-of-day words attach directly to a stated hour with no
            // connector ("11 вечера", not "11 at вечера") - chrono's own
            // primarySuffix has no connector slot, just the bare word.
            timeOfDayConnectorWords: [],
            // RU has no PRECEDING year-marker word the way Vietnamese "năm" is
            // (its trailing marker is yearSuffixWords above).
            yearMarkerWords: [],
            weekdaySuffixExclusionWords: [],
            dayMarkerWords: [],
            // "в" is ALSO RUCasualTimeParser.ts's optional leading word before
            // "полдень"/"полночь" (`в\s*полдень`, `в\s*полночь`), and this field
            // is exactly the general-purpose hook CasualDateParser already
            // exposes for a prefix particle before ANY time-of-day word (VI's
            // "buổi" fills the identical slot for "buổi sáng"). Reusing it here
            // means "в полдень"/"в полночь" need no special-casing: "в" simply
            // becomes optional before утром/вечером/ночью too, which is a
            // harmless superset since those already parse fine bare (oracle-
            // confirmed: "Дедлайн утром", "Дедлайн вечером" both bare).
            timeOfDayPrefixWords: ["в"],
            // "около"/"примерно" - RU's approximation words, from
            // RUTimeUnitWithinFormatParser.ts's own optional prefix
            // (`(?:(?:около|примерно)\s*(?:~\s*)?)?`) and TIME_UNITS_PATTERN's
            // identical filler. No oracle case exercises this (no "около 5
            // часов" style input was ported), but it is a direct, harmless,
            // source-confirmed translation of chrono's own filler set - the
            // same class of addition as EN's own "around"/"about"/"~".
            durationFillerWords: ["около", "примерно"],
            // RU has no duration-clause conjunction in chrono's own grammar
            // (TIME_UNITS_PATTERN joins clauses on bare whitespace only, no
            // "and" word) - left empty rather than inventing one.
            durationConnectorWords: [],
            dateTimeGlueWords: []
        )
    }

    // Russian numeric dates are day.month.year ("10.08.2012" - confirmed by
    // RuMonthNameLittleEndianCases's "10.08.2012" case), and the week starts
    // Monday (Foundation convention: 1 = Sunday ... 7 = Saturday, so Monday = 2).
    //
    // elidesDurationCount is OFF, DESPITE ru needing exactly the reading it
    // describes ("через неделю"/"через месяц" state no count word at all - not
    // even an article the way English "a week" has one). Turning it on
    // regresses three PREVIOUSLY PASSING cases: "на этой неделе"/"в этом
    // месяце"/"в этом году" stop matching entirely. Measured, not assumed -
    // flipping the flag alone reproduces both directions.
    //
    // The mechanism: RelativeUnitParser's modifierAlt ("next 3 weeks") builds
    // its own duration fragment with `abbreviations: false`, and
    // elidesDurationCount widens THAT fragment too, so "на этой" (modifier,
    // offset 0) + the now-elided "неделе" matches modifierAlt BEFORE the
    // engine ever tries bareModifierAlt. modifierAlt's own extraction then
    // rejects offset 0 ("this 2 weeks" is not an expression anyone writes) and
    // returns nil - and because the regex already committed to this
    // alternative at this position, there is no second attempt at
    // bareModifierAlt for the same span. The result is not a wrong answer, it
    // is no answer, for a phrase that used to work.
    //
    // bareModifierAlt already owns the "modifier + bare unit, no count" shape
    // correctly (offset 0 anchors the period, nonzero shifts it) - modifierAlt
    // exists for a DIFFERENT shape, a modifier plus an EXPLICIT count greater
    // than one. So the elided-count alternative never needed to reach
    // modifierAlt at all; reported to main as a scoping fix (gate the elided
    // branch out of the `abbreviations: false` fragment specifically), not
    // something this locale file can express. Kept off here in the meantime -
    // regressing 3 known-good cases to fix 3 different ones is not a net gain,
    // and the 3 elided-count cases stay in RUOracleTests's deferral list with
    // this reason recorded.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2, elidesDurationCount: false)
    }

    /// Bespoke grammar the data tables cannot express - see RUParsers.swift.
    /// Mirrors EN's own ENCasualCompoundParser precedent exactly: a closed set
    /// of compound casual-time phrases whose day-shift depends on the
    /// REFERENCE's own clock hour, which CasualDateParser's generic anchor
    /// mechanism deliberately does not reach (it only pulls zero-valued
    /// "this"-style modifiers into its anchor table, by design - see the
    /// comment on `anchorOffsets` in CasualDateParser.swift).
    public var additionalParsers: [Parser] {
        [RUCasualNightEveningParser()]
    }
}

// MARK: - Vocabulary data

private extension RULocale {
    // "прошлым" only - see the doc comment on the call site for why "прошлой"
    // (the form "прошлой ночью" needs) is deliberately absent.
    static let dayShiftPrefixes: [String: Int] = [
        "прошлым": -1,
    ]

    // Chrono/JS weekday numbering (Sunday = 0), matching WEEKDAY_DICTIONARY in
    // constants.ts exactly. Genitive forms ("воскресенья", "понедельника", ...)
    // are extra spellings for the same value, the same technique as VI's
    // multiple month spellings.
    static let weekdays: [String: Int] = [
        "воскресенье": 0, "воскресенья": 0, "вск": 0, "вск.": 0,
        "понедельник": 1, "понедельника": 1, "пн": 1, "пн.": 1,
        "вторник": 2, "вторника": 2, "вт": 2, "вт.": 2,
        "среда": 3, "среды": 3, "среду": 3, "ср": 3, "ср.": 3,
        "четверг": 4, "четверга": 4, "чт": 4, "чт.": 4,
        "пятница": 5, "пятницу": 5, "пятницы": 5, "пт": 5, "пт.": 5,
        "суббота": 6, "субботу": 6, "субботы": 6, "сб": 6, "сб.": 6,
    ]

    // FULL_MONTH_NAME_DICTIONARY (nominative/genitive/prepositional) plus
    // MONTH_DICTIONARY's abbreviations, straight from constants.ts. Three
    // inflected spellings per month, same value each - "января" (genitive, "of
    // January") and "январе" (prepositional, "in January") are both real
    // spellings a date reads with, not variants Khac invented.
    static let months: [String: Int] = [
        "январь": 1, "января": 1, "январе": 1, "янв": 1, "янв.": 1,
        "февраль": 2, "февраля": 2, "феврале": 2, "фев": 2, "фев.": 2,
        "март": 3, "марта": 3, "марте": 3, "мар": 3, "мар.": 3,
        "апрель": 4, "апреля": 4, "апреле": 4, "апр": 4, "апр.": 4,
        "май": 5, "мая": 5, "мае": 5,
        "июнь": 6, "июня": 6, "июне": 6,
        "июль": 7, "июля": 7, "июле": 7,
        "август": 8, "августа": 8, "августе": 8, "авг": 8, "авг.": 8,
        "сентябрь": 9, "сентября": 9, "сентябре": 9, "сен": 9, "сен.": 9,
        "октябрь": 10, "октября": 10, "октябре": 10, "окт": 10, "окт.": 10,
        "ноябрь": 11, "ноября": 11, "ноябре": 11, "ноя": 11, "ноя.": 11,
        "декабрь": 12, "декабря": 12, "декабре": 12, "дек": 12, "дек.": 12,
    ]

    // INTEGER_WORD_DICTIONARY: nominative and genitive/oblique forms both
    // present in chrono's own table ("два"/"двух" both 2).
    static let integerWords: [String: Int] = [
        "один": 1, "одна": 1, "одной": 1, "одну": 1,
        "два": 2, "две": 2, "двух": 2,
        "три": 3, "трех": 3, "трёх": 3,
        "четыре": 4, "четырех": 4, "четырёх": 4,
        "пять": 5, "пяти": 5,
        "шесть": 6, "шести": 6,
        "семь": 7, "семи": 7,
        "восемь": 8, "восьми": 8,
        "девять": 9, "девяти": 9,
        "десять": 10, "десяти": 10,
        "одиннадцать": 11, "одиннадцати": 11,
        "двенадцать": 12, "двенадцати": 12,
    ]

    // ORDINAL_WORD_DICTIONARY: nominative and genitive per number 1-31, used by
    // MonthNameParser's day-of-month reading ("третье фев 82" = the 3rd,
    // "двадцать пятое мая" = the 25th).
    static let ordinals: [String: Int] = [
        "первое": 1, "первого": 1,
        "второе": 2, "второго": 2,
        "третье": 3, "третьего": 3,
        "четвертое": 4, "четвертого": 4,
        "пятое": 5, "пятого": 5,
        "шестое": 6, "шестого": 6,
        "седьмое": 7, "седьмого": 7,
        "восьмое": 8, "восьмого": 8,
        "девятое": 9, "девятого": 9,
        "десятое": 10, "десятого": 10,
        "одиннадцатое": 11, "одиннадцатого": 11,
        "двенадцатое": 12, "двенадцатого": 12,
        "тринадцатое": 13, "тринадцатого": 13,
        "четырнадцатое": 14, "четырнадцатого": 14,
        "пятнадцатое": 15, "пятнадцатого": 15,
        "шестнадцатое": 16, "шестнадцатого": 16,
        "семнадцатое": 17, "семнадцатого": 17,
        "восемнадцатое": 18, "восемнадцатого": 18,
        "девятнадцатое": 19, "девятнадцатого": 19,
        "двадцатое": 20, "двадцатого": 20,
        "двадцать первое": 21, "двадцать первого": 21,
        "двадцать второе": 22, "двадцать второго": 22,
        "двадцать третье": 23, "двадцать третьего": 23,
        "двадцать четвертое": 24, "двадцать четвертого": 24,
        "двадцать пятое": 25, "двадцать пятого": 25,
        "двадцать шестое": 26, "двадцать шестого": 26,
        "двадцать седьмое": 27, "двадцать седьмого": 27,
        "двадцать восьмое": 28, "двадцать восьмого": 28,
        "двадцать девятое": 29, "двадцать девятого": 29,
        "тридцатое": 30, "тридцатого": 30,
        "тридцать первое": 31, "тридцать первого": 31,
    ]

    // TIME_UNIT_DICTIONARY. "сутки"/"суток" (a full day-and-night, colloquially
    // "day") join "день"/"дня"/"дней" under .day - both are real Russian words
    // for the same calendar unit, source-confirmed rather than invented.
    static let timeUnits: [String: Calendar.Component] = [
        "сек": .second, "секунда": .second, "секунд": .second, "секунды": .second,
        "секунду": .second, "секундочка": .second, "секундочки": .second,
        "секундочек": .second, "секундочку": .second,
        "мин": .minute, "минута": .minute, "минут": .minute, "минуты": .minute,
        "минуту": .minute, "минуток": .minute, "минутки": .minute, "минутку": .minute,
        "минуточек": .minute, "минуточки": .minute, "минуточку": .minute,
        "час": .hour, "часов": .hour, "часа": .hour, "часу": .hour,
        "часиков": .hour, "часика": .hour, "часике": .hour, "часик": .hour,
        "день": .day, "дня": .day, "дней": .day, "суток": .day, "сутки": .day,
        "неделя": .weekOfYear, "неделе": .weekOfYear, "недели": .weekOfYear,
        "неделю": .weekOfYear, "недель": .weekOfYear, "недельке": .weekOfYear,
        "недельки": .weekOfYear, "неделек": .weekOfYear,
        "месяц": .month, "месяце": .month, "месяцев": .month, "месяца": .month,
        "квартал": .quarter, "квартале": .quarter, "кварталов": .quarter,
        "год": .year, "года": .year, "году": .year, "годов": .year, "лет": .year,
        "годик": .year, "годика": .year, "годиков": .year,
    ]

    // Every "last/next/this" word Russian actually uses, across three
    // grammatically distinct constructs that all read the SAME shared
    // relativeModifiers table (per the generic engine's own design, one table
    // serves WeekdayParser's pre/post/suffix groups AND RelativeUnitParser's
    // bare/counted modifier forms):
    //
    //   1. Weekday adjective agreement (RUWeekdayParser.ts): этот/эту/этой
    //      (this), прошлый/прошлую/прошлой (last), следующий/следующую/
    //      следующей/следующего (next). chrono's own bespoke regex only wires
    //      SOME of these forms into ITS prefix slot and others into ITS
    //      postfix slot (grammatical case agreement with what follows -
    //      "этот вторник" prefix, "на этой неделе" postfix); the generic
    //      WeekdayParser exposes both positions to every word uniformly, so
    //      accepting a form in a position chrono itself never tried it in is a
    //      harmless superset, not a new claim.
    //   2. "This/next/last <week/month/year>" phrase modifiers
    //      (RURelativeDateFormatParser.ts): "в прошлом"/"на прошлой" (last),
    //      "на следующей"/"в следующем" (next), "на этой"/"в этом" (this). The
    //      leading preposition varies with the followed noun's GRAMMATICAL
    //      GENDER (в for masculine/neuter месяц/год, на for feminine неделя),
    //      not by free choice, so each phrase is listed whole rather than
    //      trying to split preposition from adjective. Oracle-confirmed
    //      against every RuRelativeCases entry.
    //   3. Counted-duration modifiers (RUTimeUnitCasualRelativeFormatParser.ts):
    //      "последние"/"прошлые" (last), "следующие"/"эти" (next - chrono does
    //      NOT reverse duration for these two, confirmed by its own switch
    //      statement only listing "последние"/"прошлые"/"-" as reversed).
    //
    // "этим" (instrumental "this", agreeing with neuter "утро") is Khac's own
    // minimal addition beyond any one of chrono's three lists above - needed
    // for CasualDateParser's generic anchor mechanism to read "этим утром" (an
    // oracle case), which pulls zero-valued relativeModifiers into its anchor
    // table. Not a new claim about Russian, just the one case-form chrono's
    // own scattered lists happened not to need for anything else.
    //
    // Deliberately NOT added: "прошлым" (instrumental "last", needed for
    // "прошлым вечером") stays OUT of dayReferences (which would let it stand
    // ALONE as a complete date, e.g. a bare "прошлым" with nothing following -
    // ungrammatical Russian that would spuriously produce a "yesterday"-shaped
    // result). It is safe here in relativeModifiers instead, because every
    // consuming branch (WeekdayParser, RelativeUnitParser) requires a
    // weekday/unit partner immediately adjacent - a bare "прошлым" never
    // matches anything on its own. "прошлым вечером" itself is handled by the
    // bespoke RUCasualNightEveningParser (see RUParsers.swift), not by this
    // table, precisely because CasualDateParser's anchor mechanism only pulls
    // ZERO-valued modifiers (the "this" case) into its anchor offsets, by the
    // engine's own design - a nonzero "last"/"next" anchor is out of scope for
    // that mechanism, the same gap EN's own "last night" hit.
    static let relativeModifiers: [String: Int] = [
        "этот": 0, "эту": 0, "этой": 0, "этим": 0, "на этой": 0, "в этом": 0,
        "прошлый": -1, "прошлую": -1, "прошлой": -1, "последние": -1, "прошлые": -1,
        "в прошлом": -1, "на прошлой": -1,
        "следующий": 1, "следующую": 1, "следующей": 1, "следующего": 1,
        "следующие": 1, "эти": 1,
        "на следующей": 1, "в следующем": 1,
    ]

    // RUCasualDateParser.ts's own literal switch. "с"/"со" prefixing these
    // (chrono's own optional group) is the reported dayReferencePrefixWords
    // gap - the words themselves are unaffected by that and are complete data
    // regardless of the missing prefix hook.
    static let dayReferences: [String: Int] = [
        "сегодня": 0,
        "завтра": 1,
        "вчера": -1,
        "послезавтра": 2,
        "послепослезавтра": 3,
        "позавчера": -2,
        "позапозавчера": -3,
    ]

    // Standalone casual times of day, read by CasualDateParser (bare or
    // anchored - "вечером", "этим утром" - never attached to a stated hour).
    // "утра"/"вечера" are ALSO genitive forms RUCasualTimeParser.ts checks for
    // the identical bare meaning (`endsWith("утра")`, `lowerText === "вечера"`)
    // - source-confirmed, not oracle-exercised bare, but the same word is
    // ALSO read by meridiemHourRules below for the attached-hour case, and
    // both readings coexist exactly the way EN's own "night" note describes
    // (different parsers, no conflict, meridiemHourRules checked first).
    // "полдень"/"полночь" always appear with a leading "в" in the ported
    // oracle; that "в" is consumed by patterns.timeOfDayPrefixWords, not baked
    // into these keys.
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "утром": (6, .am), "утра": (6, .am),
        "вечером": (20, .pm), "вечера": (20, .pm),
        // Noon implies AM - chrono's own noon() quirk (casualReferences.ts),
        // matching EN's identical "noon"/"midday" convention exactly.
        "полдень": (12, .am),
        // Bare hour 0. allowDayRoll in the generic CasualDateParser's bare
        // time-of-day branch reproduces chrono's own midnight() ">2 hours"
        // roll-forward for free - no bespoke logic needed here.
        "полночь": (0, .am),
        "ночью": (0, .am),
    ]

    // Hour-dependent suffixes attached to a STATED numeric hour
    // (RUTimeExpressionParser.ts's extractPrimaryTimeComponents override).
    // "утра" always assigns AM and otherwise leaves the hour untouched in
    // chrono's own code (a redundant no-op assignment for hour<12); modeled
    // here as baseline .am with hour 12 pinned to itself so the generic
    // am-baseline math (which would otherwise fold 12 -> 0) does not invent a
    // transformation chrono's own source never performs. No oracle case tests
    // hour 12 with "утра" - this is the more faithful reading of the source,
    // not a tested claim.
    //
    // "вечера": chrono adds 12 only for hour in [6, 12) and tags PM; for
    // hour < 6 it tags AM and leaves the hour unchanged; for hour == 12 (and
    // above) it does NOTHING (no branch matches). Modeled as baseline .am
    // (matches the hour<6 branch exactly: applyMeridiem(.am, hour) is a no-op
    // below 12) with explicit overrides for 6-11 (the +12 branch) and 12
    // pinned to itself for the same reason as "утра" above - untested by any
    // oracle case, a documented judgment call rather than a verified fact.
    static let meridiemHourRules: [String: MeridiemHourRule] = [
        "утра": MeridiemHourRule(baseline: .am, overrides: [12: 12]),
        "вечера": MeridiemHourRule(baseline: .am, overrides: [
            6: 18, 7: 19, 8: 20, 9: 21, 10: 22, 11: 23, 12: 12,
        ]),
    ]

    // The full (non-abbreviated) spellings from FULL_MONTH_NAME_DICTIONARY, in
    // all three inflected forms. RU's abbreviations (янв, фев, мар, апр, авг,
    // сен, окт, ноя, дек) are all exactly 3 characters, so this set is what
    // lets the engine's "reject a bare match of at most 3 characters unless
    // it is a full name" guard tell them apart from "май" (also 3 characters,
    // but a genuine full month name, same as EN's own "may").
    static let fullMonthNames: Set<String> = [
        "январь", "января", "январе",
        "февраль", "февраля", "феврале",
        "март", "марта", "марте",
        "апрель", "апреля", "апреле",
        "май", "мая", "мае",
        "июнь", "июня", "июне",
        "июль", "июля", "июле",
        "август", "августа", "августе",
        "сентябрь", "сентября", "сентябре",
        "октябрь", "октября", "октябре",
        "ноябрь", "ноября", "ноябре",
        "декабрь", "декабря", "декабре",
    ]

    // From NUMBER_PATTERN's own vague-count alternatives: "несколько" = 3
    // (chrono's parseNumberPattern literal), "пара"/"пару"/"пары" = 2, "пол" =
    // 0.5. "пол" is complete, correct data - the gap reported to `main` is in
    // DurationExpression's whitespace requirement between count and unit
    // (Russian glues "пол" directly onto its unit with no space), not in this
    // value.
    static let casualQuantifiers: [String: Double] = [
        "несколько": 3,
        "пара": 2, "пару": 2, "пары": 2,
        "пол": 0.5,
    ]
}
