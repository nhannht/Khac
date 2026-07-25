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

    /// Month 0 is ACCEPTED by ISOParser so that a full-span result exists to shadow
    /// the fragments, and dropped afterwards by UnlikelyFilterRefiner. Declining it
    /// left nothing to shadow, and "00-10" then leaked as a bare time carrying a
    /// bogus -600 offset, plus a spurious "00:00".
    func testImpossibleMonthInISOTimestampYieldsNothing() {
        XCTAssertTrue(parse("2023-00-10T10:00:00").isEmpty)
        XCTAssertTrue(parse("2023-00-10").isEmpty)
        XCTAssertTrue(parse("2023-00-00").isEmpty)
    }

    /// KNOWN FAILING, tracked as KHAC-9. Asserted rather than omitted so it stays
    /// visible, and verified strict - forcing it to pass reports an UNEXPECTED
    /// failure, so it speaks up if the underlying gap ever closes.
    ///
    /// Month 13 cannot take the shadow trick above: it MUST keep falling through to
    /// NumericDateParser to read as 13 January, which the oracle pins. So the time
    /// portion is still scavenged, and what scavenges it is a gap Khac INHERITS
    /// from chrono rather than one it introduced. chrono's time-parser guard needs
    /// 3-4 digits to decline a range, while its timezone refiner accepts 1-2, so a
    /// two-digit signed run falls between them in chrono too - measured live:
    /// chrono reads "06:36:02 -10" as a RANGE with no offset, and "06:36:02 -100"
    /// as a time with offset -600.
    ///
    /// Widening the guard to 1-2 digits would diverge from chrono AND start eating
    /// real range ends like "8 - 11pm" and "1pm-3".
    func testMonthThirteenTimestampStillScavenges() {
        XCTExpectFailure("KHAC-9 residual: the 1-2 digit offset gap, inherited from chrono")
        XCTAssertTrue(parse("2023-13-01T10:00:00").isEmpty)
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
