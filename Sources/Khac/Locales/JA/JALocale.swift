// JALocale.swift - Japanese locale data for Khac.
//
// Japanese is the first locale whose grammar the generic parsers cannot reach at
// all, so unlike EN and VI almost nothing here is Vocabulary. That is a finding
// about the SCRIPT, not a shortcut, and it is worth stating precisely because a
// future reader will otherwise try to move these tables into Vocabulary and find
// out the hard way.
//
// Four independent properties of the shared patterns block Japanese:
//
//  1. Word boundaries. Every generic parser wraps its alternation in
//     `(?<![\p{L}\p{N}_])` ... `(?=[^\p{L}\p{N}_]|$)`. Han, Hiragana and
//     Katakana are all \p{L} and Japanese has no spaces, so every match is
//     letter-adjacent and the guard rejects it: "昨日の全国観測値ランキング"
//     yields nothing for 昨日. chrono guards the same parsers with `(\W|^)`,
//     which in JS without the /u flag is ASCII-only, so a kanji counts as a
//     boundary there. The Unicode property is the whole difference.
//  2. Full-width digits. Normalization is NFC by design, and NFC does not fold
//     width, so ９ stays ９ while every shared pattern writes [0-9]. 27 of the
//     84 JA oracle cases carry full-width forms.
//  3. CJK numerals. 八時十分 is 8:10 and 三時半五十九秒 is 15:30:59 - arithmetic
//     over characters in two different readings, not a word lookup. See
//     CJKNumerals.swift.
//  4. Pattern shape. 2012年3月31日 needs the year marker as a SUFFIX and no
//     separator at all before the month, where MonthNameParser splices its
//     yearMarkerGroup BEFORE the year and requires a separator character. 午前6時
//     needs a LEADING meridiem, where TimeExpressionParser has only a trailing
//     slot - so 午前 in timePrefixWords would match the span and silently drop
//     the am/pm, which is worse than not matching.
//
// So the parsers are bespoke, through the additionalParsers escape hatch the
// design provides for exactly this, and they mirror chrono's own architecture:
// chrono's ja locale registers 5 of its own parsers and reuses NONE of its
// common date or time parsers, sharing only ISOFormatParser and the generic
// refiners. See JAParsers.swift.
//
// What IS still shared, and is deliberately left to the engine: the numeric
// slash dates (NumericDateParser handles 2012/3/31, 12/31, 8/5 with dateOrder
// below), the ISO parser, the overlap filter, the date-time merge, the weekday
// merge and the range merge - the last three driven by the PatternSet words here.
//
// Values that are not obvious from general Japanese knowledge were taken from
// wanasit/chrono v2.10.1 (see NOTICE) and are attributed inline.

import Foundation

public struct JALocale: KhacLocale {
    public let id: LocaleID = .japanese

    public init() {}

    /// Deliberately near-empty: no weekday, month, meridiem or day-reference
    /// words. Every one of them is read by a bespoke parser instead, for the
    /// reasons at the top of this file. Filling them would be actively harmful,
    /// not merely redundant - a `weekdays` table of the single characters
    /// 日月火水木金土 would let the generic WeekdayParser hunt for 日 inside 昨日,
    /// 明日 and 3月17日, and every such match is a wrong answer competing with a
    /// right one.
    public var vocabulary: Vocabulary {
        Vocabulary()
    }

    /// Only the words the SHARED refiners consume. The parsers need nothing here.
    public var patterns: PatternSet {
        PatternSet(
            // Source: chrono's JPMergeDateRangeRefiner, whose whole body is
            // `/^\s*(から|－|ー|-|～|~)\s*$/i`. "-" and "~" are already built into
            // Khac's range check, so only the words and full-width forms are
            // listed. 〜 (U+301C WAVE DASH) is not in that refiner but IS in
            // JPTimeExpressionParser's own range alternation, so it is accepted
            // here too for consistency between a date range and a time range.
            // ー is U+30FC, the katakana prolonged sound mark, which real input
            // uses as a dash and which no width fold touches.
            rangeConnectorWords: ["から", "～", "〜", "ー", "－"],
            // Source: chrono's JPMergeDateTimeRefiner, whose whole body is
            // `/^\s*(の)?\s*$/i` - the genitive particle is the only glue
            // Japanese puts between a date and a time ("12/9の16:00"). The
            // zero-width case ("本日午前八時十分") needs no entry: the shared
            // glue check already accepts an empty gap.
            dateTimeGlueWords: ["の"]
            // timePrefixWords is deliberately EMPTY. 午前/午後 are the obvious
            // candidates and they must NOT go here: they carry an am/pm VALUE and
            // this field is structural glue that carries none, so the generic
            // TimeExpressionParser would match "午前8時" and resolve it as 08:00
            // with the 午前 silently discarded. It reads correct on the morning
            // cases and is wrong every afternoon. JATimeExpressionParser has a
            // real leading-meridiem slot instead.
        )
    }

    /// Big-endian slash dates (YYYY/MM/DD) and month-first two-field dates
    /// (12/31 is December 31st), which is what chrono's JPSlashDateFormatParser
    /// implements and what lets the shared NumericDateParser serve the ASCII
    /// slash cases unchanged. weekStart uses Foundation's convention
    /// (1 = Sunday), matching chrono's default.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .monthDay, weekStart: 1)
    }

    /// The whole of Japanese date and time grammar - see JAParsers.swift.
    public var additionalParsers: [Parser] {
        [
            JAStandardParser(),
            JASlashDateParser(),
            JAWeekdayParser(),
            JAWeekdayParenthesesParser(),
            JACasualDateParser(),
            JATimeExpressionParser(),
        ]
    }

    /// Completes the weekday merge for the one glue the shared refiner refuses -
    /// see JAMergeWeekdayParticleRefiner.
    public var additionalRefiners: [Refiner] {
        [JAMergeWeekdayParticleRefiner()]
    }
}

// MARK: - Japanese data the bespoke parsers read

extension JALocale {
    /// Weekday character to the chrono/JS weekday number (0 = Sunday). Source:
    /// chrono's ja WEEKDAY_OFFSET. These are the standard Japanese day names
    /// (日曜日 Sunday through 土曜日 Saturday), written with the day's element
    /// kanji, and the same characters serve the abbreviated parenthesised form
    /// (水) that calendars print.
    static let weekdays: [Character: Int] = [
        "日": 0, "月": 1, "火": 2, "水": 3, "木": 4, "金": 5, "土": 6,
    ]

    /// CJK digit characters. Source: chrono's ja NUMBER table. Narrower than the
    /// ZH one: Japanese has no 廿 or 卅, and no 两.
    static let numerals = CJKNumerals(digits: [
        "零": 0, "〇": 0,
        "一": 1, "二": 2, "三": 3, "四": 4, "五": 5,
        "六": 6, "七": 7, "八": 8, "九": 9, "十": 10,
    ])

    /// Japanese era name to the offset added to its era year to get the Gregorian
    /// one. Source: chrono's JPStandardParser, which hardcodes these three.
    ///
    /// An era year counts from 1 within the reign, so the offset is (first
    /// Gregorian year - 1): Reiwa began in 2019, so 令和2年 is 2020 and the offset
    /// is 2018. Heisei began 1989 (平成26年 = 2014), Showa 1926 (昭和64年 = 1989).
    ///
    /// These deliberately do NOT live in `Vocabulary.eraOffsets`, even though the
    /// numbers would fit it. That field is read as a SUFFIX after a year, the
    /// shape "2555 BE" takes; a Japanese era is a PREFIX inside the 年月日
    /// construction, 平成26年. Position, not arithmetic, is what rules it out.
    /// Only the three eras chrono covers are listed - 大正 and 明治 are absent
    /// there and are not invented here, since nothing in the oracle exercises
    /// them and guessing at a fourth offset buys no verified behavior.
    static let eraOffsets: [String: Int] = [
        "令和": 2018,
        "平成": 1988,
        "昭和": 1925,
    ]

    /// Year words that mean the REFERENCE year rather than an offset from it:
    /// 同年 (the same year), 本年 and 今年 (this year). Source: chrono's
    /// JPStandardParser `[同今本]年` group, which assigns the reference year
    /// outright.
    ///
    /// This is a third kind of era-ish word and it fits neither `eraMarkers` (a
    /// sign) nor `eraOffsets` (an offset), because it is neither: it ASSIGNS.
    /// The difference is observable, not academic - 今年11月27日 is 2012-11-27
    /// against a 2012 reference, while a bare 11月27日 goes through
    /// closest-to-reference and can land in a different year entirely.
    static let referenceYearWords = "同今本"

    /// Casual day and time-of-day words, kanji and their kana spellings. Source:
    /// chrono's JPCasualDateParser, including its kana-to-kanji normalization,
    /// which is why each kana form maps to the same entry as its kanji.
    ///
    /// The three evening words are distinct in Japanese (今夜 tonight, 今夕 this
    /// evening, 今晩 this evening) and chrono routes all three to hour 22.
    static let casualWords: [String: JACasualDateParser.Reference] = [
        "今日": .today, "きょう": .today,
        "本日": .today, "ほんじつ": .today,
        "昨日": .yesterday, "きのう": .yesterday,
        "明日": .tomorrow, "あした": .tomorrow,
        "今夜": .evening, "こんや": .evening,
        "今夕": .evening, "こんゆう": .evening,
        "今晩": .evening, "こんばん": .evening,
        "今朝": .morning, "けさ": .morning,
    ]

    /// Weekday modifier prefixes. Source: chrono's JPWeekdayParser, which
    /// recognizes exactly these three and carries a TODO noting that 先週 (last
    /// week) and 来週 (next week) are NOT the same as last/next and are therefore
    /// unhandled. That gap is chrono's and is left in place rather than guessed
    /// at, since no oracle case covers it.
    static let weekdayModifiers: [String: Weekday.Modifier] = [
        "前の": .last,
        "次の": .next,
        "今週": .this_,
    ]
}
