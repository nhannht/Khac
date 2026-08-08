// ParsingContext.swift - per-parse, per-locale state handed to parsers/refiners.

import Foundation

/// State for one locale's pass over one input. Parsers read `text` (the
/// NFC-normalized input) and `locale` (all configuration), and build results
/// through the factory methods so index/text mapping stays consistent.
public final class ParsingContext {
    public let reference: ReferencePoint
    public let options: Options
    /// All configuration a parser or refiner reads.
    public var locale: KhacLocale { prepared.locale }
    /// The NFC-normalized text parsers match against.
    public let text: String

    /// Internal: original-index mapping shared by every TextMatch this context
    /// produces.
    let normalization: NormalizedText

    /// Internal: the locale together with everything already derived from it.
    /// The context carries it so that ANYTHING holding a context - a parser, a
    /// refiner, or a shared helper like DurationExpression - can memoize a
    /// derivation. Reaching the cache only from Engine.runParser was the hole
    /// that let refiners recompile regexes on every candidate pair.
    let prepared: PreparedLocale

    init(reference: ReferencePoint, options: Options, prepared: PreparedLocale, normalization: NormalizedText) {
        self.reference = reference
        self.options = options
        self.prepared = prepared
        self.text = normalization.normalized
        self.normalization = normalization
    }

    /// A value derived from this locale and these options, built once.
    ///
    /// `build` must be a pure function of the derivation, the locale, and the
    /// options: never of `text` or of `reference`. See PreparedLocale.
    func cached<T>(_ derivation: PreparedLocale.Derivation, _ build: () -> T) -> T {
        prepared.cached(derivation, mode: options.mode, forwardDate: options.forwardDate, build: build)
    }

    /// A fresh component set seeded with implied values from the reference.
    public func createParsingComponents() -> ParsingComponents {
        ParsingComponents(reference: reference)
    }

    /// Build a result from explicit original-text index and text.
    public func createResult(index: Int, text: String, start: ParsingComponents, end: ParsingComponents? = nil, parserRank: Int = ParsedResult.defaultRank) -> ParsedResult {
        let score = computeScore(start: start, end: end)
        return ParsedResult(index: index, text: text, start: start, end: end, score: score, parserRank: parserRank)
    }

    /// Build a result whose index/text come from a match (mapped to the original
    /// text). The common path for a parser that matched one span.
    public func createResult(match: TextMatch, start: ParsingComponents, end: ParsingComponents? = nil, parserRank: Int = ParsedResult.defaultRank) -> ParsedResult {
        createResult(index: match.index, text: match.originalText, start: start, end: end, parserRank: parserRank)
    }

    /// Score = the count of CERTAIN components. It is the first overlap key and
    /// is NEVER summed with match length - length is a separate, lower key - so a
    /// long vague match cannot outrank a short precise one (SPEC 3a-H0).
    private func computeScore(start: ParsingComponents, end: ParsingComponents?) -> Int {
        start.specificityScore + (end?.specificityScore ?? 0)
    }
}
