// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ja/ja_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let jaWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "木曜日",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "木曜日", index: 0, start: OracleComponents(year: 2016, month: 9, day: 1, weekday: 4))
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "前の水曜日",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "前の水曜日", index: 0, start: OracleComponents(year: 2016, month: 8, day: 31, weekday: 3))
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "(木)",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "(木)", index: 0, start: OracleComponents(year: 2016, month: 9, day: 1, weekday: 4))
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "（木）",
        reference: OracleDate(2016, 9, 2),
        expectation: .match(text: "（木）", index: 0, start: OracleComponents(year: 2016, month: 9, day: 1, weekday: 4))
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "土曜日～月曜日",
        reference: OracleDate(2016, 9, 2),
        forwardDate: true,
        expectation: .match(text: "土曜日～月曜日", index: 0, start: OracleComponents(year: 2016, month: 9, day: 3, weekday: 6), end: OracleComponents(year: 2016, month: 9, day: 5, weekday: 1))
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "8月27日水曜日",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8月27日水曜日", index: 0, start: OracleComponents(year: 2012, month: 8, day: 27, weekday: 3), startDate: OracleDate(2012, 8, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "8月27日（水）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8月27日（水）", index: 0, start: OracleComponents(year: 2012, month: 8, day: 27, weekday: 3), startDate: OracleDate(2012, 8, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "2012/8/27（水）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/8/27（水）", index: 0, start: OracleComponents(year: 2012, month: 8, day: 27, weekday: 3), startDate: OracleDate(2012, 8, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "１／３０（木）",
        reference: OracleDate(2025, 2, 10),
        expectation: .match(text: "１／３０（木）")
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "1/30の木曜日",
        reference: OracleDate(2025, 2, 10),
        expectation: .match(text: "1/30の木曜日")
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "1/30(木)",
        reference: OracleDate(2025, 2, 10),
        expectation: .match(text: "1/30(木)")
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "１月３０日（木）１４：００",
        reference: OracleDate(2025, 2, 10),
        expectation: .match(text: "１月３０日（木）１４：００")
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "１月３１日（金）１２：００－１６：００",
        reference: OracleDate(2025, 2, 10),
        expectation: .match(text: "１月３１日（金）１２：００－１６：００")
    ),
    OracleCase(
        sourceFile: "ja_weekday.test.ts",
        input: "１月３０日（木）１２：００－１月３１日（金）１６：００",
        reference: OracleDate(2025, 2, 10),
        expectation: .match(text: "１月３０日（木）１２：００－１月３１日（金）１６：００", start: OracleComponents(weekday: 4), startDate: OracleDate(2025, 1, 30, 12), end: OracleComponents(weekday: 5), endDate: OracleDate(2025, 1, 31, 16))
    ),
]
