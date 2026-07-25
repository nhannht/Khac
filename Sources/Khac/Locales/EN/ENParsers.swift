// ENParsers.swift - bespoke English grammar the data tables cannot express.
//
// Two words resolve by RULE, not lookup, so they cannot live in Vocabulary:
//   - "weekend"/"weekday": which day they mean depends on the modifier and on
//     the reference's own position in the week (ENWeekdayParser.ts).
//   - "last night": hour 0 of a day that depends on the reference's clock -
//     before ~6 AM "last night" is still the current calendar day
//     (ENCasualDateParser.ts's inline rule; note its convention differs from
//     casualReferences.lastNight - the parser's own branch is what the oracle
//     tests, so that is what is ported).
//
// Both are casual expressions and reject strict mode, like their generic
// cousins. This is the SPEC's additionalParsers escape hatch used as intended:
// bespoke grammar for one locale, everything else still data-driven.

import Foundation

/// "this weekend", "next weekday", "on the weekend" - weekend/weekday words
/// with an optional this/last/past/next modifier.
struct ENWeekendParser: Parser {
    static let overlapRank = 45

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let modifiers = WordTable(context.locale.vocabulary.relativeModifiers).alternation
        return makeRegex(
            "(?<![\\p{L}\\p{N}_])" +
            "(?:on\\s+)?" +
            "(?:(?<mod>" + modifiers + ")\\s+)?" +
            "(?<word>weekend|weekday)" +
            // chrono carries the modifier in BOTH positions for these words, in
            // the same parser that serves ordinary weekdays. Khac splits that
            // parser, and the split dropped this half.
            weekPostfixModifierGroup(context) +
            "(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard context.options.mode != .strict else { return nil }
        guard let word = match.string(named: "word")?.lowercased() else { return nil }

        // Prefix first, then postfix - chrono's `prefix || postfix`. They cannot
        // both bind in practice, since a modifier consumed as the prefix is not
        // available to the postfix slot.
        var offset: Int? = nil
        if let modText = match.string(named: "mod") ?? match.string(named: "post"),
           let value = WordTable(context.locale.vocabulary.relativeModifiers).value(for: modText) {
            offset = value
        }
        let modifier: Weekday.Modifier? = offset.map { $0 == 0 ? .this_ : ($0 > 0 ? .next : .last) }

        let refWeekday = Weekday.chrono(fromFoundation: context.reference.brokenDown.weekday ?? 1)
        let target: Int
        if word == "weekend" {
            // "This/next weekend" is the coming Saturday; "last weekend" the
            // previous Sunday.
            target = modifier == .last ? Weekday.sunday : Weekday.saturday
        } else {
            // "weekday" walks one BUSINESS day, not one modular week position:
            // from a Friday, "last weekday" is Thursday, "next weekday" Monday.
            // On a weekend reference it snaps to the adjacent working day.
            if refWeekday == Weekday.sunday || refWeekday == Weekday.saturday {
                target = modifier == .last ? 5 : 1
            } else {
                var w = refWeekday - 1
                w = modifier == .last ? w - 1 : w + 1
                // Swift's % keeps the sign like JS, reproducing chrono's own
                // arithmetic exactly, edge behavior included.
                target = (w % 5) + 1
            }
        }

        let days = Weekday.daysToWeekday(refWeekday: refWeekday, target: target, modifier: modifier)
        let calendar = context.reference.calendar
        guard let date = calendar.date(byAdding: .day, value: days, to: context.reference.instant) else {
            return nil
        }

        var comps = context.createParsingComponents()
        comps.implyDate(date, calendar: calendar)
        comps.certain(.weekday, target)
        return .components(comps)
    }
}

/// "last night": hour 0, rolled back a day only when the reference's own clock
/// is past 6 AM - at 1 AM, "last night" is still tonight.
struct ENCasualCompoundParser: Parser {
    static let overlapRank = 55

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(
            "(?<![\\p{L}\\p{N}_])last\\s*night(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard context.options.mode != .strict else { return nil }

        let calendar = context.reference.calendar
        var target = context.reference.instant
        if (context.reference.brokenDown.hour ?? 0) > 6 {
            guard let previous = calendar.date(byAdding: .day, value: -1, to: target) else { return nil }
            target = previous
        }

        var comps = context.createParsingComponents()
        comps.assignDate(target, calendar: calendar)
        comps.imply(.hour, 0)
        return .components(comps)
    }
}
