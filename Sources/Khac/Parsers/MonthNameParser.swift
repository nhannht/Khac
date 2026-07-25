// MonthNameParser.swift - dates with a spelled-out month, either order.
//
// A named month is unambiguous, so both "10 August 2012" (little-endian) and
// "August 10, 2012" (middle-endian) are accepted regardless of the locale's
// numeric dateOrder. An explicit year (with an optional era marker) is certain;
// otherwise the year closest to the reference is implied.

import Foundation

struct MonthNameParser: Parser {
    static let overlapRank = 30

    private let boundaryBefore = "(?<![\\p{L}\\p{N}_])"

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let vocab = context.locale.vocabulary
        let months = WordTable(vocab.months).alternation
        let era = WordTable(vocab.eraMarkers).alternation
        let ordinalSuffix = "(?:st|nd|rd|th)?"
        let day = "[0-9]{1,2}" + ordinalSuffix
        let rangeConnector = "(?:to|-|\\u2013|until|through|till)"
        let year = "[0-9]{1,4}"

        let little =
            "(?:on\\s{0,3})?" +
            "(?<lday>[0-9]{1,2})(?![0-9])" + ordinalSuffix +
            "(?:\\s{0,3}" + rangeConnector + "\\s{0,3}" + day + ")?" +
            "(?:-|/|\\s{0,3}(?:of\\s{0,3})?)" +
            "(?<lmonth>" + months + ")" +
            "(?:(?:-|/|,?\\s{0,3})(?<lyear>" + year + ")(?:\\s*(?<lera>" + era + "))?(?![\\p{L}\\p{N}]))?"

        let middle =
            "(?<mmonth>" + months + ")" +
            "(?:-|/|\\s*,?\\s*)" +
            "(?<mday>[0-9]{1,2})(?![0-9])" + ordinalSuffix + "(?![:.][0-9])(?!\\s*(?:am|pm))" +
            "(?:\\s*" + rangeConnector + "\\s*" + day + "\\s*)?" +
            "(?:(?:-|/|\\s*,\\s*|\\s+)(?<myear>" + year + ")(?:\\s*(?<mera>" + era + "))?)?"

        // Month with an optional 4-digit year, no day: "September 2012",
        // "Sep. 2012", "Sep-2012", "in June of 2022", "in August".
        let monthOnly =
            "(?<omonth>" + months + ")" +
            "(?:(?:\\s*[.,/\\-]\\s*|\\s+)(?:of\\s+)?(?<oyear>[0-9]{4})(?:\\s*(?<oera>" + era + "))?)?"

        return makeRegex(
            boundaryBefore + "(?:" + little + "|" + middle + "|" + monthOnly + ")" + "(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let vocab = context.locale.vocabulary
        let monthTable = WordTable(vocab.months)
        let eraTable = WordTable(vocab.eraMarkers)

        let monthText: String
        var dayText: String?
        let yearText: String?
        let eraText: String?

        if let m = match.string(named: "lmonth") {
            monthText = m
            dayText = match.string(named: "lday")
            yearText = match.string(named: "lyear")
            eraText = match.string(named: "lera")
        } else if let m = match.string(named: "mmonth") {
            monthText = m
            dayText = match.string(named: "mday")
            yearText = match.string(named: "myear")
            eraText = match.string(named: "mera")
        } else if let m = match.string(named: "omonth") {
            monthText = m
            dayText = nil
            yearText = match.string(named: "oyear")
            eraText = match.string(named: "oera")
        } else {
            return nil
        }

        guard let month = monthTable.value(for: monthText) else { return nil }
        var day: Int? = nil
        if let dayText = dayText {
            guard let d = Int(dayText), d >= 1, d <= 31 else { return nil }
            day = d
        }

        var comps = context.createParsingComponents()
        comps.certain(.month, month)
        if let day = day {
            comps.certain(.day, day)
        } else {
            comps.imply(.day, 1)
        }

        if let yearText = yearText, var year = Int(yearText) {
            let hasEra = eraText != nil
            if !hasEra && yearText.count <= 2 {
                year = year + (year > 50 ? 1900 : 2000)
            }
            if let eraText = eraText, let sign = eraTable.value(for: eraText), sign < 0 {
                year = -year
            }
            comps.certain(.year, year)
        } else {
            comps.imply(.year, yearClosestToReference(month: month, day: day ?? 1, context: context))
        }
        return .components(comps)
    }

    /// The year (refYear-1, refYear, refYear+1) whose month/day lands closest to
    /// the reference instant. Mirrors chrono's findYearClosestToRef.
    private func yearClosestToReference(month: Int, day: Int, context: ParsingContext) -> Int {
        let calendar = context.reference.calendar
        let refYear = context.reference.brokenDown.year ?? 2000
        let reference = context.reference.instant

        var best = refYear
        var bestDistance = Double.infinity
        for candidate in [refYear - 1, refYear, refYear + 1] {
            var dc = DateComponents()
            dc.year = candidate
            dc.month = month
            dc.day = day
            dc.hour = 12
            guard let date = calendar.date(from: dc) else { continue }
            let distance = abs(date.timeIntervalSince(reference))
            if distance < bestDistance {
                bestDistance = distance
                best = candidate
            }
        }
        return best
    }
}
