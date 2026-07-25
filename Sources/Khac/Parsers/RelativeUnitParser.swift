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

        // Bare modifier plus unit, NO count: "next week", "last month", "this
        // year", Vietnamese "tuần này", "tháng trước". Both word orders are
        // accepted because the modifier is postnominal in Vietnamese and
        // prenominal in English; neither locale's oracle contains an expression
        // where the other order means something else. Listed last so a counted
        // form ("next 2 weeks") is never captured here by mistake - that shape
        // needs a count and falls through to the counted branches.
        let modifiers = WordTable(vocab.relativeModifiers).alternation
        // A unit word followed by digits is the head of a larger token, not a
        // bare unit: Vietnamese "tháng" is the word for month, but "tháng 5" is
        // May. Without this guard, the range "tháng 3 tới tháng 5" has its
        // connector "tới" (which is ALSO a modifier) glued to the following
        // "tháng" and read as "next month", destroying the range.
        let notPartOfNumberedToken = "(?!\\s{0,3}[0-9])"
        let bareModifierAlt =
            "(?:(?<bmod>" + modifiers + ")\\s{0,3}(?<bunit>" + units + ")" + notPartOfNumberedToken +
            "|(?<bunit2>" + units + ")" + notPartOfNumberedToken + "\\s{0,3}(?<bmod2>" + modifiers + "))"

        return makeRegex(
            boundaryBefore + "(?:" + pastAlt + "|" + futureSuffixAlt + "|" + futurePrefixAlt
                + "|" + bareModifierAlt + ")" + boundaryAfter
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let vocab = context.locale.vocabulary
        let units = WordTable(vocab.timeUnits)
        let integers = WordTable(vocab.integerWords)

        // Bare modifier plus unit, no count. Casual by nature - "next week" names
        // no explicit date - so strict mode rejects it, unlike the counted forms.
        if let unitText = match.string(named: "bunit") ?? match.string(named: "bunit2"),
           let modText = match.string(named: "bmod") ?? match.string(named: "bmod2") {
            guard context.options.mode != .strict else { return nil }
            guard let component = units.value(for: unitText),
                  let offset = WordTable(vocab.relativeModifiers).value(for: modText) else { return nil }
            guard let comps = currentOrShiftedPeriod(component: component, offset: offset, context: context) else {
                return nil
            }
            return .components(comps)
        }

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
        let shift = Self.shiftable(component, sign * count)
        guard let target = calendar.date(byAdding: shift.component, value: shift.value, to: context.reference.instant) else {
            return nil
        }

        var comps = context.createParsingComponents()
        comps.implyAll(from: target, calendar: calendar)
        return .components(comps)
    }

    /// Resolve a bare "modifier + unit" expression.
    ///
    /// A nonzero offset is plain calendar arithmetic that keeps every other
    /// field: "next year" from the 22nd is the 22nd of next year, not January 1.
    ///
    /// Offset zero means THIS period, which is a different operation - it anchors
    /// to the period's start rather than shifting. "this month" is the 1st, and
    /// "this year" is January 1, with the named unit certain because the text
    /// stated it. A week is deliberately left unanchored: chrono's source rolls
    /// back to the week's start, but its own EN case for "this week" uses a
    /// Sunday reference, where rolling back is a no-op and so proves nothing,
    /// while Khac's VI case for "tuần này" asserts the day does NOT move. Leaving
    /// it unanchored satisfies both. Revisit only if a case actually discriminates.
    private func currentOrShiftedPeriod(
        component: Calendar.Component,
        offset: Int,
        context: ParsingContext
    ) -> ParsingComponents? {
        let calendar = context.reference.calendar
        var comps = context.createParsingComponents()

        guard offset != 0 else {
            let reference = context.reference.brokenDown
            switch component {
            case .month:
                comps.certain(.year, reference.year ?? 0)
                comps.certain(.month, reference.month ?? 1)
                comps.imply(.day, 1)
            case .year:
                comps.certain(.year, reference.year ?? 0)
                comps.imply(.month, 1)
                comps.imply(.day, 1)
            default:
                break
            }
            return comps
        }

        let shift = Self.shiftable(component, offset)
        guard let target = calendar.date(byAdding: shift.component, value: shift.value, to: context.reference.instant) else {
            return nil
        }
        comps.implyAll(from: target, calendar: calendar)
        return comps
    }

    /// Foundation's Calendar does not shift by `.quarter` - adding one leaves the
    /// date untouched - so express a quarter as three months. Everything else
    /// passes through unchanged.
    static func shiftable(_ component: Calendar.Component, _ value: Int) -> (component: Calendar.Component, value: Int) {
        component == .quarter ? (.month, value * 3) : (component, value)
    }

    private func parseNumber(_ text: String, integers: WordTable<Int>) -> Int? {
        if let value = Int(text) { return value }
        return integers.value(for: text)
    }
}
