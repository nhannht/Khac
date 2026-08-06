// DEParsers.swift - bespoke German grammar the data tables cannot express.
//
// "letzte Nacht" (last night) resolves by RULE - which calendar day it means
// depends on the reference's own clock, exactly like EN's "last night" - so it
// cannot live in Vocabulary as a lookup. Mirrors ENCasualCompoundParser.swift
// exactly: same idiom, same threshold (source-verified against chrono's
// DECasualDateParser.ts, `targetDate.getHours() > 6`), same escape hatch.
//
// This is the SPEC's additionalParsers escape hatch used as intended: bespoke
// grammar for one locale, everything else still data-driven.

import Foundation

/// "letzte Nacht": hour 0, rolled back a day only when the reference's own
/// clock is past 6 AM - at 1 AM, "letzte Nacht" is still tonight.
struct DECasualCompoundParser: Parser {
    static let overlapRank = 55

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(
            "(?<![\\p{L}\\p{N}_])letzte\\s*nacht(?=[^\\p{L}\\p{N}_]|$)"
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
