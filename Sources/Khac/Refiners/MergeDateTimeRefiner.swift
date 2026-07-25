// MergeDateTimeRefiner.swift - merge an adjacent date and time into one result.
//
// "today 5PM", "tomorrow at noon", "5pm tomorrow": a date-only result next to a
// time-only result, separated only by short glue (whitespace or a connector word
// like "at"), becomes a single result carrying both. The date supplies the
// calendar date; the time supplies the clock.

import Foundation

struct MergeDateTimeRefiner: Refiner {
    /// The clock fields a time result contributes to the merge. Date fields
    /// (year/month/day/weekday) are kept from the date result.
    private static let timeFields: [ParsingComponents.Component] = [
        .hour, .minute, .second, .millisecond, .meridiem, .timezoneOffset,
    ]

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
        let aDate = isDateOnly(a), aTime = isTimeOnly(a)
        let bDate = isDateOnly(b), bTime = isTimeOnly(b)

        let date: ParsedResult
        let time: ParsedResult
        if aDate && bTime {
            date = a; time = b
        } else if aTime && bDate {
            date = b; time = a
        } else {
            return nil
        }

        guard glueIsMergeable(between: a, and: b, context) else { return nil }

        // Category-aware merge (chrono's mergingCalculation): the date result owns
        // the date fields, the time result owns the time fields. Starting from the
        // date's components keeps its resolved date - including a weekday's implied
        // day - which a blind merge would clobber with the time result's default
        // "today". Only the time fields are overlaid.
        var mergedComponents = date.start
        for component in Self.timeFields {
            guard let value = time.start.get(component) else { continue }
            if time.start.isCertain(component) {
                mergedComponents.certain(component, value)
            } else {
                mergedComponents.imply(component, value)
            }
        }
        let original = context.normalization.original as NSString
        let start = a.index
        let end = b.rangeEnd
        guard start >= 0, end <= original.length, start < end else { return nil }
        let text = original.substring(with: NSRange(location: start, length: end - start))
        return context.createResult(index: start, text: text, start: mergedComponents)
    }

    private func isDateOnly(_ r: ParsedResult) -> Bool {
        hasDate(r) && !r.start.isCertain(.hour)
    }

    private func isTimeOnly(_ r: ParsedResult) -> Bool {
        r.start.isCertain(.hour) && !hasDate(r)
    }

    private func hasDate(_ r: ParsedResult) -> Bool {
        r.start.isCertain(.day) || r.start.isCertain(.month)
            || r.start.isCertain(.year) || r.start.isCertain(.weekday)
    }

    /// The text between the two matches must be short glue: whitespace, a comma,
    /// or a single connector word (a time prefix like "at").
    private func glueIsMergeable(between a: ParsedResult, and b: ParsedResult, _ context: ParsingContext) -> Bool {
        let original = context.normalization.original as NSString
        let gapStart = min(a.rangeEnd, b.rangeEnd)
        let gapEnd = max(a.index, b.index)
        guard gapStart <= gapEnd, gapEnd <= original.length else { return false }
        let gap = original.substring(with: NSRange(location: gapStart, length: gapEnd - gapStart))
        let gluePunctuation = CharacterSet.whitespaces.union(CharacterSet(charactersIn: ",.:"))
        let trimmed = gap.trimmingCharacters(in: gluePunctuation)
        if trimmed.isEmpty { return true }
        let connectors = Set(context.locale.patterns.timePrefixWords.map { WordTable<Int>.fold($0) })
        return connectors.contains(WordTable<Int>.fold(trimmed))
    }
}
