// FIParsers.swift - bespoke Finnish grammar the data tables cannot express.
//
// "viime yönä" (last night) fuses a NONZERO relative modifier onto a
// time-of-day word, which CasualDateParser's generic anchor mechanism
// deliberately does not reach (it only pulls ZERO-valued "this"-style
// modifiers into its anchor table) - the same gap RU's/UK's own equivalent
// hits, see RUParsers.swift's header comment for the full account.
//
// Finnish's own threshold (hour > 6 rolls back) matches EN's OWN inline
// "last night" rule (ENParsers.swift) exactly, NOT RU/UK's shared
// casualReferences.lastNight (hour < 6). Oracle-confirmed: "viime yönä" at
// reference hour 14 (> 6) rolls back to the previous day, hour 0.

import Foundation

struct FICasualLastNightParser: Parser {
    static let overlapRank = 55

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(
            "(?<![\\p{L}\\p{N}_])viime\\s*yönä(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard context.options.mode != .strict else { return nil }

        let calendar = context.reference.calendar
        var target = context.reference.instant
        if (context.reference.brokenDown.hour ?? 0) > 6 {
            guard let shifted = calendar.date(byAdding: .day, value: -1, to: target) else { return nil }
            target = shifted
        }

        var comps = context.createParsingComponents()
        comps.assignDate(target, calendar: calendar)
        comps.imply(.hour, 0)
        return .components(comps)
    }
}
