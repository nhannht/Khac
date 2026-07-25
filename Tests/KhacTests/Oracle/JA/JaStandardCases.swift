// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ja/ja_standard.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let jaStandardCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（2012年3月31日現在）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012年3月31日", index: 5, start: OracleComponents(year: 2012, month: 3, day: 31), startDate: OracleDate(2012, 3, 31, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（2012年９月3日現在）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012年９月3日", index: 5, start: OracleComponents(year: 2012, month: 9, day: 3), startDate: OracleDate(2012, 9, 3, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（2020年2月29日現在）",
        reference: OracleDate(2019, 8, 10),
        expectation: .match(text: "2020年2月29日", index: 5, start: OracleComponents(year: 2020, month: 2, day: 29), startDate: OracleDate(2020, 2, 29, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（９月3日現在）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "９月3日", index: 5, start: OracleComponents(year: 2012, month: 9, day: 3), startDate: OracleDate(2012, 9, 3, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（平成26年12月29日）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "平成26年12月29日", index: 5, start: OracleComponents(year: 2014, month: 12, day: 29), startDate: OracleDate(2014, 12, 29, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（昭和６４年１月７日）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "昭和６４年１月７日", index: 5, start: OracleComponents(year: 1989, month: 1, day: 7), startDate: OracleDate(1989, 1, 7, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（令和元年5月1日）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "令和元年5月1日", index: 5, start: OracleComponents(year: 2019, month: 5, day: 1), startDate: OracleDate(2019, 5, 1, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（令和2年5月1日）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "令和2年5月1日", index: 5, start: OracleComponents(year: 2020, month: 5, day: 1), startDate: OracleDate(2020, 5, 1, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（同年7月27日）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "同年7月27日", index: 5, start: OracleComponents(year: 2012, month: 7, day: 27), startDate: OracleDate(2012, 7, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（本年7月27日）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "本年7月27日", index: 5, start: OracleComponents(year: 2012, month: 7, day: 27), startDate: OracleDate(2012, 7, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（今年7月27日）",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "今年7月27日", index: 5, start: OracleComponents(year: 2012, month: 7, day: 27), startDate: OracleDate(2012, 7, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "主な株主（今年11月27日）",
        reference: OracleDate(2012, 1, 10),
        expectation: .match(text: "今年11月27日", index: 5, start: OracleComponents(year: 2012, month: 11, day: 27), startDate: OracleDate(2012, 11, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "7月27日",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "7月27日", index: 0, start: OracleComponents(year: 2012, month: 7, day: 27), startDate: OracleDate(2012, 7, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "11月27日",
        reference: OracleDate(2012, 1, 10),
        expectation: .match(text: "11月27日", index: 0, start: OracleComponents(year: 2011, month: 11, day: 27), startDate: OracleDate(2011, 11, 27, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "2013年12月26日-2014年1月7日",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2013年12月26日-2014年1月7日", index: 0, start: OracleComponents(year: 2013, month: 12, day: 26), startDate: OracleDate(2013, 12, 26, 12), end: OracleComponents(year: 2014, month: 1, day: 7), endDate: OracleDate(2014, 1, 7, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "２０１３年１２月２６日ー2014年1月7日",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "２０１３年１２月２６日ー2014年1月7日", index: 0, start: OracleComponents(year: 2013, month: 12, day: 26), startDate: OracleDate(2013, 12, 26, 12), end: OracleComponents(year: 2014, month: 1, day: 7), endDate: OracleDate(2014, 1, 7, 12))
    ),
    OracleCase(
        sourceFile: "ja_standard.test.ts",
        input: "2013年12月26日 ～ ２０１４年１月７日",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2013年12月26日 ～ ２０１４年１月７日", index: 0, start: OracleComponents(year: 2013, month: 12, day: 26), startDate: OracleDate(2013, 12, 26, 12), end: OracleComponents(year: 2014, month: 1, day: 7), endDate: OracleDate(2014, 1, 7, 12))
    ),
]
