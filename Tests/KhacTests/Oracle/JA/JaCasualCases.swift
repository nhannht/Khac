// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ja/ja_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let jaCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "今日感じたことを忘れずに",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今日", startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "きょう感じたことを忘れずに",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "きょう", startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "本日はお日柄もよく",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "本日", startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "ほんじつはお日柄もよく",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ほんじつ", startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "昨日の全国観測値ランキング",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "昨日", startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "きのうの全国観測値ランキング",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "きのう", startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "明日の天気は晴れです",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "明日", startDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "あしたの天気は晴れです",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "あした", startDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "今夜には雨が降るでしょう",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今夜", startDate: OracleDate(2012, 8, 10, 22))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "こんやには雨が降るでしょう",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "こんや", startDate: OracleDate(2012, 8, 10, 22))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "今夕には雨が降るでしょう",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今夕", startDate: OracleDate(2012, 8, 10, 22))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "こんゆうには雨が降るでしょう",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "こんゆう", startDate: OracleDate(2012, 8, 10, 22))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "今晩には雨が降るでしょう",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今晩", startDate: OracleDate(2012, 8, 10, 22))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "こんばんには雨が降るでしょう",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "こんばん", startDate: OracleDate(2012, 8, 10, 22))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "今朝食べたパンは美味しかった",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "今朝", startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "ja_casual.test.ts",
        input: "けさ食べたパンは美味しかった",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "けさ", startDate: OracleDate(2012, 8, 10, 6))
    ),
]
