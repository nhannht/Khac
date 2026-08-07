// Runs the ported chrono ZH oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [ZHLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/zh/**/*.test.ts, never chrono's test code.
//
// Modeled on ENOracleTests.swift, and reporting the same way: PER CASE, not per
// asserted field, so one case that gets four components wrong is one failure
// carrying four reasons.
//
// Locale note: ZHLocale is constructed directly here so the corpus pins the
// locale ALONE, independent of the allLocales() registry. Cross-locale
// composition is covered by ZHCompositionTests below, through a deliberate
// Khac(locales:) blend.
//
// ONE locale for both scripts, so the Simplified and Traditional tables both run
// against the same ZHLocale(). They stay SEPARATE test methods and separate
// scoreboard rows on purpose: a script difference has to stay visible instead of
// averaging away into one number.

import Foundation
import XCTest
import Khac

/// Evaluates one oracle case against the real engine and reports why it failed.
struct ZHOracleRunner {
    let khac: Khac

    /// Defaults to this locale ALONE, which is what the corpus asserts. The
    /// composition test below injects a multi-locale instance instead.
    init(khac: Khac = Khac(localeInstances: [ZHLocale()])) {
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
let zhDeferrals: [String: String] = [:]

final class ZHOracleTests: XCTestCase {
    private let runner = ZHOracleRunner()

    /// Fails once per failing CASE, listing every reason that case failed. A case
    /// listed in `zhDeferrals` is expected to fail, with its own stated reason.
    private func run(_ cases: [OracleCase]) {
        for c in cases {
            if let reason = zhDeferrals[c.input] {
                expectKnownFailure("KHAC-6 deferral: " + reason) {
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

    func testHansAgoCases() { run(zhHansAgoCases) }
    func testHansCasualCases() { run(zhHansCasualCases) }
    func testHansDateCases() { run(zhHansDateCases) }
    func testHansDeadlineCases() { run(zhHansDeadlineCases) }
    func testHansTimeExpCases() { run(zhHansTimeExpCases) }
    func testHansWeekdayCases() { run(zhHansWeekdayCases) }
    func testHantAgoCases() { run(zhHantAgoCases) }
    func testHantCasualCases() { run(zhHantCasualCases) }
    func testHantDateCases() { run(zhHantDateCases) }
    func testHantDeadlineCases() { run(zhHantDeadlineCases) }
    func testHantTimeExpCases() { run(zhHantTimeExpCases) }
    func testHantWeekdayCases() { run(zhHantWeekdayCases) }
    func testRootCases() { run(zhRootCases) }
}

/// The progress instrument: how many ZH oracle cases the engine reproduces,
/// broken down by chrono source file, with a ratchet floor that only goes up.
final class ZHOracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it to
    /// accommodate a regression.
    ///
    static let floor = 168

    func testScoreboard() {
        let runner = ZHOracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in zhOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["ZH ORACLE SCOREBOARD  \(passed)/\(zhOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "ZH oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
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
/// parserRank (both come from the shared NumericDateParser), so the winner falls
/// through to a tiebreak that is deterministic but arbitrary with respect to
/// locale. This is NOT specific to CJK and it is not new: on today's
/// `defaultLocales()` of en+vi the EN oracle case `": 8/1/2012"` already resolves
/// to January 8th, and no test catches it because ENOracleTests runs EN alone.
///
/// So the conflicts are listed by input rather than absorbed into a lower count. A
/// NEW conflict fails this test; fixing the tiebreak makes the list shrink and
/// fails it too, which is the point.
final class ZHCompositionTests: XCTestCase {
    /// Empty, and that is the finding: Chinese always writes its date markers
    /// (年月日号), so it never competes for a bare numeric slash date the way
    /// Japanese does.
    static let knownCrossLocaleConflicts: Set<String> = []

    func testComposesWithTheOtherLocales() {
        let composed = Khac(locales: [.english, .vietnamese, .japanese, .chinese])
        let runner = ZHOracleRunner(khac: composed)
        var unexpected: [String] = []
        for c in zhOracleCases where zhDeferrals[c.input] == nil {
            let reasons = runner.reasons(for: c)
            if !reasons.isEmpty, !Self.knownCrossLocaleConflicts.contains(c.input) {
                unexpected.append("\(c.input.debugDescription): " + reasons.joined(separator: "; "))
            }
        }
        XCTAssertEqual(unexpected, [], "ZH regressed under multi-locale composition")
    }
}
