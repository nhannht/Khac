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
        let markerPrefix = regexAlternation(context.locale.patterns.yearMarkerWords)
            .map { "(?:(?<marker>" + $0 + ")\\s{0,3})?" } ?? ""
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
