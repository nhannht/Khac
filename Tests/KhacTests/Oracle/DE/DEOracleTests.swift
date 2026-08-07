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

    // MARK: - Deferral reasons
    //
    // Two checkpoint-1 findings are RESOLVED as of this pass and no longer
    // appear below: the day+period+month gap (MonthNameParser now reads
    // `dayOrdinalSuffixes`/`dateConnectorWords`/`monthPrefixWords` as data -
    // 31 cases recovered) and the 2-digit-year dot date gap (now
    // `options.dotIsUnambiguousDateSeparator` - 2 cases recovered). The bare
    // month+year fallback gap ("32. Oktober 2015") is ALSO resolved, by
    // `options.monthNameForms` - narrowing German to `.dayFirst`, matching
    // chrono's own registered parser list, turns the fallback off outright
    // rather than needing a special-cased rejection.

    /// RelativeUnitParser.swift's six alternatives (past-suffix, future-suffix,
    /// future-prefix, signed, modifier-prefix, bare-modifier) have no slot for a
    /// modifier landing AFTER the number and BEFORE the unit word. Still open -
    /// held per main's call: one German case is not enough to justify a
    /// seventh alternative in a parser all fourteen locales share; decided
    /// once every soldier's final report is in.
    private static let numberModifierUnit =
        "KHAC-6 deferral: NUMBER-MODIFIER-UNIT duration ('30 vorangegangenen Tagen') has no matching alternative in RelativeUnitParser.swift - reported to engine at checkpoint 1"

    /// Named timezone abbreviations (CET) are out of scope for Khac v1's generic
    /// parsers - the SAME boundary the EN oracle already excludes 5 cases for
    /// (see Oracle/README.md), not a new German-specific gap.
    private static let namedTimezone =
        "KHAC-6 deferral: named timezone abbreviation (CET) unsupported - same v1 scope boundary EN's oracle already excludes, not a new gap"

    /// TimeExpressionParser's trailing connector-then-tod slot requires a tod
    /// WORD once it engages - `(?:\s*connector(?<tod>todAlt))?` - so a bare
    /// decorative "Uhr" with nothing after it can only be consumed via the
    /// clockHourWords hw-slot (no colon present) or the connector-before-a-tod-
    /// word shape (colon present, meridiem word follows). Neither covers a
    /// colon time followed by a BARE trailing "Uhr" with no meridiem word at
    /// all ("19:53 Uhr", nothing after). chrono's own DESpecificTimeExpressionParser
    /// makes this decoration unconditionally optional at the pattern level
    /// (`(?:\s*Uhr)?`, no following word required); Khac's shared engine has
    /// no locale slot for an unconditional trailing decorative word, only for
    /// one that gates a further tod capture. Narrow (1 case), found after the
    /// timeOfDayConnectorWords fix above closed the adjacent, more common shape.
    private static let bareTrailingUhrAfterColonTime =
        "KHAC-6 deferral: a bare decorative 'Uhr' trailing a colon time with nothing after it has no engine slot (timeOfDayConnectorWords requires a following tod word) - reported to engine"

    func testCasualCases() { run(deCasualCases) }

    func testDashCases() {
        run(deDashCases)
    }

    func testMonthNameLittleEndianCases() {
        run(deMonthNameLittleEndianCases, deferrals: [17: Self.bareTrailingUhrAfterColonTime])
    }

    func testTimeExpCases() {
        run(deTimeExpCases, deferrals: [15: Self.namedTimezone, 16: Self.namedTimezone, 20: Self.namedTimezone])
    }

    func testTimeUnitsCasualRelativeCases() {
        run(deTimeUnitsCasualRelativeCases, deferrals: [4: Self.numberModifierUnit])
    }

    func testTimeUnitsWithinCases() { run(deTimeUnitsWithinCases) }

    func testWeekdayCases() {
        run(deWeekdayCases)
    }

    func testYearCases() {
        run(deYearCases)
    }
}

/// The progress instrument, mirroring ENOracleScoreboardTests. Prints how many
/// oracle cases the engine reproduces, broken down by chrono source file, and
/// holds a ratchet floor so the number can only go up.
final class DEOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression. 119/124 after master's Wall 1 /
    /// dotIsUnambiguousDateSeparator / monthNameForms fixes landed (up from
    /// 87) - the 5-case gap is the three deferrals in DEOracleTests above:
    /// NUMBER-MODIFIER-UNIT duration (1), named timezone (3), bare trailing
    /// "Uhr" after a colon time (1).
    static let floor = 119

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
