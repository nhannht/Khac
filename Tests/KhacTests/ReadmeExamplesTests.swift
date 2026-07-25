// ReadmeExamplesTests.swift - every snippet in README.md must compile and hold.
//
// A README that drifts from the API is worse than no README. These are the
// snippets verbatim, against the public surface only (no @testable), so a
// signature change breaks the build here rather than in a user's project.

import XCTest
import Khac

final class ReadmeExamplesTests: XCTestCase {
    private func reference() -> ReferencePoint {
        var c = DateComponents()
        c.year = 2024; c.month = 6; c.day = 9; c.hour = 12
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "UTC") ?? .current
        return ReferencePoint(instant: cal.date(from: c)!, calendar: cal)
    }

    private func ymdhm(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        f.timeZone = TimeZone(identifier: "UTC")
        return f.string(from: d)
    }

    func testOpeningSnippetCompiles() {
        let khac = Khac()
        XCTAssertNotNil(khac.parseDate("next Friday at 5pm", reference: reference()))
        XCTAssertNotNil(khac.parseDate("sáng mai", reference: reference()))
        XCTAssertFalse(khac.parse("from Aug 10 to Aug 14", reference: reference()).isEmpty)
    }

    func testMultipleResultsSnippet() {
        let results = Khac().parse("meet Aug 10, then again on Sept 2", reference: reference())
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].text, "Aug 10")
        XCTAssertEqual(ymdhm(results[0].date), "2024-08-10 12:00")
        XCTAssertEqual(results[1].text, "Sept 2")
        XCTAssertEqual(ymdhm(results[1].date), "2024-09-02 12:00")
        XCTAssertEqual(results[1].index, 27)

        // The highlight snippet.
        for r in results {
            let range = NSRange(location: r.index, length: r.matchLength)
            XCTAssertEqual(range.length, (r.text as NSString).length)
        }
    }

    func testReferenceTimeZoneSnippet() {
        let ref = ReferencePoint(instant: Date(), timeZone: TimeZone(identifier: "Asia/Ho_Chi_Minh")!)
        XCTAssertNotNil(Khac().parseDate("tomorrow", reference: ref))
    }

    func testStrictModeSnippet() {
        let khac = Khac()
        let strict = Options(mode: .strict)
        XCTAssertTrue(khac.parse("tomorrow", reference: reference(), options: strict).isEmpty)
        XCTAssertEqual(khac.parse("August 10, 2012", reference: reference(), options: strict).count, 1)
    }

    func testForwardDateOptionCompiles() {
        _ = Khac().parse("Friday", reference: reference(), options: Options(forwardDate: true))
    }

    func testLocaleSelectionSnippet() {
        XCTAssertFalse(Khac(locales: [.english]).parse("August 10, 2012", reference: reference()).isEmpty)
        XCTAssertFalse(Khac(locales: [.vietnamese]).parse("ngày 15 tháng 3 năm 2020", reference: reference()).isEmpty)
        XCTAssertFalse(Khac(locales: [.english, .vietnamese]).parse("tomorrow", reference: reference()).isEmpty)
    }

    func testRangeSnippet() {
        let r = Khac().parse("December 31 2022 10:00 pm - 1:00 am", reference: reference()).first
        XCTAssertNotNil(r)
        XCTAssertEqual(ymdhm(r!.date), "2022-12-31 22:00")
        XCTAssertEqual(r?.end.map { ymdhm($0.date()) }, "2023-01-01 01:00")
        XCTAssertNotNil(r?.interval)
    }

    /// Every English line in the "What it parses" table.
    func testEnglishTable() {
        let cases: [(String, String)] = [
            ("tomorrow", "2024-06-10 12:00"),
            ("tonight at 8", "2024-06-09 20:00"),
            ("next Friday at 5pm", "2024-06-14 17:00"),
            ("last night", "2024-06-08 00:00"),
            ("this weekend", "2024-06-15 12:00"),
            ("5 days from now", "2024-06-14 12:00"),
            ("2 weeks ago", "2024-05-26 12:00"),
            ("in 3 hours", "2024-06-09 15:00"),
            ("2 days after tomorrow", "2024-06-12 12:00"),
            ("August 10, 2012", "2012-08-10 12:00"),
            ("10 Aug 2012", "2012-08-10 12:00"),
            ("8/10/2012", "2012-08-10 12:00"),
            ("Mon, 06 Nov 2023 06:36:02 -0500", "2023-11-06 11:36"),
            ("06/Nov/2023:06:36:02 -0500", "2023-11-06 11:36"),
        ]
        for (input, expected) in cases {
            let r = Khac().parse(input, reference: reference()).first
            XCTAssertEqual(ymdhm(r?.date ?? .distantPast), expected, "README claims \(input) -> \(expected)")
        }
        XCTAssertEqual(
            Khac().parse("Mon, 06 Nov 2023 06:36:02 -0500", reference: reference()).first?.start.get(.timezoneOffset),
            -300
        )
    }

    /// Every Vietnamese line in the "What it parses" table.
    func testVietnameseTable() {
        let cases: [(String, String)] = [
            ("ngày 15 tháng 3 năm 2020", "2020-03-15 12:00"),
            ("mùng 2 tháng 9", "2024-09-02 12:00"),
            ("sáng mai", "2024-06-10 09:00"),
            ("7 giờ sáng mai", "2024-06-10 07:00"),
            ("thứ hai tới", "2024-06-10 12:00"),
            ("hai tuần trước", "2024-05-26 12:00"),
            ("12 giờ đêm", "2024-06-09 00:00"),
        ]
        for (input, expected) in cases {
            let r = Khac().parse(input, reference: reference()).first
            XCTAssertEqual(ymdhm(r?.date ?? .distantPast), expected, "README claims \(input) -> \(expected)")
        }
    }

    /// The negative cases the Results section names by hand.
    func testNamedNegativesInReadme() {
        let khac = Khac()
        XCTAssertTrue(khac.parse("2019 to 2020", reference: reference()).isEmpty)
        XCTAssertTrue(khac.parse("10 - 10.1", reference: reference()).isEmpty)
    }

    /// The day-shift gate limitation the README states. A bare clock is not a
    /// time-of-day word, so the shift does not attach. Asserted because it is a
    /// documented SHORTFALL: if it ever starts working, the README is wrong and
    /// should say so rather than under-selling the parser.
    func testDayShiftNeedsATimeOfDayWord() {
        let vi = Khac(locales: [.vietnamese])
        // Works: "sáng" is a time-of-day word.
        XCTAssertEqual(ymdhm(vi.parseDate("7 giờ sáng mai", reference: reference()) ?? .distantPast), "2024-06-10 07:00")
        // Does not: a bare clock leaves the shift unattached, so the day stays today.
        XCTAssertEqual(vi.parse("8 giờ mai", reference: reference()).first?.start.get(.day), 9)
        XCTAssertEqual(vi.parse("15:30 mai", reference: reference()).first?.start.get(.day), 9)
    }

    /// The marked-versus-unmarked invalid day asymmetry, as the README states it.
    /// An earlier draft claimed "0 August" produced nothing; it degrades to the
    /// month instead, and this test is why the README does not say otherwise.
    func testInvalidDayAsymmetryInReadme() {
        let khac = Khac()
        XCTAssertTrue(
            khac.parse("ngày 0 tháng 4 năm 2000", reference: reference()).isEmpty,
            "a MARKED invalid day rejects outright"
        )
        let unmarked = khac.parse("0 August", reference: reference()).first
        XCTAssertEqual(unmarked?.text, "August", "an UNMARKED invalid day degrades to the month")
        XCTAssertEqual(unmarked?.start.get(.month), 8)
    }

    /// The four KHAC-FIX divergences the README lists as corrections over chrono.
    func testKhacFixDivergencesInReadme() {
        let khac = Khac(locales: [.vietnamese])
        XCTAssertEqual(ymdhm(khac.parseDate("12 giờ đêm", reference: reference()) ?? .distantPast), "2024-06-09 00:00")
        XCTAssertEqual(ymdhm(khac.parseDate("1 giờ đêm", reference: reference()) ?? .distantPast), "2024-06-09 01:00")
        XCTAssertEqual(ymdhm(khac.parseDate("sáng mai", reference: reference()) ?? .distantPast), "2024-06-10 09:00")
    }

    /// The limitation the README used to state outright, now deleted from it.
    /// "7 giờ sáng mai" answered 09:00 because a "sáng mai" carrying three DERIVED
    /// certains outranked a "7 giờ sáng" carrying two STATED ones. The doc claimed
    /// the same class existed in English; it does not, and never did - English
    /// writes no day word inside a time-of-day word's span, so the shorter casual
    /// match is always strictly contained and the containment pre-pass drops it.
    /// Both halves are asserted here so neither can go stale again.
    func testStatedHourNoLongerLosesToADerivedDate() {
        let vi = Khac(locales: [.vietnamese])
        XCTAssertEqual(
            ymdhm(vi.parseDate("7 giờ sáng mai", reference: reference()) ?? .distantPast),
            "2024-06-10 07:00",
            "the written hour is the one the reader stated"
        )

        let en = Khac(locales: [.english])
        for input in ["7am tomorrow morning", "at 7 tomorrow morning", "7 in the morning tomorrow"] {
            XCTAssertEqual(
                ymdhm(en.parseDate(input, reference: reference()) ?? .distantPast),
                "2024-06-10 07:00",
                "\(input): the English class the README claimed has no reproducer"
            )
        }
    }
}
