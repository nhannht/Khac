// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hans/zh_hans_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHansTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "我上午6点13分打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "上午6点13分", index: 1, start: OracleComponents(hour: 6, minute: 13))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "我后天凌晨打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "后天凌晨", index: 1)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "我大前天凌晨打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "大前天凌晨", index: 1)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "我明天上午8点要打游戏",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "明天上午8点", index: 1, start: OracleComponents(year: 2012, month: 8, day: 11, hour: 8))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "早上8点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "早上8点", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "我从今早八点十分至下午11点32分打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "从今早八点十分至下午11点32分", index: 1, start: OracleComponents(hour: 8, minute: 10), end: OracleComponents(hour: 23, minute: 32))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "6点30pm-11点pm",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "6点30pm-11点pm", index: 0, start: OracleComponents(hour: 18, minute: 30), end: OracleComponents(hour: 23, minute: 0))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "我二零一八年十一月二十六日下午三点半五十九秒打游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "二零一八年十一月二十六日下午三点半五十九秒", index: 1, start: OracleComponents(year: 2018, month: 11, day: 26, hour: 15, minute: 30, second: 59, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "1点pm到3点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "1点pm到3点", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 13, minute: 0, second: 0, millisecond: 0), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 3, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "2014年, 3月5日早上 6 点至 7 点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2014年, 3月5日早上 6 点至 7 点")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "下星期六凌晨1点30分二十九秒",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "下星期六凌晨1点30分二十九秒")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "昨天早上六点正",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "昨天早上六点正")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "六月四日3:00am",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "六月四日3:00am")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "上个礼拜五16时",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "上个礼拜五16时")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "3月17日 20点15",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3月17日 20点15")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "10点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10点")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "中午12点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 12))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10时",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 22))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "昨晚8点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(day: 9, hour: 20))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "前天下午三点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(day: 8, hour: 15))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "大后天晚上9点30分",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(day: 13, hour: 21, minute: 30))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "三点",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(start: OracleComponents(hour: 3))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "晚上11点 ~ 凌晨2点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 23), end: OracleComponents(day: 11, hour: 2))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "2023-10-26 10:30:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2023-10-26 10:30:00", start: OracleComponents(year: 2023, month: 10, day: 26, hour: 10, minute: 30, second: 0))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 明天早上6点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 6))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今天早上9点 - 后天凌晨3点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 9), end: OracleComponents(year: 2012, month: 8, day: 12, hour: 3))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 明早6点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 6))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "9:00:00 - 9:00:30",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 9, minute: 0, second: 0), end: OracleComponents(hour: 9, minute: 0, second: 30))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "下午2点 - 晚上8点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 14), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 20))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "3点 - 5点PM",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 17))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 昨晚10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 前天晚上10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 8))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 大前天晚上10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 7))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 后天晚上10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 12))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 大后天晚上10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 13))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "明天10点到明天11点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "明天10点到明天11点", start: OracleComponents(day: 11, hour: 10), end: OracleComponents(day: 11, hour: 11))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今早10点 - 明早10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 10), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 10))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今早10点 - 明天上午10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 10), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 10))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今早10点 - 明天凌晨2点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 10), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 2))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "下午2点 - 明天下午3点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 14), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 15))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "晚上10点 - 2点",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 2))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 前晚10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 8, hour: 22))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 大前晚10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 7, hour: 22))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 后早10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 12, hour: 10))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_time_exp.test.ts",
        input: "今晚10点 - 大后早10点",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10), end: OracleComponents(year: 2012, month: 8, day: 13, hour: 10))
    ),
]
