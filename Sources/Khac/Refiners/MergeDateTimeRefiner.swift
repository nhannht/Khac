// MergeDateTimeRefiner.swift - merge an adjacent date and time into one result.
//
// "today 5PM", "tomorrow at noon", "tonight 8pm", "monday 7 to 9am": a
// date-like result next to a time-like result, separated only by short glue
// (whitespace, one punctuation mark, or a single connector word), becomes one
// result carrying both. The date supplies the calendar date; the time supplies
// the clock.
//
// Mirrors chrono's AbstractMergeDateTimeRefiner + mergingCalculation.ts:
//   - Classification uses the lax isDateLikeOnly/isTimeLikeOnly predicates, so a
//     casual time ("morning", implied hour 6) merges onto "sunday" even though
//     nothing about it is certain.
//   - Either side may carry an end: "22-23 Feb at 7pm" (date range + time) and
//     "monday 7 to 9am" (date + time range) both merge, clock applied to both
//     ends. A time-range end landing before the start rolls to the next day.
//   - A pm hint on the date side promotes the time's bare hour: "tonight at 8"
//     is 20:00 because "tonight" carries an implied pm.

import Foundation

struct MergeDateTimeRefiner: Refiner {
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
        // chrono's ordered branching: the earlier result claims the date role
        // first. A result can be both date-like and time-like ("morning"); the
        // order decides which half it plays.
        let date: ParsedResult
        let time: ParsedResult
        if a.start.isDateLikeOnly && b.start.isTimeLikeOnly {
            date = a; time = b
        } else if b.start.isDateLikeOnly && a.start.isTimeLikeOnly {
            date = b; time = a
        } else {
            return nil
        }

        // A pure reference-seeded result (nothing certain at all, e.g. a bare
        // relative shift) may pose as either half; requiring SOME certain or
        // deliberately-set field on each side keeps "5 days ago" from being
        // swallowed as a "date" by a stray bare number. The date half must have
        // a date-ish field or a time-of-day hour; the time half must have an
        // hour that differs from plain reference seeding or a stated clock.
        guard hasSubstance(date.start), hasSubstance(time.start) else { return nil }

        guard glueIsMergeable(between: a, and: b, context) else { return nil }

        let mergedStart = mergedComponents(date: date.start, time: time.start)

        var mergedEnd: ParsingComponents? = nil
        if date.end != nil || time.end != nil {
            let endDate = date.end ?? date.start
            let endTime = time.end ?? time.start
            var end = mergedComponents(date: endDate, time: endTime)

            // "Tuesday 9pm - 1am": with no date-side end, an end clock landing
            // before the start is the next day.
            if date.end == nil, end.date() < mergedStart.date() {
                let calendar = context.reference.calendar
                if let rolled = calendar.date(byAdding: .day, value: 1, to: end.date()) {
                    if end.isCertain(.day) {
                        end.assignDate(rolled, calendar: calendar)
                    } else {
                        end.implyDate(rolled, calendar: calendar)
                    }
                }
            }
            mergedEnd = end
        }

        let original = context.normalization.original as NSString
        let start = a.index
        let end = b.rangeEnd
        guard start >= 0, end <= original.length, start < end else { return nil }
        let text = original.substring(with: NSRange(location: start, length: end - start))
        return context.createResult(index: start, text: text, start: mergedStart, end: mergedEnd)
    }

    /// chrono's mergeDateTimeComponent: date fields from the date side, clock
    /// from the time side, meridiem negotiated between them.
    private func mergedComponents(date: ParsingComponents, time: ParsingComponents) -> ParsingComponents {
        var merged = date

        if time.isCertain(.hour) {
            merged.certain(.hour, time.get(.hour) ?? 0)
            merged.certain(.minute, time.get(.minute) ?? 0)
            if time.isCertain(.second) {
                merged.certain(.second, time.get(.second) ?? 0)
                if time.isCertain(.millisecond) {
                    merged.certain(.millisecond, time.get(.millisecond) ?? 0)
                } else {
                    merged.imply(.millisecond, time.get(.millisecond) ?? 0)
                }
            } else {
                merged.imply(.second, time.get(.second) ?? 0)
                merged.imply(.millisecond, time.get(.millisecond) ?? 0)
            }
        } else {
            if let hour = time.get(.hour) { merged.imply(.hour, hour) }
            if let minute = time.get(.minute) { merged.imply(.minute, minute) }
            if let second = time.get(.second) { merged.imply(.second, second) }
            if let ms = time.get(.millisecond) { merged.imply(.millisecond, ms) }
        }

        if time.isCertain(.timezoneOffset) {
            merged.certain(.timezoneOffset, time.get(.timezoneOffset) ?? 0)
        }

        // The date side's meridiem is "meaningful" whenever it exists at all:
        // reference seeding never sets one, so its presence on a side with no
        // certain hour is always a parser's deliberate hint ("tonight" = pm).
        // chrono gates this on casual-reference tags; presence is the same test
        // in this model.
        let dateHasMeaningfulMeridiem = date.get(.meridiem) != nil

        if time.isCertain(.meridiem) {
            merged.certain(.meridiem, time.get(.meridiem) ?? 0)
        } else if let timeMeridiem = time.get(.meridiem), !dateHasMeaningfulMeridiem {
            merged.imply(.meridiem, timeMeridiem)
        }

        // The pm promotion: "tonight at 8" -> 20, "this afternoon at 3" -> 15.
        if merged.get(.meridiem) == Meridiem.pm.rawValue, let hour = merged.get(.hour), hour < 12 {
            if time.isCertain(.hour) {
                merged.certain(.hour, hour + 12)
            } else {
                merged.imply(.hour, hour + 12)
            }
        }

        return merged
    }

    /// The side has at least one field a parser actually produced, as opposed to
    /// pure reference seeding.
    private func hasSubstance(_ c: ParsingComponents) -> Bool {
        ParsingComponents.Component.allCases.contains { c.isCertain($0) }
            || c.get(.meridiem) != nil
    }

    /// The text between the two matches must be short glue: whitespace, at most
    /// one punctuation mark (, - . : ∙), or a single connector word (a time
    /// prefix like "at", or a locale glue word like "after").
    private func glueIsMergeable(between a: ParsedResult, and b: ParsedResult, _ context: ParsingContext) -> Bool {
        let original = context.normalization.original as NSString
        let gapStart = min(a.rangeEnd, b.rangeEnd)
        let gapEnd = max(a.index, b.index)
        guard gapStart <= gapEnd, gapEnd <= original.length else { return false }
        let gap = original.substring(with: NSRange(location: gapStart, length: gapEnd - gapStart))
        let trimmed = gap.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return true }
        if [",", "-", ".", ":", "\u{2219}", "\u{2022}"].contains(trimmed) { return true }
        let words = context.locale.patterns.timePrefixWords + context.locale.patterns.dateTimeGlueWords
        let connectors = Set(words.map { WordTable<Int>.fold($0) })
        return connectors.contains(WordTable<Int>.fold(trimmed))
    }
}
