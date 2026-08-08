// CoreTests.swift - engine internals proven independently of any real locale.

import XCTest
@testable import Khac

final class CoreTests: XCTestCase {

    // MARK: Normalization + original index mapping

    func testNFCNormalizationComposesDecomposedText() {
        let composed = "cà phê"
        let decomposed = composed.decomposedStringWithCanonicalMapping
        XCTAssertNotEqual(composed.utf16.count, decomposed.utf16.count, "precondition: NFD is longer")

        let n = NormalizedText(original: decomposed)
        XCTAssertEqual(n.normalized, composed, "normalized form should be NFC")
    }

    func testOriginalIndexRecoveredFromNormalizedOffset() {
        // Decomposed Vietnamese: matching happens on NFC, indices report the
        // original (NFD) offsets so highlights land on the user's real text.
        let decomposed = "cà phê".decomposedStringWithCanonicalMapping
        let n = NormalizedText(original: decomposed)

        // Locate "phê" (NFC) in the normalized text, map back to the original.
        let ns = n.normalized as NSString
        let nfcRange = ns.range(of: "phê".precomposedStringWithCanonicalMapping)
        XCTAssertNotEqual(nfcRange.location, NSNotFound)

        let originalOffset = n.originalUTF16Offset(forNormalizedUTF16: nfcRange.location)
        let recovered = n.originalSubstring(forNormalizedUTF16: nfcRange.location ..< (nfcRange.location + nfcRange.length))
        XCTAssertEqual(recovered.precomposedStringWithCanonicalMapping, "phê")

        // The recovered original substring starts exactly at the reported offset.
        let originalNS = decomposed as NSString
        let sliceFromOffset = originalNS.substring(from: originalOffset)
        XCTAssertTrue(sliceFromOffset.hasPrefix(recovered))
    }

    func testAsciiTextHasIdentityMapping() {
        let n = NormalizedText(original: "meeting on 3/4")
        XCTAssertEqual(n.normalized, "meeting on 3/4")
        XCTAssertEqual(n.originalUTF16Offset(forNormalizedUTF16: 11), 11)
    }

    // MARK: ParsingComponents

    func testCertainOverridesImplied() {
        var c = ParsingComponents(reference: .now)
        XCTAssertFalse(c.isCertain(.hour))
        c.imply(.hour, 9)
        XCTAssertFalse(c.isCertain(.hour))
        c.certain(.hour, 17)
        XCTAssertTrue(c.isCertain(.hour))
        XCTAssertEqual(c.get(.hour), 17)
        // imply must not clobber a certain value.
        c.imply(.hour, 3)
        XCTAssertEqual(c.get(.hour), 17)
    }

    func testSpecificityCountsCertainOnly() {
        var c = ParsingComponents(reference: .now)
        XCTAssertEqual(c.specificityScore, 0)
        c.certain(.year, 2020)
        c.certain(.month, 5)
        c.imply(.day, 11)
        XCTAssertEqual(c.specificityScore, 2)
    }

    func testBareComponentsResolveToImpliedClock() {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        let ref = ReferencePoint(instant: Date(timeIntervalSince1970: 1_700_000_000), calendar: cal)
        let c = ParsingComponents(reference: ref)
        let hour = cal.component(.hour, from: c.date())
        XCTAssertEqual(hour, ParsingComponents.impliedHour, "bare date uses the implied clock hour")
    }

    // MARK: Overlap filtering determinism

    func testOverlapFilterIsOrderIndependent() {
        let ref = ReferencePoint.now
        func make(index: Int, length: Int, score: Int) -> ParsedResult {
            var c = ParsingComponents(reference: ref)
            c.certain(.day, 1)
            return ParsedResult(index: index, text: String(repeating: "x", count: length), start: c, end: nil, score: score)
        }

        let a = make(index: 0, length: 5, score: 10)   // [0,5)
        let b = make(index: 3, length: 5, score: 8)    // [3,8) overlaps a, lower score
        let c = make(index: 10, length: 4, score: 6)   // [10,14) independent

        let context = ParsingContext(
            reference: ref, options: Options(), prepared: PreparedLocale(MockLocale()),
            normalization: NormalizedText(original: String(repeating: "x", count: 20))
        )
        let filter = OverlapFilterRefiner()

        let out1 = filter.refine(context, [a, b, c])
        let out2 = filter.refine(context, [c, b, a])
        let out3 = filter.refine(context, [b, c, a])

        let ids1 = out1.map { $0.index }
        XCTAssertEqual(ids1, [0, 10], "b removed as it overlaps higher-scoring a")
        XCTAssertEqual(out2.map { $0.index }, ids1, "order-independent")
        XCTAssertEqual(out3.map { $0.index }, ids1, "order-independent")
    }

    // MARK: Cross-locale tie precedence (KHAC-16)

    func testLocaleRankBreaksExactTiesAndDefaultsFallThrough() {
        let ref = ReferencePoint.now
        func make(localeRank: Int) -> ParsedResult {
            var c = ParsingComponents(reference: ref)
            c.certain(.day, 8)
            c.certain(.month, 5)
            return ParsedResult(index: 0, text: "8/5", start: c, end: nil, score: 2, localeRank: localeRank)
        }

        // Identical on every intrinsic key: only localeRank differs. Lower wins,
        // in both comparison directions.
        let first = make(localeRank: 0)
        let second = make(localeRank: 1)
        XCTAssertTrue(first.isPreferred(over: second), "the earlier-listed locale wins an exact tie")
        XCTAssertFalse(second.isPreferred(over: first), "the tie must not also break the other way")

        // Two unstamped results tie on localeRank and fall through to the
        // signature - the pre-KHAC-16 behavior, so results built outside a
        // locale run (like every other test in this file) are unaffected.
        let a = make(localeRank: ParsedResult.defaultLocaleRank)
        let b = make(localeRank: ParsedResult.defaultLocaleRank)
        XCTAssertEqual(
            a.isPreferred(over: b), a.stableSignature < b.stableSignature,
            "default ranks decide nothing; the signature still does"
        )

        // An unstamped result never outranks a stamped one on this key.
        XCTAssertTrue(second.isPreferred(over: a), "stamped beats unstamped regardless of index")
    }

    // MARK: Consumer API surface (what en/vi build on)

    func testKhacRunsWithAMockLocaleWithoutCrashing() {
        let k = Khac(localeInstances: [MockLocale()])
        // The pipeline runs end to end and the weekday parser fires.
        let results = k.parse("meeting next friday")
        XCTAssertFalse(results.isEmpty)
        XCTAssertEqual(results.first?.start.get(.weekday), 5)
    }
}
