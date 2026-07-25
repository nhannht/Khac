// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/zh.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhRootCases: [OracleCase] = [
    OracleCase(
        sourceFile: "zh.test.ts",
        input: "1994-11-05T08:15:30-05:30",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "1994-11-05T08:15:30-05:30", start: OracleComponents(year: 1994, month: 11, day: 5, hour: 8, minute: 15, second: 30, timezoneOffset: -330), startDate: OracleDate(1994, 11, 5, 13, 45, 30))
    ),
    OracleCase(
        sourceFile: "zh.test.ts",
        input: "明天早上8点",
        reference: OracleDate(2012, 8, 8, 12),
        expectation: .match(text: "明天早上8点", start: OracleComponents(year: 2012, month: 8, day: 9, hour: 8))
    ),
    OracleCase(
        sourceFile: "zh.test.ts",
        input: "明天早上8點",
        reference: OracleDate(2012, 8, 8, 12),
        expectation: .match(text: "明天早上8點", start: OracleComponents(year: 2012, month: 8, day: 9, hour: 8))
    ),
]
