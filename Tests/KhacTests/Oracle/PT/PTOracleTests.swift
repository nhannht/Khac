// Runs the ported chrono PT oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [PTLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/pt/*.test.ts, never chrono's test code.
//
// Reporting is PER CASE, not per asserted field - see ENOracleTests.swift's own
// header comment for why; this file mirrors that runner exactly, parameterized
// on PTLocale.

import Foundation
import XCTest
import Khac

struct PTOracleRunner {
    let khac = Khac(localeInstances: [PTLocale()])

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

final class PTOracleTests: XCTestCase {
    private let runner = PTOracleRunner()

    /// Cases known to fail for a reason OUTSIDE this locale's own data -
    /// reported to `main` (KHAC-6). Keyed by input text, unique within each of
    /// these small per-file case lists. Never edit the oracle itself to make
    /// one of these pass; remove the entry only once the underlying fix lands
    /// and the case goes green on its own.
    private static let knownDeferrals: [String: String] = [
        // MonthNameParser's day-month connector is hardcoded to "of" and never
        // reads patterns.dateConnectorWords - the same wall reported from ES
        // and FR.
        "O prazo é terça-feira, 10 de janeiro":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        "10 de Agosto de 2012":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        "12 de Julho às 19:00":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        "Algo passou em 10 de Agosto de 2012 10:12:59 pm":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        // MonthNameParser's internal day-range connector is hardcoded to
        // English words and never reads patterns.rangeConnectorWords - same
        // wall reported from ES and FR.
        "10 a 22 Agosto 2012":
            "KHAC-6 deferral: MonthNameParser's internal day-range connector is hardcoded to English words, ignores patterns.rangeConnectorWords",
        // TimeExpressionParser's notTimezoneOffset guard misreads a compact
        // HHMM-HHMM range end as a timezone offset - same wall reported from
        // ES and FR.
        "segunda 4/29/2013 630-930am":
            "KHAC-6 deferral: TimeExpressionParser's notTimezoneOffset guard misreads a compact HHMM-HHMM range end as a timezone offset",
        "segunda-feira 5/13/2013 630-930am":
            "KHAC-6 deferral: TimeExpressionParser's notTimezoneOffset guard misreads a compact HHMM-HHMM range end as a timezone offset",
        "terça-feira 7/2/2013 1-230 pm":
            "KHAC-6 deferral: TimeExpressionParser's notTimezoneOffset guard misreads a compact HHMM-HHMM range end as a timezone offset",
    ]

    private func run(_ cases: [OracleCase]) {
        for c in cases {
            if let reason = Self.knownDeferrals[c.input] {
                XCTExpectFailure(reason) {
                    let reasons = runner.reasons(for: c)
                    XCTAssertTrue(reasons.isEmpty, "[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; "))
                }
                continue
            }
            let reasons = runner.reasons(for: c)
            guard !reasons.isEmpty else { continue }
            XCTFail("[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; "))
        }
    }

    func testCasualCases() { run(ptCasualCases) }
    func testMonthNameLittleEndianCases() { run(ptMonthNameLittleEndianCases) }
    func testSlashCases() { run(ptSlashCases) }
    func testTimeExpCases() { run(ptTimeExpCases) }
}

/// The progress instrument, mirroring ENOracleScoreboardTests.
final class PTOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression. 8 of 60 are deferred (KHAC-6, see
    /// PTOracleTests.knownDeferrals) pending engine fixes outside this
    /// locale's own data - see checkpoint reports to main.
    static let floor = 52

    func testScoreboard() {
        let runner = PTOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in ptOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["PT ORACLE SCOREBOARD  \(passed)/\(ptOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "PT oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
