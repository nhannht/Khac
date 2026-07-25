// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hant/zh_hant_date.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHantDateCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hant/zh_hant_date.test.ts",
        input: "雞2016年9月3號全部都係雞",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2016年9月3號", index: 1, start: OracleComponents(year: 2016, month: 9, day: 3))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_date.test.ts",
        input: "雞二零一六年，九月三號全部都係雞",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "二零一六年，九月三號", index: 1, start: OracleComponents(year: 2016, month: 9, day: 3))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_date.test.ts",
        input: "雞九月三號全部都係雞",
        reference: OracleDate(2014, 8, 10),
        expectation: .match(text: "九月三號", index: 1, start: OracleComponents(year: 2014, month: 9, day: 3))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_date.test.ts",
        input: "2016年09月03日",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2016年09月03日", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_date.test.ts",
        input: "2016年9月3號-2017年10月24號",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2016年9月3號-2017年10月24號", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3), end: OracleComponents(year: 2017, month: 10, day: 24))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_date.test.ts",
        input: "二零一六年九月三號ー2017年10月24號",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "二零一六年九月三號ー2017年10月24號", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3), end: OracleComponents(year: 2017, month: 10, day: 24))
    ),
]
