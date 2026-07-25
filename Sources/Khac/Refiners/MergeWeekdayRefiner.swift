// MergeWeekdayRefiner.swift - merge a weekday and an adjacent explicit date.
//
// "Tuesday, January 10", "Sun 15Sep": a weekday-only result next to a result
// that carries an explicit month/day is redundant - the explicit date wins and
// simply gains the weekday component. Glue between them is whitespace or a comma.

import Foundation

struct MergeWeekdayRefiner: Refiner {
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
        let weekday: ParsedResult
        let date: ParsedResult
        if isWeekdayOnly(a) && hasExplicitDate(b) {
            weekday = a; date = b
        } else if isWeekdayOnly(b) && hasExplicitDate(a) {
            weekday = b; date = a
        } else {
            return nil
        }

        guard glueIsMergeable(between: a, and: b, context) else { return nil }

        var components = date.start
        if let value = weekday.start.get(.weekday) {
            components.certain(.weekday, value)
        }

        let original = context.normalization.original as NSString
        let start = min(a.index, b.index)
        let end = max(a.rangeEnd, b.rangeEnd)
        guard start >= 0, end <= original.length, start < end else { return nil }
        let text = original.substring(with: NSRange(location: start, length: end - start))
        return context.createResult(index: start, text: text, start: components, end: date.end)
    }

    private func isWeekdayOnly(_ r: ParsedResult) -> Bool {
        r.start.isCertain(.weekday) && !r.start.isCertain(.day) && !r.start.isCertain(.month)
    }

    private func hasExplicitDate(_ r: ParsedResult) -> Bool {
        r.start.isCertain(.day) || r.start.isCertain(.month)
    }

    /// Short glue only: whitespace or a comma between the two matches.
    private func glueIsMergeable(between a: ParsedResult, and b: ParsedResult, _ context: ParsingContext) -> Bool {
        let original = context.normalization.original as NSString
        let gapStart = min(a.rangeEnd, b.rangeEnd)
        let gapEnd = max(a.index, b.index)
        guard gapStart <= gapEnd, gapEnd <= original.length else { return false }
        let gap = original.substring(with: NSRange(location: gapStart, length: gapEnd - gapStart))
        let trimmed = gap.trimmingCharacters(in: CharacterSet.whitespaces.union(CharacterSet(charactersIn: ",")))
        return trimmed.isEmpty
    }
}
