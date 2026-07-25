// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_month.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruMonthCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "Сентябрь 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Сентябрь 2012", index: 0, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "сен 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "сен 2012", index: 0, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "сен. 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "сен. 2012", index: 0, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "сен-2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "сен-2012", index: 0, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "в январе",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "в январе", index: 0, startDate: OracleDate(2021, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "в янв",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "в янв", index: 0, startDate: OracleDate(2021, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "май",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "май", index: 0, startDate: OracleDate(2021, 5, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "Это было в сентябре 2012 перед новым годом",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "в сентябре 2012", index: 9, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "авг 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "авг 96", index: 0, startDate: OracleDate(1996, 8, 1, 12))
    ),
    OracleCase(
        sourceFile: "ru_month.test.ts",
        input: "96 авг 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "авг 96", index: 3, startDate: OracleDate(1996, 8, 1, 12))
    ),
]
