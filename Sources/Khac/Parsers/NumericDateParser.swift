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
        makeRegex(
            "(?<![0-9])" +
            "(?<a>[0-9]{1,4})(?<sep>[/.])(?<b>[0-9]{1,2})" +
            "(?:\\k<sep>(?<c>[0-9]{1,4}))?" +
            "(?![0-9])"
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
        if match.string(named: "sep") == "." {
            let hasFourDigitYear = aText.count == 4 || bText.count == 4 || cText?.count == 4
            if !hasFourDigitYear { return nil }
        }

        var year: Int?
        var month: Int
        var day: Int?

        if let c = match.int(named: "c") {
            // Three fields.
            if aText.count == 4 || a > 31 {
                // Year-first: YYYY/MM/DD.
                year = a
                month = b
                day = c
            } else {
                switch context.locale.options.dateOrder {
                case .monthDay:
                    month = a
                    day = b
                case .dayMonth:
                    day = a
                    month = b
                }
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
                switch context.locale.options.dateOrder {
                case .monthDay:
                    month = a
                    day = b
                case .dayMonth:
                    day = a
                    month = b
                }
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
        }
        return .components(comps)
    }

    /// Expand a two-digit year the way chrono does: <100 becomes 19xx when > 50,
    /// else 20xx. Four-digit years pass through.
    private func expandYear(_ year: Int) -> Int {
        guard year < 100 else { return year }
        return year + (year > 50 ? 1900 : 2000)
    }
}
