// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_month.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itMonthCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_month.test.ts",
        input: "settembre 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "settembre 2012", index: 0, start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "it_month.test.ts",
        input: "set 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "set 2012", index: 0, start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "it_month.test.ts",
        input: "Sarà a settembre",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "settembre", index: 7, start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "it_month.test.ts",
        input: "gennaio 2019",
        reference: OracleDate(2018, 8, 10),
        expectation: .match(start: OracleComponents(year: 2019, month: 1), startDate: OracleDate(2019, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "it_month.test.ts",
        input: "dicembre 2018",
        reference: OracleDate(2018, 8, 10),
        expectation: .match(start: OracleComponents(year: 2018, month: 12), startDate: OracleDate(2018, 12, 1, 12))
    ),
    OracleCase(
        sourceFile: "it_month.test.ts",
        input: "febbraio",
        reference: OracleDate(2018, 8, 10),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2019, month: 2), startDate: OracleDate(2019, 2, 1, 12))
    ),
]
