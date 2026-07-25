// PatternCacheTests.swift - the patterns are compiled once, and the key that
// decides "once" is the right one.
//
// These are deterministic assertions about COMPILATION COUNT and pattern
// identity, not about elapsed time. A timing assertion would measure the machine
// it ran on; the invariant worth protecting is that a repeat parse compiles
// nothing, and that nothing which changes a pattern is missing from the key.

import XCTest
import Foundation
@testable import Khac

final class PatternCacheTests: XCTestCase {
    private let ref = ReferencePoint(instant: Date(timeIntervalSince1970: 1_700_000_000), calendar: .current)

    private func context(
        _ prepared: PreparedLocale,
        _ options: Options = Options(),
        text: String = "next friday at 5pm"
    ) -> ParsingContext {
        ParsingContext(
            reference: ref,
            options: options,
            locale: prepared.locale,
            normalization: NormalizedText(original: text)
        )
    }

    /// The same parser asked twice gets the SAME compiled object back, not an
    /// equal one. Identity is the proof: an equal-but-fresh regex would mean the
    /// cache missed and ICU recompiled.
    func testSecondRequestReturnsTheSameCompiledObject() {
        let prepared = PreparedLocale(ENLocale())
        let parser = WeekdayParser()

        let first = prepared.regex(for: parser, context: context(prepared))
        XCTAssertEqual(prepared.compileCount, 1)

        // A DIFFERENT context, so only the key can be producing the hit.
        let second = prepared.regex(for: parser, context: context(prepared, text: "see you monday"))
        XCTAssertEqual(prepared.compileCount, 1, "a warm key must not compile again")
        XCTAssertTrue(first === second, "the cached NSRegularExpression must be reused, not rebuilt")
    }

    /// The headline invariant: parse once, then parse as much as you like for
    /// free. Before the cache existed this number grew by ten on every call.
    func testRepeatedParsesCompileNothingAfterTheFirst() {
        let locale = ENLocale()
        let prepared = PreparedLocale(locale)
        let expected = Engine.genericParsers.count + locale.additionalParsers.count

        _ = Engine.run(text: "next friday at 5pm", reference: ref, options: Options(), locales: [prepared])
        XCTAssertEqual(prepared.compileCount, expected, "one compile per parser on the first parse")

        for _ in 0..<25 {
            _ = Engine.run(text: "august 10, 2012 at 5pm", reference: ref, options: Options(), locales: [prepared])
        }
        XCTAssertEqual(prepared.compileCount, expected, "25 further parses must compile nothing")
    }

    /// Options belong in the key because one parser's pattern really does change
    /// with them. If they were dropped, strict mode would silently run the casual
    /// pattern - a wrong answer, not a slow one.
    func testStrictModeGetsItsOwnPattern() {
        let prepared = PreparedLocale(ENLocale())
        let parser = RelativeUnitParser()

        let casual = prepared.regex(for: parser, context: context(prepared, Options(mode: .casual)))
        let strict = prepared.regex(for: parser, context: context(prepared, Options(mode: .strict)))

        XCTAssertNotEqual(casual.pattern, strict.pattern, "strict mode restricts the unit table")
        XCTAssertEqual(prepared.compileCount, 2, "two keys, two compiles")

        _ = prepared.regex(for: parser, context: context(prepared, Options(mode: .strict)))
        XCTAssertEqual(prepared.compileCount, 2, "the strict key is warm now too")
    }

    /// Two locales that report the same LocaleID must not share patterns. This is
    /// the hazard a cache keyed by LocaleID would have shipped: the suite's own
    /// MockLocale declares `.english`, so it would have been served ENLocale's
    /// patterns and still passed most of its tests.
    func testLocalesSharingAnIDDoNotSharePatterns() {
        let withMarker = MockLocale()                        // carries the "anno" year marker
        var withoutMarker = MockLocale()
        withoutMarker.patterns = PatternSet()                // drops it
        XCTAssertEqual(withMarker.id, withoutMarker.id, "the hazard needs both to claim one id")

        let a = PreparedLocale(withMarker)
        let b = PreparedLocale(withoutMarker)
        let parser = YearParser()

        let ra = a.regex(for: parser, context: context(a))
        let rb = b.regex(for: parser, context: context(b))

        XCTAssertNotEqual(ra.pattern, rb.pattern, "different vocabulary, different pattern")
        XCTAssertFalse(ra === rb, "and not the same cached object")
    }

    /// A cache that returned a stale pattern would show up here rather than in a
    /// count. Same input, many times, same answer.
    func testAnswersDoNotDriftAcrossRepeatedParses() {
        let k = Khac()
        let first = k.parse("next friday at 5pm", reference: ref)
        for _ in 0..<25 {
            let again = k.parse("next friday at 5pm", reference: ref)
            XCTAssertEqual(again.count, first.count)
            XCTAssertEqual(again.map(\.date), first.map(\.date))
            XCTAssertEqual(again.map(\.text), first.map(\.text))
        }
    }
}
