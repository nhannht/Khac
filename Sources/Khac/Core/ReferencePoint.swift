// ReferencePoint.swift - the "now" a parse is resolved against.

import Foundation

/// The instant and calendar that relative expressions ("tomorrow", "next
/// Friday") resolve against. The calendar carries the time zone used to build
/// resolved dates.
public struct ReferencePoint {
    public let instant: Date
    public let calendar: Calendar

    /// Full control: supply both instant and calendar (calendar carries the zone).
    public init(instant: Date = Date(), calendar: Calendar = ReferencePoint.defaultCalendar) {
        self.instant = instant
        self.calendar = calendar
    }

    /// Convenience: instant plus a time zone, on a Gregorian calendar.
    public init(instant: Date, timeZone: TimeZone) {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = timeZone
        self.instant = instant
        self.calendar = cal
    }

    /// Now, on a Gregorian calendar in the current time zone.
    public static var now: ReferencePoint { ReferencePoint() }

    /// A Gregorian calendar in the current time zone. Date parsing wants a
    /// proleptic Gregorian calendar regardless of the user's locale calendar.
    public static var defaultCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.current
        return cal
    }
}
