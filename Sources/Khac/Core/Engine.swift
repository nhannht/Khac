// Engine.swift - the ONE pipeline both Khac and the tests drive.
//
// There is exactly one assembly path. Khac.parse and the engine's own tests
// both call Engine.run, so a green test proves the real engine, never a parallel
// one. Per locale: normalize once, run generic + locale parsers, run merge
// refiners, then a per-locale overlap filter. Across locales: concatenate and
// run one final order-independent overlap filter.

import Foundation

enum Engine {
    /// The shared generic parsers, reused by every locale (they read all
    /// configuration from context.locale). Registration order here does not
    /// affect the final result: overlap resolution is score-based and total.
    static var genericParsers: [Parser] {
        [
            ISOParser(),
            NumericDateParser(),
            MonthNameParser(),
            WeekdayParser(),
            CasualDateParser(),
            TimeExpressionParser(),
            RelativeUnitParser(),
            YearParser(),
        ]
    }

    /// The shared merge refiners, applied before the overlap filter. The filter
    /// is applied separately (it must run last and across locales too).
    static var mergeRefiners: [Refiner] {
        [
            MergeWeekdayRefiner(),
            MergeDateTimeRefiner(),
            MergeDateRangeRefiner(),
        ]
    }

    /// Parse `text` against the given locales and return resolved results.
    static func run(text: String, reference: ReferencePoint, options: Options, locales: [KhacLocale]) -> [ParsedResult] {
        let normalization = NormalizedText(original: text)

        var allResults: [ParsedResult] = []
        var lastContext: ParsingContext?

        for locale in locales {
            let context = ParsingContext(reference: reference, options: options, locale: locale, normalization: normalization)
            lastContext = context

            // Parse: generic parsers plus the locale's bespoke parsers.
            var results: [ParsedResult] = []
            for parser in genericParsers + locale.additionalParsers {
                results += runParser(parser, context: context)
            }

            // Refine: merge refiners, then the locale's bespoke refiners, then a
            // per-locale overlap filter.
            for refiner in mergeRefiners + locale.additionalRefiners {
                results = refiner.refine(context, results)
            }
            results = OverlapFilterRefiner().refine(context, results)

            allResults += results
        }

        // Cross-locale de-duplication with the same total, order-independent filter.
        if let context = lastContext {
            allResults = OverlapFilterRefiner().refine(context, allResults)
        }

        return allResults.sorted { $0.index < $1.index }
    }

    /// Run one parser over the normalized text, collecting all non-overlapping
    /// matches. Advances past each match to avoid infinite loops on zero-width
    /// or rejected matches.
    private static func runParser(_ parser: Parser, context: ParsingContext) -> [ParsedResult] {
        let regex = parser.pattern(context)
        let ns = context.text as NSString
        let full = NSRange(location: 0, length: ns.length)

        var results: [ParsedResult] = []
        var searchStart = 0
        while searchStart <= ns.length {
            let searchRange = NSRange(location: searchStart, length: ns.length - searchStart)
            guard let match = regex.firstMatch(in: context.text, options: [], range: searchRange) else { break }

            let rank = type(of: parser).overlapRank
            let textMatch = TextMatch(result: match, normalizedNS: ns, normalization: context.normalization)
            if let produced = parser.extract(context, textMatch) {
                switch produced {
                case .components(let components):
                    results.append(context.createResult(match: textMatch, start: components, parserRank: rank))
                case .result(var result):
                    result.parserRank = rank
                    results.append(result)
                }
                // Accepted: the match CLAIMED its span, so resume past it.
                let matchEnd = match.range.location + match.range.length
                searchStart = max(matchEnd, match.range.location + 1)
            } else {
                // Rejected: extract() consumed NOTHING, so the span is still open
                // to other matches. Resume one char past the match START (chrono's
                // minimal advance), never skipping text a later valid match needs
                // (e.g. a rejected "2024.14" must not hide the "14:15" in
                // "05/31/2024.14:15"). +1 guarantees progress on a zero-width match.
                searchStart = match.range.location + 1
            }
        }

        _ = full
        return results
    }
}
