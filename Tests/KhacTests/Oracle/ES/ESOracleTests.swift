// Runs the ported chrono ES oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [ESLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/es/*.test.ts, never chrono's test code.
//
// Reporting is PER CASE, not per asserted field - see ENOracleTests.swift's own
// header comment for why; this file mirrors that runner exactly, parameterized
// on ESLocale.

import Foundation
import XCTest
import Khac

struct ESOracleRunner {
    let khac = Khac(localeInstances: [ESLocale()])

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

final class ESOracleTests: XCTestCase {
    private let runner = ESOracleRunner()

    /// Cases known to fail for a reason OUTSIDE this locale's own data -
    /// reported to `main` at checkpoint 1/2 (KHAC-6). Keyed by input text,
    /// which is unique within each of these small per-file case lists.
    /// Never edit the oracle itself to make one of these pass; remove the
    /// entry only once the underlying engine fix lands and the case goes
    /// green on its own.
    private static let knownDeferrals: [String: String] = [
        // MonthNameParser.swift's day-month connector is hardcoded to English
        // "of" and never reads context.locale.patterns.dateConnectorWords, so
        // "de" (declared in ESLocale.patterns.dateConnectorWords) has no
        // effect. Confirmed by direct build+test: "10 de Agosto" degrades to a
        // bare-month match plus an unrelated merge with a stray "10", never a
        // real day+month construct. Reported to main at checkpoint 1.
        "La fecha límite es el martes, 10 de enero":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        "La fecha límite es el miércoles, 10 de enero ":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        "10 de Agosto de 2012":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        "12 de julio a las 19:00":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        "Algo pasó el 10 de Agosto de 2012 10:12:59 pm":
            "KHAC-6 deferral: MonthNameParser's day-month connector is hardcoded to \"of\", ignores patterns.dateConnectorWords",
        // MonthNameParser.swift's internal day-range connector (the <lday> to
        // <lday2> slot, "10 - 22 Agosto") is hardcoded to English words
        // ("to|-|until|through|till") and never reads
        // patterns.rangeConnectorWords, so "a" (ES's real day-range word) has
        // no effect there. Reported to main at checkpoint 1.
        "10 a 22 Agosto 2012":
            "KHAC-6 deferral: MonthNameParser's internal day-range connector is hardcoded to English words, ignores patterns.rangeConnectorWords",
        // TimeExpressionParser.swift's notTimezoneOffset guard rejects a range
        // whose second side is a bare 3-4 digit run ("930am"), meant to keep a
        // real signed timezone offset ("-0500") from being misread as a range
        // end. The guard does not check for a trailing meridiem/letter, so it
        // also fires on a genuine compact time range ("630-930am"), and the
        // abandoned first side ("630") is then dropped outright by
        // passesLoneNumberFilters' 3+-digit bare-number rule - the match
        // degrades to the unrelated, coincidentally-valid "930am" alone.
        // Confirmed empirically (isolated parse of "630-930am" and
        // "1-230 pm"); EN's own oracle does not exercise this exact shape, so
        // this is a latent gap, not something EN already solved differently.
        "lunes 4/29/2013 630-930am":
            "KHAC-6 deferral: TimeExpressionParser's notTimezoneOffset guard misreads a compact HHMM-HHMM range end as a timezone offset",
        "lunes 5/13/2013 630-930am":
            "KHAC-6 deferral: TimeExpressionParser's notTimezoneOffset guard misreads a compact HHMM-HHMM range end as a timezone offset",
        "martes 7/2/2013 1-230 pm":
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

    func testCasualCases() { run(esCasualCases) }
    func testMonthNameLittleEndianCases() { run(esMonthNameLittleEndianCases) }
    func testSlashCases() { run(esSlashCases) }
    func testTimeExpCases() { run(esTimeExpCases) }
    func testTimeUnitsWithinCases() { run(esTimeUnitsWithinCases) }
}

/// The progress instrument, mirroring ENOracleScoreboardTests.
final class ESOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression. 9 of 75 are deferred (KHAC-6, see
    /// ESOracleTests.knownDeferrals) pending an engine fix outside this
    /// locale's own data - see checkpoint 1/2 reports to main.
    static let floor = 66

    func testScoreboard() {
        let runner = ESOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in esOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["ES ORACLE SCOREBOARD  \(passed)/\(esOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "ES oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
