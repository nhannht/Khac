// LocalePrefixWordsTests.swift - prepositions a locale wants INSIDE the match.
//
// Russian and Ukrainian write "с сегодня" and "в январе", and their oracles
// assert the preposition as part of the matched text rather than as a discourse
// word outside it. Two branches had no slot for that: CasualDateParser's bare
// day reference and MonthNameParser's month-only reading.
//
// Tested through MockLocale with invented prepositions, so what is pinned is the
// generic mechanism rather than one language's word list. The words chosen -
// "from" and "upon" - appear in no other mock table, so a pass cannot come from
// some other branch matching them by accident.

import XCTest
import Foundation
@testable import Khac

final class LocalePrefixWordsTests: XCTestCase {
    private let ref = ReferencePoint(
        instant: Calendar(identifier: .gregorian).date(from: DateComponents(
            timeZone: TimeZone.current, year: 2012, month: 8, day: 10, hour: 12))!,
        calendar: {
            var c = Calendar(identifier: .gregorian)
            c.timeZone = TimeZone.current
            return c
        }()
    )

    private func locale(dayRef: [String] = [], month: [String] = []) -> MockLocale {
        var l = MockLocale()
        var p = l.patterns
        p.dayReferencePrefixWords = dayRef
        p.monthPrefixWords = month
        l.patterns = p
        return l
    }

    private func parse(_ text: String, _ l: MockLocale) -> [ParsedResult] {
        Khac(localeInstances: [l]).parse(text, reference: ref)
    }

    func testDayReferencePrefixIsConsumedIntoTheSpan() {
        let results = parse("due from tomorrow", locale(dayRef: ["from"]))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].text, "from tomorrow", "the preposition belongs to the match")
        XCTAssertEqual(ref.calendar.component(.day, from: results[0].date), 11)
    }

    /// Unfilled means unmatched, not "matched and discarded". A locale whose
    /// oracle excludes the preposition must see the span start at the day word.
    func testUnlistedDayReferencePrefixStaysOutsideTheSpan() {
        let results = parse("due from tomorrow", locale())
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].text, "tomorrow", "an unlisted preposition is just a word")
        XCTAssertEqual(ref.calendar.component(.day, from: results[0].date), 11)
    }

    func testMonthPrefixIsConsumedIntoAMonthOnlyMatch() {
        let results = parse("it happened upon january", locale(month: ["upon"]))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].text, "upon january")
        XCTAssertEqual(ref.calendar.component(.month, from: results[0].date), 1)
    }

    func testUnlistedMonthPrefixStaysOutsideTheSpan() {
        let results = parse("it happened upon january", locale())
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].text, "january")
    }

    /// The month prefix is deliberately scoped to the month-ONLY reading. A month
    /// inside a full date takes its lead-in from the surrounding form, and letting
    /// a preposition in there would start one match before a day it does not
    /// contain.
    func testMonthPrefixDoesNotEnlargeAFullDateMatch() {
        let results = parse("upon 10 january 2012", locale(month: ["upon"]))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].text, "10 january 2012", "the full date keeps its own span")
        let d = results[0].date
        XCTAssertEqual(ref.calendar.component(.day, from: d), 10)
        XCTAssertEqual(ref.calendar.component(.month, from: d), 1)
        XCTAssertEqual(ref.calendar.component(.year, from: d), 2012)
    }
}
