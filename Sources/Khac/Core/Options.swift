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

    // There is deliberately no `timeZone` here. A time zone reaches resolution by
    // exactly two routes, each with one owner: the CALLER's zone travels on the
    // reference (`ReferencePoint(instant:timeZone:)`), and a zone stated IN THE
    // TEXT travels as a certain `.timezoneOffset` component, which overrides the
    // reference calendar in `ParsingComponents.date()`. An option carrying the
    // caller's zone a second time would duplicate the first route and require a
    // precedence rule between two spellings of the same fact.

    public init(mode: Mode = .casual, forwardDate: Bool = false) {
        self.mode = mode
        self.forwardDate = forwardDate
    }
}
