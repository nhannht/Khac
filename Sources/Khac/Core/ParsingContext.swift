// ParsingContext.swift - per-parse, per-locale state handed to parsers/refiners.

import Foundation

/// State for one locale's pass over one input. Parsers read `text` (the
/// NFC-normalized input) and `locale` (all configuration), and build results
/// through the factory methods so index/text mapping stays consistent.
public final class ParsingContext {
    public let reference: ReferencePoint
    public let options: Options
    public let locale: KhacLocale
    /// The NFC-normalized text parsers match against.
    public let text: String

    /// Internal: original-index mapping shared by every TextMatch this context
    /// produces.
    let normalization: NormalizedText

    init(reference: ReferencePoint, options: Options, locale: KhacLocale, normalization: NormalizedText) {
        self.reference = reference
        self.options = options
        self.locale = locale
        self.text = normalization.normalized
        self.normalization = normalization
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
