// RelativeDuration.swift - a parsed duration and the arithmetic that applies it.
//
// A relative expression is a DURATION applied to an ANCHOR. The anchor is
// usually implicit (the reference), but "2 days after tomorrow" anchors the
// same duration on a neighbouring result instead. Keeping the duration as a
// value - rather than resolving straight to a Date at parse time - is what lets
// one expression be re-anchored later without re-running any regex.
//
// A duration is an ORDERED clause list, largest unit first: "1 day 21 hours" is
// [(.day, 1), (.hour, 21)], not 45 hours. That distinction is load-bearing:
// adding 2 months is not adding a fixed number of days, so a duration can never
// be flattened to a single component without losing meaning.

import Foundation

/// Which way a relative duration moves from its anchor.
enum RelativeDirection {
    case past
    case future

    /// The multiplier this direction applies to every clause count.
    var sign: Int {
        switch self {
        case .past: return -1
        case .future: return 1
        }
    }
}

/// One clause of a duration, before fractions are resolved. `amount` is
/// fractional so a quantifier like "half" survives parsing intact; whole
/// clauses are produced by `RelativeDuration.init`.
struct DurationClause {
    var component: Calendar.Component
    var amount: Double

    init(_ component: Calendar.Component, _ amount: Double) {
        self.component = component
        self.amount = amount
    }
}

struct RelativeDuration {
    /// Whole-number clauses, largest unit first, after fraction cascading.
    let clauses: [(component: Calendar.Component, count: Int)]
    let direction: RelativeDirection

    /// True when nothing survived normalization (e.g. a fraction too small to
    /// express). Callers reject these rather than emitting a zero-shift result.
    var isEmpty: Bool { clauses.isEmpty }

    /// Build from fractional clauses, cascading each clause's remainder into the
    /// next smaller unit (see `cascade`). Clauses naming the same component are
    /// summed, so "1 hour 30 min" and "1.5 hours" normalize identically.
    init(_ raw: [DurationClause], direction: RelativeDirection) {
        var totals: [Calendar.Component: Double] = [:]
        for clause in raw {
            totals[clause.component, default: 0] += clause.amount
        }

        var resolved: [Calendar.Component: Int] = [:]
        for component in Self.cascadeOrder {
            guard let total = totals[component], total != 0 else { continue }
            let whole = total < 0 ? total.rounded(.up) : total.rounded(.down)
            let fraction = total - whole
            if whole != 0 {
                resolved[component, default: 0] += Int(whole)
            }
            // Push the remainder down to the next unit that can express it.
            if fraction != 0, let (next, factor) = Self.cascade[component] {
                totals[next, default: 0] += fraction * factor
            }
        }

        self.clauses = Self.cascadeOrder.compactMap { component in
            guard let count = resolved[component], count != 0 else { return nil }
            return (component, count)
        }
        self.direction = direction
    }

    /// Apply this duration to an anchor instant. Returns nil when the calendar
    /// cannot represent the result.
    func apply(to anchor: Date, calendar: Calendar) -> Date? {
        var result = anchor
        for clause in clauses {
            guard let shifted = calendar.date(
                byAdding: clause.component,
                value: clause.count * direction.sign,
                to: result
            ) else { return nil }
            result = shifted
        }
        return result
    }

    // MARK: Fraction cascading

    /// Where a fractional remainder goes, and by what factor. Reproduces
    /// chrono's own cascade (src/calculation/duration.ts) so fractional
    /// quantifiers behave identically: "half an hour" is 30 minutes, not a
    /// floored zero hours.
    ///
    /// Two deliberate notes.
    ///
    /// The month-to-week factor of 4 is chrono's approximation, not a true
    /// month length. It is kept for behavioral parity. No oracle case exercises
    /// a fractional month, so this is parity by construction, not a tested
    /// claim - the only fraction any current case uses is "half an hour".
    ///
    /// `.quarter` has NO cascade in chrono at all: it floors and silently drops
    /// the remainder. That reads as an accidental gap rather than a decision,
    /// so Khac cascades it consistently into months. Also untested by any case.
    private static let cascade: [Calendar.Component: (Calendar.Component, Double)] = [
        .year: (.month, 12),
        .quarter: (.month, 3),
        .month: (.weekOfYear, 4),
        .weekOfYear: (.day, 7),
        .day: (.hour, 24),
        .hour: (.minute, 60),
        .minute: (.second, 60),
        .second: (.nanosecond, 1_000_000_000),
    ]

    /// Largest unit to smallest. Both the cascade walk and the emitted clause
    /// order follow this, so a duration always applies its coarse shifts first
    /// (adding a month then an hour is not the same as the reverse near a
    /// month boundary).
    static let cascadeOrder: [Calendar.Component] = [
        .year, .quarter, .month, .weekOfYear, .day, .hour, .minute, .second, .nanosecond,
    ]
}
