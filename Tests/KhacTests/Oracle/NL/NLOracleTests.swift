// Runs the ported chrono NL oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [NLLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/nl/*.test.ts, never chrono's test code.
//
// Reporting mirrors DEOracleTests.swift: PER CASE, not per asserted field. A
// case known to be blocked by an engine gap (the day-token ordinal-suffix shape
// in MonthNameParser.swift, same root cause as DE's day+period+month gap) is
// deferred with its own XCTExpectFailure reason - never deleted, never weakened.

import Foundation
import XCTest
import Khac

struct NLOracleRunner {
    let khac = Khac(localeInstances: [NLLocale()])

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

final class NLOracleTests: XCTestCase {
    private let runner = NLOracleRunner()

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

    // MARK: - Deferral reasons (engine-owned, reported to main)
    //
    // RESOLVED, no longer appear below: the ordinal-suffix gap ("12de juli",
    // "31ste maart" - MonthNameParser now reads `dayOrdinalSuffixes` as data,
    // set to ["de","ste"] in NLLocale) and the month-name day-RANGE connector
    // gap ("10 tot 22 augustus" - MonthNameParser now reads
    // patterns.rangeConnectorWords for real, no NLLocale change needed since
    // "tot" was already there). Also resolved: "De deadline is nu" no longer
    // needs a deferral - main fixed the oracle itself, removing a bogus
    // timezoneOffset: 420 (a non-portable extraction-environment artifact)
    // from NlCasualCases.swift.

    /// TimeExpressionParser.swift's parseSide rejects ANY stated hour above 12
    /// that also carries a trailing meridiem/time-of-day word
    /// (`if hour > 12 { return nil }`, three times over). Correct for English
    /// (nobody says "20:00 PM") and wrong for Dutch, which allows a redundant
    /// 24h time plus a confirming period-of-day word ("23:00 's avonds"). Only
    /// bites words that exist SOLELY as trailing attachments (like "'s
    /// avonds") - a glued casual compound like "vanavond" is unaffected, since
    /// it merges in as a separate result instead (traced, not assumed).
    private static let statedHourPlusMeridiemAbove12 =
        "KHAC-6 deferral: TimeExpressionParser.swift rejects a stated hour above 12 combined with a trailing meridiem word - reported to engine"

    /// The bare "middernacht" day-roll: chrono's own NLCasualTimeParser.ts
    /// ALWAYS advances to the next day for "middernacht", unconditionally - no
    /// threshold check at all. Khac's shared CasualDateParser.applyTimeOfDay
    /// hardcodes ONE threshold (reference hour > 2) for every locale. This is
    /// the first CONFIRMED mismatch on this threshold (DE's own two data
    /// points didn't discriminate between >1 and >2; this one does - ref hour
    /// 1 rolls in Dutch, and our fixed >2 does not roll at hour 1).
    private static let midnightRollThreshold =
        "KHAC-6 deferral: CasualDateParser's midnight-roll threshold is hardcoded per engine, but Dutch always rolls unconditionally - reported to engine"

    /// RelativeDuration.swift's digit pattern hardcodes "." as the only
    /// decimal separator (`[0-9]{1,4}(?:\.[0-9]{1,3})?`). Dutch (and German)
    /// write a duration's fraction with a comma ("1,5 uur"); chrono's own
    /// NUMBER_PATTERN for both locales explicitly includes `[.,]`.
    private static let decimalCommaDuration =
        "KHAC-6 deferral: RelativeDuration.swift's digit pattern only accepts a period decimal, not Dutch/German's comma - reported to engine"

    func testCasualCases() {
        run(nlCasualCases, deferrals: [
            9: Self.midnightRollThreshold,
        ])
    }

    func testMonthCases() { run(nlMonthCases) }

    func testMonthNameLittleEndianCases() { run(nlMonthNameLittleEndianCases) }

    func testRelativeCases() { run(nlRelativeCases) }
    func testSlashCases() { run(nlSlashCases) }

    func testTimeExpCases() {
        run(nlTimeExpCases, deferrals: [4: Self.statedHourPlusMeridiemAbove12])
    }

    func testTimeUnitsAgoCases() { run(nlTimeUnitsAgoCases) }
    func testTimeUnitsCasualRelativeCases() { run(nlTimeUnitsCasualRelativeCases) }

    func testTimeUnitsLaterCases() {
        run(nlTimeUnitsLaterCases, deferrals: [18: Self.decimalCommaDuration])
    }

    func testTimeUnitsWithinCases() { run(nlTimeUnitsWithinCases) }
    func testWeekdayCases() { run(nlWeekdayCases) }
}

/// The progress instrument, mirroring DEOracleScoreboardTests.
final class NLOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression. 211/214 after master's `dayOrdinalSuffixes`
    /// / month-range-connector / oracle-artifact fixes landed (up from 203) -
    /// the 3-case gap is the three deferrals in NLOracleTests above (stated
    /// hour above 12 plus meridiem, 1; midnight-roll threshold, 1; decimal
    /// comma duration, 1).
    static let floor = 211

    func testScoreboard() {
        let runner = NLOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in nlOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["NL ORACLE SCOREBOARD  \(passed)/\(nlOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "NL oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
