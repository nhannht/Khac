// Locale.swift - the data-driven locale contract.
//
// A Locale supplies DATA (Vocabulary, PatternSet, LocaleOptions) that the shared
// generic parsers consume. Adding a locale is filling data tables, not writing
// parser classes. The escape hatch - additionalParsers / additionalRefiners -
// exists from day 1 for genuinely bespoke grammar (CJK numerals, etc.).
//
// FREEZE CONTRACT for en/vi executors:
//   - The protocols (Locale, Parser, Refiner) and the ParserResult enum are a
//     HARD freeze. Their names and method signatures will not change.
//   - The data structs (Vocabulary, PatternSet, LocaleOptions) are frozen by
//     NAME and grow ADDITIVELY only: every stored property has a default and the
//     memberwise init defaults every parameter, so new fields never break an
//     existing call site. Fill only the fields you need.

import Foundation

// MARK: - Identifiers and small value types

/// Stable identifier for a locale. String-backed so the set can grow without
/// renumbering.
public enum LocaleID: String, CaseIterable, Sendable, Hashable {
    case english = "en"
    case vietnamese = "vi"
    case german = "de"
    case spanish = "es"
    case finnish = "fi"
    case french = "fr"
    case italian = "it"
    case japanese = "ja"
    case dutch = "nl"
    case portuguese = "pt"
    case russian = "ru"
    case swedish = "sv"
    case ukrainian = "uk"
    case chinese = "zh"
}

/// Time-of-day half. Raw values match chrono (am = 0, pm = 1).
public enum Meridiem: Int, Sendable, Hashable {
    case am = 0
    case pm = 1
}

/// Resolves a numeric clock hour that carries an hour-DEPENDENT time-of-day word,
/// where a flat am/pm cannot express the meaning. Vietnamese "trưa" (midday) and
/// "đêm" (night) are the motivating cases: "1 giờ trưa" = 13:00 but "11 giờ trưa"
/// = 11:00; "12 giờ đêm" = 00:00 but "10 giờ đêm" = 22:00.
///
/// `baseline` is the default am/pm reading applied like an ordinary meridiem word
/// (am: 12 -> 0, else keep; pm: keep 12, else +12). `overrides` maps a stated
/// 1-12 clock hour to an explicit 24h hour and WINS over the baseline. So "trưa"
/// is `.pm` with 11 and 12 kept as-is; "đêm" is `.am` with 8-11 pushed to evening.
public struct MeridiemHourRule: Sendable, Hashable {
    /// Default am/pm reading for hours not listed in `overrides`.
    public var baseline: Meridiem
    /// Stated hour (1-12) -> explicit 24h hour, overriding `baseline`.
    public var overrides: [Int: Int]

    public init(baseline: Meridiem, overrides: [Int: Int] = [:]) {
        self.baseline = baseline
        self.overrides = overrides
    }
}

/// Numeric date field order for a locale, e.g. 3/4 as day/month vs month/day.
public enum DateOrder: Sendable, Hashable {
    case dayMonth
    case monthDay
}

// MARK: - Vocabulary (the bulk of locale data)

/// Word tables that map locale text to semantic values. Case is handled by the
/// engine (matching is case-insensitive), so keys should be lowercase.
///
/// Grows additively: add fields with defaults, never remove or retype.
public struct Vocabulary {
    /// Weekday names to the chrono/JS weekday number: "sunday": 0, "monday": 1,
    /// ... "saturday": 6 (matches `Weekday.sunday`/`Weekday.saturday` and the
    /// oracle - NOT Foundation's 1 = Sunday). Include short forms and localized
    /// names. The engine converts to Foundation numbering internally.
    public var weekdays: [String: Int]
    /// "january": 1 ... "december": 12 ; also short and localized names.
    public var months: [String: Int]
    /// Spelled-out cardinals: "one": 1 ... "twelve": 12 (and beyond if useful).
    public var integerWords: [String: Int]
    /// Ordinals as words: "first": 1, "second": 2, ...
    public var ordinals: [String: Int]
    /// Relative unit words mapped to a calendar component:
    /// "day": .day, "week": .weekOfYear, "month": .month, "year": .year.
    public var timeUnits: [String: Calendar.Component]
    /// Direction words: "next"/"tới": +1, "last"/"qua": -1, "this"/"này": 0.
    public var relativeModifiers: [String: Int]
    /// Day anchors relative to reference: "today": 0, "tomorrow": +1, "hôm kia": -2.
    public var dayReferences: [String: Int]
    /// Meridiem words: "am"/"sáng": .am, "pm"/"chiều": .pm.
    public var meridiem: [String: Meridiem]
    /// Named times of day. hour is 24h; optional meridiem disambiguates when the
    /// hour alone is ambiguous. "noon": (12, nil), "tối": (19, .pm).
    public var timeOfDay: [String: (hour: Int, meridiem: Meridiem?)]
    /// Day-shift words that attach as a SUFFIX to a time-of-day word: Vietnamese
    /// "sáng mai" (tomorrow morning) is "sáng" + the shift "mai": +1.
    ///
    /// A shift word is recognized ONLY directly after a time-of-day word, and
    /// ONLY in the exact case written here. Both conditions are load-bearing, and
    /// keys must therefore be lowercase.
    ///
    /// Adjacency alone is not sufficient. The slot right after a fronted time
    /// adverbial is where a SUBJECT sits in ordinary Vietnamese, so "chiều Mai
    /// đến" (Mai arrives in the afternoon) presents exactly as "chiều mai đến"
    /// (arriving tomorrow afternoon). Since Vietnamese capitalizes proper nouns
    /// and never capitalizes these suffixes mid-sentence, case is the only signal
    /// that separates a name from a date here - there is no syntactic one, because
    /// pro-drop lets the temporal reading omit its subject as well.
    ///
    /// The residue is deliberate: in all-lowercase text the two readings are
    /// ambiguous to a native reader too, and a stated date wins. That trade is
    /// chosen, not overlooked - a missed date fails loudly and the user retypes
    /// it, while a misread name creates a plausible wrong entry nobody is told
    /// about.
    ///
    /// A shift word resolves to exactly what the locale's equivalent day
    /// reference resolves to - a certain calendar date and no clock - and it
    /// matches ALONE, reading the time-of-day word through a lookbehind rather
    /// than consuming it. That is what keeps it out of the way of a stated hour:
    /// "7 giờ sáng mai" holds one time of day, and TimeExpressionParser needs it
    /// to read the 7. The date-time merge then joins the two halves, the same way
    /// it already joins "7 giờ sáng" to a spelled-out "ngày mai".
    ///
    /// Two encodings were tried before and both failed on the same word:
    ///
    /// - Whole `dayReferences` keys ("sáng mai" as one entry). `dayReferences`
    ///   carries a day offset only, so the compound resolved the day and then took
    ///   its CLOCK from the reference, answering 20:00 for "sáng mai" asked at
    ///   20:00.
    /// - A suffix of the time-of-day match ("sáng mai" as one span). This got the
    ///   bare phrase right and lost a stated hour: "7 giờ sáng mai" produced two
    ///   results that both claimed "sáng", and the one whose three certain fields
    ///   were DERIVED from the reference outranked the one whose two were written
    ///   down, so the answer was 09:00 rather than 07:00.
    ///
    /// Empty for locales without the pattern.
    public var dayShiftSuffixes: [String: Int]
    /// The same thing on the other side of the time-of-day word: a day shift
    /// written BEFORE it, as Russian "прошлым вечером" (last evening) and
    /// Ukrainian do. Resolves identically - a certain calendar date, no clock,
    /// matched alone with the time-of-day word read through a LOOKAHEAD rather
    /// than consumed - so the date-time merge joins the two halves exactly as it
    /// does for the suffix form.
    ///
    /// This exists because the concept was, briefly, a data field on one side and
    /// a hand-written parser on the other. Vietnamese put the suffix form in
    /// `dayShiftSuffixes`; Russian and Ukrainian need the prefix form, and the
    /// alternative was a bespoke parser per Slavic locale for a shape Vietnamese
    /// already expressed as data. Two code paths for one concept, kept in step by
    /// hand, is the thing this design is meant not to have.
    ///
    /// One asymmetry with the suffix table is deliberate: the suffix form matches
    /// CASE-SENSITIVELY and this one does not. That rule is Vietnamese-specific
    /// and load-bearing there - "mai" is tomorrow, "Mai" is a common given name,
    /// and pro-drop makes "chiều Mai đến" and "chiều mai đến" structurally
    /// identical, so case is the only signal separating them. A PREFIX sits where
    /// a sentence-initial capital is ordinary and carries no information, so
    /// requiring lowercase there would reject correct input to guard against an
    /// ambiguity that only arises after the time word.
    ///
    /// Empty for locales without the pattern.
    public var dayShiftPrefixes: [String: Int]
    /// Hour-DEPENDENT time-of-day words that adjust an ATTACHED numeric hour
    /// ("1 giờ trưa", "10 giờ đêm"), keyed by the same lowercase word as
    /// `meridiem`/`timeOfDay`. Resolved BEFORE the flat `meridiem` table, so a
    /// word here must NOT also appear in `meridiem`. Leave empty for locales
    /// whose time-of-day words are all flat am/pm (English).
    public var meridiemHourRules: [String: MeridiemHourRule]
    /// Era markers applied to a year: "bc"/"tcn": -1, "ad"/"scn": +1.
    public var eraMarkers: [String: Int]
    /// Era markers that OFFSET a year rather than sign it: Buddhist era
    /// "be": -543 ("2555 BE" is 2012 CE). A word lives in exactly one of the
    /// two era tables - a sign cannot express an offset and vice versa.
    public var eraOffsets: [String: Int]
    /// Which keys of `months` are FULL month names rather than abbreviations,
    /// lowercased. A bare abbreviation is too weak to be a date on its own: in
    /// running English prose "mar" or "jan" is far more often a name or a typo
    /// than a month, while "may" is a real word people do write alone.
    ///
    /// Leave EMPTY to switch the filter off entirely, which is the right choice
    /// for a locale whose month words are long enough not to collide (Vietnamese
    /// "tháng 3" is never mistaken for anything else). A locale that fills this
    /// opts IN to rejecting a bare month-only match of at most three characters
    /// unless the word appears here.
    public var fullMonthNames: Set<String>
    /// Which keys of `timeUnits` are FULL words rather than abbreviations,
    /// lowercased. Strict mode accepts only these, so "5 minutes ago" parses but
    /// "5m ago" and "5 h ago" do not - an abbreviation is exactly the kind of
    /// loose shorthand strict mode exists to refuse.
    ///
    /// Leave EMPTY to switch the restriction off, so a locale that does not
    /// declare it behaves identically in both modes.
    public var fullTimeUnitNames: Set<String>
    /// Vague counts that stand in for a number: "a"/"an"/"the" = 1, "a couple"
    /// = 2, "a few" = 3, "several" = 7, "half" = 0.5.
    ///
    /// Fractional on purpose. "half an hour" is 30 minutes, so a whole-number
    /// table could not express it - the fraction cascades into the next smaller
    /// unit (see RelativeDuration). Multi-word keys are fine and win over their
    /// own prefixes, since the alternation is built longest-first.
    public var casualQuantifiers: [String: Double]

    public init(
        weekdays: [String: Int] = [:],
        months: [String: Int] = [:],
        integerWords: [String: Int] = [:],
        ordinals: [String: Int] = [:],
        timeUnits: [String: Calendar.Component] = [:],
        relativeModifiers: [String: Int] = [:],
        dayReferences: [String: Int] = [:],
        meridiem: [String: Meridiem] = [:],
        timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [:],
        meridiemHourRules: [String: MeridiemHourRule] = [:],
        eraMarkers: [String: Int] = [:],
        eraOffsets: [String: Int] = [:],
        fullMonthNames: Set<String> = [],
        fullTimeUnitNames: Set<String> = [],
        casualQuantifiers: [String: Double] = [:],
        dayShiftSuffixes: [String: Int] = [:],
        dayShiftPrefixes: [String: Int] = [:]
    ) {
        self.dayShiftSuffixes = dayShiftSuffixes
        self.dayShiftPrefixes = dayShiftPrefixes
        self.weekdays = weekdays
        self.months = months
        self.integerWords = integerWords
        self.ordinals = ordinals
        self.timeUnits = timeUnits
        self.relativeModifiers = relativeModifiers
        self.dayReferences = dayReferences
        self.meridiem = meridiem
        self.timeOfDay = timeOfDay
        self.meridiemHourRules = meridiemHourRules
        self.eraMarkers = eraMarkers
        self.eraOffsets = eraOffsets
        self.fullMonthNames = fullMonthNames
        self.fullTimeUnitNames = fullTimeUnitNames
        self.casualQuantifiers = casualQuantifiers
    }
}

// MARK: - PatternSet (structural / connective config)

/// Structural connector words spliced into the generic parsers' regexes. These
/// carry no semantic value themselves (unlike Vocabulary); they glue tokens.
/// Each field is a list of raw words - the engine escapes them and joins with |.
///
/// Grows additively: add fields with defaults, never remove or retype.
public struct PatternSet {
    /// Words that introduce a time: "at", "lúc", "@".
    public var timePrefixWords: [String]
    /// Connector in "3rd of March": "of".
    public var dateConnectorWords: [String]
    /// Clock hour markers: "giờ", "h", "o'clock".
    public var clockHourWords: [String]
    /// Clock minute markers: "phút", "p", "min".
    public var clockMinuteWords: [String]
    /// Clock second markers: "giây", "s", "sec".
    public var clockSecondWords: [String]
    /// Past-direction SUFFIX markers for relative units: "ago", "trước", "qua".
    public var relativePastWords: [String]
    /// Future-direction PREFIX markers for relative units: "in", "within", "trong".
    public var relativeFutureWords: [String]
    /// Future-direction SUFFIX markers for relative units: "later", "sau", "nữa".
    public var futureSuffixWords: [String]
    /// Range connectors: "to", "until", "đến". Hyphen handling is built in.
    public var rangeConnectorWords: [String]
    /// Words meaning the exact current instant: "now", "bây giờ". Resolved with
    /// all clock components certain (full reference precision), unlike "today".
    public var nowWords: [String]
    /// Optional prepositions before a weekday that ARE part of the match, e.g.
    /// English "on" ("on Friday" -> match text "on Friday", per the EN oracle).
    /// Populate ONLY when the locale's oracle includes the preposition in the
    /// matched span. Leave EMPTY to exclude it: a preposition that is not listed
    /// is never matched, so the match starts at the weekday (e.g. Vietnamese
    /// "vào thứ hai" -> match text "thứ hai"). This is per-locale, not global.
    public var weekdayPrefixWords: [String]
    /// Connectors between a numeric hour and a TRAILING time-of-day word, e.g.
    /// English "at" ("8 at night") and "in the" ("3 in the afternoon"). May be
    /// multi-word (internal spaces match any whitespace run). Leave EMPTY for a
    /// locale whose time-of-day word attaches directly ("3 giờ chiều").
    public var timeOfDayConnectorWords: [String]
    /// Words that MARK a following year, e.g. Vietnamese "năm" ("tháng 4 năm
    /// 1975" = April 1975, "năm 1975" = the year 1975). Consumed two ways: as an
    /// optional connector before the year in a month-name date, and as a gate for
    /// a standalone year (parallel to an era marker). Leave EMPTY for a locale
    /// with no such word - English "of" ("June of 2022") stays built into the
    /// month parser and is NOT driven by this field.
    public var yearMarkerWords: [String]
    /// Words that must NOT follow a weekday's suffix modifier, because together
    /// they form a different construction. Vietnamese "sau khi" is the
    /// conjunction "after [clause]", so "thứ hai sau khi ..." is Monday followed
    /// by a subordinate clause, not "next Monday". Only consulted by a locale
    /// with `weekdaySuffixModifier` enabled; empty elsewhere.
    public var weekdaySuffixExclusionWords: [String]
    /// Optional marker word BEFORE a bare day number, e.g. Vietnamese "ngày" in
    /// "ngày 15 tháng 3". Distinct from `dateConnectorWords`, which sits BETWEEN
    /// day and month ("3rd of March").
    ///
    /// Consumed two ways, and it needs both to be correct. It is included in the
    /// match span, so the result covers "ngày 15 tháng 3" rather than starting a
    /// word late. And it SUPPRESSES a bare month-only match that follows a marked
    /// but invalid day: "ngày 0 tháng 4" must produce nothing, where without the
    /// suppression the rejected day leaves "tháng 4" to match on its own and the
    /// day silently disappears instead of failing.
    public var dayMarkerWords: [String]
    /// Optional particle BEFORE a time-of-day word, e.g. Vietnamese "buổi" in
    /// "buổi sáng" (the morning). The mirror image of
    /// `timeOfDayConnectorWords`, which follows a numeric hour instead.
    ///
    /// Consumed as part of the time-of-day token, so a day anchor and the time
    /// stay ONE match: without it "hôm nay buổi sáng" splits into "hôm nay" and
    /// "sáng" with an unconsumed word between them, and nothing can rejoin them.
    public var timeOfDayPrefixWords: [String]
    /// Approximation words that carry no value and may be skipped inside a
    /// duration: "in around 5 hours", "in about ~5 hours". They may repeat.
    public var durationFillerWords: [String]
    /// Words joining the clauses of one compound duration: "1 day and 2 hours".
    /// A comma is handled structurally and needs no entry.
    public var durationConnectorWords: [String]
    /// Single connector words allowed BETWEEN a date and a time being merged
    /// into one result, beyond `timePrefixWords` (which are also accepted):
    /// English "tomorrow AFTER 4pm", "Tuesday of next week BEFORE 2pm". The
    /// merge also accepts one structural punctuation mark (, - . : ∙) with no
    /// entry needed. Leave EMPTY for a locale whose date and time only ever
    /// join with a time prefix ("13/3 lúc 8 giờ").
    public var dateTimeGlueWords: [String]

    public init(
        timePrefixWords: [String] = [],
        dateConnectorWords: [String] = [],
        clockHourWords: [String] = [],
        clockMinuteWords: [String] = [],
        clockSecondWords: [String] = [],
        relativePastWords: [String] = [],
        relativeFutureWords: [String] = [],
        futureSuffixWords: [String] = [],
        rangeConnectorWords: [String] = [],
        nowWords: [String] = [],
        weekdayPrefixWords: [String] = [],
        timeOfDayConnectorWords: [String] = [],
        yearMarkerWords: [String] = [],
        weekdaySuffixExclusionWords: [String] = [],
        dayMarkerWords: [String] = [],
        timeOfDayPrefixWords: [String] = [],
        durationFillerWords: [String] = [],
        durationConnectorWords: [String] = [],
        dateTimeGlueWords: [String] = []
    ) {
        self.timePrefixWords = timePrefixWords
        self.dateConnectorWords = dateConnectorWords
        self.clockHourWords = clockHourWords
        self.clockMinuteWords = clockMinuteWords
        self.clockSecondWords = clockSecondWords
        self.relativePastWords = relativePastWords
        self.relativeFutureWords = relativeFutureWords
        self.futureSuffixWords = futureSuffixWords
        self.rangeConnectorWords = rangeConnectorWords
        self.nowWords = nowWords
        self.weekdayPrefixWords = weekdayPrefixWords
        self.timeOfDayConnectorWords = timeOfDayConnectorWords
        self.yearMarkerWords = yearMarkerWords
        self.weekdaySuffixExclusionWords = weekdaySuffixExclusionWords
        self.dayMarkerWords = dayMarkerWords
        self.timeOfDayPrefixWords = timeOfDayPrefixWords
        self.durationFillerWords = durationFillerWords
        self.durationConnectorWords = durationConnectorWords
        self.dateTimeGlueWords = dateTimeGlueWords
    }
}

// MARK: - LocaleOptions

/// Per-locale behavioral flags.
public struct LocaleOptions {
    /// How to read ambiguous numeric dates like 3/4.
    public var dateOrder: DateOrder
    /// First weekday, Foundation convention (1 = Sunday ... 7 = Saturday).
    public var weekStart: Int
    /// When true, a relative modifier may attach directly AFTER the weekday with
    /// no week-word ("thứ hai tới" = next Monday). English-style locales use the
    /// prefix form ("next Monday") and leave this false. Additive: enabling it
    /// only adds a match position, it never changes the prefix/week-word forms.
    public var weekdaySuffixModifier: Bool

    public init(dateOrder: DateOrder = .dayMonth, weekStart: Int = 2, weekdaySuffixModifier: Bool = false) {
        self.dateOrder = dateOrder
        self.weekStart = weekStart
        self.weekdaySuffixModifier = weekdaySuffixModifier
    }
}

// MARK: - Parser / Refiner protocols

/// What a parser produces for one match. `.components` is wrapped into a
/// ParsedResult by the engine using the match's original-text index and text.
/// `.result` is used as-is (for parsers that build a custom range themselves).
public enum ParserResult {
    case components(ParsingComponents)
    case result(ParsedResult)
}

/// A parser matches a regex over the normalized text and extracts components.
/// Generic parsers are stateless: they read all configuration from
/// `context.locale`, so a single shared instance serves every locale.
public protocol Parser {
    /// The pattern to run over `context.text` (NFC-normalized). Build it from
    /// `context.locale` data. Use NSRegularExpression for JS-semantic parity.
    func pattern(_ context: ParsingContext) -> NSRegularExpression
    /// Extract components from one match, or return nil to reject it.
    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult?
    /// Static per-TYPE rank: the FINAL, provably-total overlap tiebreak (lower
    /// wins) when two results tie on certain-count, length, and index. Defaults
    /// to `ParsedResult.defaultRank`; a bespoke additionalParser may leave it.
    static var overlapRank: Int { get }
}

public extension Parser {
    static var overlapRank: Int { ParsedResult.defaultRank }
}

/// A refiner transforms the flat list of results: merging adjacent date+time,
/// building ranges, or filtering overlaps. Refiners must be order-independent in
/// their observable outcome where the spec requires it (the overlap filter).
public protocol Refiner {
    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult]
}

// MARK: - Locale protocol

/// A locale is pure configuration plus optional bespoke parsers/refiners.
///
/// Named `KhacLocale`, not `Locale`, to avoid shadowing `Foundation.Locale` in
/// the test target and in any consumer that imports both Foundation and Khac.
public protocol KhacLocale {
    var id: LocaleID { get }
    var vocabulary: Vocabulary { get }
    var patterns: PatternSet { get }
    var options: LocaleOptions { get }
    /// Escape hatch for bespoke grammar. Default [].
    var additionalParsers: [Parser] { get }
    /// Escape hatch for bespoke refinement. Default [].
    var additionalRefiners: [Refiner] { get }
}

public extension KhacLocale {
    var patterns: PatternSet { PatternSet() }
    var options: LocaleOptions { LocaleOptions() }
    var additionalParsers: [Parser] { [] }
    var additionalRefiners: [Refiner] { [] }
}
