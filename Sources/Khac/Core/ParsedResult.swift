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

    /// Rank for results with no assigned producer (e.g. an external
    /// additionalParser, or a merged result). Ranks below this win ties.
    public static let defaultRank = 1000

    public init(
        index: Int,
        text: String,
        start: ParsingComponents,
        end: ParsingComponents? = nil,
        score: Int,
        parserRank: Int = ParsedResult.defaultRank
    ) {
        self.index = index
        self.text = text
        self.start = start
        self.end = end
        self.score = score
        self.parserRank = parserRank
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
    /// (certainCount desc, matchLength desc, index asc, parserRank asc, signature
    /// asc). Certain-component count outranks length outright; parserRank
    /// guarantees totality.
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
        return stableSignature < other.stableSignature
    }
}
