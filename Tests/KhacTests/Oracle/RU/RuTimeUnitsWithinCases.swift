// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_time_units_within.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruTimeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_time_units_within.test.ts",
        input: "будет сделано в течение минуты",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "в течение минуты", index: 14, startDate: OracleDate(2012, 8, 10, 0, 1))
    ),
    OracleCase(
        sourceFile: "ru_time_units_within.test.ts",
        input: "будет сделано в течение 2 часов.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "в течение 2 часов", index: 14, startDate: OracleDate(2012, 8, 10, 2))
    ),
]
