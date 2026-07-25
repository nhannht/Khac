// RelativeUnitParser.swift - a duration applied to the reference.
//
// "5 days ago", "in five days", "15 hours 29 min ago", "+2 months, 5 days",
// "next 2 weeks", "half an hour ago", "next week".
//
// A relative expression is a DURATION plus a DIRECTION. The duration itself -
// possibly several clauses, possibly a vague count like "a few" - is defined
// once in DurationExpression and shared, so every direction below reads the same
// grammar. Direction comes in five positions: a past suffix ("ago"), a future
// suffix ("later"), a future prefix ("in"), an explicit sign ("+15min"), and a
// modifier prefix ("next 2 weeks").
//
// A sixth form carries NO count at all ("next week", "tuần này"). It is not a
// duration: offset zero means the CURRENT period anchored to its start, which is
// a different operation from shifting. See currentOrShiftedPeriod.

import Foundation

struct RelativeUnitParser: Parser {
    static let overlapRank = 70

    private let boundaryBefore = "(?<![\\p{L}\\p{N}_])"
    private let boundaryAfter = "(?![\\p{L}\\p{N}_])"

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let vocab = context.locale.vocabulary
        let patterns = context.locale.patterns
        let duration = DurationExpression.fragment(context)

        // Strict mode accepts only spelled-out units: "5 minutes ago" parses,
        // "5m ago" does not. A locale that declares no full-name set is
        // unaffected and behaves the same in both modes.
        let unitTable = context.options.mode == .strict && !vocab.fullTimeUnitNames.isEmpty
            ? vocab.timeUnits.filter { vocab.fullTimeUnitNames.contains(WordTable<Int>.fold($0.key)) }
            : vocab.timeUnits
        let units = WordTable(unitTable).alternation

        let past = regexAlternation(patterns.relativePastWords) ?? "(?!)"
        let futureSuffix = regexAlternation(patterns.futureSuffixWords) ?? "(?!)"
        let futurePrefix = regexAlternation(patterns.relativeFutureWords) ?? "(?!)"
        let modifiers = WordTable(vocab.relativeModifiers).alternation

        // Past: "5 days ago", "15 hours 29 min ago"
        let pastAlt = "(?<pdur>" + duration + ")\\s{0,3}(?<psfx>" + past + ")"
        // Future suffix: "2 days later", "15 minute out"
        let futureSuffixAlt = "(?<fdur>" + duration + ")\\s{0,3}(?<fsfx>" + futureSuffix + ")"
        // Future prefix: "in 5 days", "wait for 5 minutes". Under forwardDate
        // the prefix itself is optional - chrono's PATTERN_WITH_OPTIONAL_PREFIX -
        // because that option declares bare durations to mean the future:
        // "give it 2 months" is a date two months out. Casual only; strict mode
        // still demands the explicit prefix.
        let prefixIsOptional = context.options.forwardDate && context.options.mode != .strict
        let futurePrefixGroup = "(?<fpfx>" + futurePrefix + ")\\s{0,3}"
        let futurePrefixAlt =
            (prefixIsOptional ? "(?:" + futurePrefixGroup + ")?" : futurePrefixGroup)
            + "(?<fpdur>" + duration + ")"
        // Explicit sign: "+15 minutes", "-3y", "-2hr5min"
        let signedAlt = "(?<sign>[+-])\\s{0,3}(?<sdur>" + duration + ")"
        // Modifier prefix WITH a count: "next 2 weeks", "past 2 days". Shorthand
        // units are refused here in BOTH modes - "last 2m" is not a date - unlike
        // the signed form above, which accepts "-3y".
        let modifierDuration = DurationExpression.fragment(context, abbreviations: false)
        let modifierAlt = "(?<mpmod>" + modifiers + ")\\s{0,3}(?<mpdur>" + modifierDuration + ")"

        // Bare modifier plus unit, NO count: "next week", "last month", "this
        // year", Vietnamese "tuần này", "tháng trước". Both word orders are
        // accepted because the modifier is postnominal in Vietnamese and
        // prenominal in English. Listed last so any counted form is captured by
        // the branches above first.
        //
        // A unit word followed by digits is the head of a larger token:
        // Vietnamese "tháng" is the word for month, but "tháng 5" is May.
        // Without this guard the range "tháng 3 tới tháng 5" has its connector
        // "tới" (which is ALSO a modifier) glued to the following "tháng" and
        // read as "next month", destroying the range.
        let notPartOfNumberedToken = "(?!\\s{0,3}[0-9])"
        let bareModifierAlt =
            "(?:(?<bmod>" + modifiers + ")\\s{0,3}(?<bunit>" + units + ")" + notPartOfNumberedToken +
            "|(?<bunit2>" + units + ")" + notPartOfNumberedToken + "\\s{0,3}(?<bmod2>" + modifiers + "))"

        let alternatives = [
            pastAlt, futureSuffixAlt, futurePrefixAlt, signedAlt, modifierAlt, bareModifierAlt,
        ].joined(separator: "|")

        return makeRegex(boundaryBefore + "(?:" + alternatives + ")" + boundaryAfter)
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let vocab = context.locale.vocabulary
        let units = WordTable(vocab.timeUnits)
        let modifiers = WordTable(vocab.relativeModifiers)

        // Bare modifier plus unit, no count. Casual by nature - "next week" names
        // no explicit date - so strict mode rejects it, unlike the counted forms.
        if let unitText = match.string(named: "bunit") ?? match.string(named: "bunit2"),
           let modText = match.string(named: "bmod") ?? match.string(named: "bmod2") {
            guard context.options.mode != .strict else { return nil }
            guard let component = units.value(for: unitText),
                  let offset = modifiers.value(for: modText) else { return nil }
            guard let comps = currentOrShiftedPeriod(component: component, offset: offset, context: context) else {
                return nil
            }
            return .components(comps)
        }

        guard let (durationText, direction) = durationAndDirection(match, modifiers) else { return nil }

        let clauses = DurationExpression.clauses(in: durationText, context)
        guard !clauses.isEmpty else { return nil }
        let duration = RelativeDuration(clauses, direction: direction)
        guard !duration.isEmpty else { return nil }

        let calendar = context.reference.calendar
        guard let target = duration.apply(to: context.reference.instant, calendar: calendar) else { return nil }

        var comps = context.createParsingComponents()
        comps.implyAll(from: target, calendar: calendar)
        return .components(comps)
    }

    /// Which counted branch matched, as its duration text plus the direction the
    /// surrounding words give it.
    private func durationAndDirection(
        _ match: TextMatch,
        _ modifiers: WordTable<Int>
    ) -> (String, RelativeDirection)? {
        if let text = match.string(named: "pdur") { return (text, .past) }
        if let text = match.string(named: "fdur") { return (text, .future) }
        if let text = match.string(named: "fpdur") { return (text, .future) }
        if let text = match.string(named: "sdur") {
            return (text, match.string(named: "sign") == "-" ? .past : .future)
        }
        if let text = match.string(named: "mpdur"), let modText = match.string(named: "mpmod") {
            // "this 2 weeks" is not an expression anyone writes, and offset zero
            // gives no direction to move in, so only a signed modifier counts.
            guard let offset = modifiers.value(for: modText), offset != 0 else { return nil }
            return (text, offset < 0 ? .past : .future)
        }
        return nil
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
    ///
    /// There is no chrono behaviour to be faithful to here, because chrono is
    /// internally inconsistent about it. Measured live against 2.10.1, reference
    /// Friday 2012-08-10:
    ///
    ///     chrono.parse("this week")        2012-08-05    rolled back to the week start
    ///     chrono.vi.parse("tuần này")      2012-08-17    identical to "tuần sau"
    ///
    /// Its VI locale reads "này" as +1, so in Vietnamese chrono cannot tell "this
    /// week" from "next week" at all. Khac already diverges there deliberately
    /// (KHAC-FIX: này = 0), which is what makes the unanchored week the only
    /// choice consistent with both locales rather than a dodge.
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

        let shift = RelativeDuration.shiftable(component, offset)
        guard let target = calendar.date(byAdding: shift.component, value: shift.value, to: context.reference.instant) else {
            return nil
        }
        comps.implyAll(from: target, calendar: calendar)
        return comps
    }
}
