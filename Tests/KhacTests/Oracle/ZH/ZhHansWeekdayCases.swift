// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hans/zh_hans_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHansWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "星期四",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "星期四", index: 0, start: OracleComponents(year: 2016, month: 9, day: 1, weekday: 4))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "我周一要打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "周一", index: 1, start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "礼拜四 (forward dates only)",
        reference: OracleDate(2016, 9, 2),
        forwardDate: true,
        expectation: .match(text: "礼拜四", index: 0, start: OracleComponents(year: 2016, month: 9, day: 8, weekday: 4))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "礼拜日",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "礼拜日", index: 0, start: OracleComponents(year: 2016, month: 9, day: 4, weekday: 0))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "我上个礼拜三在打游戏",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "上个礼拜三", index: 1, start: OracleComponents(year: 2016, month: 8, day: 24, weekday: 3))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "我下星期天打游戏",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "下星期天", index: 1, start: OracleComponents(year: 2016, month: 9, day: 4, weekday: 0))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "我这个星期一要打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "这个星期一", index: 1, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "星期一",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_weekday.test.ts",
        input: "星期六-星期一",
        reference: OracleDate(2016, 9, 2),
        forwardDate: true,
        expectation: .match(text: "星期六-星期一", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3, weekday: 6), end: OracleComponents(year: 2016, month: 9, day: 5, weekday: 1))
    ),
]
