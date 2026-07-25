// ISORejectionTests.swift - a rejected ISO timestamp must leave nothing behind.
//
// When ISOParser rejected an impossible date at construction, the match consumed
// nothing, the engine resumed one character in, and TimeExpressionParser then
// scavenged fragments out of the wreckage and anchored them to the reference:
// "2023-02-30T10:00:00" answered today at midnight. Silently, and plausibly.
//
// The fix is not stricter parsing but LATER rejection - range-check here, decide
// calendar validity at the result level in UnlikelyFilterRefiner, which is
// chrono's own mechanism. Accepting the span is what leaves nothing to scavenge.
//
// The neighbours below are pinned because they are chrono PARITY, not bugs, and
// a stricter-looking "fix" would break them.

import XCTest
import Khac

final class ISORejectionTests: XCTestCase {
    private func reference() -> ReferencePoint {
        var c = DateComponents()
        c.year = 2012; c.month = 8; c.day = 10; c.hour = 12
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "UTC") ?? .current
        return ReferencePoint(instant: cal.date(from: c)!, calendar: cal)
    }

    private func parse(_ text: String) -> [ParsedResult] {
        Khac(locales: [.english]).parse(text, reference: reference())
    }

    /// The reported bug: an impossible day inside a full ISO timestamp.
    func testImpossibleDayInISOTimestampYieldsNothing() {
        XCTAssertTrue(
            parse("2023-02-30T10:00:00").isEmpty,
            "an impossible date must not degrade into a time anchored to the reference day"
        )
    }

    /// KNOWN FAILING, tracked as KHAC-9. Asserted rather than omitted, so it stays
    /// visible and reports the moment it starts passing.
    ///
    /// Month 0 must fall through rather than be consumed - the same rule that
    /// keeps "2023-13-01" reading as 13 January - so this input still reaches the
    /// scavenging path. What it hits there is a DIFFERENT defect from the one the
    /// negative-offset guard fixed: "00-10" is read as the bare time "00" carrying
    /// a "-10" hour-only timezone offset, giving tzOffset -600, plus a second
    /// spurious "00:00". The guard covers 3-4 digit offsets like "-0500"; a 1-2
    /// digit signed run after a bare number is still claimed as an offset.
    ///
    /// Special-casing month 0 here would paper over that rather than fix it.
    func testImpossibleMonthInISOTimestampYieldsNothing() {
        XCTExpectFailure("KHAC-9 residual: a 1-2 digit signed run is still read as an hour offset")
        XCTAssertTrue(parse("2023-00-10T10:00:00").isEmpty)
    }

    /// PARITY, not a bug: chrono and Khac both read this as 13 January. Month is
    /// range-checked in ISOParser precisely so this falls through to
    /// NumericDateParser instead of being consumed.
    func testMonthThirteenFallsThroughToNumericDate() {
        let results = parse("2023-13-01")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.start.get(.year), 2023)
        XCTAssertEqual(results.first?.start.get(.month), 1)
        XCTAssertEqual(results.first?.start.get(.day), 13)
    }

    /// PARITY: a bare impossible date yields nothing in both.
    func testBareImpossibleDateYieldsNothing() {
        XCTAssertTrue(parse("2023-02-30").isEmpty)
    }

    /// A well-formed ISO timestamp must be entirely unaffected.
    func testWellFormedISOStillParses() {
        let results = parse("2023-11-06T06:36:02")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.start.get(.year), 2023)
        XCTAssertEqual(results.first?.start.get(.month), 11)
        XCTAssertEqual(results.first?.start.get(.day), 6)
        XCTAssertEqual(results.first?.start.get(.hour), 6)
        XCTAssertEqual(results.first?.start.get(.minute), 36)
        XCTAssertEqual(results.first?.start.get(.second), 2)
    }

    /// Feb 29 in a leap year is real and must survive; in a common year it is not
    /// and must be dropped whole rather than rolled over to March 1.
    func testLeapDayBoundary() {
        XCTAssertEqual(parse("2024-02-29").first?.start.get(.day), 29)
        XCTAssertTrue(parse("2023-02-29").isEmpty)
    }

    /// An impossible offset used to be stored as a CERTAIN component while
    /// resolution silently ignored it, since Foundation returns no zone past its
    /// 18-hour limit - so the reported component and the resolved instant
    /// disagreed with each other.
    ///
    /// The offset is DROPPED and the timestamp KEPT. The date and clock are
    /// perfectly good when only the zone is junk, and this matches what
    /// ExtractTimezoneOffsetRefiner already did, so the two paths agree.
    func testOutOfRangeTimezoneOffsetIsDroppedNotFatal() {
        for text in ["2023-11-06T06:36:02+19:00", "2023-11-06T06:36:02-15:00", "2023-11-06T06:36:02+05:99"] {
            let r = parse(text).first
            XCTAssertNotNil(r, "\(text) still states a valid date and clock")
            XCTAssertNil(r?.start.get(.timezoneOffset), "\(text) has no usable zone")
            XCTAssertEqual(r?.start.get(.hour), 6)
            XCTAssertEqual(r?.start.get(.second), 2)
        }
    }

    /// The real extremes must still parse, including the fractional-hour zones.
    func testRealTimezoneOffsetExtremes() {
        XCTAssertEqual(parse("2023-11-06T06:36:02+14:00").first?.start.get(.timezoneOffset), 840)
        XCTAssertEqual(parse("2023-11-06T06:36:02-12:00").first?.start.get(.timezoneOffset), -720)
        XCTAssertEqual(parse("2023-11-06T06:36:02+05:45").first?.start.get(.timezoneOffset), 345)
        XCTAssertEqual(parse("2023-11-06T06:36:02Z").first?.start.get(.timezoneOffset), 0)
    }
}
