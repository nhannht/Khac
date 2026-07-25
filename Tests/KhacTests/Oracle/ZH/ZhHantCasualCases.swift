// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hant/zh_hant_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHantCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞而家全部都係雞",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "而家", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8, minute: 9, second: 10, millisecond: 11))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞今日全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今日", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞聽日全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "聽日", index: 1, start: OracleComponents(year: 2012, month: 8, day: 11))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞前日全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "前日", index: 1, start: OracleComponents(year: 2012, month: 8, day: 8))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞琴日全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "琴日", index: 1, start: OracleComponents(year: 2012, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞昨天晚上全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "昨天晚上", index: 1, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 22))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞今日朝早全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今日朝早", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞晏晝全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "晏晝", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞今晚全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今晚", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞今日晏晝5點全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今日晏晝5點", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞今日 - 下禮拜五全部都係雞",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "今日 - 下禮拜五", index: 1, start: OracleComponents(year: 2012, month: 8, day: 4, hour: 12), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 12))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "雞今日 - 下禮拜五全部都係雞",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今日 - 下禮拜五", index: 1, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), end: OracleComponents(year: 2012, month: 8, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "今日夜晚",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "今日夜晚", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 22))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "今晚8點正",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "今晚8點正", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_casual.test.ts",
        input: "晚上8點",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "晚上8點", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
]
