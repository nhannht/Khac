// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hans/zh_hans_deadline.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHansDeadlineCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "五日内我要通关游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "五日内", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "5日之内我要通关游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5日之内", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "十日内我要通关游戏",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "十日内", index: 0, start: OracleComponents(year: 2012, month: 8, day: 20))
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "五分钟后",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "五分钟后", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "一个钟之内",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "一个钟之内", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "5分钟之后出门",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5分钟之后", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "我要5秒之后出门",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5秒之后", index: 2)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "半小时之内",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "半小时之内", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "两个礼拜内答复我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "两个礼拜内", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "1个月之内答复我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1个月之内", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "几个月之内答复我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "几个月之内", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "一年内答复我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "一年内", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "1年之内答复我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1年之内", index: 0)
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "5秒钟后",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5秒钟后")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "2小时后",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "2小时后")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "3天后",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "3天后")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "2星期后",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "2星期后")
    ),
    OracleCase(
        sourceFile: "hans/zh_hans_deadline.test.ts",
        input: "5分钟过后",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5分钟过后")
    ),
]
