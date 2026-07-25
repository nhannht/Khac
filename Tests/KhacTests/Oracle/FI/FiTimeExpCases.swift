// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fi/fi_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let fiTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fi_time_exp.test.ts",
        input: "klo 15:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 15, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_time_exp.test.ts",
        input: "kello 8:30",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 8, minute: 30))
    ),
    OracleCase(
        sourceFile: "fi_time_exp.test.ts",
        input: "klo 13.00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 13, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_time_exp.test.ts",
        input: "klo 10:00-12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 10, minute: 0), end: OracleComponents(hour: 12, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_time_exp.test.ts",
        input: "15 elokuuta 2012 klo 14:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15, hour: 14, minute: 0))
    ),
]
