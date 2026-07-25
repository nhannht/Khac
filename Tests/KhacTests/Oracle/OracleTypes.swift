// Engine-agnostic schema for the EN correctness oracle.
//
// Populated from wanasit/chrono (https://github.com/wanasit/chrono, MIT) test CASE
// DATA - see NOTICE and Oracle/README.md for the prior-art credit. This ports only
// the facts chrono's own tests assert (input text, reference date, expected date /
// components), never chrono's test code.
//
// This file has no dependency on Khac's Locale/ParsingComponents protocol, so the
// generated case tables compile standalone before that interface is frozen.
// ENOracleTests.swift wires these into real Khac().parse() assertions.

import Foundation

/// A calendar date/time. Always interpreted against a single fixed Calendar+TimeZone
/// chosen by the test runner (see ENOracleTests.swift), so a case's reference and
/// expected values line up consistently.
public struct OracleDate: Equatable {
    public var year: Int
    public var month: Int
    public var day: Int
    public var hour: Int
    public var minute: Int
    public var second: Int
    public var millisecond: Int

    public init(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 0, _ minute: Int = 0,
                _ second: Int = 0, _ millisecond: Int = 0) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
    }
}

/// Only the components chrono's source test asserted as certain for one side (start or
/// end) of a parsed result. A field left nil simply was not checked by the source test -
/// it does not mean the value is unimportant, only that this oracle case makes no claim
/// about it.
public struct OracleComponents: Equatable {
    public var year: Int?
    public var month: Int?
    public var day: Int?
    public var hour: Int?
    public var minute: Int?
    public var second: Int?
    public var millisecond: Int?
    public var weekday: Int?
    public var timezoneOffset: Int?

    public init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil,
                minute: Int? = nil, second: Int? = nil, millisecond: Int? = nil,
                weekday: Int? = nil, timezoneOffset: Int? = nil) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
        self.weekday = weekday
        self.timezoneOffset = timezoneOffset
    }

    public var isEmpty: Bool {
        year == nil && month == nil && day == nil && hour == nil && minute == nil
            && second == nil && millisecond == nil && weekday == nil && timezoneOffset == nil
    }
}

public enum OracleExpectation {
    /// Khac's parse() must yield zero results for this input - a false-positive guard.
    case noMatch
    /// Khac's parse() must yield a result matching these facts. Unset fields make no
    /// claim (see OracleComponents doc) rather than asserting a specific default.
    case match(
        text: String? = nil,
        index: Int? = nil,
        start: OracleComponents = OracleComponents(),
        startDate: OracleDate? = nil,
        end: OracleComponents = OracleComponents(),
        endDate: OracleDate? = nil
    )
}

/// Fallback reference instant for oracle cases whose source chrono test supplied none.
/// Arbitrary but fixed - Friday, 2012-08-10 12:00:00. Safe as a default ONLY because
/// extract.py verified each such case's expectation does not actually depend on the
/// reference (an absolute date/time, a component-only check, or a no-match guard).
public let khacOracleDefaultReference = OracleDate(2012, 8, 10, 12)

/// Mirrors Khac's own `Options.Mode` (Sources/Khac/Core/Options.swift). Kept as a
/// separate type here (rather than importing Khac) so this data file stays
/// engine-agnostic; ENOracleTests.swift maps it onto the real `Options.Mode`.
public enum OracleMode: Equatable {
    case casual
    case strict
}

public struct OracleCase {
    /// Originating chrono test file (test/en/<sourceFile> in wanasit/chrono), kept for
    /// traceability back to the source oracle.
    public let sourceFile: String
    public let input: String
    public let reference: OracleDate
    /// chrono.strict cases are ported with `mode: .strict`; everything else (bare
    /// chrono, chrono.casual, chrono.en, chrono.fr) is `.casual`, matching Khac's
    /// own default.
    public let mode: OracleMode
    public let forwardDate: Bool
    public let expectation: OracleExpectation

    public init(sourceFile: String, input: String, reference: OracleDate = khacOracleDefaultReference,
                mode: OracleMode = .casual, forwardDate: Bool = false, expectation: OracleExpectation) {
        self.sourceFile = sourceFile
        self.input = input
        self.reference = reference
        self.mode = mode
        self.forwardDate = forwardDate
        self.expectation = expectation
    }
}
