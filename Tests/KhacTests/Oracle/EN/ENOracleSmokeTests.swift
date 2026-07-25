// Compile/shape smoke test for the EN oracle data tables only - proves the generated
// case data is valid, well-typed Swift before Khac's Locale/ParsingComponents protocol
// is frozen. Real Khac().parse() assertions live in ENOracleTests.swift once the
// engine interface lands.

import XCTest

final class ENOracleSmokeTests: XCTestCase {
    func testOracleCasesLoad() {
        XCTAssertEqual(enOracleCases.count, 563)
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
