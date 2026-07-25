// MonthNameFormsTests.swift - a locale can decline a month-name construction.
//
// Every other locale switch turns a construct on by supplying the words it needs,
// so a construct with no words is unreachable. Month-name forms broke that rule:
// day-first and month-only are built from the SAME vocabulary, so filling
// `months` handed a locale every form at once.
//
// Finnish proved it matters. chrono ships one month-name parser for Finnish,
// day-first, with no bare-month form - and makes that explicit through a day>31
// guard that skips the whole span rather than falling back. So "32 elokuuta" must
// answer NOTHING, where a parser that also offers month-only answers with a bare
// August. Declining a form has to actually forbid it, not merely deprioritise it.

import XCTest
import Foundation
@testable import Khac

final class MonthNameFormsTests: XCTestCase {
    private let ref = ReferencePoint(
        instant: Calendar(identifier: .gregorian).date(from: DateComponents(
            timeZone: TimeZone.current, year: 2012, month: 8, day: 10, hour: 12))!,
        calendar: {
            var c = Calendar(identifier: .gregorian)
            c.timeZone = TimeZone.current
            return c
        }()
    )

    private func locale(_ forms: MonthNameForms) -> MockLocale {
        var l = MockLocale()
        l.options = LocaleOptions(dateOrder: l.options.dateOrder,
                                 weekStart: l.options.weekStart,
                                 monthNameForms: forms)
        return l
    }

    private func parse(_ s: String, _ l: MockLocale) -> [ParsedResult] {
        Khac(localeInstances: [l]).parse(s, reference: ref)
    }

    func testDefaultIsEveryForm() {
        XCTAssertEqual(MockLocale().options.monthNameForms, .all,
                       "a locale that says nothing keeps the behaviour it had")
        XCTAssertFalse(parse("10 august 2012", MockLocale()).isEmpty)
        XCTAssertFalse(parse("august 2012", MockLocale()).isEmpty)
    }

    /// THE FINNISH CASE. An invalid day must not degrade into a bare month.
    func testDecliningMonthOnlyMakesAnInvalidDayProduceNothing() {
        let dayFirstOnly = locale([.dayFirst])
        XCTAssertTrue(parse("32 august", dayFirstOnly).isEmpty,
                      "day 32 is not a date, and this locale has no bare-month form to fall back to")
        // The same locale still parses its own valid form.
        XCTAssertFalse(parse("15 august 2012", dayFirstOnly).isEmpty)
    }

    /// The same input WITH month-only enabled does fall back - which is what makes
    /// the assertion above about the option rather than about the day guard.
    func testWithMonthOnlyEnabledTheBareMonthStillAnswers() {
        let results = parse("32 august", locale([.dayFirst, .monthOnly]))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].text, "august")
    }

    func testDecliningMonthFirstForbidsIt() {
        XCTAssertTrue(parse("august 10", locale([.dayFirst])).isEmpty)
        XCTAssertFalse(parse("august 10", locale([.dayFirst, .monthFirst])).isEmpty)
    }

    func testDecliningEveryFormMatchesNothingRatherThanEverything() {
        let none = locale([])
        XCTAssertTrue(parse("10 august 2012", none).isEmpty)
        XCTAssertTrue(parse("august", none).isEmpty)
        XCTAssertTrue(parse("august 10, 2012", none).isEmpty,
                      "an empty alternation must not collapse into a match-anywhere pattern")
    }
}
