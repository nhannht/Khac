// RelativeUnitParser.swift - "5 days ago", "2 days later", "in five days".
//
// A count plus a time unit plus a direction word shifts the reference by that
// duration. Direction words come in three positions: a past suffix ("ago"), a
// future suffix ("later"), and a future prefix ("in"/"within"). The shifted
// year/month/day/hour/minute/second are implied onto the result.

import Foundation

struct RelativeUnitParser: Parser {
    static let overlapRank = 70

    private let boundaryBefore = "(?<![\\p{L}\\p{N}_])"
    private let boundaryAfter = "(?![\\p{L}\\p{N}_])"

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let vocab = context.locale.vocabulary
        let patterns = context.locale.patterns
        let units = WordTable(vocab.timeUnits).alternation
        let integers = WordTable(vocab.integerWords).alternation
        let number = "(?:[0-9]{1,4}|" + integers + ")"

        let past = regexAlternation(patterns.relativePastWords) ?? "(?!)"
        let futureSuffix = regexAlternation(patterns.futureSuffixWords) ?? "(?!)"
        let futurePrefix = regexAlternation(patterns.relativeFutureWords) ?? "(?!)"

        // Past: "5 days ago"
        let pastAlt =
            "(?<pn>" + number + ")\\s*(?<punit>" + units + ")\\s*(?<psfx>" + past + ")"
        // Future suffix: "2 days later"
        let futureSuffixAlt =
            "(?<fn>" + number + ")\\s*(?<funit>" + units + ")\\s*(?<fsfx>" + futureSuffix + ")"
        // Future prefix: "in 5 days"
        let futurePrefixAlt =
            "(?<fpfx>" + futurePrefix + ")\\s*(?<fpn>" + number + ")\\s*(?<fpunit>" + units + ")"

        return makeRegex(
            boundaryBefore + "(?:" + pastAlt + "|" + futureSuffixAlt + "|" + futurePrefixAlt + ")" + boundaryAfter
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let vocab = context.locale.vocabulary
        let units = WordTable(vocab.timeUnits)
        let integers = WordTable(vocab.integerWords)

        let numberText: String?
        let unitText: String?
        let sign: Int

        if let n = match.string(named: "pn") {
            numberText = n; unitText = match.string(named: "punit"); sign = -1
        } else if let n = match.string(named: "fn") {
            numberText = n; unitText = match.string(named: "funit"); sign = 1
        } else if let n = match.string(named: "fpn") {
            numberText = n; unitText = match.string(named: "fpunit"); sign = 1
        } else {
            return nil
        }

        guard let numberText = numberText, let unitText = unitText else { return nil }
        guard let count = parseNumber(numberText, integers: integers) else { return nil }
        guard let component = units.value(for: unitText) else { return nil }

        let calendar = context.reference.calendar
        guard let target = calendar.date(byAdding: component, value: sign * count, to: context.reference.instant) else {
            return nil
        }

        var comps = context.createParsingComponents()
        let c = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: target)
        comps.imply(.year, c.year ?? 0)
        comps.imply(.month, c.month ?? 0)
        comps.imply(.day, c.day ?? 0)
        comps.imply(.hour, c.hour ?? 0)
        comps.imply(.minute, c.minute ?? 0)
        comps.imply(.second, c.second ?? 0)
        return .components(comps)
    }

    private func parseNumber(_ text: String, integers: WordTable<Int>) -> Int? {
        if let value = Int(text) { return value }
        return integers.value(for: text)
    }
}
