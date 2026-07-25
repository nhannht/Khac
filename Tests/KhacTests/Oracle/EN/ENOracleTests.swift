// Runs the ported chrono EN oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [ENLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/en/*.test.ts, never chrono's test code.
//
// EXPECTED STATE (as of writing): the 8 generic parsers in Sources/Khac/Parsers/
// are stubs ("STUB: interface frozen; real implementation follows") that never
// match, so every case below currently reports zero results and fails. That is
// a parser-implementation gap (Phase 1, still in progress), not an EN locale or
// oracle-data defect. This suite is the regression bar those parsers must clear;
// re-run after they land.

import Foundation
import XCTest
import Khac

final class ENOracleTests: XCTestCase {
    private let khac = Khac(localeInstances: [ENLocale()])

    /// All oracle dates (reference and expected) are interpreted against one
    /// fixed Gregorian/UTC calendar, so cases are deterministic regardless of the
    /// machine running them - independent of what ReferencePoint.now would use.
    private let fixedCalendar: Calendar = {
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

    private func assertComponents(_ expected: OracleComponents, _ actual: ParsingComponents, _ message: String) {
        if let v = expected.year { XCTAssertEqual(actual.get(.year), v, "\(message) year") }
        if let v = expected.month { XCTAssertEqual(actual.get(.month), v, "\(message) month") }
        if let v = expected.day { XCTAssertEqual(actual.get(.day), v, "\(message) day") }
        if let v = expected.hour { XCTAssertEqual(actual.get(.hour), v, "\(message) hour") }
        if let v = expected.minute { XCTAssertEqual(actual.get(.minute), v, "\(message) minute") }
        if let v = expected.second { XCTAssertEqual(actual.get(.second), v, "\(message) second") }
        if let v = expected.millisecond { XCTAssertEqual(actual.get(.millisecond), v, "\(message) millisecond") }
        if let v = expected.weekday { XCTAssertEqual(actual.get(.weekday), v, "\(message) weekday") }
        if let v = expected.timezoneOffset { XCTAssertEqual(actual.get(.timezoneOffset), v, "\(message) timezoneOffset") }
    }

    private func run(_ cases: [OracleCase]) {
        for c in cases {
            let mode: Options.Mode = c.mode == .strict ? .strict : .casual
            let options = Options(mode: mode, forwardDate: c.forwardDate)
            let results = khac.parse(c.input, reference: reference(c.reference), options: options)
            let label = "[\(c.sourceFile)] \(c.input.debugDescription)"

            switch c.expectation {
            case .noMatch:
                XCTAssertTrue(results.isEmpty, "\(label) expected no match, got \(results.count)")

            case .match(let text, let index, let start, let startDate, let end, let endDate):
                guard let result = results.first else {
                    XCTFail("\(label) expected a match, got none")
                    continue
                }
                if let text = text {
                    XCTAssertEqual(result.text, text, "\(label) text")
                }
                if let index = index {
                    XCTAssertEqual(result.index, index, "\(label) index")
                }
                if !start.isEmpty {
                    assertComponents(start, result.start, "\(label) start")
                }
                if let startDate = startDate {
                    XCTAssertEqual(result.start.date(), resolvedDate(startDate), "\(label) startDate")
                }
                if !end.isEmpty {
                    if let endComponents = result.end {
                        assertComponents(end, endComponents, "\(label) end")
                    } else {
                        XCTFail("\(label) expected end components, got none")
                    }
                }
                if let endDate = endDate {
                    if let endComponents = result.end {
                        XCTAssertEqual(endComponents.date(), resolvedDate(endDate), "\(label) endDate")
                    } else {
                        XCTFail("\(label) expected an end date, got none")
                    }
                }
            }
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
