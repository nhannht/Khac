// MergingRefinerTests.swift - a run of three or more results must collapse.
//
// The merge refiners used a pairwise sweep that consumed both sides and stepped
// past them, so only one pair per neighbourhood could ever merge and a third
// element was stranded. chrono uses a rolling accumulator: the merged result
// stays as the left-hand side and is offered to the next result, so a chain
// collapses in a single pass. Khac now shares one implementation of that sweep.
//
// Running the pipeline more times would not have fixed this, which is why it is
// worth a test rather than a comment. chrono runs each refiner exactly once; the
// accumulator is what makes one pass sufficient.

import XCTest
import Khac

final class MergingRefinerTests: XCTestCase {
    private func reference() -> ReferencePoint {
        var c = DateComponents()
        c.year = 2012; c.month = 8; c.day = 10; c.hour = 12
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "UTC") ?? .current
        return ReferencePoint(instant: cal.date(from: c)!, calendar: cal)
    }

    private func ymd(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f.string(from: d)
    }

    private func parse(_ s: String) -> [ParsedResult] {
        Khac(locales: [.english]).parse(s, reference: reference())
    }

    /// Two durations after one anchor. The single-duration cases below are what
    /// make the old behaviour legible: the chained input used to resolve to
    /// 2012-08-24, byte-identical to applying "+10 days" ALONE, because "+5 days"
    /// was stranded and later misread by the timezone refiner as an offset.
    func testTwoChainedDurationsBothApply() {
        let chained = parse("next tuesday +10 days +5 days")
        XCTAssertEqual(chained.count, 1, "the whole phrase is one date")
        XCTAssertEqual(ymd(chained.first?.date ?? .distantPast), "2012-08-29")
        XCTAssertEqual(chained.first?.text, "next tuesday +10 days +5 days")
    }

    /// The controls. Next Tuesday is Aug 14; +10 is Aug 24 and +5 is Aug 19, so
    /// 2012-08-29 above is both durations applied rather than a coincidence.
    func testSingleDurationsUnchanged() {
        XCTAssertEqual(ymd(parse("next tuesday +10 days").first?.date ?? .distantPast), "2012-08-24")
        XCTAssertEqual(ymd(parse("next tuesday +5 days").first?.date ?? .distantPast), "2012-08-19")
        XCTAssertEqual(ymd(parse("2023-12-29 -10days").first?.date ?? .distantPast), "2023-12-19")
    }

    /// A three-part expression that needs two sequential merges on one side of a
    /// larger range. This was flagged as unreachable under the pairwise sweep.
    func testDateTimeRangeCollapsesInOnePass() {
        let r = parse("SUN 15SEP 11:05 AM - 12:50 PM").first
        XCTAssertNotNil(r)
        XCTAssertEqual(ymd(r?.date ?? .distantPast), "2012-09-15")
        XCTAssertEqual(r?.start.get(.hour), 11)
        XCTAssertEqual(r?.start.get(.minute), 5)
        XCTAssertEqual(r?.end?.get(.hour), 12)
        XCTAssertEqual(r?.end?.get(.minute), 50)
    }

    /// Ordinary two-part merges must be completely unaffected. An accumulator
    /// that over-merges would show up here by swallowing a separate result.
    func testTwoPartMergesUnaffected() {
        XCTAssertEqual(parse("August 10, 2012 5pm").first?.start.get(.hour), 17)
        XCTAssertEqual(parse("tomorrow at noon").first?.start.get(.hour), 12)
        XCTAssertEqual(ymd(parse("Friday 12-30-16").first?.date ?? .distantPast), "2016-12-30")
        XCTAssertEqual(ymd(parse("2 days after tomorrow").first?.date ?? .distantPast), "2012-08-13")

        let range = parse("from Aug 10 to Aug 14").first
        XCTAssertEqual(ymd(range?.date ?? .distantPast), "2012-08-10")
        XCTAssertEqual(range.flatMap { $0.end.map { ymd($0.date()) } }, "2012-08-14")
    }

    /// Separate dates in one sentence must stay separate. This is the failure the
    /// accumulator could plausibly introduce, so it is asserted directly.
    func testUnrelatedDatesDoNotAccumulate() {
        let results = parse("meet Aug 10, then again on Sept 2")
        XCTAssertEqual(results.count, 2, "two events, not one accumulated span")
        XCTAssertEqual(results.first?.text, "Aug 10")
        XCTAssertEqual(results.last?.text, "Sept 2")
    }
}
