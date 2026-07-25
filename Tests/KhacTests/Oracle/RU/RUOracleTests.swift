// Runs the ported chrono RU oracle (this directory's *Cases.swift tables)
// against the real engine via Khac(localeInstances: [RULocale()]). See NOTICE
// and Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/ru/*.test.ts, never chrono's test code.
//
// Reporting is PER CASE, not per asserted field - see ENOracleTests.swift's own
// header comment for why. Mirrors that file's structure exactly.
//
// A small, individually-reasoned set of cases is deferred via XCTExpectFailure
// rather than passing: each depends on a specific engine gap reported to
// `main` under KHAC-6 (see RULocale.swift's header comment), not on anything
// wrong with the data ported here. None are skipped, edited, or weakened -
// every reason names the exact missing capability.

import Foundation
import XCTest
import Khac

struct RUOracleRunner {
    let khac = Khac(localeInstances: [RULocale()])

    /// Same fixed Gregorian/UTC calendar as ENOracleRunner, for the same reason:
    /// deterministic cases regardless of the machine running them.
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

final class RUOracleTests: XCTestCase {
    private let runner = RUOracleRunner()

    /// Cases individually deferred pending a specific engine gap reported to
    /// `main` (KHAC-6), keyed by input text (unique within ru's ported corpus).
    /// Each reason names the exact missing capability. Six former deferrals
    /// (dayReferencePrefixWords, monthPrefixWords, bareMonthPrefixWords,
    /// dayOrdinalSuffixes, yearSuffixWords) are gone from this list because
    /// the fields landed and RULocale now sets them - watched go green here
    /// before removal, per main's instruction not to flip a deferral on faith.
    private let deferrals: [String: String] = [
        "полчаса назад что-то было":
            "KHAC-6 deferral: DurationExpression requires whitespace between a word-count and its unit; получаса/полчаса is glued with none (reported to main)",
        "через полчаса":
            "KHAC-6 deferral: same gap as \"полчаса назад\" - glued quantifier+unit",
        "через неделю":
            "KHAC-6 deferral: options.elidesDurationCount exists and would read this correctly on its own, but turning it on regresses \"на этой неделе\"/\"в этом месяце\"/\"в этом году\" (three DIFFERENT, previously-passing cases) through an interaction with RelativeUnitParser's modifierAlt - see RULocale.swift's `options` comment for the full mechanism. Left off until main scopes the elided alternative out of the modifier-prefixed duration fragment.",
        "через месяц":
            "KHAC-6 deferral: same gap as \"через неделю\" - elidesDurationCount regresses 3 other cases if turned on",
        "будет сделано в течение минуты":
            "KHAC-6 deferral: same gap as \"через неделю\" - elidesDurationCount regresses 3 other cases if turned on",
    ]

    /// Fails once per failing CASE, listing every reason that case failed.
    /// A case in `deferrals` is expected to currently fail for its stated
    /// reason - XCTExpectFailure keeps the suite green on it without silently
    /// dropping the assertion.
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

    func testCasualCases() { run(ruCasualCases) }
    func testMonthCases() { run(ruMonthCases) }
    func testMonthNameLittleEndianCases() { run(ruMonthNameLittleEndianCases) }
    func testRelativeCases() { run(ruRelativeCases) }
    func testTimeExpCases() { run(ruTimeExpCases) }
    func testTimeUnitsAgoCases() { run(ruTimeUnitsAgoCases) }
    func testTimeUnitsCasualRelativeCases() { run(ruTimeUnitsCasualRelativeCases) }
    func testTimeUnitsWithinCases() { run(ruTimeUnitsWithinCases) }
    func testWeekdayCases() { run(ruWeekdayCases) }
}

/// The progress instrument, mirroring ENOracleScoreboardTests exactly. Passed
/// count EXCLUDES the 5 deferred cases (they are expected failures, not
/// passes) - raise `floor` whenever the real pass count goes up, never to
/// paper over a regression.
final class RUOracleScoreboardTests: XCTestCase {
    static let floor = 126

    func testScoreboard() {
        let runner = RUOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in ruOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["RU ORACLE SCOREBOARD  \(passed)/\(ruOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "RU oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
