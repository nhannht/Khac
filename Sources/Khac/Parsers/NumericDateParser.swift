// NumericDateParser.swift - numeric dates like 8/10/2012, 04/2016, 2016/04/07.
//
// The order of the first two fields follows the locale's dateOrder (.monthDay
// for en, .dayMonth for most others). A 4-digit leading field is read as a
// year-first date regardless of order. A 2-field form with a 4-digit second
// field is a month/year. Two-digit years expand the way chrono does.

import Foundation

struct NumericDateParser: Parser {
    static let overlapRank = 20

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        // Same separator on both sides (backreference), so "8/10-2012" is rejected.
        // `b` allows 4 digits so a two-field month/year ("04/2016") can match at
        // all; in the three-field form the greedy run still stops at the next
        // separator, so "8/10/2012" keeps b = "10".
        //
        // The boundary lookarounds also refuse a digit-slash on either flank,
        // chrono's SlashDateFormatParser guard: in "4/13/1" neither "4/13"
        // (followed by /1) nor "13/1" (preceded by 4/) is a date - the whole
        // token is a version number.
        makeRegex(
            "(?<![0-9])(?<![0-9]/)" +
            "(?<a>[0-9]{1,4})(?<sep>[/.\\- ])(?<b>[0-9]{1,4})" +
            "(?:\\k<sep>(?<c>[0-9]{1,4}))?" +
            "(?![0-9])(?!/[0-9])"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let a = match.int(named: "a"), let b = match.int(named: "b") else { return nil }
        let aText = match.string(named: "a") ?? ""
        let bText = match.string(named: "b") ?? ""
        let cText = match.string(named: "c")

        // A "." separator is only a date when a 4-digit year is present
        // ("02.07.2013", "2014.12.28"). Otherwise it is a decimal or version
        // number ("6.5 kilograms", "1.1.3"), never a date.
        //
        // That reasoning depends on the locale writing decimals with a period,
        // which is not universal. German writes them with a comma and dots dates as
        // "30.12.16", where there is nothing to be ambiguous WITH - so the guard
        // was refusing that locale's standard numeric date to protect against a
        // collision it does not have. A locale whose decimal mark is not the period
        // opts out via `options.dotIsUnambiguousDateSeparator`; every other locale
        // keeps the 4-digit-year requirement exactly.
        let separator = match.string(named: "sep")
        if separator == ".", !context.locale.options.dotIsUnambiguousDateSeparator {
            let hasFourDigitYear = aText.count == 4 || bText.count == 4 || cText?.count == 4
            if !hasFourDigitYear { return nil }
        }
        // A "-" needs all three fields: "12-30-16" and "2024-13-01" are dates,
        // but a two-field "7-8" is a plain number range (chrono only accepts a
        // yearless two-field form with a slash).
        if separator == "-", cText == nil { return nil }
        // A space separator is the year-first form ONLY: "2014 12 28". Any
        // other spaced number pair is prose.
        if separator == " ", aText.count != 4 || cText == nil { return nil }

        var year: Int?
        var month: Int
        var day: Int?

        if let c = match.int(named: "c") {
            // Three fields.
            if aText.count == 4 || a > 31 {
                // Year-first: YYYY/MM/DD. Here `c` is the DAY, so it carries no
                // digit-count rule - only a year field does. This is the ONE
                // branch where strict mode refuses the month/day swap
                // (chrono's ENYearMonthDayParser strictMonthDateOrder); the
                // plain slash/dash forms below swap in both modes.
                guard let resolved = resolvedMonthDay(month: b, day: c, strictRefusesSwap: true, context) else { return nil }
                year = a
                month = resolved.month
                day = resolved.day
            } else {
                // A slash-date's YEAR field is exactly 2 or 4 digits in chrono
                // ("4/13/1" is not a date). This is a rule about the year, which
                // is why it lives here and not in the pattern: in the year-first
                // branch above the same group holds a day.
                guard let cText = cText, cText.count == 2 || cText.count == 4 else { return nil }
                let ordered = orderedMonthDay(first: a, second: b, context)
                guard let resolved = resolvedMonthDay(month: ordered.month, day: ordered.day, context) else { return nil }
                month = resolved.month
                day = resolved.day
                year = expandYear(c)
            }
        } else {
            // Two fields.
            if bText.count == 4 {
                // Month/year.
                month = a
                year = b
                day = nil
            } else {
                // Day/month (or month/day) with the year left implied.
                let ordered = orderedMonthDay(first: a, second: b, context)
                guard let resolved = resolvedMonthDay(month: ordered.month, day: ordered.day, context) else { return nil }
                month = resolved.month
                day = resolved.day
                year = nil
            }
        }

        guard (1...12).contains(month) else { return nil }
        if let day = day {
            guard (1...31).contains(day) else { return nil }
            // Reject impossible days (06/31, non-leap 02/29) when the year is known.
            if let year = year, !isRealDate(year: year, month: month, day: day, calendar: context.reference.calendar) {
                return nil
            }
        }

        var comps = context.createParsingComponents()
        comps.certain(.month, month)
        if let day = day {
            comps.certain(.day, day)
        } else {
            comps.imply(.day, 1)
        }
        if let year = year {
            comps.certain(.year, year)
        } else if let day = day {
            // No year stated: the nearest one, as chrono's SlashDateFormatParser
            // does via findYearClosestToRef - "5/31" in December 1999 is May of
            // the COMING year, not the ref year's own past May.
            comps.imply(.year, yearClosestToReference(month: month, day: day, context: context))
        }
        return .components(comps)
    }

    /// Assign two numeric fields to month and day per the locale's declared order.
    private func orderedMonthDay(first: Int, second: Int, _ context: ParsingContext) -> (month: Int, day: Int) {
        switch context.locale.options.dateOrder {
        case .monthDay: return (month: first, day: second)
        case .dayMonth: return (month: second, day: first)
        }
    }

    /// chrono's ambiguity rule: when the field the order assigned to the month
    /// cannot BE a month but the other one can, the two swap - "14/4" is the 14th
    /// of April even in a month-first locale, because there is no 14th month.
    ///
    /// Only the year-first form refuses the swap in strict mode (chrono's
    /// ENYearMonthDayParser strictMonthDateOrder), which is why "2024-13-01" is
    /// casual-only while a strict "30-12-16" still reads as December 30th -
    /// chrono's SlashDateFormatParser swaps unconditionally.
    private func resolvedMonthDay(
        month: Int, day: Int, strictRefusesSwap: Bool = false, _ context: ParsingContext
    ) -> (month: Int, day: Int)? {
        if (1...12).contains(month) { return (month, day) }
        if strictRefusesSwap, context.options.mode == .strict { return nil }
        guard (1...12).contains(day) else { return nil }
        return (month: day, day: month)
    }

    /// Expand a two-digit year the way chrono does: <100 becomes 19xx when > 50,
    /// else 20xx. Four-digit years pass through.
    private func expandYear(_ year: Int) -> Int {
        guard year < 100 else { return year }
        return year + (year > 50 ? 1900 : 2000)
    }
}
