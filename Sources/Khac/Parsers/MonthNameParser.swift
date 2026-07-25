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
        // Atomic group so a numeric month token cannot be backtracked down to a
        // shorter one. VI months carry digits ("tháng 12"); without this the
        // engine re-splits "tháng 12" into "tháng 1" + a stray "2" day. Locking
        // the longest match keeps "tháng 12" whole. Harmless for alphabetic
        // months (no shorter month is a prefix that leaves a usable day digit).
        //
        // The trailing digit guard covers the case the atomic group cannot: a
        // valid short key that prefixes an INVALID longer one. "tháng 13" is not
        // a month, but "tháng 1" is, and without this guard it matches 7 of those
        // 9 characters and leaves a stray "3" for the year group to swallow.
        let months = "(?>" + WordTable(vocab.months).alternation + ")(?![0-9])"
        // Glued to the day's digits, from locale data: English "10th", Dutch
        // "12de", German "10." where the period IS the ordinal marker. This was
        // the English set spelled out, which silently made every other locale's
        // day form unreachable.
        let ordinalSuffix = regexAlternation(context.locale.patterns.dayOrdinalSuffixes)
            .map { "(?:" + $0 + ")?" } ?? ""
        // chrono's ORDINAL_NUMBER_PATTERN: a spelled-out ordinal, or digits with
        // an optional ordinal suffix. The locale already carries the words.
        // The numeric form is RANGE-restricted to 1-31 in the pattern itself, so
        // a two-digit number that cannot be a day never claims the day slot and
        // the alternation falls through to the month-plus-year reading: "Aug 96"
        // is August 1996, not a rejected 96th of August.
        let ordinalWords = WordTable(vocab.ordinals).alternation
        // The word BETWEEN day and month ("3rd of March"). This field was
        // declared, documented, and filled by English, but never read: the parser
        // spelled "of" out instead. Reading it is the fix, not a new field.
        let dateConnector = regexAlternation(context.locale.patterns.dateConnectorWords)
        let dateConnectorGroup = dateConnector.map { "(?:" + $0 + "\\s{0,3})?" } ?? ""
        // The preposition that can LEAD a full month-name date, from data now
        // rather than a literal "on". Kept separate from the bare-month one below:
        // sharing one field let the month-only reading start EARLIER than the full
        // date and turned "on Sept 2" into "on Sept".
        let monthPrefixGroup = regexAlternation(context.locale.patterns.monthPrefixWords)
            .map { "(?:" + $0 + "\\s{0,3})?" } ?? ""
        let bareMonthPrefixGroup = regexAlternation(context.locale.patterns.bareMonthPrefixWords)
            .map { "(?:" + $0 + "\\s{0,3})?" } ?? ""
        let day = "(?:" + ordinalWords + "|(?:3[01]|[12][0-9]|0?[1-9])(?![0-9])" + ordinalSuffix + ")"
        // The day-to-day connector INSIDE one month-name match ("10 - 22 August
        // 2012"). The WORDS come from the locale, like every other connector in
        // the engine; only the punctuation stays built in, because a hyphen and an
        // en dash read as a range in every locale this library targets and no
        // locale should have to restate them.
        //
        // This was a hardcoded English list for as long as English was the only
        // locale with a day-range test, which quietly made it the one connector in
        // the engine NOT reading patterns.rangeConnectorWords - TimeExpressionParser
        // and MergeDateRangeRefiner both already did. English loses nothing by the
        // change: its rangeConnectorWords holds exactly the words that were spelled
        // out here. The Romance locales are what exposed it, each with its own word
        // in this slot - Spanish "10 a 22 Agosto 2012", French "au", Italian "al".
        let connectorWords = regexAlternation(context.locale.patterns.rangeConnectorWords)
        let rangeConnector = "(?:" + (connectorWords.map { $0 + "|" } ?? "") + "-|\\u2013)"
        // Optional locale year-marker word before the year, e.g. VI "năm" in
        // "tháng 4 năm 1975". Empty for locales without one (English keeps its
        // built-in "of"), so this adds nothing to their patterns.
        let yearMarkerGroup = regexAlternation(context.locale.patterns.yearMarkerWords)
            .map { "(?:" + $0 + "\\s*)?" } ?? ""

        // Optional marker word before the day number ("ngày 15"), included in the
        // match so the reported span covers the whole phrase.
        let dayMarker = regexAlternation(context.locale.patterns.dayMarkerWords)
        let dayMarkerGroup = dayMarker.map { "(?:" + $0 + "\\s{0,3})?" } ?? ""

        let little =
            monthPrefixGroup +
            dayMarkerGroup +
            "(?<lday>" + day + ")" +
            "(?:\\s{0,3}" + rangeConnector + "\\s{0,3}(?<lday2>" + day + "))?" +
            "(?:-|/|\\s{0,3}" + dateConnectorGroup + ")" +
            "(?<lmonth>" + months + ")" +
            "(?:(?:-|/|,?\\s{0,3})" + yearMarkerGroup + yearGroup(prefix: "l", context) + "(?![\\p{L}\\p{N}]))?"

        // Month-then-day requires a real separator (space, hyphen, slash, or
        // comma), never a zero-width one. Otherwise a numeric month with an
        // out-of-range trailing digit ("tháng 13") re-reads as "tháng 1" + day
        // "3"; a real separator forces "tháng 13" to fail and be rejected. EN
        // "August 10" / "Aug-10" / "August, 10" all still carry a separator.
        let middle =
            "(?<mmonth>" + months + ")" +
            "(?:\\s*[-/,]\\s*|\\s+)" +
            "(?<mday>" + day + ")(?![:.][0-9])(?!\\s*(?:am|pm))" +
            "(?:\\s*" + rangeConnector + "\\s*(?<mday2>" + day + ")\\s*)?" +
            "(?:(?:-|/|\\s*,\\s*|\\s+)" + yearMarkerGroup + yearGroup(prefix: "m", context) + ")?"

        // Month with an optional year, no day: "September 2012", "Sep. 2012",
        // "Sep-2012", "in June of 2022", "in August", "Aug 96".
        //
        // The lookbehind is what makes an invalid MARKED day fail instead of
        // silently degrading. "ngày 0 tháng 4 năm 2000" rejects in the little
        // branch (day 0), and the engine then resumes one character on and would
        // happily match the bare "tháng 4 năm 2000", dropping the day the writer
        // explicitly stated. Refusing a bare month that follows a marked day
        // number means the whole phrase produces nothing, which is correct: the
        // text named a day, and that day is not real.
        let markedDayLookbehind = dayMarker.map { "(?<!" + $0 + "\\s{0,3}[0-9]{1,2}\\s{0,3})" } ?? ""
        let monthOnly =
            markedDayLookbehind +
            bareMonthPrefixGroup +
            "(?<omonth>" + months + ")" +
            "(?:(?:\\s*[.,/\\-]\\s*|\\s+)" + dateConnectorGroup + yearMarkerGroup + yearGroup(prefix: "o", context) + ")?"

        // Year-first forms, which neither of the above can reach: `little`
        // requires the day first and caps it at two digits, so a four-digit year
        // can never start it, and NumericDateParser is purely numeric and cannot
        // read a month NAME.
        let dateSeparator = "(?:\\s{0,3}[-/,]\\s{0,3}|\\s{1,3})"
        // "2012/Aug/10", "The Deadline is 2018 March 18"
        let yearFirstDay =
            yearGroup(prefix: "z", context) + dateSeparator +
            "(?<zmonth>" + months + ")" + dateSeparator +
            "(?<zday>" + day + ")"
        // "2024 Aug", "2024-August", "2024 AD August"
        let yearFirstMonth =
            yearGroup(prefix: "y", context) + dateSeparator + dateConnectorGroup +
            "(?<ymonth>" + months + ")"

        let alternatives = [little, middle, yearFirstDay, yearFirstMonth, monthOnly]
            .joined(separator: "|")
        return makeRegex(
            boundaryBefore + "(?:" + alternatives + ")" + "(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    /// The year part of a month-name date, as two alternatives sharing one
    /// prefix. An era marker vouches for any 1-4 digit year ("234 BCE"). A BARE
    /// year has to earn it: exactly 2 or 4 digits, never 1 or 3, and a 2-digit
    /// one must not be followed by anything showing it is really something else.
    /// Without that guard the year group eats the head of a following clock time
    /// ("5 May 12:00" becomes the year 12) or a meridiem hour ("24 October, 9 am"
    /// becomes the year 9), stranding the rest of the time expression.
    ///
    /// The exclusion list is built from locale DATA - meridiem words, clock-hour
    /// words, month names - rather than hardcoded English, so it serves every
    /// locale on the same engine.
    private func yearGroup(prefix: String, _ context: ParsingContext) -> String {
        let vocab = context.locale.vocabulary
        let eraWords = Array(vocab.eraMarkers.keys) + Array(vocab.eraOffsets.keys)
        let era = regexAlternation(eraWords.map { WordTable<Int>.fold($0) }) ?? "(?!)"
        let meridiemWords = WordTable(vocab.meridiem).alternation
        let monthWords = WordTable(vocab.months).alternation
        let clockWords = regexAlternation(context.locale.patterns.clockHourWords) ?? "(?!)"
        let followers = [meridiemWords, clockWords, monthWords].joined(separator: "|")
        let bare = "(?:[1-9][0-9]{3}|[0-9]{2}(?![\\p{L}\\p{N}_]|:[0-9]|\\s{1,3}(?:" + followers + ")))"
        return "(?:(?<\(prefix)yearEra>[1-9][0-9]{0,3})\\s{0,2}(?<\(prefix)era>" + era + ")"
            + "|(?<\(prefix)year>" + bare + "))"
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let vocab = context.locale.vocabulary
        let monthTable = WordTable(vocab.months)
        let eraTable = WordTable(vocab.eraMarkers)
        let ordinalTable = WordTable(vocab.ordinals)

        let monthText: String
        var dayText: String?
        var day2Text: String?
        let yearText: String?
        let eraText: String?
        var isMonthOnly = false

        func year(_ prefix: String) -> String? {
            match.string(named: prefix + "yearEra") ?? match.string(named: prefix + "year")
        }

        if let m = match.string(named: "lmonth") {
            monthText = m
            dayText = match.string(named: "lday")
            day2Text = match.string(named: "lday2")
            yearText = year("l")
            eraText = match.string(named: "lera")
        } else if let m = match.string(named: "mmonth") {
            monthText = m
            dayText = match.string(named: "mday")
            day2Text = match.string(named: "mday2")
            yearText = year("m")
            eraText = match.string(named: "mera")
        } else if let m = match.string(named: "zmonth") {
            monthText = m
            dayText = match.string(named: "zday")
            yearText = year("z")
            eraText = match.string(named: "zera")
        } else if let m = match.string(named: "ymonth") {
            monthText = m
            dayText = nil
            yearText = year("y")
            eraText = match.string(named: "yera")
        } else if let m = match.string(named: "omonth") {
            monthText = m
            dayText = nil
            yearText = year("o")
            eraText = match.string(named: "oera")
            isMonthOnly = true
        } else {
            return nil
        }

        guard let month = monthTable.value(for: monthText) else { return nil }

        // A bare month that is only an ABBREVIATION is too weak to be a date on
        // its own: "mar" and "jan" in running prose are far more often a name or
        // a typo than a month. chrono rejects a month-only match of at most three
        // characters unless the word is a full month name, which is why bare
        // "may" survives and bare "mar" does not. A preceding "in" vouches for
        // the abbreviation - "in Jan" is a date. chrono gets the same effect by
        // consuming the "in" into its match before measuring its length; the
        // result span is the month either way. Only applies to a locale that
        // declares its full month names; one that does not is unaffected.
        if isMonthOnly, !vocab.fullMonthNames.isEmpty, match.text.count <= 3,
           !vocab.fullMonthNames.contains(WordTable<Int>.fold(monthText)) {
            let ns = context.text as NSString
            let before = ns.substring(to: match.range.location)
            let vouched = makeRegex("(?:^|[^\\p{L}\\p{N}_])in\\s{0,3}$")
                .firstMatch(in: before, range: NSRange(location: 0, length: (before as NSString).length)) != nil
            if !vouched { return nil }
        }

        func dayValue(_ text: String?) -> Int? {
            guard let text = text else { return nil }
            if let word = ordinalTable.value(for: text) { return word }
            return Int(text.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))
        }

        var day: Int? = nil
        if dayText != nil {
            guard let d = dayValue(dayText), d >= 1, d <= 31 else { return nil }
            day = d
        }

        // Strict mode: every strict month-name oracle case is a complete explicit
        // date, so reject a result whose day is only implied. This also stops a
        // rejected out-of-range day ("32 August") from surfacing its bare month
        // when the engine resumes one char past the rejected match. Non-strict
        // deliberately does NOT reject: the EN oracle "96 Aug 96" surfaces the
        // bare "Aug 96", so an out-of-range plain-number day drops and the month
        // stands.
        if context.options.mode == .strict && day == nil { return nil }

        var comps = context.createParsingComponents()
        comps.certain(.month, month)
        if let day = day {
            comps.certain(.day, day)
        } else {
            comps.imply(.day, 1)
        }

        var resolvedYear: Int
        if let yearText = yearText, var value = Int(yearText) {
            let hasEra = eraText != nil
            if !hasEra && yearText.count <= 2 {
                value = value + (value > 50 ? 1900 : 2000)
            }
            if let eraText = eraText {
                // An OFFSET era shifts the count ("2555 BE" is 2012 CE); a sign
                // era negates it. A word lives in exactly one table.
                if let offset = WordTable(context.locale.vocabulary.eraOffsets).value(for: eraText) {
                    value += offset
                } else if let sign = eraTable.value(for: eraText), sign < 0 {
                    value = -value
                }
            }
            comps.certain(.year, value)
            resolvedYear = value
        } else {
            resolvedYear = yearClosestToReference(month: month, day: day ?? 1, context: context)
            comps.imply(.year, resolvedYear)
        }
        // (yearClosestToReference is the shared helper in ParserSupport.swift.)

        // A named month makes an impossible day impossible outright: there is no
        // 29 February 2014. NumericDateParser already rejects these; the same
        // shared check belongs here. chrono does not hunt for a nearby year that
        // would make a bare "29 February" valid - it simply rejects.
        //
        // Only for a year in the common era. Foundation splits BC years into a
        // separate era rather than negative years, so a negative year cannot
        // round-trip through `isRealDate` and every BC date would be rejected as
        // impossible ("10 August 234 BCE" would lose its day and surface as a
        // bare "August 234 BCE"). No oracle case validates a BC day-of-month.
        if let day = day, resolvedYear > 0,
           !isRealDate(year: resolvedYear, month: month, day: day, calendar: context.reference.calendar) {
            return nil
        }

        // A day range inside one month-name date ("August 10 - 22, 2012"): the
        // end shares everything with the start and overrides the day alone. An
        // IMPOSSIBLE end day (June 31) is still emitted: UnlikelyFilterRefiner
        // then drops the whole result, which is what makes "June 10 - 31, 2022"
        // produce nothing at all rather than silently shedding its end.
        if let day2 = dayValue(day2Text), day2 >= 1, day2 <= 31 {
            var end = comps
            end.certain(.day, day2)
            return .result(context.createResult(match: match, start: comps, end: end))
        }

        return .components(comps)
    }

}
