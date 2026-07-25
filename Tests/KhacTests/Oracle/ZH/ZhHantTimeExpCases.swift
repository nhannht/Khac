// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hant/zh_hant_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHantTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "雞上午6點13分全部都係雞",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "上午6點13分", index: 1, start: OracleComponents(hour: 6, minute: 13))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "雞後天凌晨全部都係雞",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "後天凌晨", index: 1)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "雞大前天凌晨全部都係雞",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "大前天凌晨", index: 1)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "我明天上午8點要打遊戲",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "明天上午8點", index: 1, start: OracleComponents(year: 2012, month: 8, day: 11, hour: 8))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "雞由今朝八點十分至下午11點32分全部都係雞",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "由今朝八點十分至下午11點32分", index: 1, start: OracleComponents(hour: 8, minute: 10), end: OracleComponents(hour: 23, minute: 32))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "6點30pm-11點pm",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "6點30pm-11點pm", index: 0, start: OracleComponents(hour: 18, minute: 30), end: OracleComponents(hour: 23, minute: 0))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "雞二零一八年十一月廿六日下午三時半五十九秒全部都係雞",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "二零一八年十一月廿六日下午三時半五十九秒", index: 1, start: OracleComponents(year: 2018, month: 11, day: 26, hour: 15, minute: 30, second: 59, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "1點pm到3點",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "1點pm到3點", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 13, minute: 0, second: 0, millisecond: 0), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 3, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "大後日下晝5點",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "大後日下晝5點", index: 0, start: OracleComponents(year: 2012, month: 8, day: 13, hour: 17, minute: 0))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "聽晚10點到聽晚11點",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "聽晚10點到聽晚11點", index: 0, start: OracleComponents(year: 2012, month: 8, day: 11, hour: 22, minute: 0), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 23, minute: 0))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "2014年, 3月5日晏晝 6 點至 7 點",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2014年, 3月5日晏晝 6 點至 7 點")
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "下星期六凌晨1點30分廿九秒",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "下星期六凌晨1點30分廿九秒")
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "尋日朝早六點正",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "尋日朝早六點正")
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "六月四日3:00am",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "六月四日3:00am")
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "上個禮拜五16時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "上個禮拜五16時")
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "3月17日 20點15",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3月17日 20點15")
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "10點",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10點")
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_time_exp.test.ts",
        input: "中午12點",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 12))
    ),
]
