// Runs the ported chrono UK oracle (this directory's *Cases.swift tables)
// against the real engine via Khac(localeInstances: [UKLocale()]). See NOTICE
// and Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/uk/*.test.ts, never chrono's test code.
//
// Mirrors RUOracleTests.swift exactly, including the deferral mechanism - see
// that file's header comment for the rationale. Ukrainian shares Russian's
// grammar shape (Slavic sibling), so the same engine gaps (KHAC-6) recur here
// with Ukrainian's own words; the deferral list below is the uk-specific
// subset actually exercised by uk's ported oracle.

import Foundation
import XCTest
import Khac

struct UKOracleRunner {
    let khac = Khac(localeInstances: [UKLocale()])

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

final class UKOracleTests: XCTestCase {
    private let runner = UKOracleRunner()

    /// Cases individually deferred pending a specific engine gap reported to
    /// `main` (KHAC-6), keyed by input text. Same gaps as RU's own deferral
    /// list (see RULocale.swift's header comment), uk's own words, and one
    /// fewer entry - no case in uk's ported oracle exercises the trailing
    /// year-suffix gap RU's "года" case does.
    private let deferrals: [String: String] = [
        "Подія від сьогодні і до післязавтра":
            "KHAC-6 deferral: CasualDateParser's bare day-reference branch has no data-driven prefix hook for \"від\" (reported to main, needs dayReferencePrefixWords)",
        "в січні":
            "KHAC-6 deferral: MonthNameParser's monthOnly branch has no data-driven prefix hook for \"в\" (reported to main, needs monthPrefixWords)",
        "в січ":
            "KHAC-6 deferral: same gap as \"в січні\" - monthPrefixWords",
        "Це було у вересні 2012 перед новим роком":
            "KHAC-6 deferral: same gap as \"в січні\" - monthPrefixWords (here \"у\"), with a trailing year",
        "із 10 по 22 серпня 2012":
            "KHAC-6 deferral: MonthNameParser's little branch hardcodes English \"on\" instead of a data-driven prefix; reported as the same monthPrefixWords fix generalized to this branch",
        "24го жовтня, 9:00":
            "KHAC-6 deferral: MonthNameParser's day-ordinal suffix is hardcoded to English st/nd/rd/th; Ukrainian's го/ого/е has no field (reported to main)",
        "півгодини тому щось відбулось":
            "KHAC-6 deferral: DurationExpression requires whitespace between a word-count and its unit; півгодини is glued with none (reported to main)",
        "через півгодини":
            "KHAC-6 deferral: same gap as \"півгодини тому\" - glued quantifier+unit",
        "через тиждень":
            "KHAC-6 deferral: DurationExpression's clause pattern requires an explicit count (digits or word); Ukrainian elides the count entirely for 1 (\"через тиждень\", no word at all) - reported to main",
        "через місяць":
            "KHAC-6 deferral: same gap as \"через тиждень\" - elided count defaulting to 1",
        "через рік":
            "KHAC-6 deferral: same gap as \"через тиждень\" - elided count defaulting to 1",
        "буде зроблено протягом хвилини":
            "KHAC-6 deferral: same gap as \"через тиждень\" - elided count defaulting to 1 (\"протягом хвилини\", no count word)",
    ]

    private func run(_ cases: [OracleCase]) {
        for c in cases {
            if let reason = deferrals[c.input] {
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

    func testCasualCases() { run(ukCasualCases) }
    func testMonthCases() { run(ukMonthCases) }
    func testMonthNameLittleEndianCases() { run(ukMonthNameLittleEndianCases) }
    func testRelativeCases() { run(ukRelativeCases) }
    func testTimeExpCases() { run(ukTimeExpCases) }
    func testTimeUnitsAgoCases() { run(ukTimeUnitsAgoCases) }
    func testTimeUnitsCasualRelativeCases() { run(ukTimeUnitsCasualRelativeCases) }
    func testTimeUnitsWithinCases() { run(ukTimeUnitsWithinCases) }
    func testWeekdayCases() { run(ukWeekdayCases) }
}

/// The progress instrument, mirroring RUOracleScoreboardTests exactly.
final class UKOracleScoreboardTests: XCTestCase {
    static let floor = 119

    func testScoreboard() {
        let runner = UKOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in ukOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["UK ORACLE SCOREBOARD  \(passed)/\(ukOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "UK oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
