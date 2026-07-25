// Options.swift - engine-level parse options (distinct from per-locale LocaleOptions).

import Foundation

/// Options that steer a single parse call.
public struct Options {
    /// Casual mode enables relaxed parsers ("tomorrow", "5pm"). Strict mode
    /// restricts to unambiguous absolute forms.
    public enum Mode: Sendable, Hashable {
        case casual
        case strict
    }

    public var mode: Mode
    /// When true, a bare date that could be past or future is pushed forward.
    public var forwardDate: Bool
    /// Overrides the reference calendar's time zone for resolution when set.
    public var timeZone: TimeZone?

    public init(mode: Mode = .casual, forwardDate: Bool = false, timeZone: TimeZone? = nil) {
        self.mode = mode
        self.forwardDate = forwardDate
        self.timeZone = timeZone
    }
}
