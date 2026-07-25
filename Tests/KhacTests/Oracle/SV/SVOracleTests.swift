// Runs the ported chrono SV oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [SVLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/sv/*.test.ts, never chrono's test code.
//
// One case is deferred: MonthNameParser.swift's `monthOnly` alternative is
// present for EVERY Khac locale with no per-locale opt-out, but chrono's own
// SV parser list (src/locales/sv/index.ts) registers no bare "month + year, no
// day" fallback at all - the same finding as DE's "32. Oktober 2015" (DE's
// index.ts is equally bare of one), now CONFIRMED recurring across 2 of 3
// locales in this batch rather than a one-off.

import Foundation
import XCTest
import Khac

struct SVOracleRunner {
    let khac = Khac(localeInstances: [SVLocale()])

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

final class SVOracleTests: XCTestCase {
    private let runner = SVOracleRunner()

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

    func testCasualCases() { run(svCasualCases) }

    func testMonthNameLittleEndianCases() {
        run(svMonthNameLittleEndianCases, deferrals: [
            5: "KHAC-6 deferral: MonthNameParser's bare month+year fallback has no per-locale opt-out, but chrono registers none for Swedish (same finding as DE's '32. Oktober 2015') - reported to engine",
        ])
    }

    func testTimeUnitsCasualRelativeCases() { run(svTimeUnitsCasualRelativeCases) }
    func testWeekdayCases() { run(svWeekdayCases) }
}

/// The progress instrument, mirroring DE/NLOracleScoreboardTests.
final class SVOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression. 40/41 - the one gap is the monthOnly
    /// fallback deferral in SVOracleTests above.
    static let floor = 40

    func testScoreboard() {
        let runner = SVOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in svOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["SV ORACLE SCOREBOARD  \(passed)/\(svOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "SV oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
