// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_month_name_middle_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itMonthNameMiddleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_month_name_middle_endian.test.ts",
        input: "agosto 10, 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "agosto 10, 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_middle_endian.test.ts",
        input: "agosto 10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "agosto 10", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_middle_endian.test.ts",
        input: "agosto 32, 2014",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_month_name_middle_endian.test.ts",
        input: "febbraio 29, 2014",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
