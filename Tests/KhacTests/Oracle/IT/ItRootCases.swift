// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itRootCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it.test.ts",
        input: "La scadenza è il 15 marzo 2024",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "il 15 marzo 2024", start: OracleComponents(year: 2024, month: 3, day: 15))
    ),
    OracleCase(
        sourceFile: "it.test.ts",
        input: "Ci incontriamo domani alle 10:00",
        reference: OracleDate(2012, 8, 10, 8, 9),
        expectation: .match(text: "domani alle 10:00", start: OracleComponents(day: 11, hour: 10, minute: 0))
    ),
    OracleCase(
        sourceFile: "it.test.ts",
        input: "ieri sera",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ieri sera", start: OracleComponents(day: 9, hour: 20))
    ),
]
