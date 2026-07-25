// ZHParsers.swift - the whole of Chinese date and time grammar, both scripts.
//
// One parser per family, each reading the UNION of chrono's zh.hans and zh.hant
// vocabularies. Since the two scripts' characters are disjoint (see ZHLocale.swift
// for the evidence), one union parser is equivalent to running chrono's two and is
// simpler than either. chrono's own root `zh` locale already registers both
// scripts' parsers side by side, so a combined locale is its shape too.
//
// Ported from wanasit/chrono v2.10.1 (MIT): ZHHans/ZHHant DateParser,
// WeekdayParser, RelationWeekdayParser, TimeExpressionParser, DeadlineFormatParser,
// AgoFormatParser, CasualDateParser. See NOTICE.
//
// Two places where chrono's zh code is internally inconsistent, reproduced rather
// than tidied, because the oracle is chrono:
//
//  - The "late night" guard. Before 2 AM, 明天 is still the current calendar day.
//    chrono applies that guard to BOTH day slots of its casual parser, but in its
//    TIME parser only to the first slot (明早/明晚) and not the second (明天/明日).
//  - The end-side meridiem rule differs from Japanese. chrono's zh compares the
//    start hour against the end hour directly, where its ja compares the start
//    hour MINUS 12. The two produce different answers for the same shape, so
//    neither can be shared.

import Foundation

/// Day shift for a relative day word, honoring chrono's late-night guard.
///
/// The guard exists because 明天 said at 00:30 still means the calendar day it is
/// said on. It applies ONLY to the tomorrow words, and only where chrono applies
/// it - `guarded` is the caller's choice for that reason.
private func zhShiftedDay(_ context: ParsingContext, _ word: String, guarded: Bool) -> Date? {
    guard let offset = ZHLocale.dayWords[word] else { return nil }
    if guarded, ZHLocale.lateNightGuardedDayWords.contains(word),
       (context.reference.brokenDown.hour ?? 0) <= 1 {
        return context.reference.instant
    }
    return context.reference.calendar.date(byAdding: .day, value: offset, to: context.reference.instant)
}

/// The `(?:day)(?:short tod)` / `(?:tod)` / `(?:day)日|天(?:tod)?` alternation that
/// opens both the casual and the time parser, with every group suffixed so several
/// copies can coexist in one pattern.
///
/// The branch ORDER is chrono's and is load bearing: `今晚` must be read as the day
/// 今 plus the short time-of-day 晚, while `今天早上` must fall through to the third
/// branch, where the 天 is consumed and 早上 is a full time-of-day word.
private func zhDayTimeOfDayGroup(_ s: String) -> String {
    let days = regexAlternation(Array(ZHLocale.dayWords.keys)) ?? "(?!)"
    let shortTod = regexAlternation(ZHLocale.shortTimeOfDayWords) ?? "(?!)"
    let tod = regexAlternation(ZHLocale.timeOfDayWords) ?? "(?!)"
    return "(?:"
        + "(?<d1\(s)>" + days + ")(?<t1\(s)>" + shortTod + ")"
        + "|(?<t2\(s)>" + tod + ")"
        + "|(?<d3\(s)>" + days + ")(?:日|天)[\\s,，]*(?<t3\(s)>" + tod + ")?"
        + ")"
}

/// Which day and time-of-day groups participated, read back out of a match.
private struct ZHDayTimeOfDay {
    var dayWord: String?
    /// True when the day word came from the FIRST slot, which is the only one
    /// chrono guards against late night in the time parser.
    var dayFromFirstSlot = false
    var timeOfDayWord: String?

    init(_ match: TextMatch, _ s: String) {
        if let day = match.string(named: "d1" + s) {
            dayWord = day
            dayFromFirstSlot = true
            timeOfDayWord = match.string(named: "t1" + s)
        } else if let tod = match.string(named: "t2" + s) {
            timeOfDayWord = tod
        } else if let day = match.string(named: "d3" + s) {
            dayWord = day
            timeOfDayWord = match.string(named: "t3" + s)
        }
    }

    /// The time-of-day word's first character, which is how chrono dispatches on
    /// it - 早上 and 早 lead to the same branch.
    var timeOfDayKey: Character? { timeOfDayWord?.first }
}

// MARK: - Dates

/// `2016年9月3号`, `九月三号`, `二零一八年十一月二十六日`, `3月17日`.
///
/// Source: chrono's ZHHans/ZHHantDateParser. The month and its 月 are the only
/// required parts; a missing day takes the reference's, and a missing year the
/// reference's. The year accepts four CJK numerals in the POSITIONAL reading, so
/// 二零一六 is 2016 and not 9 - see CJKNumerals.
struct ZHDateParser: Parser {
    static let overlapRank = 25

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let cjk = "[" + ZHLocale.numerals.characterClass + "]"
        // hans allows 3 CJK characters for the month and day, hant only 2, because
        // hant can write 26 as 廿六 while hans needs 二十六. The union takes 3.
        let number = "(?:[0-9]{1,2}|" + cjk + "{1,3})"
        return makeRegex(
            cjkWordBoundary
            + "(?<year>[0-9]{2,4}|" + cjk + "{4}|" + cjk + "{2})?\\s*(?:年)?[\\s,，]*"
            + "(?<month>" + number + ")\\s*月\\s*"
            + "(?<day>" + number + ")?\\s*(?:日|号|號)?"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let monthText = match.string(named: "month"),
              let month = ZHLocale.numerals.integer(monthText) else { return nil }

        var comps = context.createParsingComponents()
        comps.certain(.month, month)

        if let dayText = match.string(named: "day") {
            guard let day = ZHLocale.numerals.integer(dayText) else { return nil }
            comps.certain(.day, day)
        } else {
            comps.imply(.day, context.reference.brokenDown.day ?? 1)
        }

        if let yearText = match.string(named: "year") {
            // A year is transcribed digit by digit, not summed: 二零一六 is 2016.
            // ASCII digits read normally.
            guard let year = CJKNumerals.arabic(yearText) ?? ZHLocale.numerals.positional(yearText) else {
                return nil
            }
            comps.certain(.year, year)
        } else {
            // chrono uses the reference year outright here, NOT the
            // closest-to-reference search its ja and en parsers use.
            comps.imply(.year, context.reference.brokenDown.year ?? 0)
        }

        return .components(comps)
    }
}

// MARK: - Weekdays

/// Chinese weekday arithmetic, which is chrono's zh-specific version and NOT the
/// shared `Weekday.daysToWeekday`.
///
/// The two genuinely disagree, so sharing would be wrong rather than merely
/// different. From a Friday reference, 上个礼拜三 (last Wednesday) is
/// `3 - 7 - 5 = -9` days here, where the shared rule walks back to the most recent
/// Wednesday at -2. The oracle asserts -9 (2016-09-02 to 2016-08-24), so this is
/// the rule Chinese needs.
///
/// A modified weekday also FIXES the calendar date (certain), while a plain or
/// "this" one leaves it implied so ForwardDateRefiner can still move it - which is
/// what makes the forward-dates-only case work.
private func zhWeekdayComponents(
    _ context: ParsingContext, weekday: Int, modifier: ZHWeekdayModifier?
) -> ParsingComponents? {
    let refWeekday = Weekday.chrono(fromFoundation: context.reference.brokenDown.weekday ?? 1)

    let days: Int
    var dateIsCertain = false
    switch modifier {
    case .last:
        days = weekday - 7 - refWeekday
        dateIsCertain = true
    case .next:
        days = weekday + 7 - refWeekday
        dateIsCertain = true
    case .this_:
        days = weekday - refWeekday
    case nil:
        // The closest occurrence in either direction. chrono writes this as two
        // conditional adjustments of `offset - refOffset`, which is the same
        // function as the shared closest rule, so that one IS reused.
        days = Weekday.daysToWeekday(refWeekday: refWeekday, target: weekday, modifier: nil)
    }

    let calendar = context.reference.calendar
    guard let date = calendar.date(byAdding: .day, value: days, to: context.reference.instant) else {
        return nil
    }
    var comps = context.createParsingComponents()
    if dateIsCertain {
        comps.assignDate(date, calendar: calendar)
    } else {
        comps.implyDate(date, calendar: calendar)
    }
    comps.certain(.weekday, weekday)
    return comps
}

/// `星期四`, `礼拜日`, `周一`, `禮拜四`, `週一`.
struct ZHWeekdayParser: Parser {
    static let overlapRank = 42

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let weeks = regexAlternation(ZHLocale.weekWords) ?? "(?!)"
        let days = regexAlternation(Array(ZHLocale.weekdays.keys)) ?? "(?!)"
        return makeRegex(cjkWordBoundary + weeks + "(?<weekday>" + days + ")")
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let text = match.string(named: "weekday"),
              let weekday = ZHLocale.weekdays[text] else { return nil }
        guard let comps = zhWeekdayComponents(context, weekday: weekday, modifier: nil) else {
            return nil
        }
        return .components(comps)
    }
}

/// `上个礼拜三`, `下星期天`, `这个星期一`, `這個星期一`.
struct ZHRelationWeekdayParser: Parser {
    static let overlapRank = 41

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let modifiers = regexAlternation(Array(ZHLocale.weekModifiers.keys)) ?? "(?!)"
        let weeks = regexAlternation(ZHLocale.weekWords) ?? "(?!)"
        let days = regexAlternation(Array(ZHLocale.weekdays.keys)) ?? "(?!)"
        return makeRegex(
            cjkWordBoundary
            + "(?<prefix>" + modifiers + ")(?:个|個)?" + weeks + "(?<weekday>" + days + ")"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard let text = match.string(named: "weekday"),
              let weekday = ZHLocale.weekdays[text] else { return nil }
        let modifier = match.string(named: "prefix").flatMap { ZHLocale.weekModifiers[$0] }
        guard let comps = zhWeekdayComponents(context, weekday: weekday, modifier: modifier) else {
            return nil
        }
        return .components(comps)
    }
}

// MARK: - Casual references

/// `现在`, `而家`, `今天`, `明天早上`, `昨晚`, `下午`, `今日夜晚`.
///
/// Source: chrono's ZHHans/ZHHantCasualDateParser. The date is always CERTAIN; the
/// clock a time-of-day word brings is always IMPLIED, so a stated hour beside it
/// still wins.
struct ZHCasualDateParser: Parser {
    static let overlapRank = 52

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let now = regexAlternation(ZHLocale.nowWords) ?? "(?!)"
        return makeRegex(
            cjkWordBoundary + "(?:(?<now>" + now + ")|" + zhDayTimeOfDayGroup("") + ")"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard context.options.mode != .strict else { return nil }

        let calendar = context.reference.calendar
        var comps = context.createParsingComponents()

        if match.hasGroup(named: "now") {
            // chrono implies the reference's clock here rather than asserting it,
            // unlike the English "now" - so a following explicit time can still
            // override it.
            comps.implySimilarTime(to: context.reference)
            comps.assignDate(context.reference.instant, calendar: calendar)
            return .components(comps)
        }

        let read = ZHDayTimeOfDay(match, "")
        guard read.dayWord != nil || read.timeOfDayWord != nil else { return nil }

        var target = context.reference.instant
        if let word = read.dayWord {
            // Guarded in BOTH slots here, unlike the time parser. chrono's own
            // asymmetry; see the file header.
            guard let shifted = zhShiftedDay(context, word, guarded: true) else { return nil }
            target = shifted
        }
        comps.assignDate(target, calendar: calendar)

        if let key = read.timeOfDayKey, let clock = ZHLocale.timeOfDayClocks[key] {
            comps.imply(.hour, clock.hour)
            if let meridiem = clock.meridiem {
                comps.imply(.meridiem, meridiem.rawValue)
            }
        }

        return .components(comps)
    }
}

// MARK: - Time expressions

/// `上午6点13分`, `晚上8点`, `10点`, `今早八点十分至下午11点32分`, `6点30pm-11点pm`,
/// `下午三点半五十九秒`.
///
/// Source: chrono's ZHHans/ZHHantTimeExpressionParser, which like its Japanese
/// cousin reads the range itself rather than leaving it to the range refiner,
/// because the end side's meridiem is inferred from the start side.
struct ZHTimeExpressionParser: Parser {
    static let overlapRank = 62

    private static let latinMeridiem = "a\\.m\\.|p\\.m\\.|am?|pm?"

    /// One side: an optional "from", an optional day and time-of-day, then the
    /// clock. Only the clock is required.
    private static func side(_ s: String) -> String {
        let cjk = "[" + ZHLocale.numerals.characterClass + "]+"
        let number = "(?:[0-9]+|" + cjk + ")"
        let from = regexAlternation(ZHLocale.fromWords) ?? "(?!)"
        // The `[\s,，]*` separator belongs to each optional group that PRECEDES it,
        // never to the hour. chrono writes it once, outside both groups, as
        // `(?:from)?(?:daytod)?[\s,，]*hour`, so when neither group participates the
        // run is still live and a match can BEGIN with whitespace: `"  11:00 "`
        // reports the span `"  11:00"` from index 0 rather than `"11:00"` from index
        // 2. Alone that only widens a span harmlessly. Under composition it destroys
        // the correct answer, because the widened span strictly CONTAINS another
        // locale's correct one and the overlap filter's containment pass drops the
        // contained result before any score is compared - measured against nl, which
        // lost its `11:00` outright.
        //
        // Attaching the run to each preceding group keeps every case that needs it
        // (`早上 6 点` has a space between the time-of-day word and the hour) while
        // making it impossible for whitespace to be the first thing a match eats.
        // Same fix as the trailing runs below, same reason.
        return "(?:" + from + "[\\s,，]*)?"
            + "(?:" + zhDayTimeOfDayGroup(s) + "[\\s,，]*)?"
            + "(?<hour\(s)>" + number + ")\\s*(?:" + ZHLocale.hourMarkerPattern + "|:|：)\\s*"
            // 正 and 整 both mean "on the hour", so they are a minute of 0 rather
            // than a number.
            //
            // Each \s* sits INSIDE the group that requires its marker. chrono
            // writes these as `\s*(?:分|:|：)?\s*` and `\s*(?:秒)?`, where the run
            // is consumed even when no marker follows it, so "10:00:00 - 15/15"
            // reports the span "10:00:00 " with a trailing space. Harmless while zh
            // parses alone, wrong the moment another locale claims the same clock:
            // the longer span CONTAINS the correct one, and the overlap filter's
            // containment pass drops the correct one outright.
            + "(?:(?<minute\(s)>[0-9]+|半|正|整|" + cjk + ")(?:\\s*(?:分|:|：))?)?"
            + "(?:(?<second\(s)>" + number + ")(?:\\s*秒)?)?"
            + "(?:\\s*(?<lmer\(s)>" + latinMeridiem + "))?"
    }

    /// The trailing `至7点` / `-11点pm` half, anchored and run by hand on the text
    /// after the first match, as chrono runs its SECOND_REG_PATTERN.
    private static let rangePattern: NSRegularExpression = makeRegex(
        "^\\s*(?:到|至|-|\\u2013|~|〜|～|－)\\s*" + side("2")
    )

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(cjkWordBoundary + Self.side(""))
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        guard var start = Self.clock(
            context, match, suffix: "",
            defaultDate: context.reference.instant,
            startSide: nil
        )?.components else { return nil }

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
        // chrono defaults the end side's calendar date to the START's, not to the
        // reference, and only resets to the reference when the end states a day
        // word of its own. Passing the start's date here is what reproduces that.
        guard let reading = Self.clock(
            context, tail, suffix: "2",
            defaultDate: start.date(),
            startSide: start
        ) else {
            // chrono rejects the whole result when the end side is invalid, rather
            // than falling back to the start alone: `23时-25时` yields nothing.
            return nil
        }
        var end = reading.components

        // A Latin am/pm written on the END settles an unstated meridiem on the
        // START. chrono does this for the Latin form only, never for a Chinese
        // time-of-day word, and only when the start never stated one.
        if let settled = reading.settlesStartMeridiem, !start.isCertain(.meridiem) {
            start.imply(.meridiem, settled.rawValue)
            let startHour = start.get(.hour) ?? 0
            if settled == .am {
                if startHour == 12 { start.certain(.hour, 0) }
            } else if startHour != 12 {
                start.certain(.hour, startHour + 12)
            }
        }

        // An end clock before the start is the next day.
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

    /// One side's reading: its components, plus any meridiem it settles back onto
    /// the start side.
    private struct Reading {
        var components: ParsingComponents
        var settlesStartMeridiem: Meridiem?
    }

    /// One side's components, or nil to reject the whole match.
    ///
    /// `startSide` is supplied only for the end side, and only read: an end with no
    /// stated meridiem borrows from the start. The back-propagation in the other
    /// direction is RETURNED rather than applied, so this stays a pure read of the
    /// match. The two never interact - chrono's back-propagation runs only in the
    /// Latin-meridiem branch, and the borrow only when no branch ran at all.
    private static func clock(
        _ context: ParsingContext, _ match: TextMatch, suffix: String,
        defaultDate: Date, startSide: ParsingComponents?
    ) -> Reading? {
        guard let hourText = match.string(named: "hour" + suffix),
              var hour = ZHLocale.numerals.integer(hourText) else { return nil }

        var comps = context.createParsingComponents()
        let read = ZHDayTimeOfDay(match, suffix)
        let calendar = context.reference.calendar

        // ----- Day
        if let word = read.dayWord {
            // A stated day word always counts from the REFERENCE, which is why
            // chrono resets its end moment before shifting. The guard applies to
            // the FIRST slot only in this parser - chrono's own asymmetry with its
            // casual parser, see the file header.
            guard let shifted = zhShiftedDay(context, word, guarded: read.dayFromFirstSlot) else {
                return nil
            }
            comps.assignDate(shifted, calendar: calendar)
        } else {
            comps.implyDate(defaultDate, calendar: calendar)
        }

        // ----- Second
        if let secondText = match.string(named: "second" + suffix) {
            guard let second = ZHLocale.numerals.integer(secondText), second < 60 else { return nil }
            comps.certain(.second, second)
        }

        // ----- Minute
        var minute = 0
        if let minuteText = match.string(named: "minute" + suffix) {
            if minuteText == "半" {
                minute = 30
            } else if minuteText == "正" || minuteText == "整" {
                // 正 and 整 both mean "on the hour", so they are a minute of zero
                // rather than a number.
                minute = 0
            } else {
                guard let value = ZHLocale.numerals.integer(minuteText) else { return nil }
                minute = value
            }
        } else if hour > 100 {
            // A four-digit clock written without a separator: 1230点.
            minute = hour % 100
            hour /= 100
        }
        guard minute < 60, hour <= 24 else { return nil }

        // ----- Meridiem
        //
        // A 24-hour reading settles it on its own, BEFORE any word is consulted:
        // 16时 is certainly pm because of the 16. That is why `10点` (hour 10, no
        // word) ends up with only an IMPLIED am while `16时` gets a certain pm.
        var meridiem: Meridiem? = hour >= 12 ? .pm : nil
        var settlesStart: Meridiem? = nil

        if let latin = match.string(named: "lmer" + suffix) {
            guard hour <= 12 else { return nil }
            let lowered = latin.lowercased()
            if lowered.hasPrefix("a") {
                meridiem = .am
                if hour == 12 { hour = 0 }
            } else if lowered.hasPrefix("p") {
                meridiem = .pm
                if hour != 12 { hour += 12 }
            }
            if startSide != nil { settlesStart = meridiem }
        } else if let key = read.timeOfDayKey, let stated = ZHLocale.timeOfDayMeridiems[key] {
            // 夜 and 中 are absent from that table on purpose: chrono has no branch
            // for them, so 中午12点 takes its pm from the 12 alone.
            meridiem = stated
            if stated == .am {
                if hour == 12 { hour = 0 }
            } else if hour != 12 {
                hour += 12
            }
        }

        comps.certain(.hour, hour)
        comps.certain(.minute, minute)

        if let meridiem = meridiem {
            comps.certain(.meridiem, meridiem.rawValue)
        } else if let start = startSide {
            // The end side with nothing stated borrows from the start, by a
            // DIFFERENT comparison than Japanese uses: chrono's zh compares the
            // start hour against the end hour directly, where its ja subtracts 12
            // from the start first. Same shape, different answer, so the rule
            // cannot be shared between the two locales.
            let startAtPM = start.isCertain(.meridiem)
                && start.get(.meridiem) == Meridiem.pm.rawValue
            if startAtPM, (start.get(.hour) ?? 0) > hour {
                comps.imply(.meridiem, Meridiem.am.rawValue)
            }
        } else {
            comps.imply(.meridiem, Meridiem.am.rawValue)
        }

        return Reading(components: comps, settlesStartMeridiem: settlesStart)
    }
}

// MARK: - Durations

/// The shared body of the two duration parsers, which differ only in their
/// direction suffix. `5分钟前` back, `5分钟后` and `五日内` forward.
///
/// Source: chrono's ZHHans/ZHHant Ago and Deadline parsers, which are otherwise
/// the same code. A DATE unit produces a certain calendar date and no clock; a
/// CLOCK unit produces an implied date and a certain clock.
private func zhDuration(
    _ context: ParsingContext, _ match: TextMatch, direction: RelativeDirection
) -> ParserResult? {
    guard let countText = match.string(named: "count"),
          let unitText = match.string(named: "unit"),
          let component = ZHLocale.durationUnits[unitText] else { return nil }

    let amount: Double
    if let digits = CJKNumerals.arabic(countText) {
        amount = Double(digits)
    } else if let cjk = ZHLocale.numerals.additive(countText) {
        amount = Double(cjk)
    } else if let vague = ZHLocale.durationQuantifiers[countText] {
        // 几/幾 is 3 and 半 is a half, so the amount has to be fractional: 半小时
        // is 30 minutes, which RelativeDuration cascades for us.
        amount = vague
    } else {
        return nil
    }

    let duration = RelativeDuration([DurationClause(component, amount)], direction: direction)
    let calendar = context.reference.calendar
    guard !duration.isEmpty,
          let target = duration.apply(to: context.reference.instant, calendar: calendar) else {
        return nil
    }

    var comps = context.createParsingComponents()
    let isCalendarUnit = [.day, .weekOfYear, .month, .year].contains(component)
    if isCalendarUnit {
        comps.assignDate(target, calendar: calendar)
    } else {
        comps.implyDate(target, calendar: calendar)
        let c = calendar.dateComponents([.hour, .minute, .second], from: target)
        comps.certain(.hour, c.hour ?? 0)
        comps.certain(.minute, c.minute ?? 0)
        comps.certain(.second, c.second ?? 0)
    }
    return .components(comps)
}

/// The count-and-unit prefix both duration parsers share.
private func zhDurationPrefix() -> String {
    let cjk = "[" + ZHLocale.numerals.characterClass + "]+"
    let quantifiers = regexAlternation(Array(ZHLocale.durationQuantifiers.keys)) ?? "(?!)"
    let units = regexAlternation(Array(ZHLocale.durationUnits.keys)) ?? "(?!)"
    return cjkWordBoundary
        + "(?<count>[0-9]+|" + cjk + "|" + quantifiers + ")\\s*"
        // 个/個 is a measure word carrying no value: 一个钟 is one hour.
        + "(?:个|個)?"
        + "(?<unit>" + units + ")"
}

/// `5分钟前`, `1小时之前`, `3天前`, `五分鐘前`.
struct ZHAgoParser: Parser {
    static let overlapRank = 70

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        makeRegex(zhDurationPrefix() + "(?:之)?前")
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        zhDuration(context, match, direction: .past)
    }
}

/// `5分钟后`, `5分钟过后`, `五日内`, `一年之内`, `5分鐘之後`, `五日內`.
struct ZHDeadlineParser: Parser {
    static let overlapRank = 71

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        // Union of hans `(?:(?:之|过)?后|(?:之)?内)` and hant
        // `(?:(?:之|過)?後|(?:之)?內)`.
        makeRegex(zhDurationPrefix() + "(?:(?:之|过|過)?(?:后|後)|(?:之)?(?:内|內))")
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        zhDuration(context, match, direction: .future)
    }
}
