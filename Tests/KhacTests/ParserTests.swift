// ParserTests.swift - the generic parsers end to end through Engine.run, driven
// by MockLocale (English-like). Scenarios mirror chrono's EN oracle so behavior
// is pinned before the real EN/VI locales integrate.

import XCTest
@testable import Khac

final class ParserTests: XCTestCase {

    private let utc = TimeZone(identifier: "UTC")!

    private func reference(_ y: Int, _ mo: Int, _ d: Int, _ h: Int = 12, _ mi: Int = 0, _ s: Int = 0) -> ReferencePoint {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = utc
        let comps = DateComponents(year: y, month: mo, day: d, hour: h, minute: mi, second: s)
        return ReferencePoint(instant: cal.date(from: comps)!, calendar: cal)
    }

    private let khac = Khac(localeInstances: [MockLocale()])

    private func firstResult(_ text: String, _ ref: ReferencePoint) -> ParsedResult? {
        khac.parse(text, reference: ref).first
    }

    // MARK: ISO

    func testISOWithNegativeOffset() {
        let r = firstResult("1994-11-05T08:15:30-05:30", reference(2012, 8, 8))
        XCTAssertEqual(r?.text, "1994-11-05T08:15:30-05:30")
        XCTAssertEqual(r?.start.get(.year), 1994)
        XCTAssertEqual(r?.start.get(.month), 11)
        XCTAssertEqual(r?.start.get(.day), 5)
        XCTAssertEqual(r?.start.get(.hour), 8)
        XCTAssertEqual(r?.start.get(.minute), 15)
        XCTAssertEqual(r?.start.get(.second), 30)
        XCTAssertEqual(r?.start.get(.timezoneOffset), -330)
    }

    func testISOWithZulu() {
        let r = firstResult("1994-11-05T13:15:30Z", reference(2012, 8, 8))
        XCTAssertEqual(r?.start.get(.timezoneOffset), 0)
        XCTAssertTrue(r?.start.isCertain(.hour) ?? false)
    }

    func testISOIndexInsideSentence() {
        let r = firstResult("- 1994-11-05T13:15:30Z", reference(2012, 8, 8))
        XCTAssertEqual(r?.index, 2)
        XCTAssertEqual(r?.text, "1994-11-05T13:15:30Z")
    }

    // MARK: Numeric

    func testSlashMonthDay() {
        let r = firstResult("8/10/2012", reference(2012, 8, 10))
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertEqual(r?.start.get(.day), 10)
        XCTAssertEqual(r?.start.get(.year), 2012)
        // Bare date resolves at implied noon.
        var cal = Calendar(identifier: .gregorian); cal.timeZone = utc
        XCTAssertEqual(cal.component(.hour, from: r!.date), 12)
    }

    func testImpossibleDatesAreRejected() {
        let ref = reference(2012, 8, 10)
        XCTAssertNil(firstResult("06/31/2022", ref), "June has 30 days")
        XCTAssertNil(firstResult("02/29/2022", ref), "2022 is not a leap year")
        XCTAssertNil(firstResult("2014-02-30", ref), "February never has 30 days")
        XCTAssertNil(firstResult("2014-08-32", ref), "no 32nd day")
        // A real leap day still parses.
        XCTAssertNotNil(firstResult("02/29/2024", ref), "2024 is a leap year")
    }

    func testDotSeparatorRequiresFourDigitYear() {
        let ref = reference(2012, 8, 10)
        // Decimals and version strings are not dates (NumericDate must not claim
        // "6.5" or "1.1.3" as a date). "1.10.30" additionally needs the A3
        // TimeExpression dot-minute guard, so it is covered separately.
        XCTAssertNil(firstResult("6.5 kilograms", ref))
        XCTAssertNil(firstResult("1.1.3", ref))
        // A dot date with a 4-digit year IS a date.
        let r = firstResult("02.07.2013", ref)
        XCTAssertEqual(r?.start.get(.year), 2013)
        XCTAssertEqual(r?.start.get(.month), 2)
        XCTAssertEqual(r?.start.get(.day), 7)
    }

    func testSlashInsideSentenceIndex() {
        let r = firstResult(": 8/1/2012", reference(2012, 8, 10))
        XCTAssertEqual(r?.text, "8/1/2012")
        XCTAssertEqual(r?.index, 2)
        XCTAssertEqual(r?.start.get(.day), 1)
    }

    // MARK: Casual

    func testTodayResolvesAtReferenceTime() {
        let ref = reference(2012, 8, 10, 14, 12)
        let r = firstResult("The Deadline is today", ref)
        XCTAssertEqual(r?.text, "today")
        XCTAssertEqual(r?.index, 16)
        XCTAssertEqual(r?.start.get(.day), 10)
        var cal = Calendar(identifier: .gregorian); cal.timeZone = utc
        XCTAssertEqual(cal.component(.hour, from: r!.date), 14)
        XCTAssertEqual(cal.component(.minute, from: r!.date), 12)
    }

    func testTomorrowAdvancesDay() {
        let ref = reference(2012, 8, 10, 17, 10)
        let r = firstResult("The Deadline is Tomorrow", ref)
        XCTAssertEqual(r?.start.get(.day), 11)
        var cal = Calendar(identifier: .gregorian); cal.timeZone = utc
        XCTAssertEqual(cal.component(.hour, from: r!.date), 17)
    }

    func testNowIsFullPrecisionCertain() {
        let ref = reference(2012, 8, 10, 8, 9, 10)
        let r = firstResult("The Deadline is now", ref)
        XCTAssertEqual(r?.text, "now")
        XCTAssertTrue(r?.start.isCertain(.hour) ?? false)
        XCTAssertEqual(r?.start.get(.hour), 8)
        XCTAssertEqual(r?.start.get(.minute), 9)
        XCTAssertEqual(r?.start.get(.second), 10)
    }

    // MARK: Weekday

    func testBareWeekdayNearestOccurrence() {
        let ref = reference(2012, 8, 9) // Thursday
        let monday = firstResult("Monday", ref)
        XCTAssertEqual(monday?.start.get(.day), 6, "nearest Monday is 3 days back")
        XCTAssertEqual(monday?.start.get(.weekday), 1)

        let sunday = firstResult("Sunday", ref)
        XCTAssertEqual(sunday?.start.get(.day), 12, "nearest Sunday is 3 days ahead")
        XCTAssertEqual(sunday?.start.get(.weekday), 0)

        let thursday = firstResult("Thursday", ref)
        XCTAssertEqual(thursday?.start.get(.day), 9)
    }

    func testLastAndPastFriday() {
        let ref = reference(2012, 8, 9) // Thursday
        let last = firstResult("The Deadline is last Friday", ref)
        XCTAssertEqual(last?.text, "last Friday")
        XCTAssertEqual(last?.start.get(.day), 3)
        XCTAssertEqual(last?.start.get(.weekday), 5)

        let past = firstResult("The Deadline is past Friday", ref)
        XCTAssertEqual(past?.start.get(.day), 3)
    }

    func testWeekdaySuffixModifier() {
        // A locale that attaches the modifier AFTER the weekday ("Monday next"),
        // the shared Path A slot used by Vietnamese "thứ hai tới".
        var suffixLocale = MockLocale()
        suffixLocale.options = LocaleOptions(dateOrder: .monthDay, weekStart: 1, weekdaySuffixModifier: true)
        let khac = Khac(localeInstances: [suffixLocale])
        let ref = reference(2012, 8, 9) // Thursday

        let next = khac.parse("Monday next", reference: ref).first
        XCTAssertEqual(next?.text, "Monday next")
        XCTAssertEqual(next?.start.get(.day), 13, "next Monday, forward")
        XCTAssertEqual(next?.start.get(.weekday), 1)

        let last = khac.parse("Monday last", reference: ref).first
        XCTAssertEqual(last?.start.get(.day), 6, "last Monday, backward")
    }

    // MARK: Casual time of day

    func testThisMorningImpliesSixToday() {
        let ref = reference(2012, 8, 10, 12)
        let r = firstResult("The Deadline was this morning", ref)
        XCTAssertEqual(r?.text, "this morning")
        XCTAssertEqual(r?.start.get(.day), 10)
        XCTAssertEqual(r?.start.get(.hour), 6)
    }

    func testMidnightRollsToComingDay() {
        let ref = reference(2012, 8, 10, 12)
        let r = firstResult("The Deadline is midnight", ref)
        XCTAssertEqual(r?.text, "midnight")
        XCTAssertEqual(r?.start.get(.hour), 0)
        XCTAssertTrue(r?.start.isCertain(.hour) ?? false)
        XCTAssertEqual(r?.start.get(.day), 11, "past 2 AM, midnight is the coming midnight")
    }

    func testMidnightEarlyMorningStaysToday() {
        let ref = reference(2012, 8, 10, 1)
        let r = firstResult("The Deadline was midnight", ref)
        XCTAssertEqual(r?.start.get(.hour), 0)
        XCTAssertEqual(r?.start.get(.day), 10, "before 2 AM, midnight is today's")
    }

    func testYesterdayAfternoonAnchorsDayAndHour() {
        let ref = reference(2016, 10, 1, 0)
        let r = firstResult("yesterday afternoon", ref)
        XCTAssertEqual(r?.text, "yesterday afternoon")
        XCTAssertEqual(r?.start.get(.day), 30)
        XCTAssertEqual(r?.start.get(.month), 9)
        XCTAssertEqual(r?.start.get(.hour), 15)
    }

    func testTonightIsTodayAtTwentyTwo() {
        let ref = reference(2012, 1, 1, 12)
        let r = firstResult("tonight", ref)
        XCTAssertEqual(r?.start.get(.day), 1)
        XCTAssertEqual(r?.start.get(.hour), 22)
    }

    func testTomorrowAtNoonMergesTimeOntoDate() {
        let ref = reference(2012, 8, 10, 14)
        let r = firstResult("Tomorrow at noon", ref)
        XCTAssertEqual(r?.start.get(.day), 11)
        XCTAssertEqual(r?.start.get(.hour), 12)
        XCTAssertTrue(r?.start.isCertain(.hour) ?? false)
    }

    // MARK: Year with era

    func testYearBCNegatesValue() {
        let r = firstResult("500 BC", reference(2012, 8, 10))
        XCTAssertEqual(r?.start.get(.year), -500)
    }

    func testYearADKeepsTwoDigitLiteral() {
        let r = firstResult("88 AD", reference(2012, 8, 10))
        XCTAssertEqual(r?.start.get(.year), 88, "an era marker suppresses two-digit expansion")
    }

    // MARK: Time expression

    func testTimeExpressionAppliesMeridiem() {
        let r = firstResult("5:30 PM", reference(2012, 8, 10))
        XCTAssertEqual(r?.start.get(.hour), 17)
        XCTAssertEqual(r?.start.get(.minute), 30)
        XCTAssertTrue(r?.start.isCertain(.hour) ?? false)
    }

    func testAttachedMeridiemNoColon() {
        // The bread-and-butter attached form ("11am", "9pm") must still parse as a
        // time. This sits right next to the lone-number filter and pins it.
        let am = firstResult("11am", reference(2016, 10, 1))
        XCTAssertEqual(am?.text, "11am")
        XCTAssertEqual(am?.start.get(.hour), 11)

        let pm = firstResult("9pm", reference(2016, 10, 1))
        XCTAssertEqual(pm?.start.get(.hour), 21)
    }

    func testPrefixedBareHourStillMatches() {
        let r = firstResult("at 12", reference(2016, 10, 1))
        XCTAssertEqual(r?.start.get(.hour), 12)
    }

    func testBareTwoDigitNumberIsNotATime() {
        XCTAssertNil(firstResult("  11 ", reference(2016, 10, 1)), "a lone number is not a time")
    }

    // MARK: Month name

    func testMonthNameMiddleEndian() {
        let r = firstResult("August 10, 2012", reference(2012, 1, 1))
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertEqual(r?.start.get(.day), 10)
        XCTAssertEqual(r?.start.get(.year), 2012)
    }

    // MARK: Relative unit

    func testDaysAgoShiftsBackward() {
        let r = firstResult("5 days ago", reference(2012, 8, 10))
        XCTAssertEqual(r?.start.get(.day), 5)
        XCTAssertEqual(r?.start.get(.month), 8)
    }

    func testInFiveDaysShiftsForward() {
        let r = firstResult("in 5 days", reference(2012, 8, 10))
        XCTAssertEqual(r?.start.get(.day), 15)
    }

    // MARK: Refiners

    func testMergeDateTimeGluesTodayAndTime() {
        let ref = reference(2012, 8, 10, 12)
        let r = firstResult("The Deadline is today 5PM", ref)
        XCTAssertEqual(r?.text, "today 5PM")
        XCTAssertEqual(r?.start.get(.day), 10)
        XCTAssertEqual(r?.start.get(.hour), 17)
    }

    func testWeekdayPlusTimeKeepsWeekdayDay() {
        let ref = reference(2012, 8, 10, 12) // Friday; nearest Tuesday is Aug 7
        let r = firstResult("Tuesday 9am", ref)
        XCTAssertEqual(r?.text, "Tuesday 9am")
        XCTAssertEqual(r?.start.get(.day), 7, "the weekday's resolved day, not today")
        XCTAssertEqual(r?.start.get(.hour), 9)
        XCTAssertEqual(r?.start.get(.weekday), 2)
    }

    func testMergeWeekdayCarriesWeekdayOntoDate() {
        let r = firstResult("Tuesday, August 10, 2012", reference(2012, 1, 1))
        XCTAssertEqual(r?.text, "Tuesday, August 10, 2012")
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertEqual(r?.start.get(.day), 10)
        XCTAssertEqual(r?.start.get(.weekday), 2)
    }

    func testMergeDateRangePropagatesYear() {
        let r = firstResult("May to December 2022", reference(2012, 1, 1))
        XCTAssertEqual(r?.start.get(.month), 5)
        XCTAssertEqual(r?.start.get(.year), 2022)
        XCTAssertEqual(r?.end?.get(.month), 12)
        XCTAssertEqual(r?.end?.get(.year), 2022)
    }
}
