// PublicAPITests.swift - the shipping public surface, exercised the way a consumer sees it.
//
// Every other suite builds the parser with Khac(localeInstances:), which bypasses
// the built-in locale registry entirely. That let defaultLocales() sit empty at
// its integration stub while 561 EN oracle cases and 69 VI cases reported green:
// the engine was correct and Khac() returned nothing for every input. Green tests
// were not evidence about the API anyone would actually call.
//
// So these tests deliberately do NOT use @testable, and deliberately do NOT use
// Khac(localeInstances:). They import the module the way an external SPM consumer
// does and go through the no-argument and id-selecting initializers only. A locale
// that is implemented but left out of defaultLocales() fails here and nowhere else.

import XCTest
import Khac

final class PublicAPITests: XCTestCase {
    // MARK: - Helpers

    /// Fixed reference so every assertion below is deterministic.
    private func reference() -> ReferencePoint {
        var comps = DateComponents()
        comps.year = 2012; comps.month = 8; comps.day = 10
        comps.hour = 12; comps.minute = 0; comps.second = 0
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh") ?? .current
        return ReferencePoint(instant: cal.date(from: comps)!, calendar: cal)
    }

    private func ymd(_ date: Date) -> (Int, Int, Int) {
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh") ?? .current
        let c = cal.dateComponents([.year, .month, .day], from: date)
        return (c.year!, c.month!, c.day!)
    }

    // MARK: - The no-argument initializer

    func testDefaultInitializerParsesEnglish() {
        let results = Khac().parse("August 10, 2012", reference: reference())
        XCTAssertEqual(results.count, 1, "Khac() must resolve English through the built-in locale registry")
        guard let first = results.first else { return }
        XCTAssertEqual(ymd(first.date).0, 2012)
        XCTAssertEqual(ymd(first.date).1, 8)
        XCTAssertEqual(ymd(first.date).2, 10)
    }

    func testDefaultInitializerParsesVietnamese() {
        let results = Khac().parse("ngày 15 tháng 3 năm 2020", reference: reference())
        XCTAssertGreaterThanOrEqual(results.count, 1, "Khac() must resolve Vietnamese through the built-in locale registry")
        guard let first = results.first else { return }
        XCTAssertEqual(ymd(first.date).0, 2020)
        XCTAssertEqual(ymd(first.date).1, 3)
        XCTAssertEqual(ymd(first.date).2, 15)
    }

    func testDefaultInitializerConvenienceDate() {
        XCTAssertNotNil(
            Khac().parseDate("August 10, 2012", reference: reference()),
            "parseDate is the one-line entry point in the type's own doc comment"
        )
    }

    // MARK: - Selecting locales by identifier

    func testEnglishSelectedByID() {
        let results = Khac(locales: [.english]).parse("August 10, 2012", reference: reference())
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(ymd(results[0].date).1, 8)
    }

    func testVietnameseSelectedByID() {
        let results = Khac(locales: [.vietnamese]).parse("ngày 15 tháng 3 năm 2020", reference: reference())
        XCTAssertGreaterThanOrEqual(results.count, 1)
        guard let first = results.first else { return }
        XCTAssertEqual(ymd(first.date).0, 2020)
        XCTAssertEqual(ymd(first.date).1, 3)
        XCTAssertEqual(ymd(first.date).2, 15)
    }

    /// Every id the registry claims to ship must actually resolve to an instance.
    /// This is the assertion that fails the moment a locale is implemented but not
    /// registered - the exact shape of the bug this file exists for.
    func testShippedLocaleIDsAllResolve() {
        for id in [LocaleID.english, .vietnamese] {
            let sample = id == .english ? "August 10, 2012" : "ngày 15 tháng 3 năm 2020"
            XCTAssertGreaterThanOrEqual(
                Khac(locales: [id]).parse(sample, reference: reference()).count, 1,
                "LocaleID.\(id.rawValue) is not reachable through Khac(locales:)"
            )
        }
    }

    // MARK: - Documented empty behaviour

    func testNoLocalesParsesNothing() {
        XCTAssertTrue(
            Khac(locales: []).parse("August 10, 2012", reference: reference()).isEmpty,
            "an empty locale selection has nothing to parse with"
        )
    }
}
