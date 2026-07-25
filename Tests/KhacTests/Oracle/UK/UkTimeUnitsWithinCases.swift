// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/uk/uk_time_units_within.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ukTimeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "uk_time_units_within.test.ts",
        input: "буде зроблено протягом хвилини",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "протягом хвилини", index: 14, startDate: OracleDate(2012, 8, 10, 0, 1))
    ),
    OracleCase(
        sourceFile: "uk_time_units_within.test.ts",
        input: "буде виконано на протязі 2 годин.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "на протязі 2 годин", index: 14, startDate: OracleDate(2012, 8, 10, 2))
    ),
    OracleCase(
        sourceFile: "uk_time_units_within.test.ts",
        input: "купив 5 годинників",
        reference: OracleDate(2012, 8, 10),
        forwardDate: true,
        expectation: .noMatch
    ),
]
