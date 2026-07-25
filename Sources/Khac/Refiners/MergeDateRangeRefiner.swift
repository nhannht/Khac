// MergeDateRangeRefiner.swift - merge "date - date" into one start/end result.
//
// Two date (or time) results joined by a range connector ("to", "until", "-")
// become a single result with a start and an end. A calendar component that is
// certain on one side but only implied on the other propagates across, so
// "May to December, 2022" shares the year 2022 on both ends.

import Foundation

struct MergeDateRangeRefiner: Refiner {
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
        // Only merge single (non-range) results into a range.
        guard a.end == nil, b.end == nil else { return nil }
        guard isDateLike(a), isDateLike(b) else { return nil }
        guard rangeConnector(between: a, and: b, context) else { return nil }

        var start = a.start
        var end = b.start
        for component in [ParsingComponents.Component.year, .month, .day] {
            if start.isCertain(component), !end.isCertain(component), let v = start.get(component) {
                end.imply(component, v)
            }
            if end.isCertain(component), !start.isCertain(component), let v = end.get(component) {
                start.imply(component, v)
            }
        }

        let original = context.normalization.original as NSString
        let lo = a.index
        let hi = b.rangeEnd
        guard lo >= 0, hi <= original.length, lo < hi else { return nil }
        let text = original.substring(with: NSRange(location: lo, length: hi - lo))
        return context.createResult(index: lo, text: text, start: start, end: end)
    }

    private func isDateLike(_ r: ParsedResult) -> Bool {
        r.start.isCertain(.day) || r.start.isCertain(.month) || r.start.isCertain(.year)
            || r.start.isCertain(.weekday) || r.start.isCertain(.hour)
    }

    /// The gap between the two matches is a range connector word or a dash.
    private func rangeConnector(between a: ParsedResult, and b: ParsedResult, _ context: ParsingContext) -> Bool {
        let original = context.normalization.original as NSString
        let gapStart = a.rangeEnd
        let gapEnd = b.index
        guard gapStart <= gapEnd, gapEnd <= original.length else { return false }
        let gap = original.substring(with: NSRange(location: gapStart, length: gapEnd - gapStart))
        let trimmed = gap.trimmingCharacters(in: .whitespaces)
        if ["-", "\u{2013}", "\u{2014}", "~"].contains(trimmed) { return true }
        let connectors = Set(context.locale.patterns.rangeConnectorWords.map { WordTable<Int>.fold($0) })
        return connectors.contains(WordTable<Int>.fold(trimmed))
    }
}
