// EraSuffixNormalizationTests.swift - a tail-scanning refiner must not care which
// Unicode form the caller typed in.
//
// ExtractYearSuffixRefiner builds its era alternation from LOCALE VOCABULARY and
// used to match it against the ORIGINAL string. Patterns are folded to NFC and
// real input often is not, so an accented era marker meeting decomposed text
// simply failed to match - silently, because the refiner's no-match branch just
// leaves the year implied. No locale ships an accented era marker today, which is
// why nothing failed and why this needed a locale to exist before it could be
// pinned. KHAC-7.
//
// The marker used here is not synthetic: Vietnamese spells the era out as
// "trước Công nguyên" alongside the abbreviation TCN, so this is a form a Phase 2
// locale can genuinely carry.
//
// The date forms matter. A MONTH-NAME date absorbs a trailing era-marked year
// inside MonthNameParser's own pattern, which matches in normalized coordinates
// and was never affected - so "august 10 234 <era>" passes with the bug present
// and pins nothing. The refiner is only the sole route to the year when the date
// came from a parser with no year slot of its own, which is why every case below
// uses a numeric or date-plus-time form. Measured before the fix:
//
//   NFD "8/10 234 trước công nguyên"   ->  [8/10] y=2012  +  [234 trước...] y=-234
//
// A caller taking the first result is told 2012. Silent, and wrong.

import XCTest
@testable import Khac

final class EraSuffixNormalizationTests: XCTestCase {
    private let utc = TimeZone(identifier: "UTC")!

    private func reference() -> ReferencePoint {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = utc
        let comps = DateComponents(year: 2012, month: 8, day: 10, hour: 12)
        return ReferencePoint(instant: cal.date(from: comps)!, calendar: cal)
    }

    /// MockLocale plus a diacritic-bearing era marker. Everything else unchanged,
    /// so a failure here is about normalization and nothing else.
    private func accentedEraLocale() -> MockLocale {
        var locale = MockLocale()
        locale.vocabulary.eraMarkers["trước công nguyên"] = -1
        return locale
    }

    /// The control. An ASCII era marker exercises the same refiner and must be
    /// completely unaffected by the coordinate change.
    func testAsciiEraSuffixStillAttaches() {
        let khac = Khac(localeInstances: [accentedEraLocale()])
        let r = khac.parse("8/10 234 bc", reference: reference()).first
        XCTAssertEqual(r?.start.get(.year), -234)
        XCTAssertEqual(r?.text, "8/10 234 bc", "the refiner extends the match over the suffix")
    }

    /// The pin. Both Unicode forms must reach the same year, and the NFD form is
    /// the one that resolved to the reference year before KHAC-7.
    func testAccentedEraSuffixAttachesInBothNormalizationForms() {
        let khac = Khac(localeInstances: [accentedEraLocale()])
        for text in ["8/10 234 trước công nguyên", "8/10 5:30 pm 234 trước công nguyên"] {
            let nfc = text.precomposedStringWithCanonicalMapping
            let nfd = text.decomposedStringWithCanonicalMapping

            // Swift's String == is canonical-equivalence based, so the two forms
            // compare EQUAL however differently they are stored. The scalars are
            // what UTF-16 matching sees, so that is what has to differ to prove
            // anything.
            XCTAssertNotEqual(
                Array(nfd.unicodeScalars), Array(nfc.unicodeScalars),
                "the two forms of \(text) must actually differ, or this proves nothing"
            )

            for (form, label) in [(nfc, "NFC"), (nfd, "NFD")] {
                let results = khac.parse(form, reference: reference())
                XCTAssertEqual(
                    results.count, 1,
                    "\(label) \(text) left the year as a separate result instead of attaching it"
                )
                XCTAssertEqual(results.first?.start.get(.year), -234, "\(label) \(text) year")
                XCTAssertEqual(results.first?.text, form, "\(label) \(text) span")
            }
        }
    }

    /// Offsets stay in ORIGINAL coordinates even though matching moved to
    /// normalized ones. This is the half a coordinate change breaks silently: the
    /// year would still be right while the reported span sliced the wrong bytes.
    func testExtendedMatchStillSlicesTheOriginalText() {
        let khac = Khac(localeInstances: [accentedEraLocale()])
        let text = "họp 8/10 234 trước công nguyên".decomposedStringWithCanonicalMapping
        let ns = text as NSString

        for r in khac.parse(text, reference: reference()) {
            XCTAssertLessThanOrEqual(r.rangeEnd, ns.length, "match runs past the end of the input")
            guard r.rangeEnd <= ns.length else { continue }
            XCTAssertEqual(
                ns.substring(with: NSRange(location: r.index, length: r.matchLength)),
                r.text,
                "reported offsets do not slice the original text"
            )
        }
    }

    // MARK: The inverse map itself

    /// The two directions must agree at every grapheme boundary. They now read one
    /// pair of parallel arrays, so this pins the contract rather than the code.
    func testNormalizedAndOriginalOffsetsRoundTrip() {
        for input in [
            "họp lúc 3 giờ chiều mai",
            "Đường Nguyễn Huệ, thứ sáu 5 giờ chiều",
            "plain ascii only",
            "",
        ] {
            for form in [
                input.precomposedStringWithCanonicalMapping,
                input.decomposedStringWithCanonicalMapping,
            ] {
                let n = NormalizedText(original: form)
                let normalizedLength = (n.normalized as NSString).length

                // Walk the ORIGINAL by grapheme, since those are the boundaries the
                // map records, and check the round trip closes at each one.
                var originalOffset = 0
                for character in form {
                    let normalizedOffset = n.normalizedUTF16Offset(forOriginalUTF16: originalOffset)
                    XCTAssertLessThanOrEqual(normalizedOffset, normalizedLength)
                    XCTAssertEqual(
                        n.originalUTF16Offset(forNormalizedUTF16: normalizedOffset),
                        originalOffset,
                        "round trip lost a boundary in \(form)"
                    )
                    originalOffset += String(character).utf16.count
                }

                // The end boundary, which is where a tail scan usually starts.
                XCTAssertEqual(n.normalizedUTF16Offset(forOriginalUTF16: originalOffset), normalizedLength)
            }
        }
    }

    /// An offset past the end must not trap. A result at the very end of the input
    /// hands the refiner exactly this, and the tail is then empty.
    func testOffsetPastTheEndSnapsToTheEnd() {
        let n = NormalizedText(original: "chiều mai".decomposedStringWithCanonicalMapping)
        let normalizedLength = (n.normalized as NSString).length
        XCTAssertEqual(n.normalizedUTF16Offset(forOriginalUTF16: 9_999), normalizedLength)
    }
}
