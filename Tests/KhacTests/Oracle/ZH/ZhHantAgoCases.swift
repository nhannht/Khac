// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hant/zh_hant_ago.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHantAgoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hant/zh_hant_ago.test.ts",
        input: "1小時前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1小時前", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_ago.test.ts",
        input: "1小時之前出門了",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1小時之前", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_ago.test.ts",
        input: "五分鐘前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "五分鐘前", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_ago.test.ts",
        input: "3天前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "3天前", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_ago.test.ts",
        input: "2禮拜前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "2禮拜前", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_ago.test.ts",
        input: "半小時前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "半小時前", index: 0)
    ),
]
