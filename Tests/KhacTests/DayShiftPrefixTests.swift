// DayShiftPrefixTests.swift - a day shift written BEFORE the time of day.
//
// Proved against MockLocale rather than a real locale, so what is under test is
// the GENERIC mechanism and not one language's vocabulary. Russian and Ukrainian
// are the locales that need it ("прошлым вечером"), but if this only worked for
// them it would not be the data-driven feature it claims to be.
//
// The mirror-image suffix form has its own coverage in VITests; these assert the
// two spellings of one fact resolve the same way, which is the property that
// would break first if the prefix branch drifted from the suffix branch.

import XCTest
import Foundation
@testable import Khac

final class DayShiftPrefixTests: XCTestCase {
    /// Friday 2012-08-10, 20:00 - an evening reference, so a shift that reads the
    /// clock off the reference instead of the time-of-day word would be visible.
    private let ref = ReferencePoint(
        instant: Calendar(identifier: .gregorian).date(from: DateComponents(
            timeZone: TimeZone.current, year: 2012, month: 8, day: 10, hour: 20))!,
        calendar: {
            var c = Calendar(identifier: .gregorian)
            c.timeZone = TimeZone.current
            return c
        }()
    )

    /// MockLocale with a prefix day-shift table. "past" is deliberately a word the
    /// mock already knows as a relative modifier, and "coming" one it does not,
    /// so the pair also shows the branch does not depend on a word being absent
    /// from every other table.
    private func localeWithPrefixes() -> MockLocale {
        var locale = MockLocale()
        var vocab = locale.vocabulary
        vocab.dayShiftPrefixes = ["yester": -1, "morrow": 1]
        locale.vocabulary = vocab
        return locale
    }

    private func parse(_ text: String, _ locale: MockLocale) -> [ParsedResult] {
        Khac(localeInstances: [locale]).parse(text, reference: ref)
    }

    func testPrefixShiftResolvesTheDayAndTakesItsClockFromTheTimeWord() {
        let results = parse("yester evening", localeWithPrefixes())
        XCTAssertFalse(results.isEmpty, "a prefix day shift before a time of day must parse")

        let calendar = ref.calendar
        let date = results[0].date
        XCTAssertEqual(calendar.component(.day, from: date), 9, "yester = the day before the reference")
        XCTAssertEqual(calendar.component(.month, from: date), 8)
        // MockLocale maps "evening" to hour 20. The clock must come from the time
        // word, not from the reference happening to also be 20:00 - so the day is
        // what proves the shift applied, and the hour proves the merge ran.
        XCTAssertEqual(calendar.component(.hour, from: date), 20)
    }

    func testForwardPrefixShift() {
        let results = parse("morrow morning", localeWithPrefixes())
        XCTAssertFalse(results.isEmpty)
        let calendar = ref.calendar
        let date = results[0].date
        XCTAssertEqual(calendar.component(.day, from: date), 11, "morrow = the day after the reference")
        XCTAssertEqual(calendar.component(.hour, from: date), 6, "MockLocale morning = 06:00")
    }

    /// The shift word must NOT match on its own. It carries a day offset and no
    /// clock, so without an adjacent time-of-day word there is nothing to merge
    /// with and it would answer with the reference's own time - the exact failure
    /// the suffix form was redesigned to avoid.
    func testPrefixShiftDoesNotMatchAlone() {
        let results = parse("yester", localeWithPrefixes())
        XCTAssertTrue(results.isEmpty, "a bare shift word has no time of day to attach to")
    }

    /// A locale that fills neither table is unaffected: the branch is not emitted
    /// at all, so no word becomes reserved.
    ///
    /// The assertion is about the SHIFT, not about parsing nothing. "evening" is a
    /// time-of-day word in the mock, so the bare time-of-day branch still matches
    /// it and answers on the reference's own day - which is the whole point. An
    /// earlier version of this test asserted an empty result and failed, correctly:
    /// it was checking that the sentence was unparseable rather than that the
    /// unfilled table changed nothing.
    func testLocaleWithoutPrefixesIgnoresTheShiftWord() {
        let plain = MockLocale()
        XCTAssertTrue(plain.vocabulary.dayShiftPrefixes.isEmpty, "the mock ships without prefixes")

        let results = parse("yester evening", plain)
        XCTAssertFalse(results.isEmpty, "\"evening\" is still a time of day on its own")
        XCTAssertEqual(ref.calendar.component(.day, from: results[0].date), 10,
                       "with no prefix table, \"yester\" is just a word and the day does not move")
        XCTAssertEqual(results[0].text, "evening", "and it claims only the time-of-day word")
    }

    /// Case-insensitive on purpose, and this is the assertion that documents why.
    /// The SUFFIX form is case-SENSITIVE, because Vietnamese "Mai" is a given name
    /// that can only appear after the time word. A prefix sits where a
    /// sentence-initial capital is ordinary, so rejecting it would refuse correct
    /// input to guard an ambiguity that cannot occur in that position.
    func testPrefixShiftIsCaseInsensitiveUnlikeTheSuffixForm() {
        let results = parse("Yester evening", localeWithPrefixes())
        XCTAssertFalse(results.isEmpty, "a capitalised prefix is ordinary sentence case, not a proper noun")
        XCTAssertEqual(ref.calendar.component(.day, from: results[0].date), 9)
    }
}
