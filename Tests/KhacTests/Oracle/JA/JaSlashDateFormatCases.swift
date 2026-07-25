// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ja/ja_slash_date_format.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let jaSlashDateFormatCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ja_slash_date_format.test.ts",
        input: "2012/3/31",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/3/31", index: 0, start: OracleComponents(year: 2012, month: 3, day: 31), startDate: OracleDate(2012, 3, 31, 12))
    ),
    OracleCase(
        sourceFile: "ja_slash_date_format.test.ts",
        input: "12/31",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12/31", index: 0, start: OracleComponents(year: 2012, month: 12, day: 31), startDate: OracleDate(2012, 12, 31, 12))
    ),
    OracleCase(
        sourceFile: "ja_slash_date_format.test.ts",
        input: "8/5",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8/5", index: 0, start: OracleComponents(year: 2012, month: 8, day: 5), startDate: OracleDate(2012, 8, 5, 12))
    ),
    OracleCase(
        sourceFile: "ja_slash_date_format.test.ts",
        input: "2013/12/26~2014/1/7",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2013/12/26~2014/1/7", index: 0, start: OracleComponents(year: 2013, month: 12, day: 26), startDate: OracleDate(2013, 12, 26, 12), end: OracleComponents(year: 2014, month: 1, day: 7), endDate: OracleDate(2014, 1, 7, 12))
    ),
]
