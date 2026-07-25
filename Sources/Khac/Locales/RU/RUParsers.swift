// RUParsers.swift - bespoke Russian grammar the data tables cannot express.
//
// Two casual compound phrases resolve by RULE, not lookup, so they cannot live
// in Vocabulary: "прошлым вечером" (yesterday evening) and "прошлой ночью"
// (last night). Both are a NONZERO relative modifier ("last") fused directly
// onto a time-of-day word, which CasualDateParser's generic anchor mechanism
// deliberately does not reach - it only pulls ZERO-valued ("this") modifiers
// into its anchor table (see the comment on `anchorOffsets` in
// CasualDateParser.swift). This is the exact same gap EN's own "last night"
// hit, and the fix is the same shape: EN's ENCasualCompoundParser precedent,
// a small hardcoded parser for a closed set of phrases, everything else still
// data-driven.
//
// Both phrases are read directly from chrono's shared casualReferences.ts
// (yesterdayEvening/lastNight), NOT from RUCasualTimeParser.ts's own inline
// code, because that IS what those two functions are - RU calls them as-is,
// unlike EN which diverges from casualReferences.lastNight with its own
// different threshold (see ENParsers.swift's comment on that divergence).
// Confirmed against the oracle: "прошлой ночью" at reference hour 8 keeps
// today's date (no rollback); the SAME input at reference hour 2 rolls back a
// day - the opposite threshold direction from EN's inline rule, which is
// exactly casualReferences.lastNight's own "hour < 6" rule, not EN's "hour > 6".

import Foundation

struct RUCasualNightEveningParser: Parser {
    static let overlapRank = 55

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(
            "(?<![\\p{L}\\p{N}_])" +
            "(?:(?<evening>прошлым\\s*вечером)|(?<night>прошлой\\s*ночью))" +
            "(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard context.options.mode != .strict else { return nil }

        let calendar = context.reference.calendar
        var comps = context.createParsingComponents()

        // yesterdayEvening(): a FLAT -1 day, hour 20 pm, every time - no
        // reference-hour threshold at all (casualReferences.ts).
        if match.string(named: "evening") != nil {
            guard let target = calendar.date(byAdding: .day, value: -1, to: context.reference.instant) else {
                return nil
            }
            comps.assignDate(target, calendar: calendar)
            comps.imply(.hour, 20)
            comps.imply(.meridiem, Meridiem.pm.rawValue)
            return .components(comps)
        }

        // lastNight(): rolls back a day only when the reference's OWN clock
        // hour is before 6 AM - at 8 AM "last night" is still hour 0 of TODAY
        // (the night that just ended), at 2 AM it is still hour 0 of
        // YESTERDAY (the night has not ended yet). Oracle-confirmed both ways.
        if match.string(named: "night") != nil {
            var target = context.reference.instant
            if (context.reference.brokenDown.hour ?? 0) < 6 {
                guard let shifted = calendar.date(byAdding: .day, value: -1, to: target) else { return nil }
                target = shifted
            }
            comps.assignDate(target, calendar: calendar)
            // chrono's own casualReferences.lastNight uses imply, not assign -
            // the hour is inferred from the word, never a stated digit.
            comps.imply(.hour, 0)
            return .components(comps)
        }

        return nil
    }
}
