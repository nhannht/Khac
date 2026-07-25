// MergeRelativeAnchorRefiner.swift - re-anchor a relative duration onto a date.
//
// "2 days after tomorrow", "2 weeks after yesterday", "2 months before 02/02",
// "next tuesday +10 days", "2023-12-29 -10days".
//
// A relative expression is a duration applied to an ANCHOR, and the anchor is
// usually implicit - the reference. When a date sits next to the relative
// expression, THAT is the anchor instead. RelativeUnitParser cannot know this:
// it resolves against the reference at parse time, which is why "2 day before
// yesterday" otherwise shifts from today and lands a day late.
//
// The duration is recovered by re-reading the relative result's own text through
// the same locale-driven helper the parser used, so there is one definition of
// what a duration is. Recovering it by DIFFING the two resolved dates would be
// wrong: adding two months is not adding a fixed number of days, so "2 months
// before 02/02" would silently resolve to the wrong date.

import Foundation

struct MergeRelativeAnchorRefiner: Refiner {
    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        guard results.count > 1 else { return results }
        let sorted = results.sorted { $0.index < $1.index }

        var output: [ParsedResult] = []
        var i = 0
        while i < sorted.count {
            if i + 1 < sorted.count, let merged = merge(sorted[i], sorted[i + 1], context) {
                output.append(merged)
                i += 2
            } else {
                output.append(sorted[i])
                i += 1
            }
        }
        return output
    }

    private func merge(_ a: ParsedResult, _ b: ParsedResult, _ context: ParsingContext) -> ParsedResult? {
        // Exactly one side must be a dangling relative expression, and the other
        // must carry a real date to anchor it on.
        let relative: RelativeDuration
        let anchor: ParsedResult
        if let duration = DurationExpression.relative(in: a.text, context), hasDate(b) {
            relative = duration
            anchor = b
        } else if let duration = DurationExpression.relative(in: b.text, context), hasDate(a) {
            relative = duration
            anchor = a
        } else {
            return nil
        }

        guard gapIsGlue(between: a, and: b, context) else { return nil }

        let calendar = context.reference.calendar
        guard let shifted = relative.apply(to: anchor.start.date(), calendar: calendar) else { return nil }

        // Keep the anchor's own components - notably its clock, so a bare date's
        // implied noon survives - and move only the calendar date, preserving how
        // certain each field already was.
        var merged = anchor.start
        let moved = calendar.dateComponents([.year, .month, .day], from: shifted)
        assign(&merged, .year, moved.year, wasCertain: anchor.start.isCertain(.year))
        assign(&merged, .month, moved.month, wasCertain: anchor.start.isCertain(.month))
        assign(&merged, .day, moved.day, wasCertain: anchor.start.isCertain(.day))

        let original = context.normalization.original as NSString
        let start = min(a.index, b.index)
        let end = max(a.rangeEnd, b.rangeEnd)
        guard start >= 0, end <= original.length, start < end else { return nil }
        let text = original.substring(with: NSRange(location: start, length: end - start))
        return context.createResult(index: start, text: text, start: merged)
    }

    private func assign(
        _ comps: inout ParsingComponents,
        _ component: ParsingComponents.Component,
        _ value: Int?,
        wasCertain: Bool
    ) {
        guard let value = value else { return }
        // Moving the date must not change how certain the anchor's fields were:
        // "02/02" stated its month and day, a bare weekday only implied them.
        if wasCertain {
            comps.certain(component, value)
        } else {
            comps.imply(component, value)
        }
    }

    private func hasDate(_ r: ParsedResult) -> Bool {
        r.start.isCertain(.day) || r.start.isCertain(.month)
            || r.start.isCertain(.year) || r.start.isCertain(.weekday)
    }

    /// The two matches must be adjacent, separated by nothing but whitespace or
    /// light punctuation. A whole clause between them means they are unrelated.
    private func gapIsGlue(between a: ParsedResult, and b: ParsedResult, _ context: ParsingContext) -> Bool {
        let original = context.normalization.original as NSString
        let gapStart = min(a.rangeEnd, b.rangeEnd)
        let gapEnd = max(a.index, b.index)
        guard gapStart <= gapEnd, gapEnd <= original.length else { return false }
        let gap = original.substring(with: NSRange(location: gapStart, length: gapEnd - gapStart))
        return gap.trimmingCharacters(in: CharacterSet.whitespaces.union(CharacterSet(charactersIn: ",."))).isEmpty
    }
}
