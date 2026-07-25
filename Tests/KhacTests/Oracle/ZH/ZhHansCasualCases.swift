// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hans/zh_hans_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHansCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我今天要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今天", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我明日要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "明日", index: 1, start: OracleComponents(year: 2012, month: 8, day: 11))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我前天要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "前天", index: 1, start: OracleComponents(year: 2012, month: 8, day: 8))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我昨日要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "昨日", index: 1, start: OracleComponents(year: 2012, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我昨天晚上要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "昨天晚上", index: 1, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 22))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我今天早上要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今天早上", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我下午要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "下午", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我今晚要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今晚", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我今天下午5点要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今天下午5点", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我今天 - 下周五要打游戏",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "今天 - 下周五", index: 1, start: OracleComponents(year: 2012, month: 8, day: 4, hour: 12), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 12))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "我今日 - 下周五要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今日 - 下周五", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), end: OracleComponents(year: 2012, month: 8, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "今日夜晚",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "今日夜晚", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 22))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "今晚8点正",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "今晚8点正", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_casual.test.ts",
        input: "晚上8点",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "晚上8点", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
]
