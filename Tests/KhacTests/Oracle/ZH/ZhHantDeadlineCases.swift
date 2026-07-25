// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/zh/hant/zh_hant_deadline.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let zhHantDeadlineCases: [OracleCase] = [
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "五日內我地有d野做",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "五日內", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "5日之內我地有d野做",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5日之內", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "十日內我地有d野做",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "十日內", index: 0, start: OracleComponents(year: 2012, month: 8, day: 20))
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "五分鐘後",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "五分鐘後", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "一個鐘之內",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "一個鐘之內", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "5分鐘之後我就收皮",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5分鐘之後", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "係5秒之後你就會收皮",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5秒之後", index: 1)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "半小時之內",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "半小時之內", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "兩個禮拜內答覆我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "兩個禮拜內", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "1個月之內答覆我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1個月之內", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "幾個月之內答覆我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "幾個月之內", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "一年內答覆我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "一年內", index: 0)
    ),
    OracleCase(
        sourceFile: "hant/zh_hant_deadline.test.ts",
        input: "1年之內答覆我",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1年之內", index: 0)
    ),
]
