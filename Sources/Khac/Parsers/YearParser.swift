// YearParser.swift - a standalone year that carries an era marker.
//
// A bare number is never a date on its own, so this parser fires only when a
// year is followed by an explicit era marker ("234 BCE", "88 AD"). The era sets
// the sign: BC/BCE negate the year, AD/CE leave it positive. A two-digit year is
// taken literally when an era is present ("88 AD" is year 88, not 1988), matching
// MonthNameParser. Month and day stay implied from the reference.
//
// Not handled here (documented deferrals): a bare year with no era (chrono does
// not parse it either), and the Buddhist era "BE" whose 543-year offset the
// sign-based eraMarkers table cannot express.

import Foundation

struct YearParser: Parser {
    static let overlapRank = 80

    private let boundaryBefore = "(?<![\\p{L}\\p{N}_])"
    private let boundaryAfter = "(?![\\p{L}\\p{N}_])"

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let era = WordTable(context.locale.vocabulary.eraMarkers).alternation
        return makeRegex(
            boundaryBefore + "(?<yr>[0-9]{1,4})\\s{0,3}(?<era>" + era + ")" + boundaryAfter
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let yearText = match.string(named: "yr"),
              let eraText = match.string(named: "era"),
              var year = Int(yearText) else { return nil }

        if let sign = WordTable(context.locale.vocabulary.eraMarkers).value(for: eraText), sign < 0 {
            year = -year
        }

        var comps = context.createParsingComponents()
        comps.certain(.year, year)
        return .components(comps)
    }
}
