// ISOParser.swift - locale-independent ISO-8601.
//
// Behavior mirrors chrono: YYYY-MM-DD with an optional Thh:mm[:ss[.SSS]] and an
// optional zone (Z or +hh:mm / -hh:mm / +hh). A trailing "Z" is offset 0; an
// explicit offset is stored in minutes with a signed minute part; no zone leaves
// timezoneOffset unset (resolved in the reference zone).

import Foundation

struct ISOParser: Parser {
    static let overlapRank = 10

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(
            "(?<![0-9])" +
            "(?<y>[0-9]{4})-(?<mo>[0-9]{1,2})-(?<d>[0-9]{1,2})" +
            "(?:T(?<h>[0-9]{1,2}):(?<mi>[0-9]{1,2})" +
                "(?::(?<s>[0-9]{1,2})(?:\\.(?<ms>[0-9]{1,4}))?)?" +
                "(?<tz>Z|(?<zsign>[+-][0-9]{2}):?(?<zmin>[0-9]{2})?)?" +
            ")?" +
            "(?![0-9])"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let year = match.int(named: "y"),
              let month = match.int(named: "mo"),
              let day = match.int(named: "d") else { return nil }
        // RANGE validation only, deliberately. Calendar validity is decided later,
        // at the RESULT level, by UnlikelyFilterRefiner - which is chrono's own
        // mechanism and the same ruling B2/B3 settled on.
        //
        // Rejecting an impossible date HERE looks stricter and is worse. A
        // rejected match consumes nothing, the engine resumes one character in,
        // and TimeExpressionParser then scavenges fragments out of the wreckage:
        // "2023-02-30T10:00:00" yielded "00:00" anchored to the REFERENCE day, so
        // asking about an impossible date got you today at midnight. Accepting the
        // span and letting the refiner drop the whole result leaves nothing behind
        // to scavenge.
        //
        // Month 0 is accepted DELIBERATELY, and the zero in that range is the whole
        // point. Accepting it produces a full-span result that SHADOWS the
        // fragments; UnlikelyFilterRefiner then drops it, since isRealDate already
        // requires (1...12). Declining it instead left no shadow, so
        // "2023-00-10T10:00:00" leaked "00-10" with a bogus -600 offset plus a
        // spurious "00:00". chrono's own lax ISO parser accepts month 00 for
        // exactly this reason.
        //
        // Month 13 must still fall through, so the upper bound stays: "2023-13-01"
        // has to reach NumericDateParser and read as 13 January, matching chrono
        // and pinned by the oracle.
        guard (0...12).contains(month), (1...31).contains(day) else { return nil }

        var c = context.createParsingComponents()
        c.certain(.year, year)
        c.certain(.month, month)
        c.certain(.day, day)

        if let hour = match.int(named: "h"), let minute = match.int(named: "mi") {
            c.certain(.hour, hour)
            c.certain(.minute, minute)
            if let second = match.int(named: "s") { c.certain(.second, second) }
            if let ms = match.int(named: "ms") { c.certain(.millisecond, ms) }

            if let tz = match.string(named: "tz"), !tz.isEmpty {
                if tz == "Z" || tz == "z" {
                    c.certain(.timezoneOffset, 0)
                } else if let sign = match.string(named: "zsign") {
                    let hourOffset = Int(sign) ?? 0
                    let minuteOffset = match.int(named: "zmin") ?? 0
                    var offset = hourOffset * 60
                    offset += hourOffset < 0 ? -minuteOffset : minuteOffset
                    // Same bounds ExtractTimezoneOffsetRefiner already applies, so
                    // the two paths stop disagreeing: a minute field is a minute
                    // field, and no real zone sits more than 14 hours from GMT.
                    // Out of bounds the offset is DROPPED and the rest of the
                    // timestamp kept - the date and clock are fine, only the zone
                    // is nonsense, and rejecting the match would reopen the
                    // scavenging hole the range check above just closed.
                    //
                    // Storing it was silently self-contradictory:
                    // TimeZone(secondsFromGMT:) returns nil past Foundation's
                    // 18-hour limit, so date() fell through to the reference zone
                    // while the component still reported a certain offset.
                    if minuteOffset < 60, abs(offset) <= 14 * 60 {
                        c.certain(.timezoneOffset, offset)
                    }
                }
            }
        }

        return .components(c)
    }
}
