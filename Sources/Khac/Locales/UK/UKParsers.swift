// UKParsers.swift - bespoke Ukrainian grammar the data tables cannot express.
//
// Same gap, same fix shape as RU's RUParsers.swift (see its header comment for
// the full account): "минулого вечора" (yesterday evening) and "минулої ночі"
// (last night) fuse a NONZERO relative modifier onto a time-of-day word, which
// CasualDateParser's generic anchor mechanism deliberately does not reach.
//
// Both phrases read chrono's shared casualReferences.ts functions as-is
// (yesterdayEvening/lastNight) - confirmed against the oracle exactly the way
// RU's own two cases were: "минулої ночі" at reference hour 8 keeps today's
// date (no rollback), the SAME input at reference hour 2 rolls back a day.

import Foundation

struct UKCasualNightEveningParser: Parser {
    static let overlapRank = 55

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(
            "(?<![\\p{L}\\p{N}_])" +
            "(?:(?<evening>минулого\\s*вечора)|(?<night>минулої\\s*ночі))" +
            "(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard context.options.mode != .strict else { return nil }

        let calendar = context.reference.calendar
        var comps = context.createParsingComponents()

        // yesterdayEvening(): a FLAT -1 day, hour 20 pm, every time.
        if match.string(named: "evening") != nil {
            guard let target = calendar.date(byAdding: .day, value: -1, to: context.reference.instant) else {
                return nil
            }
            comps.assignDate(target, calendar: calendar)
            comps.imply(.hour, 20)
            comps.imply(.meridiem, Meridiem.pm.rawValue)
            return .components(comps)
        }

        // lastNight(): rolls back a day only when the reference's own clock
        // hour is before 6 AM - the same threshold as RU's identical
        // casualReferences.lastNight call.
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
