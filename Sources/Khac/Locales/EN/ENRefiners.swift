// ENRefiners.swift - English-lexical result filtering.
//
// chrono's ENUnlikelyFormatFilter plus the "for the X" exclusion from
// ENTimeUnitWithinFormatParser: judgments about specific ENGLISH words that
// have no data-table shape, so they live in the locale's own refiner rather
// than the generic pipeline.

import Foundation

/// Drops matches that are far more likely ordinary English than dates:
///   - "for the year" is a scope phrase, not the duration "the year".
///   - "may" is a modal verb unless the whole input names the month or an
///     "in" immediately precedes it ("in may" keeps, "Theresa may" drops).
///   - "...the second" is an ordinal, not the time unit, whenever more text
///     follows ("in the second half of 2025").
struct ENUnlikelyFormatFilter: Refiner {
    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        let original = context.normalization.original as NSString

        return results.filter { result in
            let folded = WordTable<Int>.fold(result.text)
                .trimmingCharacters(in: .whitespaces)

            // "for the <word>" is chrono's within-parser exclusion, checked
            // before the whole-input exemption because chrono's parser never
            // produces the match in the first place.
            if matches(folded, "^for\\s+the\\s+\\w+") { return false }

            // A result spanning the entire input is taken at face value.
            let wholeInput = (original as String).trimmingCharacters(in: .whitespacesAndNewlines)
            if result.text.trimmingCharacters(in: .whitespacesAndNewlines) == wholeInput {
                return true
            }

            if folded == "may" {
                let before = original.substring(to: result.index)
                    .trimmingCharacters(in: .whitespaces)
                if !matches(WordTable<Int>.fold(before), "\\bin$") { return false }
            }

            if folded.hasSuffix("the second") { return false }

            return true
        }
    }

    private func matches(_ text: String, _ pattern: String) -> Bool {
        let ns = text as NSString
        return makeRegex(pattern).firstMatch(in: text, range: NSRange(location: 0, length: ns.length)) != nil
    }
}
