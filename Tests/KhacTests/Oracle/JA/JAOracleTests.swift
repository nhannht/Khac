// Runs the ported chrono JA oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [JALocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/ja/*.test.ts, never chrono's test code.
//
// Modeled on ENOracleTests.swift, and reporting the same way: PER CASE, not per
// asserted field, so one case that gets four components wrong is one failure
// carrying four reasons.
//
// Locale note: JALocale is constructed directly here so the corpus pins the
// locale ALONE, independent of the allLocales() registry. The composition test
// at the bottom runs the same corpus through a deliberate Khac(locales:) blend.

import Foundation
import XCTest
import Khac

/// Evaluates one oracle case against the real engine and reports why it failed.
struct JAOracleRunner {
    let khac: Khac

    /// Defaults to this locale ALONE, which is what the corpus asserts. The
    /// composition test below runs a deliberate multi-locale blend instead.
    init(khac: Khac = Khac(localeInstances: [JALocale()])) {
        self.khac = khac
    }

    /// All oracle dates are interpreted against one fixed Gregorian/UTC calendar,
    /// so cases are deterministic regardless of the machine running them.
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

    /// Every way this case failed. Empty means the case passes.
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

/// Cases deferred under KHAC-6, keyed by the exact oracle input, each with its own
/// reason. A deferral names what the locale needs that the engine does not yet
/// provide; it is never a way to quiet a case that merely fails.
///
/// Deliberately keyed by input rather than by source file, so a whole family can
/// never be skipped in one line. XCTExpectFailure is strict, so an entry whose
/// case starts passing fails the suite until the entry is removed - the table
/// cannot rot silently.
let jaDeferrals: [String: String] = [:]

final class JAOracleTests: XCTestCase {
    private let runner = JAOracleRunner()

    /// Fails once per failing CASE, listing every reason that case failed. A case
    /// listed in `jaDeferrals` is expected to fail, with its own stated reason.
    private func run(_ cases: [OracleCase]) {
        for c in cases {
            if let reason = jaDeferrals[c.input] {
                XCTExpectFailure("KHAC-6 deferral: " + reason) {
                    let reasons = runner.reasons(for: c)
                    if !reasons.isEmpty {
                        XCTFail("[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; "))
                    }
                }
                continue
            }
            let reasons = runner.reasons(for: c)
            guard !reasons.isEmpty else { continue }
            XCTFail("[\(c.sourceFile)] \(c.input.debugDescription) - " + reasons.joined(separator: "; "))
        }
    }

    func testCasualCases() { run(jaCasualCases) }
    func testSlashDateFormatCases() { run(jaSlashDateFormatCases) }
    func testStandardCases() { run(jaStandardCases) }
    func testTimeExpCases() { run(jaTimeExpCases) }
    func testWeekdayCases() { run(jaWeekdayCases) }
}

/// The progress instrument: how many JA oracle cases the engine reproduces,
/// broken down by chrono source file, with a ratchet floor that only goes up.
final class JAOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it to
    /// accommodate a regression.
    static let floor = 84

    func testScoreboard() {
        let runner = JAOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in jaOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["JA ORACLE SCOREBOARD  \(passed)/\(jaOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "JA oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}

/// Guards what the per-locale runner above structurally CANNOT see: every oracle
/// runner in this package builds a single-locale `Khac`, while `Khac()` composes
/// `defaultLocales()` and `Engine.run` concatenates all their results before one
/// final cross-locale overlap filter. Registering this locale - the open item
/// flagged to engine - is what activates that path, so the regression would
/// otherwise be found by whoever registers it rather than here.
///
/// A bare numeric slash date has no locale-independent reading, so a locale whose
/// `dateOrder` differs legitimately disagrees: `8/5` is August 5th in en and ja and
/// May 8th in vi. Two such results tie on span, certain-count, length, index AND
/// parserRank (both come from the shared NumericDateParser). Before KHAC-16 the
/// winner fell through to a tiebreak that was deterministic but arbitrary with
/// respect to locale - the EN oracle case `": 8/1/2012"` answered January 8th
/// through `Khac()` while ENOracleTests, running EN alone, stayed green. The
/// localeRank key now sends such a tie to the locale listed first.
///
/// So the conflicts are listed by input rather than absorbed into a lower count. A
/// NEW conflict fails this test; fixing the tiebreak makes the list shrink and
/// fails it too, which is the point.
final class JACompositionTests: XCTestCase {
    /// Inputs whose reading another registered locale legitimately disputes.
    /// Empty since the KHAC-16 localeRank tiebreak: `8/5` was here while an
    /// exact cross-locale tie broke arbitrarily; it now goes to the locale
    /// listed first (EN, which agrees with JA's month/day reading).
    static let knownCrossLocaleConflicts: Set<String> = []

    func testComposesWithTheOtherLocales() {
        let composed = Khac(locales: [.english, .vietnamese, .japanese, .chinese])
        let runner = JAOracleRunner(khac: composed)
        var unexpected: [String] = []
        var conflictsThatNowPass: [String] = []
        for c in jaOracleCases where jaDeferrals[c.input] == nil {
            let failed = !runner.reasons(for: c).isEmpty
            let known = Self.knownCrossLocaleConflicts.contains(c.input)
            if failed && !known {
                unexpected.append("\(c.input.debugDescription): " + runner.reasons(for: c).joined(separator: "; "))
            } else if !failed && known {
                conflictsThatNowPass.append(c.input)
            }
        }
        XCTAssertEqual(unexpected, [], "JA regressed under multi-locale composition")
        XCTAssertEqual(
            conflictsThatNowPass, [],
            "a listed cross-locale conflict now passes - remove it from knownCrossLocaleConflicts"
        )
    }
}
