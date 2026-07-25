// NormalizationTests.swift - the answer must not depend on the input's Unicode form.
//
// The engine matches on NFC and reports offsets in ORIGINAL coordinates. That
// split is correct, and it is also a trap: anything that re-reads a result's
// ORIGINAL text and matches it against an NFC-built pattern silently finds
// nothing. For Vietnamese that is not a rare edge - macOS text fields, dictation,
// and any path read off HFS+ deliver NFD, so an accented word like "tháng" simply
// fails to match, the code takes its no-match branch, and the caller is handed a
// confident date that is wrong by the whole duration.
//
// MergeRelativeAnchorRefiner had exactly that bug, and no suite could see it: EN's
// duration words are ASCII, so 561/561 EN said nothing, and every VI test fixture
// was written NFC. These tests assert the invariant directly instead - same text,
// two Unicode forms, one answer - so the next refiner that re-parses a result is
// caught here rather than in a user's calendar.

import XCTest
import Khac

final class NormalizationTests: XCTestCase {
    private func reference() -> ReferencePoint {
        var comps = DateComponents()
        comps.year = 2012; comps.month = 8; comps.day = 10
        comps.hour = 12; comps.minute = 0; comps.second = 0
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh") ?? .current
        return ReferencePoint(instant: cal.date(from: comps)!, calendar: cal)
    }

    private func ymd(_ date: Date) -> DateComponents {
        var cal = ReferencePoint.defaultCalendar
        cal.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh") ?? .current
        return cal.dateComponents([.year, .month, .day], from: date)
    }

    /// Every case here re-anchors a relative duration onto an adjacent date, which
    /// is the path that re-parses a result's own text. The expected values are
    /// pinned as well as compared, so a future change that breaks BOTH forms
    /// equally still fails rather than passing on mutual agreement.
    private let relativeAnchorCases: [(text: String, year: Int, month: Int, day: Int)] = [
        ("2 ngày sau ngày mai", 2012, 8, 13),
        ("2 tuần sau ngày mai", 2012, 8, 25),
        ("3 ngày trước ngày 15 tháng 3", 2012, 3, 12),
        ("2 tháng trước ngày 15 tháng 3", 2012, 1, 15),
    ]

    func testRelativeAnchorAgreesAcrossNormalizationForms() {
        let khac = Khac(locales: [.vietnamese])
        for c in relativeAnchorCases {
            let nfc = c.text.precomposedStringWithCanonicalMapping
            let nfd = c.text.decomposedStringWithCanonicalMapping
            // Swift's String == is canonical-equivalence based, so the two forms
            // compare EQUAL as Strings however differently they are stored. The
            // scalars are what the engine's UTF-16 matching actually sees, so
            // that is what has to differ for this case to prove anything.
            XCTAssertNotEqual(
                Array(nfd.unicodeScalars), Array(nfc.unicodeScalars),
                "\(c.text) must actually differ between forms, or it proves nothing"
            )

            guard let fromNFC = khac.parseDate(nfc, reference: reference()) else {
                return XCTFail("NFC form of \(c.text) did not parse")
            }
            guard let fromNFD = khac.parseDate(nfd, reference: reference()) else {
                return XCTFail("NFD form of \(c.text) did not parse")
            }

            let expected = ymd(fromNFC)
            XCTAssertEqual(expected.year, c.year, "NFC \(c.text) year")
            XCTAssertEqual(expected.month, c.month, "NFC \(c.text) month")
            XCTAssertEqual(expected.day, c.day, "NFC \(c.text) day")
            XCTAssertEqual(fromNFD, fromNFC, "NFD \(c.text) resolved differently from NFC")
        }
    }

    /// Broader sweep over ordinary Vietnamese forms, agreement only. These did not
    /// regress, and the point is to keep it that way as locales are added.
    func testCommonVietnameseFormsAgreeAcrossNormalizationForms() {
        let khac = Khac(locales: [.vietnamese])
        let inputs = [
            "ngày 15 tháng 3 năm 2020",
            "thứ sáu tuần tới",
            "3 giờ chiều mai",
            "12 giờ đêm",
            "hai tuần trước",
            "Đường Nguyễn Huệ, thứ sáu 5 giờ chiều",
        ]
        for input in inputs {
            let nfc = input.precomposedStringWithCanonicalMapping
            let nfd = input.decomposedStringWithCanonicalMapping
            XCTAssertEqual(
                khac.parseDate(nfd, reference: reference()),
                khac.parseDate(nfc, reference: reference()),
                "\(input) resolved differently in NFD"
            )
        }
    }

    /// The other half of the contract: offsets stay in ORIGINAL coordinates, so a
    /// caller slicing the input it actually passed in gets the matched text back.
    /// Normalizing changes UTF-16 lengths, so this is where an offset-map slip
    /// would show up.
    func testReportedOffsetsSliceTheOriginalText() {
        let khac = Khac(locales: [.vietnamese])
        let inputs = [
            "Đường Nguyễn Huệ, thứ sáu 5 giờ chiều",
            "họp lúc 3 giờ chiều mai",
            "2 tháng trước ngày 15 tháng 3",
        ]
        for input in inputs {
            for form in [input.precomposedStringWithCanonicalMapping, input.decomposedStringWithCanonicalMapping] {
                let ns = form as NSString
                for r in khac.parse(form, reference: reference()) {
                    XCTAssertLessThanOrEqual(r.rangeEnd, ns.length, "match runs past the end of \(form)")
                    guard r.rangeEnd <= ns.length else { continue }
                    XCTAssertEqual(
                        ns.substring(with: NSRange(location: r.index, length: r.matchLength)),
                        r.text,
                        "reported offsets do not slice the original text"
                    )
                }
            }
        }
    }
}
