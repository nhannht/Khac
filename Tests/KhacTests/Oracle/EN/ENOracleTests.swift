// Runs the ported chrono EN oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [ENLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/en/*.test.ts, never chrono's test code.
//
// Reporting is PER CASE, not per asserted field: one oracle case that gets four
// components wrong is one failure carrying four reasons, not four failures. A
// field-level count cannot be read as progress (fixing a parser changes how many
// fields each broken case even reaches), so the case count is the only honest
// measure of how much of chrono's behavior the engine reproduces. testScoreboard
// prints that count per source file and holds the ratchet floor.

import Foundation
import XCTest
import Khac

/// Evaluates one oracle case against the real engine and reports why it failed.
/// Shared by the per-group tests and the scoreboard so there is exactly one
/// judgement of what "passing" means.
struct ENOracleRunner {
    let khac = Khac(localeInstances: [ENLocale()])

    /// All oracle dates (reference and expected) are interpreted against one
    /// fixed Gregorian/UTC calendar, so cases are deterministic regardless of the
    /// machine running them - independent of what ReferencePoint.now would use.
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

final class ENOracleTests: XCTestCase {
    private let runner = ENOracleRunner()

    /// Fails once per failing CASE, listing every reason that case failed.
    private func run(_ cases: [OracleCase]) {
        for c in cases {
            let reasons = runner.reasons(for: c)
            guard !reasons.isEmpty else { continue }
            XCTFail("[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; "))
        }
    }

    func testGeneralCases() { run(generalCases) }
    func testCasualCases() { run(casualCases) }
    func testISOCases() { run(isoCases) }
    func testMergingRelativeDatesCases() { run(mergingRelativeDatesCases) }
    func testMonthCases() { run(monthCases) }
    func testMonthNameLittleEndianCases() { run(monthNameLittleEndianCases) }
    func testMonthNameMiddleEndianCases() { run(monthNameMiddleEndianCases) }
    func testRelativeCases() { run(relativeCases) }
    func testSlashCases() { run(slashCases) }
    func testTimeExpressionCases() { run(timeExpressionCases) }
    func testTimeUnitsAgoCases() { run(timeUnitsAgoCases) }
    func testTimeUnitsCasualRelativeCases() { run(timeUnitsCasualRelativeCases) }
    func testTimeUnitsLaterCases() { run(timeUnitsLaterCases) }
    func testTimeUnitsWithinCases() { run(timeUnitsWithinCases) }
    func testWeekdayCases() { run(weekdayCases) }
    func testYearCases() { run(yearCases) }
    func testYearMonthDayCases() { run(yearMonthDayCases) }
    func testNegativeCases() { run(negativeCases) }
}

/// The progress instrument. Prints how many of the 563 oracle cases the engine
/// reproduces, broken down by chrono source file, and holds a ratchet floor so
/// the number can only go up. Raise `floor` whenever it does.
final class ENOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression.
    static let floor = 528

    func testScoreboard() {
        let runner = ENOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in enOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["EN ORACLE SCOREBOARD  \(passed)/\(enOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "EN oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
