// Compile/shape smoke test for the EN oracle data tables only - proves the generated
// case data is valid, well-typed Swift before Khac's Locale/ParsingComponents protocol
// is frozen. Real Khac().parse() assertions live in ENOracleTests.swift once the
// engine interface lands.

import XCTest

final class ENOracleSmokeTests: XCTestCase {
    func testOracleCasesLoad() {
        // 561, not the 563 originally extracted. Two cases are not portable:
        // the duplicate "Dec. 21" case asserted a result contradicting its twin
        // for the same input and reference (see MonthNameMiddleEndianCases.swift),
        // and "Thursday 9AM" tested a CUSTOM chrono with its time parser
        // removed, a configuration surgery a single-engine port cannot express
        // (see GeneralCases.swift).
        XCTAssertEqual(enOracleCases.count, 561)
    }

    func testNoMatchCasesArePresent() {
        let noMatchCount = enOracleCases.filter {
            if case .noMatch = $0.expectation { return true }
            return false
        }.count
        XCTAssertGreaterThan(noMatchCount, 0)
    }

    func testEveryCaseHasNonEmptyInput() {
        XCTAssertTrue(enOracleCases.allSatisfy { !$0.input.isEmpty })
    }
}
