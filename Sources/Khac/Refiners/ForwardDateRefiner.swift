// ForwardDateRefiner.swift - push ambiguous results into the future.
//
// Active only under Options.forwardDate. A result that pinned its date fully is
// never touched; only the three ambiguous shapes move, exactly as in chrono's
// ForwardDateRefiner:
//   1. A bare time already past ("1am" at noon) belongs to the coming day.
//   2. A bare weekday already past ("Monday" on a Thursday) is the coming one.
//   3. A month with a guessed year already past ("in December" next January)
//      moves forward a year, up to three times.
//
// Runs AFTER the date-time and weekday merges (so "sunday morning" is one
// result by now) and BEFORE the range merge, so each side of "monday - friday"
// forwards independently and the range repair then untangles the order -
// matching chrono's refiner ordering.

import Foundation

struct ForwardDateRefiner: Refiner {
    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        guard context.options.forwardDate else { return results }
        let calendar = context.reference.calendar
        let reference = context.reference.instant

        return results.map { result in
            var result = result

            // 1. Time-only, already past: move to the following day.
            if result.start.isTimeLikeOnly, reference > result.start.date(),
               let nextDay = calendar.date(byAdding: .day, value: 1, to: reference) {
                result.start.implyDate(nextDay, calendar: calendar)
                if var end = result.end, end.isTimeLikeOnly {
                    end.implyDate(nextDay, calendar: calendar)
                    if result.start.date() > end.date(),
                       let dayAfter = calendar.date(byAdding: .day, value: 1, to: nextDay) {
                        end.implyDate(dayAfter, calendar: calendar)
                    }
                    result.end = end
                }
            }

            // 2. Weekday-only, already past: move to the coming occurrence.
            if result.start.isOnlyWeekdayComponent, reference > result.start.date(),
               let target = result.start.get(.weekday) {
                let refWeekday = Weekday.chrono(fromFoundation: calendar.component(.weekday, from: reference))
                var days = target - refWeekday
                if days < 0 { days += 7 }
                if days == 0 { days = 7 }
                if let forwarded = calendar.date(byAdding: .day, value: days, to: reference) {
                    result.start.implyDate(forwarded, calendar: calendar)
                    if var end = result.end, result.start.date() > end.date() {
                        end.implyDate(forwarded, calendar: calendar)
                        result.end = end
                    }
                }
            }

            // 3. Known month, guessed year, already past: forward a year at a
            // time (a range's end year rides along), capped at three tries.
            if result.start.isDateWithUnknownYear, reference > result.start.date() {
                for _ in 0..<3 where reference > result.start.date() {
                    result.start.imply(.year, (result.start.get(.year) ?? 0) + 1)
                    if var end = result.end, !end.isCertain(.year) {
                        end.imply(.year, (end.get(.year) ?? 0) + 1)
                        result.end = end
                    }
                }
            }

            return result
        }
    }
}
