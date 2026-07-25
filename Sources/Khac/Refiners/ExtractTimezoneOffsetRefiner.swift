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

import Foundation

struct ExtractTimezoneOffsetRefiner: Refiner {
    private static let pattern = makeRegex(
        "^\\s*(?:\\(?(?:GMT|UTC)\\s?)?(?<sign>[+-])(?<h>[0-9]{1,2})(?::?(?<m>[0-9]{2}))?\\)?"
    )

    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        let original = context.normalization.original as NSString

        return results.map { result in
            guard !result.start.isCertain(.timezoneOffset) else { return result }

            let tail = NSRange(location: result.rangeEnd, length: original.length - result.rangeEnd)
            guard tail.length > 0,
                  let match = Self.pattern.firstMatch(in: original as String, options: .anchored, range: tail)
            else { return result }

            let hours = Int(original.substring(with: match.range(withName: "h"))) ?? 0
            let minuteRange = match.range(withName: "m")
            let minutes = minuteRange.location != NSNotFound
                ? Int(original.substring(with: minuteRange)) ?? 0
                : 0
            var offset = hours * 60 + minutes
            guard offset <= 14 * 60 else { return result }
            if original.substring(with: match.range(withName: "sign")) == "-" {
                offset = -offset
            }

            var start = result.start
            start.certain(.timezoneOffset, offset)
            var end = result.end
            end?.certain(.timezoneOffset, offset)
            let matchedText = original.substring(with: match.range)
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
