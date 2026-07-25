// MergeDateTimeCertaintyTests.swift - which clock fields a merge claims as stated.
//
// MergeDateTimeRefiner marks the MINUTE certain whenever the hour is, even when
// the time side only implied it, while the second and millisecond branches right
// beside it mirror the source's certainty instead. That asymmetry looks exactly
// like a port slip, and it survived review twice because no test asserted
// certainty in either direction - only resolved instants, which it does not
// change on its own.
//
// It is chrono's asymmetry, not a slip (mergingCalculation.ts:38-40, v2.10.1),
// so these tests pin the CURRENT behaviour deliberately. They are what makes the
// next reader's "obvious cleanup" fail loudly instead of silently reordering a
// contested overlap through the certain-count key in SPEC 3a-H0. KHAC-13.

import XCTest
import Khac

final class MergeDateTimeCertaintyTests: XCTestCase {
    private func reference() -> ReferencePoint {
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "UTC") ?? .current
        var c = DateComponents()
        c.year = 2012; c.month = 8; c.day = 10; c.hour = 12
        return ReferencePoint(instant: cal.date(from: c)!, calendar: cal)
    }

    private func parse(_ s: String) -> ParsedResult? {
        Khac(locales: [.english]).parse(s, reference: reference()).first
    }

    /// A stated hour with no stated minute. The minute is still claimed CERTAIN,
    /// which is chrono's behaviour and is the whole point of this file.
    func testStatedHourMakesTheUnstatedMinuteCertain() {
        for text in ["tomorrow at 5pm", "August 10, 2012 5pm", "next Friday at 9am"] {
            let start = parse(text)?.start
            XCTAssertEqual(start?.isCertain(.hour), true, "\(text) states an hour")
            XCTAssertEqual(
                start?.isCertain(.minute), true,
                "\(text) states no minute, and chrono marks it certain anyway"
            )
            XCTAssertEqual(start?.get(.minute), 0, "\(text) minute value")
        }
    }

    /// The contrast that shows the asymmetry is real rather than a reading of the
    /// code: second and millisecond do NOT get the same treatment. Same input,
    /// same branch, different rule.
    func testUnstatedSecondStaysImplied() {
        let start = parse("tomorrow at 5:30pm")?.start
        XCTAssertEqual(start?.isCertain(.hour), true)
        XCTAssertEqual(start?.isCertain(.minute), true)
        XCTAssertEqual(start?.isCertain(.second), false, "no second was stated, so it stays implied")
        XCTAssertEqual(start?.get(.second), 0)
    }

    /// And a stated second IS carried across as certain, so the branch below the
    /// minute genuinely mirrors its source.
    func testStatedSecondIsCertain() {
        let start = parse("August 10, 2012 5:30:15pm")?.start
        XCTAssertEqual(start?.isCertain(.second), true)
        XCTAssertEqual(start?.get(.second), 15)
        XCTAssertEqual(start?.isCertain(.millisecond), false, "no millisecond stated")
    }
}
