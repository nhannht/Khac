// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hans/zh_hans_ago.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHansAgoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hans/zh_hans_ago.test.ts",
        input: "1小时前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1小时前", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_ago.test.ts",
        input: "1小时之前出门了",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1小时之前", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_ago.test.ts",
        input: "五分钟前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "五分钟前", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_ago.test.ts",
        input: "3天前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "3天前", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_ago.test.ts",
        input: "2星期前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "2星期前", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_ago.test.ts",
        input: "半小时前",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "半小时前", index: 0)
    ),
]
