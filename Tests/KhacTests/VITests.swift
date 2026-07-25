// VITests.swift - Vietnamese locale oracle tests.
//
// Cases ported from wanasit/chrono's real test/vi/*.test.ts suite (fetched from
// github.com/wanasit/chrono, not copied source - see NOTICE) plus native-added
// cases where chrono's own JS reference was found wrong by native review (see
// inline notes). Every expected value is native-verified, not merely ported.
//
// Section letters (A-P) mirror the chrono source file that seeded them; native
// additions are marked N.

import XCTest
@testable import Khac

final class VITests: XCTestCase {
    // MARK: - Helpers

    private func ref(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12, _ mi: Int = 0, _ s: Int = 0, _ ms: Int = 0) -> ReferencePoint {
        var comps = DateComponents()
        comps.year = y; comps.month = m; comps.day = d
        comps.hour = h; comps.minute = mi; comps.second = s
        comps.nanosecond = ms * 1_000_000
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh") ?? .current
        let date = cal.date(from: comps)!
        return ReferencePoint(instant: date, calendar: cal)
    }

    private func parseVI(
        _ text: String,
        _ reference: ReferencePoint,
        mode: Options.Mode = .casual,
        forwardDate: Bool = false
    ) -> [ParsedResult] {
        Khac(localeInstances: [VILocale()]).parse(text, reference: reference, options: Options(mode: mode, forwardDate: forwardDate))
    }

    private func single(
        _ text: String,
        _ reference: ReferencePoint,
        mode: Options.Mode = .casual,
        forwardDate: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ParsedResult? {
        let results = parseVI(text, reference, mode: mode, forwardDate: forwardDate)
        XCTAssertEqual(results.count, 1, "expected exactly 1 result for '\(text)', got \(results.count)", file: file, line: line)
        return results.first
    }

    private func assertNoResult(_ text: String, _ reference: ReferencePoint, mode: Options.Mode = .casual, file: StaticString = #filePath, line: UInt = #line) {
        let results = parseVI(text, reference, mode: mode)
        XCTAssertTrue(results.isEmpty, "expected no result for '\(text)', got \(results)", file: file, line: line)
    }

    // MARK: - A. Casual day references

    func testCasualHomNay() {
        let r = single("Cuộc hẹn hôm nay.", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.index, 9)
        XCTAssertEqual(r?.text, "hôm nay")
        XCTAssertEqual(r?.start.get(.year), 2012)
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertEqual(r?.start.get(.day), 10)
    }

    func testCasualHomQua() {
        let r = single("Hội nghị hôm qua.", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.index, 9)
        XCTAssertEqual(r?.text, "hôm qua")
        XCTAssertEqual(r?.start.get(.year), 2012)
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertEqual(r?.start.get(.day), 9)

        let r2 = single("hôm qua", ref(2012, 8, 1, 12))
        XCTAssertEqual(r2?.start.get(.month), 7) // crosses month boundary backward
        XCTAssertEqual(r2?.start.get(.day), 31)
    }

    func testCasualNgayMai() {
        let r = single("Lịch ngày mai.", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.index, 5)
        XCTAssertEqual(r?.text, "ngày mai")
        XCTAssertEqual(r?.start.get(.day), 11)
        XCTAssertEqual(r?.start.get(.month), 8)

        let r2 = single("ngày mai", ref(2012, 8, 31, 12))
        XCTAssertEqual(r2?.start.get(.month), 9) // crosses month boundary forward
        XCTAssertEqual(r2?.start.get(.day), 1)
    }

    func testCasualNgayKia() {
        let r = single("ngày kia", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.text, "ngày kia")
        XCTAssertEqual(r?.start.get(.day), 12)
    }

    func testCasualHomKia() {
        let r = single("hôm kia", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.year), 2012)
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertEqual(r?.start.get(.day), 8) // 10 - 2
    }

    func testCasualBayGioLucNay() {
        let r = single("bây giờ", ref(2012, 8, 10, 8, 9, 10, 11))
        XCTAssertEqual(r?.start.get(.hour), 8)
        XCTAssertEqual(r?.start.get(.minute), 9)
        XCTAssertEqual(r?.start.get(.second), 10)

        let r2 = single("lúc này", ref(2012, 8, 10, 8, 9, 10, 11))
        XCTAssertEqual(r2?.start.get(.hour), 8)
    }

    // KHAC-FIX: chrono's reference only has "ngày mai", never bare "mai",
    // which silently breaks "sáng mai" (tomorrow morning, very common - "sáng"
    // alone already implies TODAY). Khac does NOT add bare "mai" as an
    // unconditional dayReferences entry - "Mai" is an extremely common
    // Vietnamese given name, and case-insensitive matching would misread it as
    // "tomorrow" in any sentence naming that person. Instead Khac adds the
    // compound phrase "sáng mai" (and its siblings: trưa/chiều/tối/đêm/nửa đêm
    // mai) as its own dayReferences key, scoping the fix to the actual
    // compound rather than a bare token.
    //
    // OPEN QUESTION for engine (day is asserted below, hour deliberately is
    // not): dayReferences only carries a day offset, not an hour. Whether "sáng
    // mai" ALSO ends up with hour=9 (from CasualTimeParser's separate "sáng"
    // match merging in) or defaults to the seeded implied hour (noon) depends
    // on whether the overlap filter treats the longer "sáng mai" dayReferences
    // match and the shorter "sáng" timeOfDay match as competitors (one wins,
    // hour=9 is lost) or lets a merge refiner combine them (hour=9 preserved).
    // Not asserting hour until that is confirmed - asserting it wrong would be
    // worse than not asserting it.
    func testCasualCompoundMai() {
        let r = single("sáng mai", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.day), 11) // tomorrow, not today - this part is unconditionally correct
    }

    func testCasualIsCertain() {
        let r = single("hôm nay", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.isCertain(.day), true)
        XCTAssertEqual(r?.start.isCertain(.month), true)
        XCTAssertEqual(r?.start.isCertain(.year), true)
        XCTAssertEqual(r?.start.isCertain(.hour), false)
    }

    // MARK: - B. Casual time-of-day

    func testCasualTimeOfDay() {
        let r0 = ref(2012, 8, 10, 12)

        XCTAssertEqual(single("buổi trưa", r0)?.start.get(.hour), 12)
        XCTAssertEqual(single("buổi chiều", r0)?.start.get(.hour), 15)
        XCTAssertEqual(single("buổi tối", r0)?.start.get(.hour), 19)
        XCTAssertEqual(single("buổi đêm", r0)?.start.get(.hour), 22)
        XCTAssertEqual(single("đêm", r0)?.start.get(.hour), 22) // bare, no "buổi" prefix
        XCTAssertEqual(single("nửa đêm", r0)?.start.get(.hour), 0)
        XCTAssertEqual(single("bình minh", r0)?.start.get(.hour), 6)
        XCTAssertEqual(single("sáng sớm", r0)?.start.get(.hour), 6)

        let morning = single("hôm nay buổi sáng", ref(2012, 8, 10, 6))
        XCTAssertEqual(morning?.start.get(.hour), 9)
        XCTAssertEqual(morning?.start.get(.meridiem), Meridiem.am.rawValue)

        let merged = single("hôm nay buổi chiều", r0)
        XCTAssertEqual(merged?.start.get(.day), 10)
        XCTAssertEqual(merged?.start.get(.hour), 15)
    }

    // MARK: - C. Explicit time expressions

    func testTimeLucGio() {
        let r0 = ref(2012, 8, 10, 12)
        let r = single("Cuộc hẹn lúc 7 giờ.", r0)
        XCTAssertEqual(r?.index, 9)
        XCTAssertEqual(r?.text, "lúc 7 giờ")
        XCTAssertEqual(r?.start.get(.hour), 7)
        XCTAssertEqual(r?.start.get(.minute), 0)

        XCTAssertEqual(single("7 giờ sáng", r0)?.start.get(.hour), 7)
        XCTAssertEqual(single("7 giờ tối", r0)?.start.get(.hour), 19)
    }

    func testTimeGioPhut() {
        let r0 = ref(2012, 8, 10, 12)
        let r = single("lúc 7 giờ 30 phút", r0)
        XCTAssertEqual(r?.start.get(.hour), 7)
        XCTAssertEqual(r?.start.get(.minute), 30)

        let r2 = single("vào 15 giờ 45 phút", r0)
        XCTAssertEqual(r2?.start.get(.hour), 15)
        XCTAssertEqual(r2?.start.get(.minute), 45)
    }

    func testTimeColonFormat() {
        let r = single("Hẹn lúc 15:30.", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.hour), 15)
        XCTAssertEqual(r?.start.get(.minute), 30)
    }

    func testDateTimeCombined() {
        let r = single("ngày 30 tháng 4 năm 1975 lúc 11 giờ", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.day), 30)
        XCTAssertEqual(r?.start.get(.month), 4)
        XCTAssertEqual(r?.start.get(.year), 1975)
        XCTAssertEqual(r?.start.get(.hour), 11)
    }

    func testMeridiemSangChieuToi() {
        let r0 = ref(2012, 8, 10, 12)
        XCTAssertEqual(single("9 giờ sáng", r0)?.start.get(.hour), 9)
        XCTAssertEqual(single("3 giờ chiều", r0)?.start.get(.hour), 15)
        XCTAssertEqual(single("10 giờ đêm", r0)?.start.get(.hour), 22)
    }

    // "trưa" noon-region branch. This was described as ported from chrono as-is,
    // and it was not: chrono cuts the AM boundary at hour < 10, Khac's table
    // started it at 11, so hour 10 fell through to the PM baseline and "10 giờ
    // trưa" resolved to 22:00. review-vi caught it against chrono's real master
    // source, and it is wrong natively too - trưa never reaches evening or night.
    // Hour 10 is now covered here so the boundary cannot silently move again.
    func testMeridiemTruaNoonRegion() {
        let r0 = ref(2012, 8, 10, 12)

        let r1 = single("1 giờ trưa", r0)
        XCTAssertEqual(r1?.start.get(.hour), 13)
        XCTAssertEqual(r1?.start.get(.meridiem), Meridiem.pm.rawValue)

        let r10 = single("10 giờ trưa", r0)
        XCTAssertEqual(r10?.start.get(.hour), 10, "10 giờ trưa is late morning, never 22:00")
        XCTAssertEqual(r10?.start.get(.meridiem), Meridiem.am.rawValue)

        let r2 = single("11 giờ trưa", r0)
        XCTAssertEqual(r2?.start.get(.hour), 11)
        XCTAssertEqual(r2?.start.get(.meridiem), Meridiem.am.rawValue)

        let r3 = single("12 giờ trưa", r0)
        XCTAssertEqual(r3?.start.get(.hour), 12)
        XCTAssertEqual(r3?.start.get(.meridiem), Meridiem.pm.rawValue)
    }

    // review-vi: "N giờ buổi X" resolves correctly, but by an undocumented
    // two-step that no test protected. VI leaves timeOfDayConnectorWords unset, so
    // TimeExpressionParser cannot swallow "buổi" between the numeral and the
    // trailing time-of-day word. Instead "7 giờ" parses alone with a certain hour
    // and no meridiem, "buổi tối" parses alone as an implied PM, and
    // MergeDateTimeRefiner's pm-promotion recombines them. Correct today, but it
    // rests entirely on merge classification and ranking, which this session
    // rewrote wholesale - so it gets an explicit guard.
    func testNumericHourWithBuoiTimeOfDay() {
        let r0 = ref(2012, 8, 10, 12)
        XCTAssertEqual(single("7 giờ buổi tối", r0)?.start.get(.hour), 19)
        XCTAssertEqual(single("3 giờ buổi sáng", r0)?.start.get(.hour), 3)
    }

    func testMeridiemSangMidnight() {
        let r = single("12 giờ sáng", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.hour), 0)
        XCTAssertEqual(r?.start.get(.meridiem), Meridiem.am.rawValue)
    }

    // KHAC-FIX: chrono's own reference treats "đêm" uniformly like chiều/tối
    // (PM, +12 if hour<12), which wrongly reads "12 giờ đêm" as noon and "1
    // giờ đêm" as 13:00. Native meaning (review-vi confirmed all 5 values):
    // đêm hours 1-4 and 12 are AM (deep night / midnight); only 8-11 are PM.
    // Hours 5-7 are deliberately NOT asserted (rare/uncertain in natural
    // speech - see scratchpad/vi-oracle-cases-draft.md N1d). Depends on
    // engine's meridiemHourRules (or equivalent) landing - currently expected
    // to fail since TimeExpressionParser is still a stub.
    func testMeridiemDemBoundaryCorrected() {
        let r0 = ref(2012, 8, 10, 12)

        let midnight = single("12 giờ đêm", r0)
        XCTAssertEqual(midnight?.start.get(.hour), 0, "12 giờ đêm = midnight, not noon")
        XCTAssertEqual(midnight?.start.get(.meridiem), Meridiem.am.rawValue)

        let oneAM = single("1 giờ đêm", r0)
        XCTAssertEqual(oneAM?.start.get(.hour), 1, "1 giờ đêm = 1am, not 13:00")
        XCTAssertEqual(oneAM?.start.get(.meridiem), Meridiem.am.rawValue)

        let fourAM = single("4 giờ đêm", r0)
        XCTAssertEqual(fourAM?.start.get(.hour), 4)
        XCTAssertEqual(fourAM?.start.get(.meridiem), Meridiem.am.rawValue)

        let eightPM = single("8 giờ đêm", r0)
        XCTAssertEqual(eightPM?.start.get(.hour), 20)
        XCTAssertEqual(eightPM?.start.get(.meridiem), Meridiem.pm.rawValue)
    }

    func testIsCertainHourMeridiem() {
        let r0 = ref(2012, 8, 10, 12)
        let r1 = single("lúc 7 giờ", r0)
        XCTAssertEqual(r1?.start.isCertain(.hour), true)
        XCTAssertEqual(r1?.start.isCertain(.meridiem), false)

        let r2 = single("7 giờ sáng", r0)
        XCTAssertEqual(r2?.start.isCertain(.hour), true)
        XCTAssertEqual(r2?.start.isCertain(.meridiem), true)
    }

    // MARK: - D. Weekday

    // REF: Thursday 2012-08-09
    private var weekdayRef: ReferencePoint { ref(2012, 8, 9, 12) }

    func testWeekdayFullNames() {
        let r0 = weekdayRef
        let r = single("Hẹn vào thứ hai", r0)
        XCTAssertEqual(r?.index, 8)
        XCTAssertEqual(r?.start.get(.weekday), 1)

        XCTAssertEqual(single("thứ ba", r0)?.start.get(.weekday), 2)
        XCTAssertEqual(single("thứ tư", r0)?.start.get(.weekday), 3)
        XCTAssertEqual(single("thứ năm", r0)?.start.get(.weekday), 4)
        XCTAssertEqual(single("thứ sáu", r0)?.start.get(.weekday), 5)
        XCTAssertEqual(single("thứ bảy", r0)?.start.get(.weekday), 6)

        // Sunday: chrono/JS numbering per engine's explicit correction -
        // Sunday=0, NOT 7. See VILocale.vocabulary.weekdays comment.
        XCTAssertEqual(single("chủ nhật", r0)?.start.get(.weekday), 0)
    }

    func testWeekdayAbbreviations() {
        let r0 = weekdayRef
        let r = single("Hẹn t2", r0)
        XCTAssertEqual(r?.index, 4)
        XCTAssertEqual(r?.start.get(.weekday), 1)

        XCTAssertEqual(single("t7", r0)?.start.get(.weekday), 6)
        XCTAssertEqual(single("cn", r0)?.start.get(.weekday), 0) // Sunday abbreviation - see note above
    }

    func testWeekdayImpliesDate() {
        let r = single("thứ hai tới", weekdayRef)
        XCTAssertEqual(r?.start.get(.weekday), 1)
        XCTAssertEqual(r?.start.isCertain(.day), false) // implied, not certain
    }

    func testWeekdayNextModifiers() {
        let r0 = weekdayRef // Thu 2012-08-09; next Monday = 2012-08-13
        let r1 = single("thứ hai tới", r0)
        XCTAssertEqual(r1?.start.get(.weekday), 1)
        XCTAssertEqual(r1?.start.get(.day), 13)

        let r2 = single("thứ hai sau", r0)
        XCTAssertEqual(r2?.start.get(.weekday), 1)
        XCTAssertEqual(r2?.start.get(.day), 13)
    }

    func testWeekdayLastModifier() {
        // REF Thu 2012-08-09; last Monday = 2012-08-06
        // D1 landed (WeekdayParser's suffix-modifier slot): "qua" is now
        // genuinely captured as a bare suffix modifier (-1), not a
        // coincidental nearest-occurrence fallback as before D1. Re-verified
        // passing for the real reason.
        let r = single("thứ hai qua", weekdayRef)
        XCTAssertEqual(r?.start.get(.weekday), 1)
        XCTAssertEqual(r?.start.get(.day), 6)
    }

    // "sau khi" is a conjunction ("after when"), not "sau" (next) + "khi". Must
    // not consume "sau" as a weekday modifier.
    // REGRESSION (post-D1, confirmed by test run, reported to engine): now
    // that the suffix-modifier slot exists and is load-bearing, "sau" IS
    // being captured as a suffix modifier before the "khi" exclusion check
    // applies, so the match wrongly extends to "thứ hai sau". This guard is
    // no longer passing vacuously - it is genuinely broken. Fix is
    // engine-owned (WeekdayParser's suffix-modifier vs. exclusion-guard
    // ordering), not something VILocale data can patch around.
    func testWeekdaySauKhiGuard() {
        let results = parseVI("thứ hai sau khi chiến tranh kết thúc", ref(2012, 8, 10, 12))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.text, "thứ hai")
    }

    // Native addition: same guard on a different weekday, confirming it is not
    // hardcoded to "hai". Same post-D1 regression as above.
    func testWeekdaySauKhiGuardOtherWeekday() {
        let results = parseVI("gặp nhau thứ ba sau khi họp xong", ref(2012, 8, 10, 12))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.text, "thứ ba")
    }

    // review-vi: the guard is implemented as an exclusion applied to WHICHEVER
    // modifier matched, not as a special case for "sau", so it already covers
    // every modifier followed by "khi". "trước khi" is at least as common in real
    // Vietnamese as "sau khi", and "tới khi" occurs too, but only "sau khi" was
    // tested - so narrowing the exclusion back to "sau" specifically would have
    // regressed both with nothing to catch it.
    func testWeekdayTruocKhiGuard() {
        let results = parseVI("thứ hai trước khi đi công tác", ref(2012, 8, 10, 12))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.text, "thứ hai")
    }

    func testWeekdayToiKhiGuard() {
        let results = parseVI("thứ hai tới khi có tin báo", ref(2012, 8, 10, 12))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.text, "thứ hai")
    }

    // KHAC-FIX: chrono's own VIWeekdayParser.ts captures "này" in its modifier
    // regex but never gives it a modifierType branch (only tới/sau/qua are
    // mapped), so chrono silently drops it and resolves as if no modifier were
    // present. Khac maps "này" to Weekday.Modifier.this_, a real and
    // deterministic mapping. The forward-only RESOLUTION that .this_ produces is
    // chrono's pre-existing shared convention rather than something Khac
    // invented: Vietnamese marks tense with đã/sẽ rather than on the date phrase,
    // so "thứ Hai này" is exactly as forward/backward-ambiguous as English "this
    // Monday", and no VI-specific reason to diverge survives scrutiny.
    //
    // The day assertion was deferred across several sessions while WeekdayParser
    // had no bare-suffix slot and "này" fell through to the nearest-weekday path.
    // That structural fix has landed, and review-vi re-verified the mechanism at
    // DISCRIMINATING references - Wed 2012-08-08 and Thu 2012-08-09, where
    // forward (Mon Aug 13) and nearest/backward (Mon Aug 6) disagree - so the
    // assertion is live again. It matters: .weekday alone is 1 for every
    // candidate Monday, so without the day a regression straight back to the
    // nearest path would pass unnoticed.
    func testWeekdayNayIsCurrentPeriod() {
        let r = single("thứ hai này", weekdayRef) // ref Thu 2012-08-09
        XCTAssertEqual(r?.start.get(.weekday), 1)
        XCTAssertEqual(r?.start.get(.day), 13, "này resolves forward to Mon Aug 13, not back to Aug 6")
    }

    // Native addition, reclaimed from the forwardDate section (E3): this was
    // originally testForwardDateSameWeekdayStays, asserted with forwardDate:
    // true. Checked whether it holds under DEFAULT mode with that argument
    // dropped - it does (default nearest-weekday resolution already gives
    // today when today IS the target weekday), so it is not forward-roll-
    // specific and belongs here as ordinary Phase-1 weekday coverage, not P2.
    func testWeekdaySameDayStays() {
        // weekdayRef is Thu 2012-08-09; "thứ năm" same day -> stays, not pushed
        // a week forward.
        let r = single("thứ năm", weekdayRef)
        XCTAssertEqual(r?.start.get(.weekday), 4)
        XCTAssertEqual(r?.start.get(.day), 9)
    }

    // MARK: - E. Standard D/M/Y dates

    func testStandardFullWithNgayPrefix() {
        let r0 = ref(2012, 8, 10, 12)
        let r1 = single("Ngày 30 tháng 4 năm 1975 là ngày giải phóng.", r0)
        XCTAssertEqual(r1?.start.get(.year), 1975)
        XCTAssertEqual(r1?.start.get(.month), 4)
        XCTAssertEqual(r1?.start.get(.day), 30)
        XCTAssertEqual(r1?.start.isCertain(.year), true)
        XCTAssertEqual(r1?.start.isCertain(.month), true)
        XCTAssertEqual(r1?.start.isCertain(.day), true)

        let r2 = single("Hiệp định được ký ngày 27 tháng 1 năm 1973.", r0)
        XCTAssertEqual(r2?.text, "ngày 27 tháng 1 năm 1973")
        XCTAssertEqual(r2?.start.get(.year), 1973)

        // Culturally salient sanity check: Vietnamese Women's Day.
        let r3 = single("ngày 8 tháng 3 năm 2020", r0)
        XCTAssertEqual(r3?.start.get(.year), 2020)
        XCTAssertEqual(r3?.start.get(.month), 3)
        XCTAssertEqual(r3?.start.get(.day), 8)
    }

    func testStandardNoNgayPrefix() {
        let r0 = ref(2012, 8, 10, 12)
        let r = single("7 tháng 5 năm 1954 là ngày chấm dứt trận Điện Biên Phủ.", r0)
        XCTAssertEqual(r?.start.get(.day), 7)
        XCTAssertEqual(r?.start.get(.month), 5)
        XCTAssertEqual(r?.start.get(.year), 1954)
    }

    func testStandardNoYearImpliesClosest() {
        let r = single("ngày 15 tháng 3", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.day), 15)
        XCTAssertEqual(r?.start.get(.month), 3)
        XCTAssertEqual(r?.start.isCertain(.year), false)
        XCTAssertEqual(r?.start.isCertain(.day), true)
        XCTAssertEqual(r?.start.isCertain(.month), true)
    }

    func testStandardIndexPosition() {
        let r = single("Sự kiện ngày 30 tháng 4 năm 1975 quan trọng.", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.index, 8)
        XCTAssertEqual(r?.text, "ngày 30 tháng 4 năm 1975")
    }

    func testStandardInvalidMonthRejected() {
        assertNoResult("ngày 1 tháng 13", ref(2012, 8, 10, 12))
    }

    // MARK: - F. tháng-năm (month + year, no day)

    func testMonthYear() {
        let r0 = ref(2012, 8, 10, 12)
        let r = single("tháng 4 năm 1975", r0)
        XCTAssertEqual(r?.text, "tháng 4 năm 1975")
        XCTAssertEqual(r?.start.get(.month), 4)
        XCTAssertEqual(r?.start.get(.year), 1975)
        XCTAssertEqual(r?.start.isCertain(.day), false)
    }

    func testMonthYearSlash() {
        let r = single("tháng 3/1975", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.month), 3)
        XCTAssertEqual(r?.start.get(.year), 1975)
    }

    func testMonthOnlyImpliesCurrentYear() {
        let r = single("tháng 3", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.month), 3)
        XCTAssertEqual(r?.start.isCertain(.year), false)
        XCTAssertEqual(r?.start.get(.year), 2012)
    }

    func testMonthOutOfRangeRejected() {
        let r0 = ref(2012, 8, 10, 12)
        assertNoResult("tháng 13", r0)
        assertNoResult("tháng 0", r0)
    }

    // MARK: - G. Year

    func testYearBare() {
        let r0 = ref(2012, 8, 10, 12)
        XCTAssertEqual(single("Việt Nam thống nhất vào năm 1976.", r0)?.start.get(.year), 1976)
        XCTAssertEqual(single("Cách mạng năm 1789.", r0)?.start.get(.year), 1789)
    }

    func testYearBC() {
        let r0 = ref(2012, 8, 10, 12)
        XCTAssertEqual(single("Năm 179 TCN, triều đại bị diệt.", r0)?.start.get(.year), -179)
        XCTAssertEqual(single("Văn minh có từ năm 3000 TCN.", r0)?.start.get(.year), -3000)
    }

    func testYearThreeDigit() {
        XCTAssertEqual(single("năm 938 là năm độc lập.", ref(2012, 8, 10, 12))?.start.get(.year), 938)
    }

    func testYearBareFourDigitNotAYear() {
        assertNoResult("Có 1975 người tham gia.", ref(2012, 8, 10, 12))
    }

    // MARK: - H. Slash dates (dateOrder = .dayMonth)

    func testSlashDDMMYYYY() {
        let r0 = ref(2012, 8, 10, 12)
        let r = single("Ngày 30/04/1975.", r0)
        XCTAssertEqual(r?.start.get(.day), 30)
        XCTAssertEqual(r?.start.get(.month), 4)
        XCTAssertEqual(r?.start.get(.year), 1975)
    }

    func testSlashNoZeroPad() {
        let r = single("3/5/1968", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.day), 3)
        XCTAssertEqual(r?.start.get(.month), 5)
        XCTAssertEqual(r?.start.get(.year), 1968)
    }

    // Native addition: bare slash form (no "tháng" word) must still respect
    // day-before-month order. Easy to silently flip if EN's .monthDay default
    // leaks in.
    func testSlashDayBeforeMonthNoThang() {
        let r = single("8/3", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.day), 8)
        XCTAssertEqual(r?.start.get(.month), 3)
    }

    // MARK: - I. Relative "N unit trước/qua" - ago

    func testAgoDays() {
        let r0 = ref(2012, 8, 10, 12)
        let r = single("Sự kiện 3 ngày trước.", r0)
        XCTAssertEqual(r?.index, 8)
        XCTAssertEqual(r?.text, "3 ngày trước")
        XCTAssertEqual(r?.start.get(.day), 7)
        XCTAssertEqual(r?.start.get(.month), 8)
    }

    func testAgoWeeksMonthsYears() {
        let r0 = ref(2012, 8, 10, 12)
        let weeks = single("2 tuần trước", r0)
        XCTAssertEqual(weeks?.start.get(.day), 27)
        XCTAssertEqual(weeks?.start.get(.month), 7)

        let months = single("3 tháng trước", r0)
        XCTAssertEqual(months?.start.get(.month), 5)

        let years = single("5 năm trước", r0)
        XCTAssertEqual(years?.start.get(.year), 2007)

        let quaVariant = single("1 tháng qua", r0)
        XCTAssertEqual(quaVariant?.start.get(.month), 7)
    }

    func testAgoNumberWords() {
        let r0 = ref(2012, 8, 10, 12)
        let hai = single("hai tuần trước", r0)
        XCTAssertEqual(hai?.start.get(.day), 27)
        XCTAssertEqual(hai?.start.get(.month), 7)

        let ba = single("ba ngày trước", r0)
        XCTAssertEqual(ba?.start.get(.day), 7)
        XCTAssertEqual(ba?.start.get(.month), 8)
    }

    // Native stress test: adjacent, textually-identical "năm" tokens in two
    // different roles - integer-word 5, then unit-word year.
    func testAgoNamNamTruocStress() {
        let r = single("năm năm trước", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.year), 2007) // 5 years back
    }

    // MARK: - J. Relative "N unit sau/nữa/tới" - later

    func testLaterDays() {
        let r0 = ref(2012, 8, 10, 12)
        let r = single("Sự kiện 3 ngày sau.", r0)
        XCTAssertEqual(r?.index, 8)
        XCTAssertEqual(r?.text, "3 ngày sau")
        XCTAssertEqual(r?.start.get(.day), 13)
    }

    func testLaterWeeksMonthsYears() {
        let r0 = ref(2012, 8, 10, 12)
        XCTAssertEqual(single("2 tuần nữa", r0)?.start.get(.day), 24)
        XCTAssertEqual(single("3 tháng tới", r0)?.start.get(.month), 11)
        XCTAssertEqual(single("10 năm sau", r0)?.start.get(.year), 2022)
    }

    // MARK: - K. "trong (vòng) N unit" - within

    func testWithin() {
        let r0 = ref(2012, 8, 10, 12)
        let r = single("trong 3 ngày", r0)
        XCTAssertEqual(r?.text, "trong 3 ngày")
        XCTAssertEqual(r?.start.get(.day), 13)

        XCTAssertEqual(single("Hoàn thành trong 2 tuần.", r0)?.start.get(.day), 24)
        XCTAssertEqual(single("trong vòng 3 tháng", r0)?.start.get(.month), 11)
    }

    // MARK: - L. Casual relative unit (này/trước/qua/sau/tới/tiếp incl. bare unit)

    func testCasualRelativeMergeDateTime() {
        let morning = single("hôm qua lúc 7 giờ", ref(2012, 8, 10, 6))
        XCTAssertEqual(morning?.start.get(.day), 9)
        XCTAssertEqual(morning?.start.get(.hour), 7)

        let tomorrow = single("ngày mai lúc 15 giờ", ref(2012, 8, 10, 12))
        XCTAssertEqual(tomorrow?.start.get(.day), 11)
        XCTAssertEqual(tomorrow?.start.get(.hour), 15)
    }

    func testCasualRelativeBareUnit() {
        let r0 = ref(2012, 8, 10, 12)
        let month = single("tháng trước", r0)
        XCTAssertEqual(month?.start.get(.month), 7) // August - 1 = July

        let year = single("năm sau", r0)
        XCTAssertEqual(year?.start.get(.year), 2013)

        let week = single("tuần trước", r0)
        XCTAssertEqual(week?.start.get(.day), 3) // 10 - 7
    }

    // "này" must resolve to offset 0, not fall through to the +1 default.
    // Corrects a confirmed bug in chrono's own JS reference (see
    // VILocale.vocabulary.relativeModifiers comment) - chrono's code only
    // reverses duration for trước/qua and silently leaves này at +1, making
    // "tuần này" and "tuần sau" compute the same date. Cross-checked: no ported
    // chrono case asserts a numeric value for này (only strict-mode rejection,
    // which holds regardless of this fix).
    func testCasualRelativeNayIsZeroOffset() {
        let r = single("tuần này", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.day), 10, "này must mean the current week, not next week")
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertEqual(r?.start.get(.year), 2012)
    }

    // MARK: - M. Date ranges

    func testDateRangeDenConnector() {
        let r = single("từ ngày 5 tháng 8 đến ngày 10 tháng 8 năm 2012", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.day), 5)
        XCTAssertEqual(r?.start.get(.month), 8)
        XCTAssertNotNil(r?.end)
        XCTAssertEqual(r?.end?.get(.day), 10)
        XCTAssertEqual(r?.end?.get(.year), 2012)
    }

    func testDateRangeEmDash() {
        let r = single("ngày 1 tháng 4 – ngày 30 tháng 4 năm 2000", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.day), 1)
        XCTAssertNotNil(r?.end)
        XCTAssertEqual(r?.end?.get(.day), 30)
        XCTAssertEqual(r?.end?.get(.year), 2000)
    }

    func testDateRangeHyphen() {
        let r = single("ngày 3 tháng 9 - ngày 5 tháng 9 năm 1945", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.year), 1945)
        XCTAssertEqual(r?.end?.get(.day), 5)
    }

    func testDateRangeToiConnector() {
        let r = single("tháng 3 tới tháng 5 năm 1975", ref(2012, 8, 10, 12))
        XCTAssertEqual(r?.start.get(.month), 3)
        XCTAssertEqual(r?.end?.get(.month), 5)
        XCTAssertEqual(r?.end?.get(.year), 1975)
    }

    func testDateRangeStartBeforeEnd() {
        let r = single("ngày 1 tháng 1 đến ngày 31 tháng 12 năm 2020", ref(2012, 8, 10, 12))
        XCTAssertNotNil(r?.interval)
        if let interval = r?.interval {
            XCTAssertLessThan(interval.start, interval.end)
        }
    }

    // MARK: - N. Strict mode

    func testStrictRejectsCasual() {
        let r0 = ref(2012, 8, 10, 12)
        for text in ["hôm nay", "hôm qua", "ngày mai", "ngày kia",
                     "buổi sáng", "buổi trưa", "buổi chiều", "buổi tối",
                     "tuần này", "tháng trước", "năm sau",
                     "thứ hai", "chủ nhật"] {
            assertNoResult(text, r0, mode: .strict)
        }
    }

    func testStrictAcceptsAbsolute() {
        let r0 = ref(2012, 8, 10, 12)
        let r1 = single("ngày 30 tháng 4 năm 1975", r0, mode: .strict)
        XCTAssertEqual(r1?.start.get(.year), 1975)

        let r2 = single("lúc 7 giờ 30 phút", r0, mode: .strict)
        XCTAssertEqual(r2?.start.get(.hour), 7)

        let r3 = single("30/4/1975", r0, mode: .strict)
        XCTAssertEqual(r3?.start.get(.day), 30)

        let r4 = single("3 ngày trước", r0, mode: .strict)
        XCTAssertEqual(r4?.start.get(.day), 7)
    }

    // MARK: - O. forwardDate option
    //
    // P2: forward-time day-roll [E3]. Main's E3 ruling: REMOVE Options.forwardDate
    // for v0.1 (forward-roll is P2, not Phase 1). These 4 tests are deferred, not
    // deleted - P2 re-activates them. Renamed off the "test" prefix so XCTest
    // does not discover/run them. (A 5th test originally lived here,
    // testForwardDateSameWeekdayStays - checked whether it holds under default
    // mode with the forwardDate:true argument dropped; it does, so main reclaimed
    // it as an active Phase-1 default-behavior test - see testWeekdaySameDayStays
    // in the Weekday section instead.)

    func p2_testForwardDateTimeRollsToNextDay() {
        let r = single("7 giờ sáng", ref(2012, 8, 10, 8, 0), forwardDate: true)
        XCTAssertEqual(r?.start.get(.day), 11)
        XCTAssertEqual(r?.start.get(.hour), 7)
    }

    func p2_testForwardDateWeekdayRollsForward() {
        // REF Tue 2012-08-14; last Monday Aug13 already passed -> next Monday Aug20.
        let r = single("thứ hai", ref(2012, 8, 14, 12), forwardDate: true)
        XCTAssertEqual(r?.start.get(.weekday), 1)
        XCTAssertEqual(r?.start.get(.day), 20)
    }

    func p2_testForwardDateSlashRollsToNextYear() {
        let r = single("15/3", ref(2012, 8, 10, 12), forwardDate: true)
        XCTAssertEqual(r?.start.get(.year), 2013)
    }

    func p2_testForwardDateMonthRollsToNextYear() {
        let r = single("tháng 3", ref(2012, 8, 10, 12), forwardDate: true)
        XCTAssertEqual(r?.start.get(.year), 2013)
    }

    // MARK: - P. Negative / non-date cases

    func testNegativeInvalidDay() {
        assertNoResult("ngày 0 tháng 4 năm 2000", ref(2012, 8, 10, 12))
    }

    func testNegativeSlashOutOfRange() {
        assertNoResult("32/13/2020", ref(2012, 8, 10, 12))
    }

    func testNegativePhoneNumber() {
        assertNoResult("0912345678", ref(2012, 8, 10, 12))
    }

    func testNegativeBareNumbers() {
        let r0 = ref(2012, 8, 10, 12)
        for text in ["3", "11", "0.5", "35.49", "12.53%"] {
            assertNoResult(text, r0)
        }
    }

    func testNegativeCurrencyMeasurement() {
        let r0 = ref(2012, 8, 10, 12)
        assertNoResult("$1,194.09", r0)
        assertNoResult("at 6.5 kilograms", r0)
    }

    func testNegativeVersionNumbers() {
        let r0 = ref(2012, 8, 10, 12)
        assertNoResult("1.1.3", r0)
        assertNoResult("1.10.30", r0)
    }

    func testNegativeHyphenatedRanges() {
        let r0 = ref(2012, 8, 10, 12)
        assertNoResult("1-2", r0)
        assertNoResult("1-2-3", r0)
    }

    func testNegativeImpossibleMinute() {
        let r0 = ref(2012, 8, 10, 12)
        assertNoResult("7 giờ 61 phút", r0)
        assertNoResult("7 giờ 99 phút", r0)
    }

    // MARK: - NFC / diacritics (core-level, VI is where accents make it observable)

    func testNFDInputMatchesNFC() {
        // "thứ Sáu" (Friday) built explicitly in NFD (decomposed) form, as could
        // arrive from certain input sources, vs the NFC (precomposed) literal.
        let nfc = "thứ Sáu"
        let nfd = nfc.decomposedStringWithCanonicalMapping
        XCTAssertNotEqual(Array(nfc.utf16), Array(nfd.utf16), "test fixture must actually be decomposed, or this proves nothing")

        let r0 = ref(2012, 8, 9, 12)
        let fromNFC = single(nfc, r0)
        let fromNFD = single(nfd, r0)
        XCTAssertEqual(fromNFC?.start.get(.weekday), fromNFD?.start.get(.weekday))
        XCTAssertEqual(fromNFD?.start.get(.weekday), 5)
    }
}
