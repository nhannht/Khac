// WeekdayParser.swift - "Monday", "on Friday next week", "last Tuesday".
//
// Weekday numbering is chrono/JS (0 = Sunday). The day offset follows chrono's
// getDaysToWeekday exactly (this = forward, last = backward, next has the
// Sunday/Saturday special cases, bare = nearest). The resolved date is implied
// (chrono's addDurationAsImplied) with the weekday itself certain.

import Foundation

struct WeekdayParser: Parser {
    static let overlapRank = 40

    private let boundaryBefore = "(?<![\\p{L}\\p{N}_])"

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let vocab = context.locale.vocabulary
        let weekdays = WordTable(vocab.weekdays).alternation
        let modifiers = WordTable(vocab.relativeModifiers).alternation
        let weekWords = weekWordAlternation(context) ?? "week"
        let prefix = regexAlternation(context.locale.patterns.weekdayPrefixWords)

        let prefixGroup = prefix.map { "(?:" + $0 + "\\s+)?" } ?? ""

        // Third modifier position: a modifier suffixed directly to the weekday,
        // no week-word ("thứ hai tới"). Only when the locale enables it, so
        // prefix-style locales (English) are unchanged.
        //
        // The exclusion guard sits INSIDE the optional group, which is what makes
        // it degrade correctly: Vietnamese "sau khi" is the conjunction "after
        // [clause]", not the modifier "sau" (next) followed by an unrelated word,
        // so "thứ hai sau khi chiến tranh kết thúc" must match "thứ hai" alone.
        // With the lookahead inside, a failed guard collapses the whole optional
        // group to zero-width and the bare weekday still matches; placing it
        // after the group would instead reject the weekday outright.
        let suffixExclusion = regexAlternation(context.locale.patterns.weekdaySuffixExclusionWords)
            .map { "(?!\\s+" + $0 + "(?![\\p{L}\\p{N}_]))" } ?? ""
        let suffixGroup = context.locale.options.weekdaySuffixModifier
            ? "(?:\\s+(?<suffix>" + modifiers + ")" + suffixExclusion + ")?"
            : ""

        return makeRegex(
            boundaryBefore +
            prefixGroup +
            "(?:(?<pre>" + modifiers + ")\\s+)?" +
            "(?<wd>" + weekdays + ")" +
            "(?:\\s*,)?" +
            "(?:\\s*(?:of\\s+)?(?<post>" + modifiers + ")\\s+" + weekWords + ")?" +
            suffixGroup +
            "(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let vocab = context.locale.vocabulary
        let weekdays = WordTable(vocab.weekdays)
        guard let target = weekdays.value(for: match.string(named: "wd") ?? "") else { return nil }

        // A bare weekday names no calendar date on its own, so strict mode
        // rejects it, matching the other parsers' gate.
        guard context.options.mode != .strict else { return nil }

        let modifiers = WordTable(vocab.relativeModifiers)
        var modifier: Weekday.Modifier? = nil
        if let text = match.string(named: "pre") ?? match.string(named: "post") ?? match.string(named: "suffix"),
           let value = modifiers.value(for: text) {
            modifier = value == 0 ? .this_ : (value > 0 ? .next : .last)
        }

        let refWeekday = Weekday.chrono(fromFoundation: context.reference.brokenDown.weekday ?? 1)
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

    /// Alternation of the locale's words for a week (timeUnits mapped to
    /// .weekOfYear), used by the "... next week" postfix.
    private func weekWordAlternation(_ context: ParsingContext) -> String? {
        let words = context.locale.vocabulary.timeUnits
            .filter { $0.value == .weekOfYear }
            .map { $0.key }
        return regexAlternation(words)
    }
}
