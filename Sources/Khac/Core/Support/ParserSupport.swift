// ParserSupport.swift - shared helpers that make the generic parsers data-driven.
//
// A WordTable turns one of a locale's vocabulary dictionaries into (a) a regex
// alternation fragment to splice into a pattern and (b) a lookup from matched
// text back to the value. This is what lets ONE parser serve every locale: the
// words are data, the parsing logic is shared.

import Foundation

/// A locale word table compiled into a regex alternation plus a value lookup.
struct WordTable<Value> {
    /// A non-capturing alternation of the (escaped) keys, or a never-match group
    /// when empty. Splice this into a larger pattern.
    let alternation: String
    private let map: [String: Value]

    init(_ dictionary: [String: Value]) {
        var normalized: [String: Value] = [:]
        for (key, value) in dictionary {
            normalized[WordTable.fold(key)] = value
        }
        self.map = normalized
        self.alternation = regexAlternation(Array(normalized.keys)) ?? "(?!)"
    }

    /// The value for a matched substring, folded to the table's key form.
    func value(for matched: String) -> Value? {
        map[WordTable.fold(matched)]
    }

    /// True when the table has no entries (its alternation never matches).
    var isEmpty: Bool { map.isEmpty }

    /// Fold to NFC + lowercase so lookups are case-insensitive and match the
    /// normalized text the engine searches.
    static func fold(_ s: String) -> String {
        s.precomposedStringWithCanonicalMapping.lowercased()
    }
}

// MARK: - Calendar validity

/// True when (year, month, day) is a real calendar date: the month is 1...12 and
/// the day falls within that month's length for that year, leap years included.
/// Rejects impossible numeric dates such as 06/31 or a non-leap 02/29 by building
/// the date and checking it round-trips without the calendar rolling it over.
func isRealDate(year: Int, month: Int, day: Int, calendar: Calendar) -> Bool {
    guard (1...12).contains(month), day >= 1 else { return false }
    var c = DateComponents()
    c.year = year
    c.month = month
    c.day = day
    c.hour = 12
    guard let date = calendar.date(from: c) else { return false }
    let back = calendar.dateComponents([.year, .month, .day], from: date)
    return back.year == year && back.month == month && back.day == day
}

// MARK: - Reference and calendar helpers

extension ReferencePoint {
    /// Broken-down components of the reference instant in the reference calendar.
    var brokenDown: DateComponents {
        calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond, .weekday],
            from: instant
        )
    }
}

extension ParsingComponents {
    /// Imply the reference's clock time (hour/minute/second/millisecond) onto this
    /// component set, overriding the default noon implication. Used by casual date
    /// references ("today", "tomorrow") which chrono resolves at the reference's
    /// time of day rather than noon.
    mutating func implySimilarTime(to reference: ReferencePoint) {
        let c = reference.brokenDown
        imply(.hour, c.hour ?? 0)
        imply(.minute, c.minute ?? 0)
        imply(.second, c.second ?? 0)
        imply(.millisecond, ParsingComponents.milliseconds(fromNanoseconds: c.nanosecond ?? 0))
    }

    /// Assign a certain calendar date (year/month/day) from an absolute Date,
    /// read in the reference calendar.
    mutating func assignDate(_ date: Date, calendar: Calendar) {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        certain(.year, c.year ?? 0)
        certain(.month, c.month ?? 0)
        certain(.day, c.day ?? 0)
    }

    /// Imply a calendar date (year/month/day) from an absolute Date. Used where
    /// chrono treats the date as implied (e.g. a bare weekday), overriding the
    /// reference values seeded at construction.
    mutating func implyDate(_ date: Date, calendar: Calendar) {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        imply(.year, c.year ?? 0)
        imply(.month, c.month ?? 0)
        imply(.day, c.day ?? 0)
    }
}

// MARK: - Weekday numbering

/// chrono/JS weekday numbering: 0 = Sunday ... 6 = Saturday. This is what the
/// oracle asserts and what locale vocabularies use.
enum Weekday {
    static let sunday = 0
    static let saturday = 6

    /// Convert chrono/JS numbering (0 = Sunday) to Foundation numbering
    /// (1 = Sunday ... 7 = Saturday).
    static func foundation(fromChrono chrono: Int) -> Int {
        (chrono % 7) + 1
    }

    /// Convert Foundation numbering (1 = Sunday) to chrono/JS numbering (0 = Sunday).
    static func chrono(fromFoundation foundation: Int) -> Int {
        (foundation - 1) % 7
    }

    enum Modifier { case this_, next, last }

    /// Number of days from the reference weekday to the target, honoring a
    /// this/next/last modifier. Reimplements chrono's getDaysToWeekday exactly.
    /// All weekday arguments use chrono numbering.
    static func daysToWeekday(refWeekday: Int, target: Int, modifier: Modifier?) -> Int {
        switch modifier {
        case .this_:
            return forwardDays(refWeekday: refWeekday, target: target)
        case .last:
            return backwardDays(refWeekday: refWeekday, target: target)
        case .next:
            if refWeekday == sunday {
                return target == sunday ? 7 : target
            }
            if refWeekday == saturday {
                if target == saturday { return 7 }
                if target == sunday { return 8 }
                return 1 + target
            }
            if target < refWeekday && target != sunday {
                return forwardDays(refWeekday: refWeekday, target: target)
            } else {
                return forwardDays(refWeekday: refWeekday, target: target) + 7
            }
        case nil:
            let backward = backwardDays(refWeekday: refWeekday, target: target)
            let forward = forwardDays(refWeekday: refWeekday, target: target)
            return forward < -backward ? forward : backward
        }
    }

    private static func forwardDays(refWeekday: Int, target: Int) -> Int {
        var forward = target - refWeekday
        if forward < 0 { forward += 7 }
        return forward
    }

    private static func backwardDays(refWeekday: Int, target: Int) -> Int {
        var backward = target - refWeekday
        if backward >= 0 { backward -= 7 }
        return backward
    }
}
