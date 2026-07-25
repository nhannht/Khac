// CasualDateParser.swift - today / tomorrow / yesterday, "now", and time-of-day.
//
// Four lexical categories, all data-driven from the locale:
//   - "now": the exact reference instant, every clock component certain.
//   - Day references ("today", "tomorrow", "yesterday"): reference plus an offset
//     of whole days, at the reference's own time of day (implySimilarTime).
//   - Day-shift suffixes (VI "mai" in "sáng mai"): the same day reference written
//     after a time of day. A separate match gated on a lookbehind, resolving to a
//     certain calendar date and no clock, so the date-time merge can join it to
//     whichever result claimed the time of day.
//   - Times of day ("morning", "noon", "midnight", "tonight"): a clock time from
//     vocabulary.timeOfDay, optionally anchored to a day ("yesterday afternoon",
//     "this morning"). Morning/afternoon/evening imply their hour (a following
//     explicit time can override it); noon and midnight set it certainly, which
//     also lets the date-time merge attach them ("Tomorrow at noon"). Midnight
//     rolls to the coming day when the reference is past very early morning.
//
// Mirrors chrono's ENCasualDateParser + ENCasualTimeParser + casualReferences.
// The idiom "last night" (yesterday at hour 0, not the midnight roll) and the
// merge of a casual time with a following explicit time ("tonight 8pm") are not
// handled here; they are documented deferrals.

import Foundation

struct CasualDateParser: Parser {
    static let overlapRank = 50

    /// Boundary that does not cut inside a letter/number run (Unicode-aware).
    private let boundaryBefore = "(?<![\\p{L}\\p{N}_])"
    private let boundaryAfter = "(?![\\p{L}\\p{N}_])"

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let vocab = context.locale.vocabulary
        let dayRefs = WordTable(vocab.dayReferences).alternation
        let anchors = WordTable(anchorOffsets(context)).alternation
        // An optional particle before the time-of-day word ("buổi sáng"), part of
        // the token itself so the match covers it and an anchored phrase stays
        // one result. Empty for locales without one.
        let todPrefix = regexAlternation(context.locale.patterns.timeOfDayPrefixWords)
            .map { "(?:" + $0 + "\\s{0,3})?" } ?? ""
        let timesOfDay = WordTable(vocab.timeOfDay).alternation
        let now = regexAlternation(context.locale.patterns.nowWords) ?? "(?!)"
        // A day-shift word is the locale's day reference in SUFFIX position:
        // Vietnamese "sáng mai" is "sáng" (the clock) plus "mai" (the day). It
        // matches ON ITS OWN, behind a LOOKBEHIND for the time-of-day word, and
        // resolves to exactly what "ngày mai" resolves to - a certain calendar
        // date, no clock. MergeDateTimeRefiner then joins the two halves, which
        // is the same path "7 giờ sáng ngày mai" already takes.
        //
        // The lookbehind is what makes this work, and consuming the time-of-day
        // word into this match is what broke it. "7 giờ sáng mai" holds ONE time
        // of day, and TimeExpressionParser needs it to read the hour 7. While the
        // shift was a suffix of this parser's own time-of-day branch, both parsers
        // claimed "sáng" and the overlap filter had to kill one of them: a "sáng
        // mai" carrying three derived certains (year, month, day - none of them
        // written by anyone) outranked a "7 giờ sáng" carrying two STATED ones,
        // and the stated hour lost. Reading the word without consuming it leaves
        // it to whichever parser actually claims it, and the two results stop
        // competing for a span they never disagreed about.
        //
        // The gate is DIRECT adjacency to a time-of-day word, and the word is
        // matched CASE-SENSITIVELY via ICU's scoped (?-i:) against this pattern's
        // otherwise case-insensitive matching.
        //
        // Adjacency alone is not enough, because the position right after a fronted
        // time adverbial is exactly where a SUBJECT sits in ordinary Vietnamese:
        // "chiều Mai đến" (Mai arrives in the afternoon) has the same shape as
        // "chiều mai đến" (arriving tomorrow afternoon) and differs only in the
        // capital. Vietnamese capitalizes proper nouns and never capitalizes this
        // suffix mid-sentence, so case is the only signal that separates them -
        // review-vi looked for a syntactic one and reported a negative result,
        // since pro-drop lets the temporal reading omit its subject too.
        //
        // The limitation this leaves is deliberate and was chosen explicitly: in
        // all-lowercase text the two readings are genuinely ambiguous to a native
        // reader as well, and there a stated date wins. That direction is the one
        // this codebase takes every time - a loud miss beats a quiet wrong answer.
        let dayShift = WordTable(vocab.dayShiftSuffixes)

        // Order matters: NSRegularExpression takes the first matching alternative
        // at a position, so the day-anchored time-of-day combo must precede the
        // bare day reference, which must precede the bare time of day.
        // The prefix sits OUTSIDE the capture group: it is consumed into the
        // match span, but the group must hold only the time-of-day word itself,
        // since that is what gets looked up in the vocabulary.
        //
        // The shift alternative goes LAST, and its position is the one here that
        // does not matter: its lookbehind only holds at a spot no other
        // alternative can start at, since a shift word is in no other table.
        // Last is simply where an optional, locale-dependent branch belongs.
        var alternatives = [
            "(?<nowg>" + now + ")",
            "(?<anchor>" + anchors + ")\\s{0,3}" + todPrefix + "(?<atod>" + timesOfDay + ")",
            "(?<dref>" + dayRefs + ")",
            todPrefix + "(?<btod>" + timesOfDay + ")",
        ]
        if !dayShift.isEmpty {
            alternatives.append(
                "(?<=" + timesOfDay + "\\s{1,3})(?<dshift>(?-i:" + dayShift.alternation + "))"
            )
        }

        return makeRegex(boundaryBefore + "(?:" + alternatives.joined(separator: "|") + ")" + boundaryAfter)
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        // Strict mode wants complete, explicit dates. Every word this parser
        // knows is casual by definition, so none of them survive it. Same gate
        // TimeExpressionParser and MonthNameParser already apply.
        guard context.options.mode != .strict else { return nil }

        var comps = context.createParsingComponents()

        // "now": full precision, all certain.
        if match.string(named: "nowg") != nil {
            let c = context.reference.brokenDown
            comps.certain(.year, c.year ?? 0)
            comps.certain(.month, c.month ?? 0)
            comps.certain(.day, c.day ?? 0)
            comps.certain(.hour, c.hour ?? 0)
            comps.certain(.minute, c.minute ?? 0)
            comps.certain(.second, c.second ?? 0)
            comps.certain(.millisecond, ParsingComponents.milliseconds(fromNanoseconds: c.nanosecond ?? 0))
            return .components(comps)
        }

        let calendar = context.reference.calendar

        // Day-anchored time of day: "yesterday afternoon", "this morning".
        if let anchorText = match.string(named: "anchor"),
           let todText = match.string(named: "atod") {
            let offset = WordTable(anchorOffsets(context)).value(for: anchorText) ?? 0
            guard let target = calendar.date(byAdding: .day, value: offset, to: context.reference.instant) else {
                return nil
            }
            comps.assignDate(target, calendar: calendar)
            applyTimeOfDay(todText, to: &comps, context: context, allowDayRoll: false)
            return .components(comps)
        }

        // Bare day reference: "today", "tomorrow", "yesterday".
        if let drefText = match.string(named: "dref") {
            guard let offset = WordTable(context.locale.vocabulary.dayReferences).value(for: drefText) else {
                return nil
            }
            guard let target = calendar.date(byAdding: .day, value: offset, to: context.reference.instant) else {
                return nil
            }
            comps.assignDate(target, calendar: calendar)
            comps.implySimilarTime(to: context.reference)
            return .components(comps)
        }

        // Day-shift suffix: the same day reference as the branch above, written
        // after a time of day ("sáng mai" = tomorrow morning). It supplies the DAY
        // and nothing else - the time-of-day word supplies the clock through its
        // own match, and the date-time merge puts the two together.
        //
        // The midnight roll needs no suppressing here, unlike when this was a
        // suffix of the branch below. "nửa đêm" still rolls to the coming day on
        // its own, but that roll is IMPLIED, and the merge takes its calendar date
        // from this side, where the day is certain. A stated day replaces a guessed
        // one rather than stacking on top of it.
        if let shiftText = match.string(named: "dshift") {
            guard let offset = WordTable(context.locale.vocabulary.dayShiftSuffixes).value(for: shiftText),
                  let target = calendar.date(byAdding: .day, value: offset, to: context.reference.instant) else {
                return nil
            }
            comps.assignDate(target, calendar: calendar)
            comps.implySimilarTime(to: context.reference)
            return .components(comps)
        }

        // Bare time of day: "morning", "noon", "midnight", "tonight".
        if let btodText = match.string(named: "btod") {
            applyTimeOfDay(btodText, to: &comps, context: context, allowDayRoll: true)
            return .components(comps)
        }

        return nil
    }

    /// Apply a time-of-day word's clock time. Midnight (hour 0) and noon (hour 12)
    /// are set certainly; other times are implied so a following explicit time can
    /// override them. Midnight rolls to the coming day when `allowDayRoll` is set
    /// and the reference is past 2 AM (chrono's "coming midnight" rule).
    private func applyTimeOfDay(
        _ word: String,
        to comps: inout ParsingComponents,
        context: ParsingContext,
        allowDayRoll: Bool
    ) {
        guard let entry = WordTable(context.locale.vocabulary.timeOfDay).value(for: word) else { return }
        let hour = entry.hour

        if hour == 0 {
            comps.certain(.hour, 0)
            if allowDayRoll, (context.reference.brokenDown.hour ?? 0) > 2 {
                let calendar = context.reference.calendar
                if let target = calendar.date(byAdding: .day, value: 1, to: context.reference.instant) {
                    comps.implyDate(target, calendar: calendar)
                }
            }
        } else if hour == 12 {
            comps.certain(.hour, 12)
        } else {
            comps.imply(.hour, hour)
        }

        if let meridiem = entry.meridiem {
            comps.imply(.meridiem, meridiem.rawValue)
        }
        comps.imply(.minute, 0)
        comps.imply(.second, 0)
        comps.imply(.millisecond, 0)
    }

    /// Day anchors usable before a time of day: the locale's day references plus
    /// any relative modifier meaning "this" (offset 0), e.g. "this morning".
    private func anchorOffsets(_ context: ParsingContext) -> [String: Int] {
        var offsets = context.locale.vocabulary.dayReferences
        for (word, value) in context.locale.vocabulary.relativeModifiers where value == 0 {
            offsets[word] = 0
        }
        return offsets
    }
}
