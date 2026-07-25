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

    /// KNOWN FAILING, tracked as KHAC-9 with the cause in KHAC-8. Asserted rather
    /// than omitted, so it stays visible and reports the moment it starts passing.
    ///
    /// Month 0 must fall through rather than be consumed - the same rule that
    /// keeps "2023-13-01" reading as 13 January - so this input still reaches the
    /// scavenging path. What it scavenges is KHAC-8's bug, not this one: "00-10"
    /// is read as the bare time "00" carrying a "-10" TIMEZONE OFFSET, giving
    /// tzOffset -600, plus a second spurious "00:00". Fixing the sign handling in
    /// the time parser is what closes this, and doing it here instead would mean
    /// special-casing month 0 to paper over an unrelated defect.
    func testImpossibleMonthInISOTimestampYieldsNothing() {
        XCTExpectFailure("KHAC-9 residual: blocked on KHAC-8's negative-offset handling")
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

    /// A timezone offset outside the real -12:00 to +14:00 range used to be stored
    /// as a CERTAIN component while resolution silently ignored it, since
    /// Foundation returns no zone for an out-of-range offset. The reported
    /// component and the resolved instant then disagreed.
    func testOutOfRangeTimezoneOffsetIsRejected() {
        XCTAssertTrue(parse("2023-11-06T06:36:02+19:00").isEmpty)
        XCTAssertTrue(parse("2023-11-06T06:36:02-15:00").isEmpty)
    }

    /// The real extremes must still parse, including the fractional-hour zones.
    func testRealTimezoneOffsetExtremes() {
        XCTAssertEqual(parse("2023-11-06T06:36:02+14:00").first?.start.get(.timezoneOffset), 840)
        XCTAssertEqual(parse("2023-11-06T06:36:02-12:00").first?.start.get(.timezoneOffset), -720)
        XCTAssertEqual(parse("2023-11-06T06:36:02+05:45").first?.start.get(.timezoneOffset), 345)
        XCTAssertEqual(parse("2023-11-06T06:36:02Z").first?.start.get(.timezoneOffset), 0)
    }
}
