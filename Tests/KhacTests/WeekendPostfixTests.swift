// WeekendPostfixTests.swift - the modifier can sit on either side of the word.
//
// chrono puts weekdays AND the rule-resolved words ("weekend", "weekday") in ONE
// parser, so both get a prefix slot ("next weekend") and a postfix slot
// ("weekend next week") for free. Khac splits that parser in two - a generic
// weekday parser driven by locale vocabulary, and an EN parser for the two words
// that resolve by rule rather than lookup - and the split silently dropped the
// postfix from the second half.
//
// It looked handled. A glue-word merge still pulled "next week" into the reported
// span, so the text came back complete while the modifier was ignored:
//
//     "weekend next week"   was 2012-08-11, chrono gives 2012-08-18
//
// Every expectation below is measured from chrono 2.10.1 at this reference, not
// derived from the code.

import XCTest
import Khac

final class WeekendPostfixTests: XCTestCase {
    /// Friday 2012-08-10 12:00 UTC. Chosen because it is a weekday, so the
    /// "weekday" branch takes its working-day arithmetic rather than its
    /// weekend-reference shortcut.
    private func reference() -> ReferencePoint {
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "UTC") ?? .current
        var c = DateComponents()
        c.year = 2012; c.month = 8; c.day = 10; c.hour = 12
        return ReferencePoint(instant: cal.date(from: c)!, calendar: cal)
    }

    private func ymd(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f.string(from: date)
    }

    /// The five cases that diverged, plus the ones that already agreed. Keeping
    /// the agreeing cases here is the point: "weekend this week" and "weekday next
    /// week" landed on chrono's answer by COINCIDENCE while the modifier was being
    /// dropped, so a suite holding only the broken ones would have shrunk to
    /// nothing the moment they were fixed.
    private let cases: [(text: String, expected: String)] = [
        // Postfix - these were wrong.
        ("weekend next week", "2012-08-18"),
        ("weekend last week", "2012-08-05"),
        ("weekday last week", "2012-08-09"),
        ("on the weekend next week", "2012-08-18"),
        ("the weekend of next week", "2012-08-18"),
        // Postfix - right by coincidence, since the answer equals the bare form.
        ("weekend this week", "2012-08-11"),
        ("weekday next week", "2012-08-13"),
        // Prefix and bare - must be completely unaffected.
        ("weekend", "2012-08-11"),
        ("this weekend", "2012-08-11"),
        ("next weekend", "2012-08-18"),
        ("last weekend", "2012-08-05"),
        ("weekday", "2012-08-13"),
        ("next weekday", "2012-08-13"),
        ("last weekday", "2012-08-09"),
        // The ordinary weekday path, which always had both slots. It shares the
        // postfix fragment now, so it is pinned here too.
        ("Monday next week", "2012-08-13"),
        ("Monday last week", "2012-08-06"),
    ]

    func testModifierResolvesFromEitherSideOfTheWord() {
        let khac = Khac(locales: [.english])
        for c in cases {
            let r = khac.parse(c.text, reference: reference()).first
            XCTAssertNotNil(r, "\(c.text) did not parse")
            XCTAssertEqual(r.map { ymd($0.date) }, c.expected, "\(c.text)")
        }
    }

    /// The span was never the broken part, and it must stay whole. If a future
    /// change fixes resolution by refusing to match the postfix at all, the date
    /// assertions above would still pass while the reported text silently shrank.
    func testPostfixStaysInsideTheReportedSpan() {
        let khac = Khac(locales: [.english])
        for (text, expected) in [
            ("weekend next week", "weekend next week"),
            ("weekday last week", "weekday last week"),
            ("the weekend of next week", "weekend of next week"),
            ("on the weekend next week", "weekend next week"),
        ] {
            XCTAssertEqual(
                khac.parse(text, reference: reference()).first?.text, expected,
                "\(text) reported a different span"
            )
        }
    }
}
