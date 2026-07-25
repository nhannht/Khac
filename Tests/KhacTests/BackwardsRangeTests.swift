// BackwardsRangeTests.swift - a backwards range must never hand a caller a trap.
//
// "August 22 - 10, 2012" resolves to a range whose end precedes its start. That
// is chrono's behaviour at the same place and is deliberately preserved: the
// range REFINER repairs a reversed range (five branches ending in a swap) while
// the month-name PARSER emits it as written, in chrono and in Khac alike.
// Swapping the sides in the parser would assert the writer meant August 10 to 22,
// which is a guess about a typo, not a parse.
//
// What is NOT acceptable is the Swift-specific hazard that follows from it.
// DateInterval(start:end:) TRAPS on end < start - a crash, not a nil - and the
// JavaScript original has no equivalent. So `interval` returning nil here is a
// load-bearing guarantee rather than defensive coding, and these tests pin it.

import XCTest
import Khac

final class BackwardsRangeTests: XCTestCase {
    private func reference() -> ReferencePoint {
        var c = DateComponents()
        c.year = 2012; c.month = 8; c.day = 10; c.hour = 12
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "UTC") ?? .current
        return ReferencePoint(instant: cal.date(from: c)!, calendar: cal)
    }

    /// Every input known to produce an end before its start, across both the EN
    /// and VI month-name paths.
    private let backwards = [
        "August 22 - 10, 2012",
        "March 5 - 1, 2020",
        "Dec 31 - 1, 2020",
        "10 - 5 August 2012",
        "22 - 10 August 2012",
        "August 22-10",
        "ngày 22 - 10 tháng 8",
    ]

    /// The guarantee. Without it, a caller following the obvious path crashes.
    func testBackwardsRangeYieldsNilIntervalRatherThanTrapping() {
        for text in backwards {
            let results = Khac().parse(text, reference: reference())
            XCTAssertFalse(results.isEmpty, "\(text) should still parse")
            for r in results where r.end != nil {
                let start = r.date
                let end = r.end!.date()
                guard end < start else { continue }
                XCTAssertNil(
                    r.interval,
                    "\(text) has end before start, so interval must be nil, never a trap"
                )
            }
        }
    }

    /// The values are reported as written, not silently reordered. Asserted so a
    /// future "tidy up" that swaps the sides has to be a deliberate decision.
    func testBackwardsRangeIsReportedAsWritten() {
        let r = Khac(locales: [.english]).parse("August 22 - 10, 2012", reference: reference()).first
        XCTAssertEqual(r?.start.get(.day), 22)
        XCTAssertEqual(r?.end?.get(.day), 10)
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertEqual(r?.end?.get(.month), 8)
    }

    /// The contrast that shows the two paths are chrono's design, not an
    /// oversight: routed through the range REFINER, the same reversal is repaired
    /// by shifting the unknown year forward rather than by swapping.
    func testRangeRefinerRepairsWhereTheParserDoesNot() {
        let r = Khac(locales: [.english]).parse("Aug 22 to Aug 10", reference: reference()).first
        XCTAssertNotNil(r?.interval, "the refiner path repairs, so this one has an interval")
        XCTAssertEqual(r?.start.get(.year), 2012)
        XCTAssertEqual(r?.end?.get(.year), 2013, "the end year shifts forward instead of the sides swapping")
    }

    /// Ordinary forward ranges keep working and keep producing an interval.
    func testForwardRangesAreUnaffected() {
        let khac = Khac(locales: [.english])
        for text in ["August 10 - 22, 2012", "from Aug 10 to Aug 14", "August 22 - 22, 2012"] {
            let r = khac.parse(text, reference: reference()).first
            XCTAssertNotNil(r?.interval, "\(text) is forward and must yield an interval")
        }
    }

    /// An IMPOSSIBLE end day is a different rule and must stay different: the
    /// whole result is dropped rather than shedding its end.
    func testImpossibleEndDayDropsTheWholeResult() {
        XCTAssertTrue(Khac(locales: [.english]).parse("June 10 - 31, 2022", reference: reference()).isEmpty)
    }
}
