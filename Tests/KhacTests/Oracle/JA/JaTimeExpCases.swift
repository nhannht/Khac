// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ja/ja_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let jaTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "私は午前6時13分に起きた",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "午前6時13分", index: 2, start: OracleComponents(hour: 6, minute: 13))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "私は午前8時に起きる",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "午前8時", index: 2, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "午後8時",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "午後8時", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 20))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "12/9の16:00",
        reference: OracleDate(2025, 12, 10, 12),
        expectation: .match(text: "12/9の16:00", start: OracleComponents(year: 2025, month: 12, day: 9, hour: 16))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "１２月９日の１６：３０",
        reference: OracleDate(2025, 12, 10, 12),
        expectation: .match(text: "１２月９日の１６：３０", start: OracleComponents(year: 2025, month: 12, day: 9, hour: 16, minute: 30))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "私は本日午前八時十分から午後11時32分までゲームをした",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "本日午前八時十分から午後11時32分", index: 2, start: OracleComponents(hour: 8, minute: 10), end: OracleComponents(hour: 23, minute: 32))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "6時30分PM-11時PM",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "6時30分PM-11時PM", index: 0, start: OracleComponents(hour: 18, minute: 30), end: OracleComponents(hour: 23, minute: 0))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "僕は2018年11月26日午後三時半五十九秒にゲームを始めた",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2018年11月26日午後三時半五十九秒", index: 2, start: OracleComponents(year: 2018, month: 11, day: 26, hour: 15, minute: 30, second: 59, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "午後1時30分から3時10分",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 13, minute: 30, second: 0), startDate: OracleDate(2012, 8, 10, 13, 30), end: OracleComponents(hour: 15, minute: 10, second: 0), endDate: OracleDate(2012, 8, 10, 15, 10))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "1時20分P.M.から3時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 13, minute: 20, second: 0), startDate: OracleDate(2012, 8, 10, 13, 20), end: OracleComponents(hour: 15, minute: 0, second: 0), endDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "午後６時半－１１時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "午後６時半－１１時", index: 0, start: OracleComponents(hour: 18, minute: 30), startDate: OracleDate(2012, 8, 10, 18, 30), end: OracleComponents(hour: 23, minute: 0), endDate: OracleDate(2012, 8, 10, 23))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "午後１１時半－１時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "午後１１時半－１時", index: 0, start: OracleComponents(hour: 23, minute: 30), startDate: OracleDate(2012, 8, 10, 23, 30), end: OracleComponents(hour: 1, minute: 0), endDate: OracleDate(2012, 8, 11, 1))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "23時20分から2時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "23時20分から2時", index: 0, start: OracleComponents(hour: 23, minute: 20), startDate: OracleDate(2012, 8, 10, 23, 20), end: OracleComponents(hour: 2, minute: 0), endDate: OracleDate(2012, 8, 11, 2))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "2014年3月5日午前 6 時から 7 時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2014年3月5日午前 6 時から 7 時")
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "次の土曜日1時30分二十九秒",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "次の土曜日1時30分二十九秒")
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "昨日午前六時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "昨日午前六時")
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "６月４日3:00am",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "６月４日3:00am")
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "前の金曜日16時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "前の金曜日16時")
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "3月17日 20時15",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3月17日 20時15")
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "10時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10時")
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "12時",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 12))
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "午後１3時",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "25時",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "5時70分",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "5時30分65秒",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "23時-25時",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "3時-5時70分",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "3時-5時30分65秒",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "1",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "12",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "12a",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "1時間",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ja_time_exp.test.ts",
        input: "25時間",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
