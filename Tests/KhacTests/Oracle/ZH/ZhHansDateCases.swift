// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hans/zh_hans_date.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHansDateCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hans/zh_hans_date.test.ts",
        input: "我2016年9月3号要打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2016年9月3号", index: 1, start: OracleComponents(year: 2016, month: 9, day: 3))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_date.test.ts",
        input: "我二零一六年，九月三号要打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "二零一六年，九月三号", index: 1, start: OracleComponents(year: 2016, month: 9, day: 3))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_date.test.ts",
        input: "我九月三号要打游戏",
        reference: OracleDate(2014, 8, 10),
        expectation: .match(text: "九月三号", index: 1, start: OracleComponents(year: 2014, month: 9, day: 3))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_date.test.ts",
        input: "2016年09月03号",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2016年09月03号", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_date.test.ts",
        input: "2016年9月3号-2017年10月24号",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2016年9月3号-2017年10月24号", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3), end: OracleComponents(year: 2017, month: 10, day: 24))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_date.test.ts",
        input: "二零一六年九月三号ー2017年10月24号",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "二零一六年九月三号ー2017年10月24号", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3), end: OracleComponents(year: 2017, month: 10, day: 24))
    ),
]
