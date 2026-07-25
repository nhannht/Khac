// YearParser.swift - a standalone year, gated by a year-marking token.
//
// A bare number is never a date on its own, so this parser fires only when the
// number is MARKED as a year, by either of two tokens that can both be present:
// a leading marker word ("năm 1976") or a trailing era marker ("234 BCE"). The
// era sets the sign: BC/BCE negate the year, AD/CE leave it positive. A
// two-digit year is taken literally when an era is present ("88 AD" is year 88,
// not 1988), matching MonthNameParser. Month and day stay implied.
//
// The two gates are one pattern with one year group and one era group, not two
// branches: a marker and an era co-occur ("năm 179 TCN"), so a branch that owns
// only its own gate drops the other one.
//
// Not handled here (documented deferrals): a bare year with no era (chrono does
// not parse it either), and the Buddhist era "BE" whose 543-year offset the
// sign-based eraMarkers table cannot express.
//
// A BC year is NOT validated, deliberately, and it is worth knowing why before
// "fixing" it. The negative year goes to Foundation, which reads it through the
// proleptic Gregorian calendar's astronomical convention, so "234 BCE" resolves
// as era = BC, year = 235 - off by one against the historian's convention, where
// there is no year zero. That is chrono's answer too, arrived at differently:
// JavaScript's Date has no era concept at all, so chrono's BC years get zero
// validation of any kind. Matching the value while the mechanism differs is the
// most that can be claimed here. Anything stricter would be a divergence, and
// nothing in the oracle or in any real input measured so far discriminates it.

import Foundation

struct YearParser: Parser {
    static let overlapRank = 80

    private let boundaryBefore = "(?<![\\p{L}\\p{N}_])"
    private let boundaryAfter = "(?![\\p{L}\\p{N}_])"

    /// Least digits a marker word alone may gate, so "5 năm" (5 years) is never
    /// read as the year 5. An explicit era gates any length ("88 AD").
    private let minimumMarkerOnlyDigits = 3

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let era = WordTable(context.locale.vocabulary.eraMarkers).alternation
        // Optional leading marker word, present only for a locale that defines
        // one ("năm 1976"); English has none and relies on the era alone.
        //
        // A marked year is only STANDALONE when nothing before it makes it part
        // of a larger date. After a month expression it is that month's year -
        // "tháng 4 năm 1975" is April 1975, one date, and MonthNameParser owns
        // it. Without this guard the year also surfaces on its own, which is
        // invisible while MonthNameParser wins the overlap but becomes wrong the
        // moment MonthNameParser correctly declines: "ngày 0 tháng 4 năm 2000"
        // names an impossible day, so the whole phrase must produce nothing
        // rather than degrade to a bare year 2000.
        let notAfterMonth = "(?<!" + WordTable(context.locale.vocabulary.months).alternation + "\\s{0,3})"
        let markerPrefix = regexAlternation(context.locale.patterns.yearMarkerWords)
            .map { "(?:" + notAfterMonth + "(?<marker>" + $0 + ")\\s{0,3})?" } ?? ""
        return makeRegex(
            boundaryBefore
                + markerPrefix
                + "(?<yr>[0-9]{1,4})"
                + "(?:\\s{0,3}(?<era>" + era + "))?"
                + boundaryAfter
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let yearText = match.string(named: "yr"), var year = Int(yearText) else { return nil }
        let eraText = match.string(named: "era")

        // At least one gate must be present - an unmarked number is not a year.
        guard match.hasGroup(named: "marker") || eraText != nil else { return nil }
        // Marker-only needs enough digits to read as a year at all.
        guard eraText != nil || yearText.count >= minimumMarkerOnlyDigits else { return nil }

        if let eraText, let sign = WordTable(context.locale.vocabulary.eraMarkers).value(for: eraText), sign < 0 {
            year = -year
        }

        var comps = context.createParsingComponents()
        comps.certain(.year, year)
        return .components(comps)
    }
}
