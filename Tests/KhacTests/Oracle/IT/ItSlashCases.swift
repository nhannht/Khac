// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_slash.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itSlashCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_slash.test.ts",
        input: "Sarà il 25/12/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "25/12/2012", index: 8, start: OracleComponents(year: 2012, month: 12, day: 25), startDate: OracleDate(2012, 12, 25, 12))
    ),
    OracleCase(
        sourceFile: "it_slash.test.ts",
        input: "Sarà il 25/12/12",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "25/12/12", index: 8, start: OracleComponents(year: 2012, month: 12, day: 25), startDate: OracleDate(2012, 12, 25, 12))
    ),
    OracleCase(
        sourceFile: "it_slash.test.ts",
        input: "Sarà il 25/12",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "25/12", index: 8, start: OracleComponents(year: 2012, month: 12, day: 25), startDate: OracleDate(2012, 12, 25, 12))
    ),
    OracleCase(
        sourceFile: "it_slash.test.ts",
        input: "dal 25/12/2012 al 30/12/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "25/12/2012 al 30/12/2012", index: 4, start: OracleComponents(year: 2012, month: 12, day: 25), startDate: OracleDate(2012, 12, 25, 12), end: OracleComponents(year: 2012, month: 12, day: 30), endDate: OracleDate(2012, 12, 30, 12))
    ),
    OracleCase(
        sourceFile: "it_slash.test.ts",
        input: "25/13/2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
