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
        // Era-suffix form: a year followed by an era marker ("88 AD", "234 BCE").
        var alternatives = ["(?<yr>[0-9]{1,4})\\s{0,3}(?<era>" + era + ")"]
        // Year-marker-prefix form: a marker word then a 3-4 digit year ("năm
        // 1976", "năm 938"). Only when the locale defines a year marker. Requires
        // 3+ digits so a bare small number after the word is never a year.
        if let marker = regexAlternation(context.locale.patterns.yearMarkerWords) {
            alternatives.append(marker + "\\s*(?<yr2>[0-9]{3,4})")
        }
        return makeRegex(
            boundaryBefore + "(?:" + alternatives.joined(separator: "|") + ")" + boundaryAfter
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        // Year-marker-prefix form ("năm 1976"): the marker fixes it as a year,
        // no era, taken literally.
        if let yearText = match.string(named: "yr2"), let year = Int(yearText) {
            var comps = context.createParsingComponents()
            comps.certain(.year, year)
            return .components(comps)
        }

        // Era-suffix form ("88 AD"): the era sets the sign.
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
