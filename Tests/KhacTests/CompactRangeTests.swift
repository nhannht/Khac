// CompactRangeTests.swift - a colonless range end is not a timezone offset.
//
// "630-930am" and "-0500" are the same shape to a regex: hyphen, three or four
// digits, boundary. The guard that stops "06:36:02 -0500" being read as a range
// therefore also stopped a real range, and the damage was not a clean miss - the
// range was refused, then the abandoned "630" was dropped as a bare three-digit
// number, so the input silently answered "930am" alone.
//
// English never tested this shape. The Spanish corpus hit it, so the assertions
// live here in English, where the bug actually was.

import XCTest
import Foundation
@testable import Khac

final class CompactRangeTests: XCTestCase {
    private let ref = ReferencePoint(
        instant: Calendar(identifier: .gregorian).date(from: DateComponents(
            timeZone: TimeZone.current, year: 2012, month: 8, day: 10, hour: 12))!,
        calendar: {
            var c = Calendar(identifier: .gregorian)
            c.timeZone = TimeZone.current
            return c
        }()
    )

    private func parse(_ s: String) -> [ParsedResult] {
        Khac(localeInstances: [ENLocale()]).parse(s, reference: ref)
    }

    func testColonlessRangeKeepsBothSides() {
        let results = parse("630-930am")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].text, "630-930am", "the first side must not be dropped")
        XCTAssertNotNil(results[0].end, "this is a range, not a lone time")
        XCTAssertEqual(results[0].start.get(.hour), 6)
        XCTAssertEqual(results[0].start.get(.minute), 30)
        XCTAssertEqual(results[0].end?.get(.hour), 9)
        XCTAssertEqual(results[0].end?.get(.minute), 30)
    }

    func testColonlessRangeWithSpacedMeridiem() {
        let results = parse("1-230 pm")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].text, "1-230 pm")
        XCTAssertNotNil(results[0].end)
        XCTAssertEqual(results[0].end?.get(.hour), 14, "230 pm is 14:30")
        XCTAssertEqual(results[0].end?.get(.minute), 30)
    }

    /// The guard still does its original job. A real offset has no meridiem after
    /// it, so it must still refuse to be read as a range end.
    func testRealTimezoneOffsetIsStillNotARange() {
        let results = parse("2014-11-30T08:15:30-05:30")
        XCTAssertFalse(results.isEmpty)
        XCTAssertEqual(results[0].start.get(.timezoneOffset), -330,
                       "the offset stays an offset")
    }

    func testCompactOffsetAfterAFullTimeIsStillNotARange() {
        let results = parse("06:36:02 -0500")
        XCTAssertFalse(results.isEmpty)
        XCTAssertNil(results[0].end, "a bare offset must not become a range end")
    }
}
