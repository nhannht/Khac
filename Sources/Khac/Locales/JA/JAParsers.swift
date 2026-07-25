// JAParsers.swift - the whole of Japanese date and time grammar.
//
// Unlike ENParsers.swift, which holds two words the data tables cannot express,
// this file holds EVERY Japanese form. JALocale.swift documents the four reasons
// the generic parsers cannot reach Japanese at all; this is the consequence.
// chrono's own ja locale is shaped the same way - 5 bespoke parsers, no reuse of
// its common date or time parsers - so this is a port of an architecture, not a
// workaround of one.
//
// Ported from wanasit/chrono v2.10.1 (MIT): JPStandardParser,
// JPSlashDateFormatParser, JPWeekdayParser, JPWeekdayWithParenthesesParser,
// JPCasualDateParser, JPTimeExpressionParser, JPMergeWeekdayComponentRefiner.
// See NOTICE.
//
// A note on word boundaries, since it is the crux. chrono guards only its time
// parser, with `(\W|^)`, and in JS without the /u flag `\W` is ASCII-only - so a
// kanji satisfies it and a digit does not. That is the correct semantic for a
// space-free script, and it is what `cjkWordBoundary` below reproduces. The
// generic parsers' `(?<![\p{L}\p{N}_])` is the same idea written with the Unicode
// property, and in CJK that one difference rejects every match.

import Foundation

// MARK: - 年月日, the standard date

/// `2012年3月31日`, `９月3日`, `平成26年12月29日`, `令和元年5月1日`, `今年7月27日`.
///
/// Source: chrono's JPStandardParser. No word boundary, deliberately: the oracle
/// expects a match inside `主な株主（2012年3月31日現在）`, where the span touches a
/// kanji on both sides, and the 年/月/日 markers are what make the match
/// unambiguous without one.
struct JAStandardParser: Parser {
    static let overlapRank = 25

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let eras = regexAlternation(Array(JALocale.eraOffsets.keys)) ?? "(?!)"
        return makeRegex(
            "(?:(?:"
            + "(?<refyear>[" + JALocale.referenceYearWords + "])"
            // 元 is "first", so 令和元年 is Reiwa year 1. It is a numeral special
            // case that exists only in this construction, which is a second
            // reason the eras cannot live in Vocabulary - there would be nowhere
            // to put it.
            + "|(?:(?<era>" + eras + ")?(?<yearnum>" + cjkArabicDigit + "{1,4}|元))"
            + ")年\\s*)?"
            + "(?<month>" + cjkArabicDigit + "{1,2})月\\s*"
            + "(?<day>" + cjkArabicDigit + "{1,2})日"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let monthText = match.string(named: "month"),
              let dayText = match.string(named: "day"),
              let month = CJKNumerals.arabic(monthText),
              let day = CJKNumerals.arabic(dayText) else { return nil }

        var comps = context.createParsingComponents()
        comps.certain(.month, month)
        comps.certain(.day, day)

        // No month/day range check, matching chrono, which has none here either.
        // The two-digit cap in the pattern is the only bound, and an out-of-range
        // month rolls over identically in both engines (JS Date and
        // Calendar.date(from:) both carry the excess into the year), so adding a
        // guard would DIVERGE from the oracle rather than harden against it.

        if match.hasGroup(named: "refyear") {
            // 同年 / 本年 / 今年: the reference's own year, assigned outright. Not
            // an offset and not a sign, which is why this cannot be Vocabulary
            // data - see JALocale.referenceYearWords.
            comps.certain(.year, context.reference.brokenDown.year ?? 0)
        } else if let yearText = match.string(named: "yearnum") {
            guard var year = yearText == "元" ? 1 : CJKNumerals.arabic(yearText) else { return nil }
            if let era = match.string(named: "era"), let offset = JALocale.eraOffsets[era] {
                year += offset
            }
            comps.certain(.year, year)
        } else {
            comps.imply(.year, yearClosestToReference(month: month, day: day, context: context))
        }

        return .components(comps)
    }
}

// MARK: - Slash dates

/// `2012/3/31`, `12/31`, `１／３０`. Big-endian, which is the Japanese
/// convention: a two-field form is month/day, and a leading four-digit field is
/// the year.
///
/// Source: chrono's JPSlashDateFormatParser. This overlaps the shared
/// NumericDateParser on purely ASCII input, and that is fine - both read
/// big-endian for this locale and produce the same components, so the overlap
/// filter keeps one of two identical answers. It exists for the FULL-WIDTH forms
/// (`１／３０（木）`), which the shared parser's `[0-9]` and `/` cannot reach.
struct JASlashDateParser: Parser {
    static let overlapRank = 22

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        // chrono writes the separator class as `[\/|\／]`, which also admits a
        // literal pipe. That is a slip in the source rather than a rule about
        // Japanese - nothing writes "3|31" as a date and no oracle case does - so
        // the pipe is not carried over.
        let slash = "[/／]"
        return makeRegex(
            cjkWordBoundary
            // Refuse a PREFIX or SUFFIX of a longer slash-separated run: in
            // "2/29/2014" the leading "2/29" is not a date, and in "4/13/1"
            // neither "4/13" nor "13/1" is. chrono's JPSlashDateFormatParser has
            // no such guard, and the shared NumericDateParser does - quoting
            // chrono's own SlashDateFormatParser for it - so this follows the
            // engine rather than the ja port.
            //
            // Not a cross-locale accommodation: without it this parser answers
            // "2/29" for "2/29/2014" in Japanese text too, silently dropping the
            // year the writer stated. It went unnoticed because no ja oracle case
            // writes a three-field slash date with a two-digit-or-less year, and
            // it surfaced only once EN's corpus - which guards this exact shape -
            // ran through the same engine.
            + "(?<!" + cjkArabicDigit + slash + ")"
            + "(?:(?<year>" + cjkArabicDigit + "{4})" + slash + ")?"
            + "(?<month>[0-1０-１]?" + cjkArabicDigit + ")"
            + slash + "(?<day>[0-3０-３]?" + cjkArabicDigit + ")"
            + "(?!" + cjkArabicDigit + ")(?!" + slash + cjkArabicDigit + ")"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let monthText = match.string(named: "month"),
              let dayText = match.string(named: "day"),
              let month = CJKNumerals.arabic(monthText),
              let day = CJKNumerals.arabic(dayText) else { return nil }
        guard (1...12).contains(month), (1...31).contains(day) else { return nil }

        var comps = context.createParsingComponents()
        comps.certain(.month, month)
        comps.certain(.day, day)

        if let yearText = match.string(named: "year"), let raw = CJKNumerals.arabic(yearText) {
            // chrono's findMostLikelyADYear: a two-digit year becomes 19xx above
            // 50 and 20xx otherwise. A four-digit year passes through, which is
            // the only case this pattern can actually produce, but the call is
            // kept so the rule lives in one place.
            comps.certain(.year, raw < 100 ? raw + (raw > 50 ? 1900 : 2000) : raw)
        } else {
            comps.imply(.year, yearClosestToReference(month: month, day: day, context: context))
        }

        return .components(comps)
    }
}

// MARK: - Weekdays

/// Build the components for a weekday, honoring an optional modifier: the date is
/// IMPLIED (shifted from the reference) and only the weekday is certain.
///
/// Mirrors chrono's createParsingComponentsAtWeekday, which shifts the reference
/// by an implied duration and then assigns the weekday.
private func weekdayComponents(
    _ context: ParsingContext, weekday: Int, modifier: Weekday.Modifier?
) -> ParsingComponents? {
    let refWeekday = Weekday.chrono(fromFoundation: context.reference.brokenDown.weekday ?? 1)
    let days = Weekday.daysToWeekday(refWeekday: refWeekday, target: weekday, modifier: modifier)
    let calendar = context.reference.calendar
    guard let date = calendar.date(byAdding: .day, value: days, to: context.reference.instant) else {
        return nil
    }
    var comps = context.createParsingComponents()
    comps.implyDate(date, calendar: calendar)
    comps.certain(.weekday, weekday)
    return comps
}

/// `木曜日`, `前の水曜日`, `次の土曜日`. The 曜 form without 日 is accepted too,
/// as chrono accepts it.
///
/// Source: chrono's JPWeekdayParser, including its unhandled cases: 先週 (last
/// week) and 来週 (next week) are NOT synonyms of last/next in Japanese, chrono
/// carries a TODO saying so, and neither guesses at them.
struct JAWeekdayParser: Parser {
    static let overlapRank = 42

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let modifiers = regexAlternation(Array(JALocale.weekdayModifiers.keys)) ?? "(?!)"
        let weekdays = String(JALocale.weekdays.keys.sorted())
        return makeRegex(
            "(?<prefix>" + modifiers + ")?"
            + "(?<weekday>[" + weekdays + "])(?:曜日|曜)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let text = match.string(named: "weekday"),
              let character = text.first,
              let weekday = JALocale.weekdays[character] else { return nil }
        let modifier = match.string(named: "prefix").flatMap { JALocale.weekdayModifiers[$0] }
        guard let comps = weekdayComponents(context, weekday: weekday, modifier: modifier) else {
            return nil
        }
        return .components(comps)
    }
}

/// `(水)`, `（土）` - the abbreviated weekday a Japanese calendar prints beside a
/// date. Source: chrono's JPWeekdayWithParenthesesParser. Both bracket widths.
struct JAWeekdayParenthesesParser: Parser {
    static let overlapRank = 43

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let weekdays = String(JALocale.weekdays.keys.sorted())
        return makeRegex("[(（](?<weekday>[" + weekdays + "])[)）]")
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let text = match.string(named: "weekday"),
              let character = text.first,
              let weekday = JALocale.weekdays[character] else { return nil }
        guard let comps = weekdayComponents(context, weekday: weekday, modifier: nil) else {
            return nil
        }
        return .components(comps)
    }
}

// MARK: - Casual references

/// `今日`, `きょう`, `本日`, `昨日`, `明日`, `今夜`, `今朝` and their kana
/// spellings. Source: chrono's JPCasualDateParser.
///
/// These are day and time-of-day WORDS, so `Vocabulary.dayReferences` and
/// `Vocabulary.timeOfDay` look like their natural home. They cannot go there:
/// the generic CasualDateParser that reads those tables wraps every alternative
/// in the `\p{L}` boundary guard, and each of these words appears flush against
/// the next kanji in real input - `今日感じたことを忘れずに` - so not one of them
/// would ever match.
struct JACasualDateParser: Parser {
    static let overlapRank = 52

    /// What a casual word resolves to. An enum rather than a day offset because
    /// two of the five carry a CLOCK and no offset, and the other three carry an
    /// offset and no clock.
    enum Reference {
        case today
        case yesterday
        case tomorrow
        /// 今夜 / 今夕 / 今晩: today at hour 22, pm.
        case evening
        /// 今朝 / けさ: today at hour 6, am.
        case morning
    }

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let words = regexAlternation(Array(JALocale.casualWords.keys)) ?? "(?!)"
        return makeRegex("(?<word>" + words + ")")
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        // Casual by definition, so strict mode refuses it - chrono registers this
        // parser only in its casual configuration.
        guard context.options.mode != .strict else { return nil }
        guard let word = match.string(named: "word"),
              let reference = JALocale.casualWords[word] else { return nil }

        let calendar = context.reference.calendar
        var comps = context.createParsingComponents()

        let dayOffset: Int
        switch reference {
        case .yesterday: dayOffset = -1
        case .tomorrow: dayOffset = 1
        case .today, .evening, .morning: dayOffset = 0
        }
        guard let target = calendar.date(byAdding: .day, value: dayOffset, to: context.reference.instant) else {
            return nil
        }
        comps.assignDate(target, calendar: calendar)

        switch reference {
        case .today, .yesterday, .tomorrow:
            // chrono's casualReferences.today/yesterday/tomorrow: a certain date
            // carrying the reference's own clock as implied, not noon.
            comps.implySimilarTime(to: context.reference)
        case .evening:
            comps.imply(.hour, 22)
            comps.certain(.meridiem, Meridiem.pm.rawValue)
        case .morning:
            comps.imply(.hour, 6)
            comps.certain(.meridiem, Meridiem.am.rawValue)
        }

        return .components(comps)
    }
}

// MARK: - Time expressions

/// `午前6時13分`, `午後8時`, `10時`, `16:00`, `午前八時十分から午後11時32分`,
/// `午後６時半－１１時`, `午後三時半五十九秒`.
///
/// Source: chrono's JPTimeExpressionParser, which is the one ja parser that
/// carries a word boundary and the one that builds its own two-sided result: the
/// range is read inside the parser rather than left to the range refiner, because
/// the end side's meridiem is INFERRED from the start side and only this parser
/// knows both halves.
///
/// A difference in engine behavior had to be reproduced here rather than relied
/// upon. On a rejected match chrono skips the whole span (its JPTimeExpressionParser
/// advances `match.index` by the match length before returning null), while this
/// engine deliberately advances by one character so a rejected outer match cannot
/// hide a valid inner one. That policy is right in general and wrong for
/// `午後１3時`, which must produce NOTHING: pm cannot take hour 13, and after the
/// rejection the fragments `１3時` and `3時` are both sitting there. Two guards in
/// the pattern close it without touching the engine, and both are rules about
/// Japanese rather than special cases:
///
///   - The leading meridiem may not be IGNORED. The alternation below either
///     consumes a meridiem word or asserts that none precedes, so `１3時` cannot
///     match while 午後 sits in front of it.
///   - A match may not start inside a number, full-width digits included, which
///     is what stops `3時` from matching after the `１`.
struct JATimeExpressionParser: Parser {
    static let overlapRank = 62

    /// The am/pm words, Japanese and Latin. `am?`/`pm?` also accept a bare "a"/"p",
    /// which is chrono's own alternation (`AM?|PM?`) rather than an addition here.
    private static let meridiemWords = "午前|午後|a\\.m\\.|p\\.m\\.|am?|pm?"

    /// One clock reading: hour, then optionally minute and second, then an
    /// optional TRAILING meridiem. Group names are suffixed so the start side, the
    /// end side, and the two leading-meridiem variants of each can coexist.
    ///
    /// Every field takes Arabic digits of either width OR CJK numerals, and the
    /// minute additionally takes 半 (half past). The unit markers 分 and 秒 are
    /// optional, which is what lets `3月17日 20時15` read 15 as the minute.
    private static func clockBody(_ suffix: String) -> String {
        let cjk = "[" + JALocale.numerals.characterClass + "]+"
        let number = "(?:" + cjkArabicDigit + "+|" + cjk + ")"
        return "(?<hour\(suffix)>" + number + ")\\s*"
            // 時間 is "hour" the DURATION, not a clock hour, so `1時間` is not a
            // time. chrono's own (?!間).
            + "(?:時(?!間)|:|：)\\s*"
            // Each \s* sits INSIDE the group that requires its marker. Written
            // as chrono writes it - `\s*(?:分|:|：)?\s*` - a trailing run is
            // consumed even when no marker follows, and the whitespace lands in
            // the reported span.
            + "(?:(?<minute\(suffix)>" + cjkArabicDigit + "+|半|" + cjk + ")(?:\\s*(?:分|:|：))?)?"
            + "(?:(?<second\(suffix)>" + number + ")\\s*秒)?"
            + "(?:\\s*(?<tmer\(suffix)>" + meridiemWords + "))?"
    }

    /// One whole side: either a leading meridiem and a clock, or a clock with the
    /// assertion that no meridiem was skipped over.
    ///
    /// Written as an alternation because a plain `(?:...)?` cannot express "absent
    /// AND none present", and the second half is exactly what makes `午後１3時`
    /// produce nothing rather than 13:00 - see the type's own comment.
    ///
    /// The `[\s,，、]*` run belongs only to the meridiem branch, where `午前 6 時`
    /// needs it. Allowing it in the bare branch would let a match BEGIN with
    /// whitespace, which moves the reported index and text off the time itself.
    private static func side(_ suffix: String) -> String {
        let leading = "(?<mer\(suffix)>" + meridiemWords + ")[\\s,，、]*" + clockBody(suffix)
        let bare = "(?<!午前)(?<!午後)" + clockBody("bare" + suffix)
        return "(?:" + leading + "|" + bare + ")"
    }

    /// The trailing `から3時` / `-11時PM` half. Anchored, and run by hand on the
    /// text after the first match, exactly as chrono runs its SECOND_REG_PATTERN.
    ///
    /// ～ (U+FF5E) is accepted alongside chrono's 〜 (U+301C): the two are
    /// routinely confused in real Japanese input, chrono's own date-range refiner
    /// lists ～ while this parser lists 〜, and a time range should not disagree
    /// with a date range about which wave dash is a dash.
    private static let rangePattern: NSRegularExpression = makeRegex(
        "^\\s*(?:から|-|\\u2013|－|~|〜|～)\\s*" + side("2")
    )

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(cjkWordBoundary + Self.side(""))
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let start = Self.clock(context, match, suffix: "") else { return nil }

        // The range half. Anchored at the end of the first match, in normalized
        // coordinates - the same space the pattern matched in.
        let firstEnd = match.range.location + match.range.length
        let ns = context.text as NSString
        guard firstEnd < ns.length,
              let rangeMatch = Self.rangePattern.firstMatch(
                  in: context.text, options: [],
                  range: NSRange(location: firstEnd, length: ns.length - firstEnd)
              )
        else {
            return .components(start)
        }

        let tail = TextMatch(result: rangeMatch, normalizedNS: ns, normalization: context.normalization)
        // chrono rejects the WHOLE result when the range's end side is invalid,
        // rather than falling back to the start alone. That is what makes
        // `23時-25時` produce nothing at all instead of 23:00.
        guard var end = Self.clock(context, tail, suffix: "2") else { return nil }

        Self.inferEndMeridiem(from: start, into: &end)

        // An end clock before the start is the next day: `23時20分から2時`.
        if end.date() < start.date() {
            end.imply(.day, (end.get(.day) ?? 1) + 1)
        }

        let rangeEnd = rangeMatch.range.location + rangeMatch.range.length
        let span = match.range.location..<rangeEnd
        return .result(context.createResult(
            index: context.normalization.originalUTF16Offset(forNormalizedUTF16: span.lowerBound),
            text: context.normalization.originalSubstring(forNormalizedUTF16: span),
            start: start,
            end: end
        ))
    }

    /// One side's components, or nil to reject the whole match.
    ///
    /// Reads the meridiem from whichever slot carried it - leading, trailing, or
    /// the bare-alternative copies of each - since only one can participate.
    private static func clock(_ context: ParsingContext, _ match: TextMatch, suffix: String) -> ParsingComponents? {
        let bare = "bare" + suffix
        guard let hourText = match.string(named: "hour" + suffix) ?? match.string(named: "hour" + bare),
              var hour = JALocale.numerals.integer(hourText) else { return nil }
        // 25時 is not a time. chrono's own bound, and it admits 24.
        guard hour <= 24 else { return nil }

        let minuteText = match.string(named: "minute" + suffix) ?? match.string(named: "minute" + bare)
        let secondText = match.string(named: "second" + suffix) ?? match.string(named: "second" + bare)
        let meridiemText = match.string(named: "mer" + suffix)
            ?? match.string(named: "tmer" + suffix)
            ?? match.string(named: "mer" + bare)
            ?? match.string(named: "tmer" + bare)

        var comps = context.createParsingComponents()

        if let minuteText = minuteText {
            let minute: Int?
            if minuteText == "半" {
                minute = 30
            } else {
                minute = JALocale.numerals.integer(minuteText)
            }
            guard let minute = minute, minute < 60 else { return nil }
            comps.certain(.minute, minute)
        }

        if let secondText = secondText {
            guard let second = JALocale.numerals.integer(secondText), second < 60 else { return nil }
            comps.certain(.second, second)
        }

        if let meridiemText = meridiemText {
            // A stated meridiem cannot sit on a 24-hour clock reading: 午後１3時
            // is not 13:00 pm, it is not a time at all.
            guard hour <= 12 else { return nil }
            let lowered = meridiemText.lowercased()
            if lowered == "午前" || lowered.hasPrefix("a") {
                if hour == 12 { hour = 0 }
                comps.certain(.meridiem, Meridiem.am.rawValue)
            } else if lowered == "午後" || lowered.hasPrefix("p") {
                if hour != 12 { hour += 12 }
                comps.certain(.meridiem, Meridiem.pm.rawValue)
            }
        } else {
            comps.imply(.meridiem, hour < 12 ? Meridiem.am.rawValue : Meridiem.pm.rawValue)
        }

        comps.certain(.hour, hour)
        return comps
    }

    /// chrono's end-side meridiem inference: an end with no stated am/pm borrows
    /// the start's, and a pm start pushes a bare end hour into the afternoon
    /// unless doing so would put the end before the start - `午後１１時半－１時`
    /// is 23:30 to 01:00, not to 13:00.
    private static func inferEndMeridiem(from start: ParsingComponents, into end: inout ParsingComponents) {
        guard !end.isCertain(.meridiem), start.isCertain(.meridiem) else { return }
        let startMeridiem = start.get(.meridiem) ?? 0
        end.imply(.meridiem, startMeridiem)
        guard startMeridiem == Meridiem.pm.rawValue else { return }

        let startHour = start.get(.hour) ?? 0
        let endHour = end.get(.hour) ?? 0
        if startHour - 12 > endHour {
            end.imply(.meridiem, Meridiem.am.rawValue)
        } else if endHour < 12 {
            end.certain(.hour, endHour + 12)
        }
    }
}

// MARK: - Refiners

/// Completes `1/30の木曜日`: a date followed by the genitive particle and a bare
/// weekday.
///
/// The shared MergeWeekdayRefiner already merges the zero-width and comma forms
/// (`8月27日水曜日`, `8月27日（水）`), and it accepts nothing else, so の and 、
/// would strand the weekday as its own result. chrono solves this by REPLACING
/// the common refiner with JPMergeWeekdayComponentRefiner, whose glue is
/// `^[,、の]?\s*$`; a locale here can only ADD refiners, so this one runs after
/// the shared pass and picks up what it left. That is additive rather than
/// duplicated work: a weekday the shared refiner already merged is no longer a
/// weekday-only result, so it cannot be merged twice.
struct JAMergeWeekdayParticleRefiner: MergingRefiner {
    func merged(_ left: ParsedResult, _ right: ParsedResult, _ context: ParsingContext) -> ParsedResult? {
        // Japanese puts the weekday AFTER the date, always, so unlike the shared
        // refiner this one does not consider the other order.
        guard left.start.isCertain(.day),
              right.start.isOnlyWeekdayComponent,
              !right.start.isCertain(.hour) else { return nil }

        let original = context.normalization.original as NSString
        guard left.rangeEnd <= right.index, right.index <= original.length else { return nil }
        let gap = original.substring(with: NSRange(location: left.rangeEnd, length: right.index - left.rangeEnd))
        let trimmed = gap.trimmingCharacters(in: .whitespaces)
        guard trimmed.isEmpty || trimmed == "の" || trimmed == "、" || trimmed == "," else { return nil }

        var start = left.start
        if let weekday = right.start.get(.weekday) {
            start.certain(.weekday, weekday)
        }
        var end = left.end
        if let weekday = right.start.get(.weekday) {
            end?.certain(.weekday, weekday)
        }

        let text = original.substring(
            with: NSRange(location: left.index, length: right.rangeEnd - left.index)
        )
        return context.createResult(index: left.index, text: text, start: start, end: end)
    }
}
