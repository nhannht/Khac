// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hant/zh_hant_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHantWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "星期四",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "星期四", index: 0, start: OracleComponents(year: 2016, month: 9, day: 1, weekday: 4))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "我週一要打遊戲",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "週一", index: 1, start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "禮拜四 (forward dates only)",
        reference: OracleDate(2016, 9, 2),
        forwardDate: true,
        expectation: .match(text: "禮拜四", index: 0, start: OracleComponents(year: 2016, month: 9, day: 8, weekday: 4))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "禮拜日",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "禮拜日", index: 0, start: OracleComponents(year: 2016, month: 9, day: 4, weekday: 0))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "雞上個禮拜三全部都係雞",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "上個禮拜三", index: 1, start: OracleComponents(year: 2016, month: 8, day: 24, weekday: 3))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "雞下星期天全部都係雞",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "下星期天", index: 1, start: OracleComponents(year: 2016, month: 9, day: 4, weekday: 0))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "我這個星期一要打遊戲",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "這個星期一", index: 1, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "星期一",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_weekday.test.ts",
        input: "星期六-星期一",
        reference: OracleDate(2016, 9, 2),
        forwardDate: true,
        expectation: .match(text: "星期六-星期一", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3, weekday: 6), end: OracleComponents(year: 2016, month: 9, day: 5, weekday: 1))
    ),
]
