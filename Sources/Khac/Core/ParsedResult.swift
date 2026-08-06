// ParsedResult.swift - one parsed date or interval, with its place in the text.

import Foundation

public struct ParsedResult {
    /// Start offset of the match in the ORIGINAL text, in UTF-16 code units.
    public let index: Int
    /// The matched substring, taken from the ORIGINAL (un-normalized) text.
    public let text: String
    /// Components of the (start) date.
    public var start: ParsingComponents
    /// Components of the end date, present for ranges.
    ///
    /// NOT guaranteed to resolve later than `start`. A backwards range is a real
    /// reading of text like "August 22 - 10, 2012", and it is reported as written
    /// rather than silently reordered - swapping the sides would assert the writer
    /// meant August 10 to 22, which is a guess about a typo. chrono behaves the
    /// same way at the same place, and the range REFINER repairs where the
    /// month-name PARSER does not, in both libraries.
    ///
    /// So do not build an interval from `start` and `end` yourself:
    /// `DateInterval(start:end:)` TRAPS when end precedes start, which is a Swift
    /// hazard with no equivalent in the JavaScript original. Use `interval`, which
    /// returns nil for exactly this case.
    public var end: ParsingComponents?
    /// Number of CERTAIN components across start and end. This is the FIRST
    /// overlap key - never summed with match length, since the units differ and
    /// length would swamp it. Higher wins.
    ///
    /// "Certain" means a parser ASSIGNED the value rather than inheriting it from
    /// the reference. It is NOT a count of what the writer wrote, and reading it
    /// that way has already cost one wrong answer: a casual day word resolving its
    /// date off the reference marks year, month and day certain without a single
    /// character stating any of them, which is three, against two for a hand-typed
    /// hour and meridiem. See SPEC 3a-H0.
    public var score: Int
    /// Static per-parser-TYPE rank, the FINAL overlap tiebreak. Lower wins. It
    /// makes the ordering provably total (independent of registration order) when
    /// two distinct results tie on score, length, and index. Defaults to
    /// `ParsedResult.defaultRank` for results without an assigned producer.
    public var parserRank: Int

    /// Position of the producing locale in the caller's DECLARED locale list,
    /// compared after `parserRank` and before the stable signature. Lower wins.
    ///
    /// This is the key that breaks a cross-locale tie the way the public API
    /// already promises: `Khac(locales:)` documents "in the given order" and
    /// `defaultLocales()` documents "the order Khac() tries them", so an exact
    /// tie - a bare "8/5" read as month/day by one locale and day/month by
    /// another - goes to the locale listed first instead of falling through to
    /// a signature that carries no locale information. Deliberate, caller-visible
    /// precedence, not the accidental registration-order dependence SPEC 3a-H0
    /// forbids. Stamped by Engine.run; `defaultLocaleRank` outside a locale run.
    public var localeRank: Int

    /// Rank for results with no assigned producer (e.g. an external
    /// additionalParser, or a merged result). Ranks below this win ties.
    public static let defaultRank = 1000

    /// Locale rank for results not produced through a locale run (e.g. built
    /// directly in tests). An unstamped result never outranks a stamped one,
    /// and two unstamped results tie here and fall through to the signature.
    public static let defaultLocaleRank = Int.max

    public init(
        index: Int,
        text: String,
        start: ParsingComponents,
        end: ParsingComponents? = nil,
        score: Int,
        parserRank: Int = ParsedResult.defaultRank,
        localeRank: Int = ParsedResult.defaultLocaleRank
    ) {
        self.index = index
        self.text = text
        self.start = start
        self.end = end
        self.score = score
        self.parserRank = parserRank
        self.localeRank = localeRank
    }

    /// The resolved start date.
    public var date: Date { start.date() }

    /// The resolved interval, or nil for a non-range result or a backwards range.
    ///
    /// This is the ONLY safe way to turn a result into a `DateInterval`, and the
    /// nil is load-bearing rather than defensive: `DateInterval(start:end:)` traps
    /// on end < start, so a caller who builds one from `start` and `end` directly
    /// crashes on input this returns nil for. See `end`.
    public var interval: DateInterval? {
        guard let end = end else { return nil }
        let s = start.date()
        let e = end.date()
        guard e >= s else { return nil }
        return DateInterval(start: s, end: e)
    }

    /// Match length in UTF-16 code units of the original matched text.
    public var matchLength: Int { text.utf16.count }

    /// End offset (exclusive) of the match in the original text.
    public var rangeEnd: Int { index + matchLength }

    /// The matched substring in the engine's MATCHING coordinates (NFC).
    ///
    /// `text` is a slice of the ORIGINAL input, so on macOS it is routinely NFD:
    /// text fields, dictation, and any path read off HFS+ all deliver decomposed
    /// accents. Every pattern in the engine is built from NFC-folded locale
    /// vocabulary, so matching NFD text against one silently finds nothing - for
    /// Vietnamese that means a whole accented word like `tháng` simply fails to
    /// match, with no error.
    ///
    /// So any refiner that RE-PARSES a result must read this, never `text`.
    /// Derived rather than stored, so it cannot fall out of step with `text`.
    ///
    /// Never use it for offsets. `index`, `matchLength`, and `rangeEnd` are all
    /// ORIGINAL-text coordinates, and normalizing changes UTF-16 lengths.
    public var normalizedText: String { text.precomposedStringWithCanonicalMapping }

    // MARK: Deterministic total ordering

    /// A stable signature that makes overlap resolution TOTAL: no two distinct
    /// results ever compare equal on the full ordering, so the winner never
    /// depends on parser registration order. Derived entirely from existing
    /// fields - no defensive state added.
    var stableSignature: String {
        let startBits = start.date().timeIntervalSinceReferenceDate
        let endBits = end?.date().timeIntervalSinceReferenceDate ?? .infinity
        return "\(index):\(matchLength):\(score):\(parserRank):\(startBits):\(endBits):\(text)"
    }

    /// Total preference order for overlap resolution. Returns true when self
    /// should be preferred over other. A LEXICOGRAPHIC tuple, never a scalar sum:
    /// (certainCount desc, matchLength desc, index asc, parserRank asc,
    /// localeRank asc, signature asc). Certain-component count outranks length
    /// outright; the signature guarantees totality.
    ///
    /// localeRank sits between parserRank and the signature so it decides ONLY
    /// ties everything intrinsic to the results left open - which is exactly the
    /// cross-locale exact tie (KHAC-16). The signature is unchanged and is only
    /// reached when localeRank ties, i.e. within one locale's own results, where
    /// it already distinguished them.
    ///
    /// Ours, not chrono's - chrono keeps the longer text and nothing else - and
    /// the EN oracle does not constrain the key ORDER, only its output. Read the
    /// caveats in SPEC 3a-H0 before reordering these on the strength of a green
    /// suite.
    func isPreferred(over other: ParsedResult) -> Bool {
        if score != other.score { return score > other.score }
        if matchLength != other.matchLength { return matchLength > other.matchLength }
        if index != other.index { return index < other.index }
        if parserRank != other.parserRank { return parserRank < other.parserRank }
        if localeRank != other.localeRank { return localeRank < other.localeRank }
        return stableSignature < other.stableSignature
    }
}
