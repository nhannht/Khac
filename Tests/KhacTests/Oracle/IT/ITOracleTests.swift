// Runs the ported chrono IT oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [ITLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/it/**/*.test.ts, never chrono's test code.
//
// Reporting is PER CASE, not per asserted field - see ENOracleTests.swift's own
// header comment for why; this file mirrors that runner exactly, parameterized
// on ITLocale.

import Foundation
import XCTest
import Khac

struct ITOracleRunner {
    let khac = Khac(localeInstances: [ITLocale()])

    let fixedCalendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }()

    private func dateComponents(_ d: OracleDate) -> DateComponents {
        var comps = DateComponents()
        comps.year = d.year
        comps.month = d.month
        comps.day = d.day
        comps.hour = d.hour
        comps.minute = d.minute
        comps.second = d.second
        comps.nanosecond = d.millisecond * 1_000_000
        return comps
    }

    private func reference(_ d: OracleDate) -> ReferencePoint {
        let instant = fixedCalendar.date(from: dateComponents(d)) ?? Date()
        return ReferencePoint(instant: instant, calendar: fixedCalendar)
    }

    private func resolvedDate(_ d: OracleDate) -> Date {
        fixedCalendar.date(from: dateComponents(d)) ?? Date()
    }

    private func componentReasons(_ expected: OracleComponents, _ actual: ParsingComponents, _ side: String) -> [String] {
        var reasons: [String] = []
        func compare(_ name: String, _ want: Int?, _ component: ParsingComponents.Component) {
            guard let want = want else { return }
            let got = actual.get(component)
            if got != want {
                reasons.append("\(side).\(name) want \(want) got \(got.map(String.init(describing:)) ?? "nil")")
            }
        }
        compare("year", expected.year, .year)
        compare("month", expected.month, .month)
        compare("day", expected.day, .day)
        compare("hour", expected.hour, .hour)
        compare("minute", expected.minute, .minute)
        compare("second", expected.second, .second)
        compare("millisecond", expected.millisecond, .millisecond)
        compare("weekday", expected.weekday, .weekday)
        compare("timezoneOffset", expected.timezoneOffset, .timezoneOffset)
        return reasons
    }

    func reasons(for c: OracleCase) -> [String] {
        let mode: Options.Mode = c.mode == .strict ? .strict : .casual
        let options = Options(mode: mode, forwardDate: c.forwardDate)
        let results = khac.parse(c.input, reference: reference(c.reference), options: options)

        switch c.expectation {
        case .noMatch:
            guard !results.isEmpty else { return [] }
            return ["want no match, got \(results.count): \(results.map(\.text))"]

        case .match(let text, let index, let start, let startDate, let end, let endDate):
            guard let result = results.first else { return ["want a match, got none"] }
            var reasons: [String] = []
            if let text = text, result.text != text {
                reasons.append("text want \(text.debugDescription) got \(result.text.debugDescription)")
            }
            if let index = index, result.index != index {
                reasons.append("index want \(index) got \(result.index)")
            }
            if !start.isEmpty {
                reasons += componentReasons(start, result.start, "start")
            }
            if let startDate = startDate, result.start.date() != resolvedDate(startDate) {
                reasons.append("startDate want \(resolvedDate(startDate)) got \(result.start.date())")
            }
            if !end.isEmpty {
                if let endComponents = result.end {
                    reasons += componentReasons(end, endComponents, "end")
                } else {
                    reasons.append("want end components, got none")
                }
            }
            if let endDate = endDate {
                if let endComponents = result.end {
                    if endComponents.date() != resolvedDate(endDate) {
                        reasons.append("endDate want \(resolvedDate(endDate)) got \(endComponents.date())")
                    }
                } else {
                    reasons.append("want an end date, got none")
                }
            }
            return reasons
        }
    }
}

final class ITOracleTests: XCTestCase {
    private let runner = ITOracleRunner()

    /// Cases known to fail for a reason OUTSIDE this locale's own data -
    /// reported to `main` (KHAC-6). Keyed by input text, unique within each of
    /// these small per-file case lists. Never edit the oracle itself to make
    /// one of these pass; remove the entry only once the underlying fix lands
    /// and the case goes green on its own.
    private static let knownDeferrals: [String: String] = [
        // chrono's own "now" carries an environment-specific timezoneOffset
        // (420 = UTC+7) baked into its test fixture from whatever machine the
        // chrono test suite was authored/run on. Khac's CasualDateParser
        // "now" branch never sets .timezoneOffset at all - a genuine
        // engine-shape gap (does "now" expose a reference timezone offset
        // field?), not locale data, and not reproducible without knowing
        // chrono's original test environment.
        "La scadenza è adesso":
            "KHAC-6 deferral: chrono's \"now\" bakes in an environment-specific timezoneOffset Khac's CasualDateParser \"now\" branch does not expose",
        // chrono's own ITCasualTimeParser regex only recognizes FEMININE
        // "questa" as the this-prefix (`(questa\s*)?(mattina|pomeriggio|...)`),
        // never masculine "questo" - even before a masculine noun like
        // "pomeriggio". A gender-agreement gap in chrono's own source, not
        // guessed at: "questa sera" (feminine noun) correctly includes
        // "questa" in the match, but "questo pomeriggio" (masculine noun)
        // does NOT include "questo" - chrono's regex simply never wrote that
        // branch. Khac's relativeModifiers-driven CasualDateParser anchor
        // mechanism can't reproduce this asymmetry: "questo" must stay
        // anchor-eligible (value 0) for WeekdayParser's "questo venerdì"/
        // "questo sabato", which correctly DO want "questo" included and are
        // currently passing - there is no per-PARSER view of the same shared
        // Vocabulary table.
        "La scadenza era questo pomeriggio ":
            "KHAC-6 deferral: chrono's ITCasualTimeParser only recognizes feminine \"questa\", not masculine \"questo\", as this-prefix - a chrono gender-agreement gap Khac's shared relativeModifiers table can't reproduce without breaking \"questo venerdì\"",
        "questo pomeriggio alle 3":
            "KHAC-6 deferral: chrono's ITCasualTimeParser only recognizes feminine \"questa\", not masculine \"questo\", as this-prefix - a chrono gender-agreement gap Khac's shared relativeModifiers table can't reproduce without breaking \"questo venerdì\"",
        // MergeDateRangeRefiner's isDateLike gate requires a CERTAIN
        // day/month/year/weekday/hour. A bare, unanchored time-of-day
        // reference like "stamattina" (implied hour only, via
        // CasualDateParser's bare-btod branch) has nothing certain, so it
        // cannot serve as one side of a range even though a day reference
        // like "oggi" can (CasualDateParser's dref branch uses assignDate,
        // which marks day/month/year CERTAIN). "ferie da oggi a domani
        // pomeriggio" (oggi = certain day) passes; this one does not.
        "ferie da stamattina a domani":
            "KHAC-6 deferral: MergeDateRangeRefiner's isDateLike gate rejects a bare time-of-day reference with nothing certain as a range side",
        // Confirmed cross-locale (also seen in FR): a bare, UNMARKED invalid
        // calendar day ("29 febbraio 2014", "agosto 32, 2014") should void
        // the WHOLE match in casual mode, the same way it already does in
        // strict mode via MonthNameParser's explicit `day == nil` guard, and
        // the same way VI's `dayMarkerWords` lookbehind already voids a
        // MARKED invalid day ("ngày 0 tháng 4"). Here there is no marker word
        // at all (bare "29 febbraio"), so neither existing guard fires, and
        // the rejected day/month construct falls through to a spurious bare
        // "febbraio 2014" / "agosto 32" match. Two locales, 8 total cases now
        // point the same way - reported to main as a confirmed casual-mode
        // gap, not a per-locale oddity.
        "29 febbraio 2014":
            "KHAC-6 deferral: casual mode falls back to a spurious bare-month match after an unmarked invalid day is rejected (confirmed cross-locale with FR)",
        "agosto 32, 2014":
            "KHAC-6 deferral: casual mode falls back to a spurious bare-month match after an unmarked invalid day is rejected (confirmed cross-locale with FR)",
        "30 febbraio 2020":
            "KHAC-6 deferral: casual mode falls back to a spurious bare-month match after an unmarked invalid day is rejected (confirmed cross-locale with FR)",
        "0 marzo 2020":
            "KHAC-6 deferral: casual mode falls back to a spurious bare-month match after an unmarked invalid day is rejected (confirmed cross-locale with FR)",
        // Named timezone abbreviations (CET/CEST) resolving to a specific
        // offset are out of v1 scope - same class EN's own port excluded and
        // FR's port did not (see the FR checkpoint report). The 3 numeric-
        // offset ItTimezoneExpCases ("+0100" etc.) already pass generically
        // via ExtractTimezoneOffsetRefiner; only the named abbreviations need
        // a lookup table that isn't Italian vocabulary.
        "10 agosto 2012 10:00 CET":
            "KHAC-6 deferral: named timezone abbreviation resolution is out of v1 scope, same class EN's own port excluded",
        "10 agosto 2012 10:00 CEST":
            "KHAC-6 deferral: named timezone abbreviation resolution is out of v1 scope, same class EN's own port excluded",
        // RelativeUnitParser's bareModifierAlt (no-count modifier+unit) has no
        // leading-article slot - the same wall reported from FR
        // ("la semaine prochaine"). These same 6 Italian phrases are ported
        // twice, once from it_relative.test.ts and once from
        // it_time_units_casual_relative.test.ts.
        "la settimana prossima":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
        "la settimana scorsa":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
        "il mese prossimo":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
        "il mese scorso":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
        "l'anno prossimo":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
        "l'anno scorso":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
    ]

    private func run(_ cases: [OracleCase]) {
        for c in cases {
            if let reason = Self.knownDeferrals[c.input] {
                XCTExpectFailure(reason) {
                    let reasons = runner.reasons(for: c)
                    XCTAssertTrue(reasons.isEmpty, "[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; "))
                }
                continue
            }
            let reasons = runner.reasons(for: c)
            guard !reasons.isEmpty else { continue }
            XCTFail("[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; "))
        }
    }

    func testRootCases() { run(itRootCases) }
    func testCasualCases() { run(itCasualCases) }
    func testInterStdCases() { run(itInterStdCases) }
    func testMergingRelativeDatesCases() { run(itMergingRelativeDatesCases) }
    func testMonthCases() { run(itMonthCases) }
    func testMonthNameLittleEndianCases() { run(itMonthNameLittleEndianCases) }
    func testMonthNameMiddleEndianCases() { run(itMonthNameMiddleEndianCases) }
    func testRelativeCases() { run(itRelativeCases) }
    func testSlashCases() { run(itSlashCases) }
    func testTimeExpCases() { run(itTimeExpCases) }
    func testTimeUnitsAgoCases() { run(itTimeUnitsAgoCases) }
    func testTimeUnitsCasualRelativeCases() { run(itTimeUnitsCasualRelativeCases) }
    func testTimeUnitsLaterCases() { run(itTimeUnitsLaterCases) }
    func testTimeUnitsWithinCases() { run(itTimeUnitsWithinCases) }
    func testTimezoneExpCases() { run(itTimezoneExpCases) }
    func testWeekdayCases() { run(itWeekdayCases) }
    func testYearCases() { run(itYearCases) }
    func testYearMonthDayCases() { run(itYearMonthDayCases) }
    func testNegativeCases() { run(itNegativeCasesCases) }
}

/// The progress instrument, mirroring ENOracleScoreboardTests.
final class ITOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression. 22 of 168 are deferred (KHAC-6, see
    /// ITOracleTests.knownDeferrals) pending engine fixes outside this
    /// locale's own data - see checkpoint reports to main.
    static let floor = 146

    func testScoreboard() {
        let runner = ITOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in itOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["IT ORACLE SCOREBOARD  \(passed)/\(itOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "IT oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
