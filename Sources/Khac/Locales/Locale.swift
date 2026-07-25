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
    /// Era markers applied to a year: "bc"/"tcn": -1, "ad"/"scn": +1.
    public var eraMarkers: [String: Int]

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
        eraMarkers: [String: Int] = [:]
    ) {
        self.weekdays = weekdays
        self.months = months
        self.integerWords = integerWords
        self.ordinals = ordinals
        self.timeUnits = timeUnits
        self.relativeModifiers = relativeModifiers
        self.dayReferences = dayReferences
        self.meridiem = meridiem
        self.timeOfDay = timeOfDay
        self.eraMarkers = eraMarkers
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
        weekdayPrefixWords: [String] = []
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
