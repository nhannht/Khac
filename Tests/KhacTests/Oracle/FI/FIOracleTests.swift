// Runs the ported chrono FI oracle (this directory's *Cases.swift tables)
// against the real engine via Khac(localeInstances: [FILocale()]). See NOTICE
// and Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/fi/*.test.ts, never chrono's test code.
//
// Mirrors RUOracleTests.swift/UKOracleTests.swift's structure, including the
// deferral mechanism - see RUOracleTests.swift's header comment for the
// rationale. Finnish's ported corpus is much narrower than ru/uk's (77 cases
// against 131 each - see FILocale.swift's header comment for why), and hits
// only one of the KHAC-6 gaps, in its own form.

import Foundation
import XCTest
import Khac

struct FIOracleRunner {
    let khac = Khac(localeInstances: [FILocale()])

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

final class FIOracleTests: XCTestCase {
    private let runner = FIOracleRunner()

    /// Cases individually deferred pending a specific engine gap reported to
    /// `main` (KHAC-6). Empty: both gaps fi hit (dateConnectorWords not being
    /// read, MonthNameParser's monthOnly having no per-locale opt-out) have
    /// since landed centrally - FILocale now sets dateConnectorWords = ["."]
    /// and options.monthNameForms = [.dayFirst], and all three previously
    /// deferred cases were watched go green here before removal. See
    /// FILocale.swift's header comment for the full account.
    private let deferrals: [String: String] = [:]

    private func run(_ cases: [OracleCase]) {
        for c in cases {
            if let reason = deferrals[c.input] {
                expectKnownFailure(reason) {
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

    func testCasualCases() { run(fiCasualCases) }
    func testCasualTimeCases() { run(fiCasualTimeCases) }
    func testMonthNameLittleEndianCases() { run(fiMonthNameLittleEndianCases) }
    func testTimeUnitsAgoCases() { run(fiTimeUnitsAgoCases) }
    func testTimeUnitsCasualRelativeCases() { run(fiTimeUnitsCasualRelativeCases) }
    func testTimeUnitsWithinCases() { run(fiTimeUnitsWithinCases) }
    func testWeekdayCases() { run(fiWeekdayCases) }
}

/// The progress instrument, mirroring RUOracleScoreboardTests/
/// UKOracleScoreboardTests exactly.
final class FIOracleScoreboardTests: XCTestCase {
    static let floor = 77

    func testScoreboard() {
        let runner = FIOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in fiOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["FI ORACLE SCOREBOARD  \(passed)/\(fiOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "FI oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
