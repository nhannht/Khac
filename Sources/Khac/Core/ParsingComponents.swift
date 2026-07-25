// ParsingComponents.swift - the strong certain-vs-implied component model.
//
// Every component is in exactly one of three states: absent, implied (filled
// from the reference or a parser's assumption), or certain (explicitly parsed).
// This makes illegal states hard to represent: a value cannot be both certain
// and implied, and resolution never guesses at a value that was truly parsed.

import Foundation

/// Whether a component value was explicitly parsed (certain) or filled in
/// (implied) from the reference or a default.
public enum Certainty: Sendable, Hashable {
    case certain
    case implied
}

public struct ParsingComponents {
    /// The date/time fields a result can carry.
    public enum Component: CaseIterable, Sendable, Hashable {
        case year, month, day
        case hour, minute, second, millisecond
        case weekday, meridiem, timezoneOffset
    }

    /// The reference this component set resolves against. Implied values are
    /// seeded from it at construction; certain values override them.
    public let reference: ReferencePoint

    private var values: [Component: (value: Int, certainty: Certainty)] = [:]

    /// Default implied clock time for a bare date with no time parsed. Matches
    /// chrono's behavior (noon). Verified against chrono src/results.ts.
    static let impliedHour = 12
    static let impliedMinute = 0
    static let impliedSecond = 0
    static let impliedMillisecond = 0

    /// Convert a nanosecond count read back from a Date to whole milliseconds,
    /// rounding so that a stored 11ms does not come back as 10 through the
    /// Double-backed Date representation.
    static func milliseconds(fromNanoseconds nanoseconds: Int) -> Int {
        Int((Double(nanoseconds) / 1_000_000).rounded())
    }

    /// Create a component set seeded with implied day/month/year/time from the
    /// reference. Certain values assigned later override these.
    public init(reference: ReferencePoint) {
        self.reference = reference
        let cal = reference.calendar
        let c = cal.dateComponents([.year, .month, .day], from: reference.instant)
        imply(.day, c.day ?? 1)
        imply(.month, c.month ?? 1)
        imply(.year, c.year ?? 2000)
        imply(.hour, Self.impliedHour)
        imply(.minute, Self.impliedMinute)
        imply(.second, Self.impliedSecond)
        imply(.millisecond, Self.impliedMillisecond)
    }

    // MARK: Assignment

    /// Set a certain (explicitly parsed) value.
    public mutating func certain(_ component: Component, _ value: Int) {
        values[component] = (value, .certain)
    }

    /// Set an implied (assumed) value. Does not overwrite a certain value.
    public mutating func imply(_ component: Component, _ value: Int) {
        if let existing = values[component], existing.certainty == .certain { return }
        values[component] = (value, .implied)
    }

    // MARK: Queries

    public func isCertain(_ component: Component) -> Bool {
        values[component]?.certainty == .certain
    }

    /// The current value (certain or implied), or nil if the component is absent.
    public func get(_ component: Component) -> Int? {
        values[component]?.value
    }

    /// Number of certain components. Used by scoring.
    public var specificityScore: Int {
        values.values.reduce(0) { $0 + ($1.certainty == .certain ? 1 : 0) }
    }

    // MARK: Resolution

    /// Resolve to a concrete Date using the reference calendar. A certain
    /// timezoneOffset (minutes from GMT) overrides the calendar's zone.
    public func date() -> Date {
        var comps = DateComponents()
        comps.year = get(.year)
        comps.month = get(.month)
        comps.day = get(.day)
        comps.hour = get(.hour)
        comps.minute = get(.minute)
        comps.second = get(.second)
        if let ms = get(.millisecond) {
            comps.nanosecond = ms * 1_000_000
        }
        var cal = reference.calendar
        if let offsetMinutes = get(.timezoneOffset),
           let zone = TimeZone(secondsFromGMT: offsetMinutes * 60) {
            cal.timeZone = zone
        }
        return cal.date(from: comps) ?? reference.instant
    }
}
