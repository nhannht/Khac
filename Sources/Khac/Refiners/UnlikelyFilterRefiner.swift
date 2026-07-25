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
// Runs after the date-time merge and BEFORE the range merge, chrono's position.

import Foundation

struct UnlikelyFilterRefiner: Refiner {
    /// chrono's plain-number shape: digits with AT MOST one decimal point.
    /// Exactly one - "02.07.2013" has two and is a real dotted date, so it must
    /// survive this filter.
    private static let plainNumber = makeRegex("^[0-9]*(\\.[0-9]*)?$", options: [])

    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        results.filter { result in
            let condensed = result.text.filter { !$0.isWhitespace }
            let ns = condensed as NSString
            if ns.length > 0,
               Self.plainNumber.firstMatch(in: condensed, range: NSRange(location: 0, length: ns.length)) != nil {
                return false
            }
            guard isPlausible(result.start, context) else { return false }
            if let end = result.end, !isPlausible(end, context) {
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
        guard let year = c.get(.year), year > 0,
              let month = c.get(.month), let day = c.get(.day) else { return true }
        return isRealDate(year: year, month: month, day: day, calendar: context.reference.calendar)
    }
}
