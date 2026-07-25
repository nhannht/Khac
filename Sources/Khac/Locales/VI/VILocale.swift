// VILocale.swift - Vietnamese locale: vocabulary, patterns, and options.
//
// Data reimplemented from native Vietnamese knowledge; cross-checked against
// wanasit/chrono's Vietnamese behavior and test suite as a correctness oracle
// (chrono's source is not copied - see NOTICE). Deviates from chrono's own JS
// reference in two places where native review found chrono itself wrong, not
// merely different - see the comments on `relativeModifiers["này"]` and on
// `meridiem` below. Correctness wins over parity with chrono when they conflict.

import Foundation

public struct VILocale: KhacLocale {
    public let id: LocaleID = .vietnamese

    public init() {}

    public var vocabulary: Vocabulary {
        Vocabulary(
            weekdays: [
                // Value convention per engine's explicit live correction (checkpoint
                // 1 follow-up): chrono/JS numbering, Sunday=0 ... Saturday=6 - NOT
                // the "Monday=1...Sunday=7" reading the doc comment on
                // Vocabulary.weekdays literally states (engine confirmed that
                // comment is stale/wrong and superseded by this correction).
                // WeekdayParser stores this value in .weekday unchanged and
                // converts to Foundation's Calendar convention internally for its
                // own date math - this dict only carries chrono's raw numbering.
                "chủ nhật": 0, "cn": 0,
                "thứ hai": 1, "t2": 1,
                "thứ ba": 2, "t3": 2,
                "thứ tư": 3, "t4": 3,
                "thứ năm": 4, "t5": 4,
                "thứ sáu": 5, "t6": 5,
                "thứ bảy": 6, "t7": 6,
            ],
            months: [
                "tháng 1": 1, "tháng một": 1, "tháng giêng": 1,
                "tháng 2": 2, "tháng hai": 2,
                "tháng 3": 3, "tháng ba": 3,
                "tháng 4": 4, "tháng tư": 4,
                "tháng 5": 5, "tháng năm": 5,
                "tháng 6": 6, "tháng sáu": 6,
                "tháng 7": 7, "tháng bảy": 7,
                "tháng 8": 8, "tháng tám": 8,
                "tháng 9": 9, "tháng chín": 9,
                "tháng 10": 10, "tháng mười": 10,
                "tháng 11": 11, "tháng mười một": 11,
                "tháng 12": 12, "tháng mười hai": 12, "tháng chạp": 12,
            ],
            integerWords: [
                "một": 1, "hai": 2, "ba": 3, "bốn": 4, "năm": 5, "sáu": 6,
                "bảy": 7, "tám": 8, "chín": 9, "mười": 10, "mười một": 11, "mười hai": 12,
            ],
            // Empty: no VI date expression uses ordinal-of-month forms ("ngày 15",
            // never "ngày thứ 15"). Note for whoever writes a generic ordinal
            // parser: "thứ hai" is ALSO the Monday weekday name, so scanning VI
            // text for a "thứ N" ordinal pattern must not collide with weekdays.
            ordinals: [:],
            timeUnits: [
                "giây": .second,
                "phút": .minute,
                "giờ": .hour,
                "ngày": .day,
                "tuần": .weekOfYear,
                "tháng": .month,
                "năm": .year,
            ],
            relativeModifiers: [
                "sau": 1, "tới": 1, "tiếp": 1, "nữa": 1,
                "trước": -1, "qua": -1,
                // KHAC-FIX: chrono's own JS reference only reverses duration for
                // "trước"/"qua" and silently leaves "này" at the default +1, so
                // "tuần này" (this week) and "tuần sau" (next week) compute the
                // IDENTICAL date in chrono - a confirmed bug (native review: no
                // native speaker accepts this). Khac maps "này" to a REAL,
                // present, zero-offset entry: này = 0 (this/current period).
                //
                // This same entry is also a KHAC-FIX for a second, separate
                // chrono omission: chrono's own VIWeekdayParser.ts captures
                // "này" in its modifier regex but never gives it a
                // modifierType branch (only tới/sau->next and qua->last are
                // mapped), so chrono silently drops "này" on the floor -
                // treated as if no modifier were present at all. Khac's fix
                // is giving "này" a real, deterministic mapping (value 0 ->
                // Weekday.Modifier.this_) - that recognition is the
                // correction. The forward-only date math .this_ itself
                // produces is the pre-existing shared chrono convention,
                // used identically by every locale - Khac does not invent new
                // semantics there, only restores the missing recognition.
                "này": 0,
            ],
            dayReferences: [
                "hôm nay": 0,
                "hôm qua": -1,
                "hôm kia": -2,
                "ngày mai": 1,
                // KHAC-FIX: chrono only has "ngày mai", never bare "mai", which
                // silently breaks "sáng mai" (tomorrow morning, very common) -
                // "sáng" alone already implies TODAY, so bare "mai" going
                // unmatched leaves the day wrong. But bare "mai" as an
                // unconditional dayReferences entry is NOT safe: "Mai" is an
                // extremely common Vietnamese given name (also "hoa mai",
                // apricot blossom), and matching is case-insensitive, so a bare
                // entry would misread "Mai ơi, đợi tôi với" (a name/vocative) as
                // "tomorrow". Khac scopes the fix to the actual compound
                // phrases instead - each time-of-day word immediately followed
                // by "mai" as ONE dayReferences key - which fixes the reported
                // gap without the false-positive surface of a bare token. This
                // does not carry the hour (dayReferences is day-offset only);
                // the merge with CasualTimeParser's own "sáng"/"chiều"/etc.
                // match still supplies the implied hour, same mechanism as
                // "hôm nay buổi sáng". Do NOT add bare "kia"/"qua" either -
                // "qua" alone is genuinely ambiguous (come over / across / last
                // time), not just "yesterday".
                "sáng mai": 1, "trưa mai": 1, "chiều mai": 1,
                "tối mai": 1, "đêm mai": 1, "nửa đêm mai": 1,
                // KNOWN GAP, deliberate: "mai" and "kia" are structurally the
                // same suffix day-shift pattern attached to a time-of-day word
                // (nay=0/mai=+1/kia=+2, same shape as this/last/next attaching
                // to time-unit words in relativeModifiers) - review-vi caught
                // that "sáng kia" (day-after-tomorrow morning) has the
                // IDENTICAL silent-wrong-day bug as "sáng mai" did, and that
                // the compound-key fix above loses the HOUR (a confidently
                // wrong noon default, not just an absent value) because
                // TimeExpressionParser doesn't exist yet to merge with. Asked
                // engine whether an adjacency-gated day-shift token (mai/kia
                // recognized only right after a timeOfDay word, mirroring the
                // "sau khi" exclusion technique) is a cleaner generic fix than
                // more hardcoded compound entries. NOT adding "sáng kia" etc.
                // compounds until that's resolved - doubling down on the same
                // wrong-hour shape would compound the problem, not fix it.
                "ngày kia": 2,
                // "bây giờ"/"lúc này" moved OUT to patterns.nowWords - engine
                // added a dedicated PatternSet field for "now" words since they
                // resolve with different certainty semantics (full precision,
                // all clock components certain) than an ordinary day reference
                // (day certain, hour only implied). See `patterns` below.
            ],
            meridiem: [
                "sáng": .am,
                "chiều": .pm,
                "tối": .pm,
                // "trưa" (noon) and "đêm" (night) are DELIBERATELY excluded here -
                // both are hour-dependent (see meridiemHourRules below) and a word
                // in meridiemHourRules must not also appear in this flat table.
            ],
            timeOfDay: [
                // Standalone casual time-of-day (no explicit hour attached) -
                // unambiguous regardless of the hour-dependent issue above.
                "sáng sớm": (6, .am),
                "bình minh": (6, .am),
                "sáng": (9, .am),
                "trưa": (12, .pm),
                "chiều": (15, .pm),
                "tối": (19, .pm),
                "đêm": (22, .pm),
                "nửa đêm": (0, .am),
            ],
            meridiemHourRules: [
                // "1 giờ trưa" = 13:00, but 10, 11 and 12 are already in the noon
                // region and stay as stated. chrono's own VITimeExpressionParser
                // cuts this boundary at < 10, not < 11 (read from master source by
                // review-vi, not inferred): hours 1-9 take PM+12, 10 and 11 stay
                // AM, 12 is PM. Khac's table omitted 10, so "10 giờ trưa" resolved
                // to 22:00 - a time trưa never reaches, since it does not extend
                // into evening or night at all.
                //
                // Hours 2-9 keep the +12 baseline, matching chrono exactly. "8 giờ
                // trưa" = 20:00 is a stretch natively, but the input is rare and
                // the project rule is to follow chrono where native judgment is
                // uncertain. Hour 10 was not that case: it was simply wrong.
                "trưa": MeridiemHourRule(baseline: .pm, overrides: [10: 10, 11: 11, 12: 12]),
                // KHAC-FIX: chrono's own JS reference treats "đêm" uniformly like
                // chiều/tối (PM, +12 if hour<12), which wrongly reads "12 giờ đêm"
                // as noon and "1 giờ đêm" as 13:00. Native meaning (review-vi
                // confirmed all 5 values): đêm hours 1-4 and 12 are AM (deep night
                // / midnight, baseline .am: 12->0, else keep); only 8-11 are PM
                // (evening), explicit overrides. Hours 5-7 untested/rare in
                // natural speech.
                "đêm": MeridiemHourRule(baseline: .am, overrides: [8: 20, 9: 21, 10: 22, 11: 23]),
            ],
            eraMarkers: [
                // "Trước Công nguyên" = BC. Keys are lowercase per Vocabulary's
                // case-insensitive-matching contract.
                "tcn": -1,
            ]
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            timePrefixWords: ["lúc", "vào"],
            // ANSWERED: "ngày" needed its own field, not this one.
            // dateConnectorWords sits BETWEEN day and month ("3rd of March"),
            // whereas "ngày" sits BEFORE the day number - see dayMarkerWords
            // below. VI has no between-day-and-month connector, so this stays
            // empty.
            dateConnectorWords: [],
            clockHourWords: ["giờ"],
            clockMinuteWords: ["phút"],
            clockSecondWords: ["giây"],
            relativePastWords: ["trước", "qua"],
            // PREFIX only ("in"/"within" reading): "trong 3 ngày nữa" = in 3
            // days. The suffix reading ("sau"/"tới"/"tiếp"/"nữa" = "later"/
            // "next", attaches after the unit) is a separate field - see
            // futureSuffixWords below. Confirmed via engine's split of the
            // two directions into distinct PatternSet fields.
            relativeFutureWords: ["trong", "trong vòng"],
            futureSuffixWords: ["sau", "tới", "tiếp", "nữa"],
            rangeConnectorWords: ["đến", "tới", "và"],
            nowWords: ["bây giờ", "lúc này"],
            // E2 (engine, confirmed): leave EMPTY, do not add "vào". The VI
            // oracle excludes the preposition from the matched span ("vào
            // thứ hai" -> match text "thứ hai"), and per the field's own doc
            // comment an unlisted prefix is simply never matched - which is
            // exactly the wanted behavior here, not a gap.
            weekdayPrefixWords: [],
            // A6/A10 (engine): "năm" marks a following year both as the
            // connector inside a month-name date ("tháng 4 năm 1975") and as
            // the gate for a standalone year ("năm 1976"). Source-verified
            // against chrono's real VIMonthYearParser.ts/VIYearParser.ts -
            // "năm" is unconditionally sufficient in both roles; TCN only
            // gates the fully-bare digit form ("179 TCN" with no "năm").
            yearMarkerWords: ["năm"],
            // "sau khi" is the conjunction "after [clause]", not the modifier
            // "sau" (next) plus an unrelated word. Without this, "thứ hai sau
            // khi chiến tranh kết thúc" reads as next Monday and swallows "sau".
            weekdaySuffixExclusionWords: ["khi"],
            // "ngày" marks a following bare day number ("ngày 15 tháng 3").
            // Including it in the match keeps the reported span and index on the
            // whole phrase, and its presence is what lets an invalid marked day
            // ("ngày 0 tháng 4") reject outright instead of silently degrading
            // to a bare "tháng 4" with the day dropped.
            dayMarkerWords: ["ngày"],
            // "buổi" is the period-of-day particle: "buổi sáng" is the morning.
            // It must be consumed as part of the time-of-day token, or a day
            // anchor and the time split into two results with an unmatched word
            // stranded between them ("hôm nay buổi sáng").
            timeOfDayPrefixWords: ["buổi"]
        )
    }

    public var options: LocaleOptions {
        // weekdaySuffixModifier: true (engine, D1 landed) - lets a relative
        // modifier attach directly AFTER the weekday with no week-word
        // ("thứ hai tới" = next Monday, "thứ hai qua" = last Monday, "thứ hai
        // này" = this Monday). Requires relativeModifiers to carry tới/sau:+1,
        // qua/trước:-1, này:0 - already true above.
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2, weekdaySuffixModifier: true)
    }
}
