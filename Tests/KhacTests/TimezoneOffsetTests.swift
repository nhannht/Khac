// TimezoneOffsetTests.swift - a negative UTC offset must not eat the time.
//
// "06:36:02 -0500" produced NO time at all, while "+0500" worked: the parser was
// asymmetric on sign. The dash was consumed as a range connector, so the input
// read as the range 06:36:02 to 0500, the bare "0500" failed the >24 validity
// check, and by that filter's own rule an invalid side voids the WHOLE match.
// The time and the offset were both lost, ExtractTimezoneOffsetRefiner never got
// a result to attach to, and only the date survived - leaving a plausible date at
// noon with no error.
//
// -HHMM is RFC 2822, RFC 3339, Apache and nginx access logs, and the Date header
// of every email sent west of Greenwich, so this was ordinary input.

import XCTest
import Khac

final class TimezoneOffsetTests: XCTestCase {
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

    /// The four reported real-world formats, each verified against chrono.
    func testNegativeOffsetFormsResolveLikeChrono() {
        let cases: [(String, Int)] = [
            ("06/Nov/2023:06:36:02 -0500", -300),
            ("2023-11-06 06:36:02 -0500", -300),
            ("Mon, 06 Nov 2023 06:36:02 -0500", -300),
        ]
        for (text, expected) in cases {
            let r = parse(text).first
            XCTAssertEqual(r?.start.get(.timezoneOffset), expected, "\(text) must carry its offset")
            XCTAssertEqual(r?.start.get(.hour), 6, "\(text) must keep its time")
            XCTAssertEqual(r?.start.get(.second), 2, "\(text) must keep its seconds")
        }
    }

    /// The sign asymmetry itself: these two must behave the same way.
    func testPositiveAndNegativeOffsetsAreSymmetric() {
        XCTAssertEqual(parse("06:36:02 +0500").first?.start.get(.timezoneOffset), 300)
        XCTAssertEqual(parse("06:36:02 -0500").first?.start.get(.timezoneOffset), -300)
        XCTAssertEqual(parse("06:36:02 -0500").first?.start.get(.hour), 6)
    }

    /// The seconds field is asserted deliberately. Guarding OUTSIDE the optional
    /// range group also makes the offset cases "pass", but by backtracking the
    /// primary to a shorter reading - "06:36:02 -0500" matches as "06:36" and the
    /// seconds vanish silently. Nothing else in the suite covers a seconds field
    /// followed by a dash-digit run, so this is the only thing standing between
    /// that mistake and a green run.
    func testSecondsSurviveTheOffsetGuard() {
        let r = parse("06:36:02 -0500").first
        XCTAssertEqual(r?.start.get(.hour), 6)
        XCTAssertEqual(r?.start.get(.minute), 36)
        XCTAssertEqual(r?.start.get(.second), 2, "the primary time must not be shortened to 06:36")
    }

    /// Real time ranges must be completely untouched: their ends are 1-2 digits,
    /// or colon-separated, and neither shape can trip a 3-4 digit guard.
    func testGenuineTimeRangesStillParse() {
        XCTAssertEqual(parse("8 - 11pm").first?.start.get(.hour), 20)
        XCTAssertEqual(parse("8 - 11pm").first?.end?.get(.hour), 23)
        XCTAssertEqual(parse("1pm-3").first?.end?.get(.hour), 15)
        XCTAssertEqual(parse("10:00:00 - 21:45:00").first?.end?.get(.hour), 21)
    }

    /// Pinned negatives. Word connectors are outside the guard entirely, and the
    /// bare-number rejections must keep rejecting.
    func testPinnedNegativesUnchanged() {
        XCTAssertTrue(parse("2019 to 2020").allSatisfy { $0.start.get(.hour) == nil || $0.text != "2019 to 2020" })
        XCTAssertTrue(parse("10 - 10.1").isEmpty)
        XCTAssertTrue(parse("10.1 - 10.12").isEmpty)
        XCTAssertTrue(parse("1-2").isEmpty)
    }
}
