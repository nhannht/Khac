// CasualDateParser.swift - today / tomorrow / yesterday, "now", and time-of-day.
//
// Three lexical categories, all data-driven from the locale:
//   - "now": the exact reference instant, every clock component certain.
//   - Day references ("today", "tomorrow", "yesterday"): reference plus an offset
//     of whole days, at the reference's own time of day (implySimilarTime).
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
        let timesOfDay = WordTable(vocab.timeOfDay).alternation
        let now = regexAlternation(context.locale.patterns.nowWords) ?? "(?!)"

        // Order matters: NSRegularExpression takes the first matching alternative
        // at a position, so the day-anchored time-of-day combo must precede the
        // bare day reference, which must precede the bare time of day.
        let body = [
            "(?<nowg>" + now + ")",
            "(?<anchor>" + anchors + ")\\s{0,3}(?<atod>" + timesOfDay + ")",
            "(?<dref>" + dayRefs + ")",
            "(?<btod>" + timesOfDay + ")",
        ].joined(separator: "|")

        return makeRegex(boundaryBefore + "(?:" + body + ")" + boundaryAfter)
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
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
