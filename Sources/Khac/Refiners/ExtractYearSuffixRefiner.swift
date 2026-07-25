// ExtractYearSuffixRefiner.swift - claim a bare year left after the match.
//
// asctime puts the year LAST: "Thu Oct 26 11:00:09 2023". By the time the date
// and time have merged, that trailing "2023" sits just past the result with no
// parser owning it. For a result whose year is still a guess, a following bare
// year (or era-marked year) is that year: assign it to both ends and extend the
// matched text over it.
//
// chrono's ENExtractYearSuffixRefiner, made locale-generic: the era words come
// from the locale's own tables. The "more than 3 characters" guard is chrono's
// own, and it is what keeps "14/4 90" from absorbing its trailing "90" - a
// 2-digit suffix never qualifies.
//
// It scans FORWARD from `result.rangeEnd`, which is an ORIGINAL-text offset, and
// its era alternation is built from locale vocabulary, which can carry
// diacritics. Those two facts collide: patterns are folded to NFC and real input
// often is not (macOS text fields, dictation and HFS+ all deliver NFD), so
// matching this pattern against the original string finds nothing whenever an
// accented era marker meets decomposed text - silently, since a missing year
// suffix just leaves the year implied. So the scan enters NORMALIZED coordinates
// through the inverse boundary map, and converts the match back to original ones
// for the text it appends. KHAC-7.

import Foundation

struct ExtractYearSuffixRefiner: Refiner {
    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        let normalization = context.normalization
        let normalized = normalization.normalized as NSString

        return results.map { result in
            guard result.start.isDateWithUnknownYear else { return result }

            let vocab = context.locale.vocabulary
            let eraWords = Array(vocab.eraMarkers.keys) + Array(vocab.eraOffsets.keys)
            // Folded like MonthNameParser's identical alternation. Unfolded keys
            // would never match the NFC text this now searches.
            let era = regexAlternation(eraWords.map { WordTable<Int>.fold($0) }) ?? "(?!)"
            let pattern = makeRegex(
                "^\\s{0,3}(?:(?<eyr>[1-9][0-9]{0,3})\\s{0,2}(?<eera>" + era + ")(?![\\p{L}\\p{N}_])"
                    + "|(?<yr>[1-9][0-9]{3})(?![\\p{L}\\p{N}_]))"
            )

            let tailStart = normalization.normalizedUTF16Offset(forOriginalUTF16: result.rangeEnd)
            let tail = NSRange(location: tailStart, length: normalized.length - tailStart)
            guard tail.length > 0,
                  let match = pattern.firstMatch(in: normalized as String, options: .anchored, range: tail)
            else { return result }

            // Appended to `result.text`, which is an ORIGINAL slice, so it must be
            // taken from the original too. Grapheme count is unchanged by NFC, so
            // chrono's length guard reads the same either way.
            let matchedText = normalization.originalSubstring(
                forNormalizedUTF16: match.range.location..<(match.range.location + match.range.length)
            )
            guard matchedText.trimmingCharacters(in: .whitespaces).count > 3 else { return result }

            var year: Int
            if match.range(withName: "eyr").location != NSNotFound {
                year = Int(normalized.substring(with: match.range(withName: "eyr"))) ?? 0
                let eraText = normalized.substring(with: match.range(withName: "eera"))
                if let offset = WordTable(vocab.eraOffsets).value(for: eraText) {
                    year += offset
                } else if let sign = WordTable(vocab.eraMarkers).value(for: eraText), sign < 0 {
                    year = -year
                }
            } else {
                year = Int(normalized.substring(with: match.range(withName: "yr"))) ?? 0
            }

            var start = result.start
            start.certain(.year, year)
            var end = result.end
            end?.certain(.year, year)
            // createResult recomputes the score from the now-certain year.
            return context.createResult(
                index: result.index,
                text: result.text + matchedText,
                start: start,
                end: end,
                parserRank: result.parserRank
            )
        }
    }
}
