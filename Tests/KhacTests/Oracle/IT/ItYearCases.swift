// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_year.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itYearCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_year.test.ts",
        input: "10 agosto 12",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 12", start: OracleComponents(year: 2012, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "it_year.test.ts",
        input: "10 agosto 99",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 99", start: OracleComponents(year: 1999, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "it_year.test.ts",
        input: "10 agosto 68",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 68", start: OracleComponents(year: 1968, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "it_year.test.ts",
        input: "nel 0000",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
