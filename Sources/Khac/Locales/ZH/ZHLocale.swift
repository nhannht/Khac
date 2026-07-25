// ZHLocale.swift - Chinese locale data for Khac, both scripts in ONE locale.
//
// Everything JALocale.swift says about why CJK cannot use the generic parsers
// applies here and is not repeated: the `\p{L}` boundary guards reject 71 of the
// 138 ZH oracle cases whose span is asserted, before any question of numerals.
// The parsers are bespoke, through additionalParsers. See ZHParsers.swift.
//
// ONE LOCALE, TWO SCRIPTS - the decision worth recording
//
// chrono ships zh.hans and zh.hant as separate sub-locales, and Khac's LocaleID
// has a single `.chinese`. Three lines of evidence say one locale carrying the
// UNION of both vocabularies is correct rather than merely convenient:
//
//  1. The code points are disjoint pairs, so the union is unambiguous. 两/兩,
//     后/後, 礼/禮, 钟/鐘, 几/幾, 点/點, 时/時, 号/號, 内/內, 过/過, 从/從, 周/週,
//     个/個. Not one character means one thing in Simplified and another in
//     Traditional. chrono's own WEEKDAY_OFFSET tables are byte-identical between
//     the two, and so are both numeral functions.
//  2. The oracle agrees. Only 6 of the 168 cases have an input that is
//     byte-identical across the two script tables (3天前, 今日夜晚, 六月四日3:00am,
//     星期一, 星期四, 星期六-星期一) and all 6 assert the SAME answer, so one
//     locale has no conflicting requirement to satisfy anywhere in the corpus.
//  3. chrono ALREADY does this. src/locales/zh/index.ts - the root `chrono.zh` -
//     registers the Hant and Hans parsers side by side in one configuration and
//     runs them against one set of refiners. So a combined locale is chrono's own
//     shape for `zh`, not an invention here.
//
// Since the two scripts' words are disjoint, ONE parser per family reading the
// union is equivalent to running chrono's two parsers per family, and is the
// simpler of the two.
//
// This also follows the EN precedent: chrono's en.GB day-first variant was
// deferred and documented rather than modeled as a second English locale.
//
// WHAT THE UNION ADDS, over each script alone
//
// The union is a deliberate permissive superset, labeled here the way ENLocale
// labels its own supersets. Reading Simplified text, it additionally accepts the
// Cantonese words 聽 尋 琴 朝 晏 and the numerals 廿 卅; reading Traditional text
// it additionally accepts 〇, which chrono's hant NUMBER table omits while its
// hans table has it. Every one of those is a character the other script does not
// use for anything else, so accepting it costs no correct reading.
//
// One further union: chrono's root `zh` omits both AgoFormatParsers and registers
// only the Hant casual parser, because its sub-locales carry those. The oracle's
// hans cases were produced against `chrono.zh.hans` and its hant cases against
// `chrono.zh.hant`, so this locale takes the union of the SUB-locales - all seven
// families - rather than the narrower root configuration.

import Foundation

public struct ZHLocale: KhacLocale {
    public let id: LocaleID = .chinese

    public init() {}

    /// Deliberately empty, for the reasons in JALocale.swift. Every Chinese word
    /// is read by a bespoke parser.
    public var vocabulary: Vocabulary {
        Vocabulary()
    }

    public var patterns: PatternSet {
        PatternSet(
            // Source: chrono's ZHHans/ZHHantMergeDateRangeRefiner, both
            // `/^\s*(至|到|-|~|～|－|ー)\s*$/i`. "-" and "~" are built into Khac's
            // range check already, so only the words and full-width forms are
            // listed. ー is U+30FC and 〜 is U+301C, both used as dashes in real
            // input; 〜 is not in that refiner but IS in the zh time parser's own
            // range alternation, so it is accepted here for the same reason as in
            // Japanese - a date range should not disagree with a time range about
            // which wave dash is a dash.
            rangeConnectorWords: ["至", "到", "～", "〜", "ー", "－"]
            // dateTimeGlueWords is deliberately EMPTY: chrono's zh date-time glue
            // is `/^\s*$/` - nothing but whitespace - and the shared refiner's
            // glue check already accepts an empty gap. Chinese needs no particle
            // between a date and a time, unlike Japanese の.
        )
    }

    /// Chinese writes dates big-endian (year, month, day) with explicit 年月日
    /// markers, so a bare two-field numeric date is month-first by the same
    /// reasoning as Japanese. Nothing in the corpus exercises it - every Chinese
    /// date carries its markers - so this is a considered default rather than a
    /// measured one. weekStart is left at the package default; chrono's zh locale
    /// does not use it and no case depends on it.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .monthDay)
    }

    /// The whole of Chinese date and time grammar - see ZHParsers.swift. The union
    /// of chrono's seven zh.hans and seven zh.hant parsers, one per family.
    public var additionalParsers: [Parser] {
        [
            ZHDateParser(),
            ZHRelationWeekdayParser(),
            ZHWeekdayParser(),
            ZHTimeExpressionParser(),
            ZHDeadlineParser(),
            ZHAgoParser(),
            ZHCasualDateParser(),
        ]
    }
}

// MARK: - Chinese data the bespoke parsers read
//
// Every table below is the UNION of chrono's zh.hans and zh.hant constants and
// inline pattern alternations, with the provenance of each addition noted.

extension ZHLocale {
    /// CJK digit characters. Source: the union of chrono's hans and hant NUMBER
    /// tables. hans contributes 〇 and 两; hant contributes 兩, 廿 (20) and 卅 (30).
    /// 廿 and 卅 are ordinary table entries rather than special rules, so 廿六
    /// adds to 26 through the same additive reading as 二十六.
    static let numerals = CJKNumerals(digits: [
        "零": 0, "〇": 0,
        "一": 1,
        "二": 2, "两": 2, "兩": 2,
        "三": 3, "四": 4, "五": 5, "六": 6, "七": 7, "八": 8, "九": 9,
        "十": 10, "廿": 20, "卅": 30,
    ])

    /// Weekday character to the chrono/JS weekday number (0 = Sunday). Source:
    /// chrono's zh WEEKDAY_OFFSET, byte-identical between the two scripts, which
    /// is itself part of the evidence for one locale. 天 and 日 both mean Sunday
    /// in this position (星期天 and 星期日).
    static let weekdays: [String: Int] = [
        "天": 0, "日": 0,
        "一": 1, "二": 2, "三": 3, "四": 4, "五": 5, "六": 6,
    ]

    /// The words for "week" that precede a weekday number. Union of hans
    /// 星期|礼拜|周 and hant 星期|禮拜|週.
    static let weekWords = ["星期", "礼拜", "禮拜", "周", "週"]

    /// Relative-week prefixes. Union of hans 上|下|这 and hant 上|下|這|今|呢, the
    /// last two being Cantonese "this". Note the hans parser has no "this
    /// week" synonym beyond 这 and the hant one has three.
    static let weekModifiers: [String: ZHWeekdayModifier] = [
        "上": .last,
        "下": .next,
        "这": .this_, "這": .this_, "今": .this_, "呢": .this_,
    ]

    /// Relative DAY words and their day offset. Union of hans
    /// 今|明|前|大前|后|大后|昨 and hant 今|明|前|大前|後|大後|聽|昨|尋|琴. The
    /// Cantonese additions are 聽 (tomorrow, same as 明) and 尋/琴 (yesterday,
    /// same as 昨); 后/後 and 大后/大後 are the two scripts' spellings of the same
    /// words.
    static let dayWords: [String: Int] = [
        "今": 0,
        "明": 1, "聽": 1,
        "昨": -1, "尋": -1, "琴": -1,
        "前": -2, "大前": -3,
        "后": 2, "後": 2,
        "大后": 3, "大後": 3,
    ]

    /// The day words that chrono guards with a late-night check: before 2 AM,
    /// "tomorrow" is still the current calendar day, so the +1 is skipped. Only
    /// the tomorrow words carry it, and only in some slots - see
    /// ZHParsers.swift, which reproduces chrono's inconsistency rather than
    /// tidying it.
    static let lateNightGuardedDayWords: Set<String> = ["明", "聽"]

    /// Time-of-day words. Union of hans
    /// 上午|早上|下午|晚上|夜晚|夜|中午|凌晨 and hant's superset, which adds the
    /// Cantonese 上晝, 朝早, 下晝 and 晏晝.
    static let timeOfDayWords = [
        "上午", "上晝", "朝早", "早上", "下午", "下晝", "晏晝",
        "晚上", "夜晚", "夜", "中午", "凌晨",
    ]

    /// Single-character time-of-day words that attach directly to a day word:
    /// 今早, 今晚, 今朝. Union of hans 早|晚 and hant 早|朝|晚 - though note the
    /// hans PATTERN lists 朝 too while its extract ignores it, so 朝 is
    /// pattern-present and semantics-absent on the Simplified side in chrono. The
    /// union gives it the Cantonese meaning everywhere.
    static let shortTimeOfDayWords = ["早", "朝", "晚"]

    /// A time-of-day word's implied clock, keyed by its FIRST character, which is
    /// how chrono dispatches. Used by the CASUAL parser, where the word supplies
    /// the whole clock rather than modifying a stated hour.
    ///
    /// Source: the union of the two casual parsers' branches. 凌 (凌晨, small
    /// hours) is hour 0 with no meridiem, which is why the value is optional
    /// rather than defaulted.
    static let timeOfDayClocks: [Character: (hour: Int, meridiem: Meridiem?)] = [
        "早": (6, nil), "朝": (6, nil), "上": (6, nil),
        "下": (15, .pm), "晏": (15, .pm),
        "中": (12, .pm),
        "夜": (22, .pm), "晚": (22, .pm),
        "凌": (0, nil),
    ]

    /// A time-of-day word's meridiem, keyed by its first character. Used by the
    /// TIME parser, where a stated hour is present and the word only says which
    /// half of the day it belongs to.
    ///
    /// 夜 and 中 are deliberately ABSENT rather than mapped: chrono's time parser
    /// has no branch for them, so a stated hour beside 夜晚 or 中午 keeps whatever
    /// the 24-hour reading gave it. That is why 中午12点 is hour 12 - the 12 makes
    /// it pm on its own, not the 中午.
    static let timeOfDayMeridiems: [Character: Meridiem] = [
        "上": .am, "朝": .am, "早": .am, "凌": .am,
        "下": .pm, "晏": .pm, "晚": .pm,
    ]

    /// Words meaning the current instant. Union of hans 现在|立刻|立即|即刻 and
    /// hant 而家|立刻|立即|即刻 (而家 is Cantonese "now").
    static let nowWords = ["现在", "而家", "立刻", "立即", "即刻"]

    /// Optional prefix introducing a starting time: "from". Union of hans 从|自
    /// and hant 由|從|自.
    static let fromWords = ["从", "自", "由", "從"]

    /// Clock hour markers as a regex fragment, union of hans 点|时 and hant 點|時.
    ///
    /// A fragment rather than a word list because 时 and 時 need a lookahead that a
    /// plain alternation cannot carry: 时间 and 時間 are the NOUN "time", not a
    /// clock hour, so a 时/時 followed by 间/間 is not an hour marker. Without the
    /// guard `1時間` (Japanese for "one hour", a duration) reads as 1 o'clock.
    ///
    /// chrono's ja carries exactly this guard, written `時(?!間)`; its zh omits it,
    /// because chrono's zh is never asked to parse text its ja might also see.
    /// Under one engine both locales read the same string, so the guard has to be
    /// on both. It is not merely an accommodation for Japanese - 時間 is a single
    /// word in Chinese too, and reading a clock hour out of it is wrong in either
    /// language. 点 and 點 need no guard; they are unambiguous.
    static let hourMarkerPattern = "(?:点|點|(?:时|時)(?!间|間))"

    /// Duration units to the calendar component they count. Union of the hans and
    /// hant Ago and Deadline patterns, which dispatch on the unit's FIRST
    /// character: 日/天 day, 星/礼/禮 week, 月 month, 年 year, 秒 second, 分
    /// minute, 小/钟/鐘 hour.
    ///
    /// Keyed by the whole word so the alternation is built longest-first and 分钟
    /// cannot be shadowed by a shorter entry. 钟/鐘 alone means an hour (个钟 is
    /// "an hour"), while 分钟/分鐘 is a minute and 秒钟/秒鐘 a second - so the
    /// longest-first ordering is load bearing, not cosmetic.
    static let durationUnits: [String: Calendar.Component] = [
        "秒钟": .second, "秒鐘": .second, "秒": .second,
        "分钟": .minute, "分鐘": .minute,
        "小时": .hour, "小時": .hour, "钟": .hour, "鐘": .hour,
        "日": .day, "天": .day,
        "星期": .weekOfYear, "礼拜": .weekOfYear, "禮拜": .weekOfYear,
        "月": .month,
        "年": .year,
    ]

    /// Vague counts that stand in for a number in a duration. Source: chrono's
    /// Ago and Deadline parsers, which read 几/幾 as 3 and 半 as 0.5. Fractional
    /// on purpose: 半小时 is 30 minutes, so a whole-number table could not express
    /// it.
    static let durationQuantifiers: [String: Double] = [
        "几": 3, "幾": 3, "半": 0.5,
    ]
}

/// A relative-week modifier. Chinese does NOT share the shared engine's weekday
/// arithmetic, so this is its own type rather than `Weekday.Modifier`: chrono's zh
/// parsers compute a different day for the same words. From a Friday reference,
/// 上个礼拜三 (last Wednesday) is 9 days back in chrono's zh, where the shared
/// `Weekday.daysToWeekday` gives 2. See ZHParsers.swift.
enum ZHWeekdayModifier {
    case last
    case next
    case this_
}
