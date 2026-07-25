// ExtractTimezoneOffsetRefiner.swift - claim a numeric zone offset after a match.
//
// "06/Nov/2023:06:36:02 +0200": the date-time parsers own everything up to the
// offset, and the offset itself is format, not locale - "+0200", "GMT+9",
// "(UTC-05:30)". For any result that has not already stated a zone, a following
// offset is that result's zone: store it (minutes from GMT) on both ends and
// extend the matched text over it.
//
// chrono's ExtractTimezoneOffsetRefiner, including the sanity cap: no real zone
// is more than 14 hours from GMT, so anything larger is left alone.
//
// Like ExtractYearSuffixRefiner it scans forward from `result.rangeEnd`, and it
// scans in NORMALIZED coordinates for the same reason. Unlike that refiner it has
// no live defect to fix: its pattern is pure ASCII format, never locale
// vocabulary, so NFD input could not break it. It is converted anyway so that
// tail-scanning has ONE convention. Two conventions in one directory is how
// KHAC-7 was written in the first place - the era refiner was built alongside
// this one and inherited the original-coordinate scan without inheriting the
// reason it was safe here. KHAC-7.

import Foundation

struct ExtractTimezoneOffsetRefiner: Refiner {
    private static let pattern = makeRegex(
        "^\\s*(?:\\(?(?:GMT|UTC)\\s?)?(?<sign>[+-])(?<h>[0-9]{1,2})(?::?(?<m>[0-9]{2}))?\\)?"
    )

    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        let normalization = context.normalization
        let normalized = normalization.normalized as NSString

        return results.map { result in
            guard !result.start.isCertain(.timezoneOffset) else { return result }

            let tailStart = normalization.normalizedUTF16Offset(forOriginalUTF16: result.rangeEnd)
            let tail = NSRange(location: tailStart, length: normalized.length - tailStart)
            guard tail.length > 0,
                  let match = Self.pattern.firstMatch(in: normalized as String, options: .anchored, range: tail)
            else { return result }

            let hours = Int(normalized.substring(with: match.range(withName: "h"))) ?? 0
            let minuteRange = match.range(withName: "m")
            let minutes = minuteRange.location != NSNotFound
                ? Int(normalized.substring(with: minuteRange)) ?? 0
                : 0
            var offset = hours * 60 + minutes
            guard offset <= 14 * 60 else { return result }
            if normalized.substring(with: match.range(withName: "sign")) == "-" {
                offset = -offset
            }

            var start = result.start
            start.certain(.timezoneOffset, offset)
            var end = result.end
            end?.certain(.timezoneOffset, offset)
            // Original slice, because it is appended to `result.text`.
            let matchedText = normalization.originalSubstring(
                forNormalizedUTF16: match.range.location..<(match.range.location + match.range.length)
            )
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
