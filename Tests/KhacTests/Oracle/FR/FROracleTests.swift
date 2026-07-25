// Runs the ported chrono FR oracle (this directory's *Cases.swift tables) against
// the real engine via Khac(localeInstances: [FRLocale()]). See NOTICE and
// Oracle/README.md for the prior-art credit - the case DATA is ported from
// wanasit/chrono (MIT) test/fr/*.test.ts, never chrono's test code.
//
// Reporting is PER CASE, not per asserted field - see ENOracleTests.swift's own
// header comment for why; this file mirrors that runner exactly, parameterized
// on FRLocale.

import Foundation
import XCTest
import Khac

struct FROracleRunner {
    let khac = Khac(localeInstances: [FRLocale()])

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

final class FROracleTests: XCTestCase {
    private let runner = FROracleRunner()

    /// Cases known to fail for a reason OUTSIDE this locale's own data -
    /// reported to `main` (KHAC-6). Keyed by input text, unique within each of
    /// these small per-file case lists. Never edit the oracle itself to make
    /// one of these pass; remove the entry only once the underlying fix lands
    /// and the case goes green on its own.
    private static let knownDeferrals: [String: String] = [
        // Idiom with no compositional home in this data model (same class as
        // EN's documented "last night" deferral) - see FRLocale.dayReferences.
        "La deadline était la veille":
            "KHAC-6 deferral: \"la veille\" (the day before/eve) has no compositional home in Vocabulary",
        // MonthNameParser's day-ordinal suffix is hardcoded to English
        // st/nd/rd/th and never reads any locale field for French "er"
        // ("1er Août").
        "1er Août 2012":
            "KHAC-6 deferral: MonthNameParser's day-ordinal suffix is hardcoded to English st/nd/rd/th, no field for French \"er\"",
        // Same day-range-connector wall reported from ES (MonthNameParser
        // hardcodes English words, ignores patterns.rangeConnectorWords).
        "10 au 22 août 2012":
            "KHAC-6 deferral: MonthNameParser's internal day-range connector is hardcoded to English words, ignores patterns.rangeConnectorWords",
        // Bare month name (no day) matching when chrono's real FR output does
        // not. Suspected either a genuine chrono FR behavioral difference from
        // EN (which DOES accept a bare month name alone) or a mode-tagging
        // slip in the oracle port (these read as casual but behave like the
        // ES equivalents, which were correctly tagged `mode: .strict`).
        // Reported to main for verification rather than resolved unilaterally
        // - not edited in the generated oracle either way.
        "32 Août 2014":
            "KHAC-6 deferral: bare month name matches when chrono's real FR output does not (suspected mode-tagging or genuine FR-specific behavior, unresolved)",
        "29 Février 2014":
            "KHAC-6 deferral: bare month name matches when chrono's real FR output does not (suspected mode-tagging or genuine FR-specific behavior, unresolved)",
        "32 Aout":
            "KHAC-6 deferral: bare month name matches when chrono's real FR output does not (suspected mode-tagging or genuine FR-specific behavior, unresolved)",
        "29 Fevrier":
            "KHAC-6 deferral: bare month name matches when chrono's real FR output does not (suspected mode-tagging or genuine FR-specific behavior, unresolved)",
        "le mois d'avril":
            "KHAC-6 deferral: bare month name matches when chrono's real FR output does not (suspected mode-tagging or genuine FR-specific behavior, unresolved)",
        "le mois d'avril prochain":
            "KHAC-6 deferral: bare month name matches when chrono's real FR output does not (suspected mode-tagging or genuine FR-specific behavior, unresolved)",
        // French's compact clock format ("8h10", "12h32") only requires a
        // marker on the FIRST unit; later digit groups are unmarked. Khac's
        // generic clock-word mechanism assumes every unit carries its own
        // marker (built for VI's "7 giờ 30 phút"), so an unmarked trailing run
        // either dangles past the match boundary ("8h10m00" loses its
        // unmarked seconds) or gets vetoed by passesLoneNumberFilters' ">24 is
        // not an hour" heuristic, which cannot tell a genuine unmarked minute
        // (0-59) from a suspicious bare hour ("8:10 - 12h32"). The same
        // filter's `[0-9][apAP]$` rule also rejects a genuine bare
        // single-letter meridiem ("5:16p", "5h16p") - EN's own port flagged
        // this exact tension as an open question since EN never needed the
        // bare form; French's oracle does. Confirmed empirically (isolated
        // parses), not just predicted from source.
        "8h10m00":
            "KHAC-6 deferral: French's compact clock format has unmarked trailing digit groups the generic clock-word mechanism cannot express",
        "5:16p":
            "KHAC-6 deferral: passesLoneNumberFilters' [0-9][apAP]$ rule rejects a genuine bare single-letter meridiem (EN's port flagged this exact tension as open)",
        "5h16p":
            "KHAC-6 deferral: passesLoneNumberFilters' [0-9][apAP]$ rule rejects a genuine bare single-letter meridiem (EN's port flagged this exact tension as open)",
        "8:10 - 12h32":
            "KHAC-6 deferral: passesLoneNumberFilters' \">24 is not an hour\" rule misfires on an unmarked clock-word minute",
        "12h12:99s":
            "KHAC-6 deferral: an invalid mixed-separator seconds run (\":99s\") is silently dropped rather than voiding the whole match, unlike chrono's own bespoke parser",
        // Likely downstream of the same clock-format edges above (the
        // standalone time match may never form), not independently
        // root-caused.
        "Quelque chose se passe le 2014-04-18 à 3h00":
            "KHAC-6 deferral: ISO date + French clock-word time fails to merge, likely downstream of the clock-format edges above",
        "Quelque chose se passe le 2014-04-18 de 7:00 à 20:00 ...":
            "KHAC-6 deferral: ISO date + French clock-word time range fails to merge, likely downstream of the clock-format edges above",
        // Named timezone abbreviations (EST/CET/CEST) resolving to a specific
        // offset are out of v1 scope - the same class EN's own port excluded
        // outright (5 EN cases, "Khac's v1 generic parsers do not include a
        // timezone-expression parser"). These 4 FR cases were not excluded
        // during extraction; flagged to main as a likely port inconsistency,
        // not fixed with locale data (a timezone-abbreviation table would not
        // be French vocabulary).
        "vendredi 2 pm EST":
            "KHAC-6 deferral: named timezone abbreviation resolution is out of v1 scope, same class EN's own port excluded",
        "vendredi 15h CET":
            "KHAC-6 deferral: named timezone abbreviation resolution is out of v1 scope, same class EN's own port excluded",
        "vendredi 15h cest":
            "KHAC-6 deferral: named timezone abbreviation resolution is out of v1 scope, same class EN's own port excluded",
        "Vendredi à 2 pm est":
            "KHAC-6 deferral: named timezone abbreviation resolution is out of v1 scope, same class EN's own port excluded",
        // Same notTimezoneOffset-misreads-a-compact-range wall reported from
        // ES.
        "lundi 29/4/2013 630-930am":
            "KHAC-6 deferral: TimeExpressionParser's notTimezoneOffset guard misreads a compact HHMM-HHMM range end as a timezone offset",
        "lundi 13/5/2013 630-930am":
            "KHAC-6 deferral: TimeExpressionParser's notTimezoneOffset guard misreads a compact HHMM-HHMM range end as a timezone offset",
        "mardi 7/2/2013 1-230 pm":
            "KHAC-6 deferral: TimeExpressionParser's notTimezoneOffset guard misreads a compact HHMM-HHMM range end as a timezone offset",
        // chrono's own FRWeekdayParser trailing boundary is `(?=\W|\d|$)` -
        // it explicitly permits a DIGIT to follow ("Jeudi6/5/2013" with no
        // space). Khac's generic WeekdayParser.swift boundary is
        // `(?=[^\p{L}\p{N}_]|$)`, which excludes digits along with letters.
        // Narrow (this is the only case in my whole batch that needs it), but
        // it is a generic-parser fix, not locale data.
        "Jeudi6/5/2013 de 7h à 10h":
            "KHAC-6 deferral: WeekdayParser's trailing boundary excludes a following digit, unlike chrono's own (?=\\W|\\d|$)",
        // FRTimeUnitAgoFormatParser is "il y a" + duration - a PAST-direction
        // PREFIX. RelativeUnitParser has no such field: relativePastWords is
        // suffix-only, unlike future direction which has both a prefix
        // (relativeFutureWords) and a suffix (futureSuffixWords) field.
        "il y a 5 jours, on a fait quelque chose":
            "KHAC-6 deferral: RelativeUnitParser has no past-direction PREFIX field (relativePastWords is suffix-only)",
        "il y a 10 jours, on a fait quelque chose":
            "KHAC-6 deferral: RelativeUnitParser has no past-direction PREFIX field (relativePastWords is suffix-only)",
        "il y a 15 minutes":
            "KHAC-6 deferral: RelativeUnitParser has no past-direction PREFIX field (relativePastWords is suffix-only)",
        "   il y a    12 heures":
            "KHAC-6 deferral: RelativeUnitParser has no past-direction PREFIX field (relativePastWords is suffix-only)",
        "il y a 12 heures il s'est passé quelque chose":
            "KHAC-6 deferral: RelativeUnitParser has no past-direction PREFIX field (relativePastWords is suffix-only)",
        "il y a 5 mois, on a fait quelque chose":
            "KHAC-6 deferral: RelativeUnitParser has no past-direction PREFIX field (relativePastWords is suffix-only)",
        "il y a 5 ans, on a fait quelque chose":
            "KHAC-6 deferral: RelativeUnitParser has no past-direction PREFIX field (relativePastWords is suffix-only)",
        "il y a une semaine, on a fait quelque chose":
            "KHAC-6 deferral: RelativeUnitParser has no past-direction PREFIX field (relativePastWords is suffix-only)",
        // RelativeUnitParser's bareModifierAlt (no-count modifier+unit) has no
        // leading-article slot, and the count-modifier-unit shape ("les 2
        // prochaines semaines", article+COUNT+MODIFIER+unit) has no
        // alternative in RelativeUnitParser at all - a third shape beyond
        // modifierAlt (modifier+count+unit) and bareModifierAlt. Confirmed
        // empirically that durationFillerWords does not help (see the note on
        // that field in FRLocale.swift): it only feeds DurationExpression's
        // counted-clause pattern, which bareModifierAlt never uses and
        // modifierAlt only uses AFTER the modifier, not before it.
        "la semaine prochaine":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
        "les 2 prochaines semaines":
            "KHAC-6 deferral: RelativeUnitParser has no count-modifier-unit alternative (article+count+modifier+unit)",
        "les trois prochaines semaines":
            "KHAC-6 deferral: RelativeUnitParser has no count-modifier-unit alternative (article+count+modifier+unit)",
        "le mois dernier":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
        "les huit dernieres minutes":
            "KHAC-6 deferral: RelativeUnitParser has no count-modifier-unit alternative (article+count+modifier+unit)",
        "le dernier trimestre":
            "KHAC-6 deferral: RelativeUnitParser's bareModifierAlt has no leading-article slot",
        "l'année prochaine":
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

    func testCasualCases() { run(frCasualCases) }
    func testLittleEndianCases() { run(frLittleEndianCases) }
    func testSlashCases() { run(frSlashCases) }
    func testTimeExpCases() { run(frTimeExpCases) }
    func testTimeUnitsAgoCases() { run(frTimeUnitsAgoCases) }
    func testTimeUnitsCasualRelativeCases() { run(frTimeUnitsCasualRelativeCases) }
    func testTimeUnitsWithinCases() { run(frTimeUnitsWithinCases) }
    func testWeekdayCases() { run(frWeekdayCases) }
}

/// The progress instrument, mirroring ENOracleScoreboardTests.
final class FROracleScoreboardTests: XCTestCase {
    /// Cases known to pass. Raise this after every improvement; never lower it
    /// to accommodate a regression. 39 of 154 are deferred (KHAC-6, see
    /// FROracleTests.knownDeferrals) pending engine fixes outside this
    /// locale's own data - see checkpoint reports to main.
    static let floor = 115

    func testScoreboard() {
        let runner = FROracleRunner()
        var passedByFile: [String: Int] = [:]
        var totalByFile: [String: Int] = [:]
        var passed = 0

        for c in frOracleCases {
            totalByFile[c.sourceFile, default: 0] += 1
            if runner.reasons(for: c).isEmpty {
                passedByFile[c.sourceFile, default: 0] += 1
                passed += 1
            }
        }

        var lines = ["FR ORACLE SCOREBOARD  \(passed)/\(frOracleCases.count) cases"]
        for file in totalByFile.keys.sorted() {
            let total = totalByFile[file] ?? 0
            let ok = passedByFile[file] ?? 0
            lines.append(String(format: "  %-42s %3d/%3d", (file as NSString).utf8String!, ok, total))
        }
        print(lines.joined(separator: "\n"))

        XCTAssertGreaterThanOrEqual(
            passed, Self.floor,
            "FR oracle regressed below the ratchet floor - \(passed) passing, floor is \(Self.floor)"
        )
    }
}
