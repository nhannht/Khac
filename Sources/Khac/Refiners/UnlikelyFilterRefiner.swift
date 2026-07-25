// UnlikelyFilterRefiner.swift - drop results that cannot really be dates.
//
// chrono's generic UnlikelyFormatFilter, two rules:
//   1. A result whose text is nothing but digits (optionally with a decimal
//      point or spaces) is a plain number. The time parser deliberately accepts
//      bare numeric hours so "-5d 00" can merge; whatever did NOT merge into a
//      larger expression by this point is filtered here.
//   2. A result that names an impossible instant - February 29 in a non-leap
//      year, June 31, an hour past 23 - is dropped whole, end included. This is
//      what makes "June 10 - 31, 2022" produce nothing rather than a rolled-over
//      July 1.
//
// Plus one of ours, the same shape as rule 1:
//   3. A leftover day-shift suffix. CasualDateParser matches VI "mai" on its own
//      so the date-time merge can attach it to the time of day before it; one
//      that reaches here attached to nothing, and a bare shift word is not a
//      date. "mai" alone is a given name and an apricot blossom, which is the
//      whole reason the parser gates it on a preceding time of day.
//
// Runs after the date-time merge and BEFORE the range merge, chrono's position.

import Foundation

struct UnlikelyFilterRefiner: Refiner {
    /// chrono's plain-number shape: digits with AT MOST one decimal point.
    /// Exactly one - "02.07.2013" has two and is a real dotted date, so it must
    /// survive this filter.
    private static let plainNumber = makeRegex("^[0-9]*(\\.[0-9]*)?$", options: [])

    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        // Built once per pass, not per result. Empty for every locale without the
        // pattern, which makes the rule below a no-op there.
        let dayShift = WordTable(context.locale.vocabulary.dayShiftSuffixes)

        return results.filter { result in
            // chrono removes only the FIRST space before testing - literally
            // `text.replace(" ", "")` - and that quirk is load-bearing: the
            // space-separated "2014 12 28" still holds a space afterwards and
            // survives, while a lone "00" or "12 28" is condemned. Replicate
            // it exactly.
            var condensed = result.text
            if let firstSpace = condensed.firstIndex(of: " ") {
                condensed.remove(at: firstSpace)
            }
            let ns = condensed as NSString
            if ns.length > 0,
               Self.plainNumber.firstMatch(in: condensed, range: NSRange(location: 0, length: ns.length)) != nil {
                return false
            }
            // A result that is nothing but a day-shift word never found the time
            // of day it modifies. Emitting it would answer with a confident
            // "tomorrow" the writer never wrote as a date on its own - the exact
            // reading testBareMaiIsNotADate exists to forbid. normalizedText,
            // not text, because this re-reads a result through NFC-folded
            // vocabulary.
            if !dayShift.isEmpty, dayShift.value(for: result.normalizedText) != nil {
                return false
            }
            guard isPlausible(result.start, context) else { return false }
            if let end = result.end, !isPlausible(end, context) {
                return false
            }
            // Strict mode refuses a result that never got past a bare weekday.
            // The parser itself must NOT reject it (chrono doesn't): "Friday
            // 12-30-16" needs the weekday to exist long enough to merge, and
            // only the still-unmerged leftover is dropped here.
            if context.options.mode == .strict, result.start.isOnlyWeekdayComponent {
                return false
            }
            return true
        }
    }

    /// The components name a representable instant. Only the common era is
    /// checked: Foundation models BC years as a separate era, so a negative year
    /// cannot round-trip through the calendar and would always read as invalid.
    private func isPlausible(_ c: ParsingComponents, _ context: ParsingContext) -> Bool {
        if let hour = c.get(.hour), !(0...23).contains(hour) { return false }
        if let minute = c.get(.minute), !(0...59).contains(minute) { return false }
        // Deliberately NOT checked here: an out-of-range timezone offset. It is
        // dropped at the point it is read, keeping the timestamp, because a date
        // and clock stay perfectly good when only the zone is junk.
        // ExtractTimezoneOffsetRefiner already worked that way, so rejecting the
        // whole result here would have made the two paths disagree.
        guard let year = c.get(.year), year > 0,
              let month = c.get(.month), let day = c.get(.day) else { return true }
        return isRealDate(year: year, month: month, day: day, calendar: context.reference.calendar)
    }
}
