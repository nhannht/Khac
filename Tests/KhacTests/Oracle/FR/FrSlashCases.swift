// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fr/fr_slash.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let frSlashCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fr_slash.test.ts",
        input: "8/2/2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8/2/2016", index: 0, start: OracleComponents(year: 2016, month: 2, day: 8), startDate: OracleDate(2016, 2, 8, 12))
    ),
    OracleCase(
        sourceFile: "fr_slash.test.ts",
        input: "le 8/2/2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2016, month: 2, day: 8), startDate: OracleDate(2016, 2, 8, 12))
    ),
    OracleCase(
        sourceFile: "fr_slash.test.ts",
        input: "le 8/2",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2013, month: 2, day: 8), startDate: OracleDate(2013, 2, 8, 12))
    ),
    OracleCase(
        sourceFile: "fr_slash.test.ts",
        input: "lundi 8/2/2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "lundi 8/2/2016", startDate: OracleDate(2016, 2, 8, 12))
    ),
    OracleCase(
        sourceFile: "fr_slash.test.ts",
        input: "samedi 9/2/20 ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "samedi 9/2/20", index: 0, start: OracleComponents(year: 2020, month: 2, day: 9), startDate: OracleDate(2020, 2, 9, 12))
    ),
]
