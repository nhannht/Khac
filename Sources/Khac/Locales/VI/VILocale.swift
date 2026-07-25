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
                // Bare "mai" is deliberately NOT here, and neither are the
                // "sáng mai" style compounds that used to be. "mai" is a day
                // shift attached to a time-of-day word and lives in
                // `dayShiftSuffixes` below; see the note there for why the
                // compound-key encoding was wrong rather than merely incomplete.
                //
                // Do NOT add bare "kia"/"qua" here either. "qua" alone is
                // genuinely ambiguous (come over / across / last time), not just
                // "yesterday".
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
            ],
            dayShiftSuffixes: [
                // KHAC-FIX: chrono has only "ngày mai", never a bare "mai", so
                // "sáng mai" (tomorrow morning, an everyday phrase) left "mai"
                // unmatched and answered with TODAY, since "sáng" alone implies
                // today.
                //
                // This was first fixed by adding "sáng mai", "trưa mai" and the
                // rest as whole `dayReferences` keys. That fixed the day and broke
                // the hour, which is worse: `dayReferences` carries a day offset
                // only, so the compound matched as one opaque token, took the
                // day-reference path, and inherited its CLOCK from the reference.
                // "sáng mai" asked at 20:00 answered 20:00 tomorrow. The comment
                // there claimed a merge with a separate "sáng" match would supply
                // the hour, but the compound key had already swallowed "sáng", so
                // no separate token survived for anything to merge with. Bare
                // phrases are the common case, so the fix missed nearly every
                // input it existed for.
                //
                // Two words carrying two facts are two tokens. "sáng" supplies the
                // hour through the ordinary time-of-day path, "mai" supplies the
                // day, and adjacency keeps bare "Mai" (a very common given name)
                // from ever matching alone.
                //
                // The second attempt made "mai" a suffix of the time-of-day match,
                // so "sáng mai" was one span. That fixed the bare phrase and lost a
                // stated hour: in "7 giờ sáng mai" both this parser and
                // TimeExpressionParser claimed "sáng", and a "sáng mai" carrying
                // three DERIVED certains beat a "7 giờ sáng" carrying two written
                // ones, answering 09:00 for a phrase that says 7. "mai" now matches
                // alone, reading the time-of-day word through a lookbehind instead
                // of eating it, and the date-time merge joins the halves.
                //
                // Keys are lowercase and matched case-sensitively; see the field's
                // own documentation for why case is load-bearing here.
                //
                // KNOWN GAP, deliberate: the gate is a preceding TIME-OF-DAY WORD,
                // so "8 giờ mai" and "15:30 mai" - a clock with no sáng/chiều/tối -
                // still answer TODAY. Both are ordinary Vietnamese and both are
                // wrong today. Widening the gate to any preceding TIME result would
                // fix them, and was measured before being declined: a bare relative
                // like "2 tuần nữa" has no certain calendar field either, so it
                // passes the same test and "2 tuần nữa mai" would silently move
                // from day 24 to tomorrow. Closing this needs a gate that separates
                // a clock from a resolved shift, which the certain/implied model
                // does not currently express - not a wider version of this one.
                "mai": 1,
                // "sáng kia" = day-after-tomorrow morning. The FORWARD reading is a
                // deliberate product decision, not a verified linguistic fact, and
                // it is recorded as such. Unlike "ngày kia" / "hôm kia", where the
                // head noun lexicalizes direction, "sáng"/"chiều"/"tối" carry none
                // of their own - compare "hôm qua buổi sáng", "sáng nay", "sáng
                // mai" - and chrono has no equivalent to follow. review-vi leaned
                // forward at moderate confidence and declined to rule it alone.
                // Chosen because it matches the "mai" symmetry a reader already
                // expects; the phrase previously parsed as bare "sáng" and
                // answered TODAY, which was wrong under either reading.
                "kia": 2,
                // NOT added: "qua" (-1). "tối qua" / "đêm qua" ("last night") are
                // more frequent than the "kia" family, so the gap is real and
                // worth closing - but "qua" is also an ordinary movement verb ("đi
                // qua", "qua nhà ai đó"), and Vietnamese drops subjects freely, so
                // "chiều qua nhà bạn chơi" (in the afternoon, went over to a
                // friend's place) has the identical shape to the temporal reading.
                // The case-sensitivity that separates "Mai" from "mai" does NOT
                // transfer, because "qua" is not a proper noun and is lowercase in
                // both readings. Needs its own analysis, not a copy of this entry.
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
            // "mùng"/"mồng" mark the same slot for the first days of a month
            // ("mùng 2 tháng 9", National Day). They are NOT lunar-only: those are
            // ordinary solar-calendar dates in everyday use. Native usage stops at
            // about day 10, which needs no range plumbing - a larger number simply
            // does not occur, and treating it as an ordinary marked day is
            // harmless. Both spellings are current; neither is a typo of the other.
            dayMarkerWords: ["ngày", "mùng", "mồng"],
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
