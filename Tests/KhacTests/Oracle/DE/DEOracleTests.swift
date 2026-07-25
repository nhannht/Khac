// Runs the ported chrono DE oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [DELocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/de/*.test.ts, never chrono's test code.
//
// Reporting mirrors ENOracleTests.swift: PER CASE, not per asserted field. A
// case known to be blocked by an engine gap (see checkpoint 1 - the day-token
// separator/decoration in MonthNameParser.swift is hardcoded English-shaped,
// and RelativeUnitParser.swift has no NUMBER-MODIFIER-UNIT alternative) is
// deferred with its own XCTExpectFailure reason rather than silently left to
// fail the bulk XCTFail - never deleted, never weakened.

import Foundation
import XCTest
import Khac

struct DEOracleRunner {
    let khac = Khac(localeInstances: [DELocale()])

    let fixedCalendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }()

    private func dateComponents(_ d: OracleDate) -> DateComponents {
        var comps = DateComponents()
        comps.year = d.year
        comps.month = d.month
        comps.day = d.day
        comps.hour = d.hour
        comps.minute = d.minute
        comps.second = d.second
        comps.nanosecond = d.millisecond * 1_000_000
        return comps
    }

    private func reference(_ d: OracleDate) -> ReferencePoint {
        let instant = fixedCalendar.date(from: dateComponents(d)) ?? Date()
        return ReferencePoint(instant: instant, calendar: fixedCalendar)
    }

    private func resolvedDate(_ d: OracleDate) -> Date {
        fixedCalendar.date(from: dateComponents(d)) ?? Date()
    }

    private func componentReasons(_ expected: OracleComponents, _ actual: ParsingComponents, _ side: String) -> [String] {
        var reasons: [String] = []
        func compare(_ name: String, _ want: Int?, _ component: ParsingComponents.Component) {
            guard let want = want else { return }
            let got = actual.get(component)
            if got != want {
                reasons.append("\(side).\(name) want \(want) got \(got.map(String.init(describing:)) ?? "nil")")
            }
        }
        compare("year", expected.year, .year)
        compare("month", expected.month, .month)
        compare("day", expected.day, .day)
        compare("hour", expected.hour, .hour)
        compare("minute", expected.minute, .minute)
        compare("second", expected.second, .second)
        compare("millisecond", expected.millisecond, .millisecond)
        compare("weekday", expected.weekday, .weekday)
        compare("timezoneOffset", expected.timezoneOffset, .timezoneOffset)
        return reasons
    }

    /// Every way this case failed. Empty means the case passes.
    func reasons(for c: OracleCase) -> [String] {
        let mode: Options.Mode = c.mode == .strict ? .strict : .casual
        let options = Options(mode: mode, forwardDate: c.forwardDate)
        let results = khac.parse(c.input, reference: reference(c.reference), options: options)

        switch c.expectation {
        case .noMatch:
            guard !results.isEmpty else { return [] }
            return ["want no match, got \(results.count): \(results.map(\.text))"]

        case .match(let text, let index, let start, let startDate, let end, let endDate):
            guard let result = results.first else { return ["want a match, got none"] }
            var reasons: [String] = []
            if let text = text, result.text != text {
                reasons.append("text want \(text.debugDescription) got \(result.text.debugDescription)")
            }
            if let index = index, result.index != index {
                reasons.append("index want \(index) got \(result.index)")
            }
            if !start.isEmpty {
                reasons += componentReasons(start, result.start, "start")
            }
            if let startDate = startDate, result.start.date() != resolvedDate(startDate) {
                reasons.append("startDate want \(resolvedDate(startDate)) got \(result.start.date())")
            }
            if !end.isEmpty {
                if let endComponents = result.end {
                    reasons += componentReasons(end, endComponents, "end")
                } else {
                    reasons.append("want end components, got none")
                }
            }
            if let endDate = endDate {
                if let endComponents = result.end {
                    if endComponents.date() != resolvedDate(endDate) {
                        reasons.append("endDate want \(resolvedDate(endDate)) got \(endComponents.date())")
                    }
                } else {
                    reasons.append("want an end date, got none")
                }
            }
            return reasons
        }
    }
}

final class DEOracleTests: XCTestCase {
    private let runner = DEOracleRunner()

    /// Fails once per failing CASE not covered by `deferrals`, listing every
    /// reason that case failed. A case listed in `deferrals` is wrapped in its
    /// own XCTExpectFailure, keyed by ARRAY INDEX (not input text - several
    /// cases repeat the same input against a different reference) so an
    /// unexpected PASS is reported too, catching a wrong prediction rather than
    /// silently hiding it.
    private func run(_ cases: [OracleCase], deferrals: [Int: String] = [:]) {
        for (i, c) in cases.enumerated() {
            if let reason = deferrals[i] {
                XCTExpectFailure(reason) {
                    let reasons = runner.reasons(for: c)
                    XCTAssertTrue(
                        reasons.isEmpty,
                        "[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; ")
                    )
                }
                continue
            }
            let reasons = runner.reasons(for: c)
            guard !reasons.isEmpty else { continue }
            XCTFail("[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; "))
        }
    }

    // MARK: - Deferral reasons (checkpoint 1 / follow-up findings, engine-owned)

    /// MonthNameParser.swift's day-month separator is hardcoded to hyphen,
    /// slash, or whitespace+"of" - no locale slot for a period glued directly to
    /// the day digits with no required space before it ("10. August", "15.Sep").
    /// This is the dominant German date shape (31 of 124 DE cases use it).
    private static let dayPeriodMonth =
        "KHAC-6 deferral: day+period+month ('10. August') needs a day-token separator MonthNameParser.swift does not support - reported to engine at checkpoint 1"

    /// RelativeUnitParser.swift's six alternatives (past-suffix, future-suffix,
    /// future-prefix, signed, modifier-prefix, bare-modifier) have no slot for a
    /// modifier landing AFTER the number and BEFORE the unit word.
    private static let numberModifierUnit =
        "KHAC-6 deferral: NUMBER-MODIFIER-UNIT duration ('30 vorangegangenen Tagen') has no matching alternative in RelativeUnitParser.swift - reported to engine at checkpoint 1"

    /// NumericDateParser.swift's dot-separator guard requires a 4-digit year
    /// present anywhere in the match, treating any 2-digit-year dot form as a
    /// decimal/version number universally. German's dd.mm.yy is the standard,
    /// unambiguous 2-digit-year numeric date (the German decimal separator is a
    /// comma, not a period, so there is no real collision to guard against here)
    /// - the guard is right for the locale it was written against and wrong for
    /// this one, with no override. Found running this suite, reported to engine.
    private static let dotDateTwoDigitYear =
        "KHAC-6 deferral: NumericDateParser.swift's dot-separator guard demands a 4-digit year, rejecting German's standard 2-digit-year dd.mm.yy - reported to engine"

    /// Named timezone abbreviations (CET) are out of scope for Khac v1's generic
    /// parsers - the SAME boundary the EN oracle already excludes 5 cases for
    /// (see Oracle/README.md), not a new German-specific gap.
    private static let namedTimezone =
        "KHAC-6 deferral: named timezone abbreviation (CET) unsupported - same v1 scope boundary EN's oracle already excludes, not a new gap"

    func testCasualCases() { run(deCasualCases) }

    func testDashCases() {
        run(deDashCases, deferrals: [2: Self.dotDateTwoDigitYear, 3: Self.dotDateTwoDigitYear])
    }

    func testMonthNameLittleEndianCases() {
        // Every one of the 20 cases in this file is the day+period+month shape,
        // including the trailing noMatch case ("32. Oktober 2015"): with the
        // period construction unimplemented, the shared MonthNameParser's
        // bare-month-plus-year fallback (present for every locale, but never
        // registered for German in chrono's own parser list - see
        // src/locales/de/index.ts) wrongly claims "Oktober 2015" on its own.
        run(deMonthNameLittleEndianCases, deferrals: Dictionary(
            uniqueKeysWithValues: (0..<deMonthNameLittleEndianCases.count).map { ($0, Self.dayPeriodMonth) }
        ))
    }

    func testTimeExpCases() {
        run(deTimeExpCases, deferrals: [15: Self.namedTimezone, 16: Self.namedTimezone, 20: Self.namedTimezone])
    }

    func testTimeUnitsCasualRelativeCases() {
        run(deTimeUnitsCasualRelativeCases, deferrals: [4: Self.numberModifierUnit])
    }

    func testTimeUnitsWithinCases() { run(deTimeUnitsWithinCases) }

    func testWeekdayCases() {
        run(deWeekdayCases, deferrals: [7: Self.dayPeriodMonth])
    }

    func testYearCases() {
        // Every case in de_year.test.ts is "10. August <year> <era>" - the same
        // day+period+month shape, blocked for the same reason.
        run(deYearCases, deferrals: Dictionary(
            uniqueKeysWithValues: (0..<deYearCases.count).map { ($0, Self.dayPeriodMonth) }
        ))
    }
}

/// The progress instrument, mirroring ENOracleScoreboardTests. Prints how many
/// oracle cases the engine reproduces, broken down by chrono source file, and
/// holds a ratchet floor so the number can only go up.
final class DEOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression. 87/124 as of this port - the 37 gap is the
    /// four deferrals in DEOracleTests above (day+period+month, 31 cases;
    /// NUMBER-MODIFIER-UNIT duration, 1; named timezone, 3; 2-digit-year dot
    /// date, 2).
    static let floor = 87

    func testScoreboard() {
        let runner = DEOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in deOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["DE ORACLE SCOREBOARD  \(passed)/\(deOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "DE oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
