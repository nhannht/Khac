// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "20:32:13",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "20:32:13", index: 0, startDate: OracleDate(2016, 10, 1, 20, 32, 13))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "10:00:00 - 21:45:01",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "10:00:00 - 21:45:01", index: 0, startDate: OracleDate(2016, 10, 1, 10), endDate: OracleDate(2016, 10, 1, 21, 45, 1))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "в 11 утра",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "в 11 утра", index: 0, startDate: OracleDate(2016, 10, 1, 11))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "в 11 вечера",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "в 11 вечера", index: 0, startDate: OracleDate(2016, 10, 1, 23))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "с 10 до 11 утра",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "с 10 до 11 утра", index: 0, startDate: OracleDate(2016, 10, 1, 10), endDate: OracleDate(2016, 10, 1, 11))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "с 10 до 11 вечера",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "с 10 до 11 вечера", index: 0, startDate: OracleDate(2016, 10, 1, 22), endDate: OracleDate(2016, 10, 1, 23))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "в 1",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "в 1", index: 0, start: OracleComponents(hour: 1))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "в 12",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "в 12", index: 0, start: OracleComponents(hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "в 12.30",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "в 12.30", index: 0, start: OracleComponents(hour: 12, minute: 30))
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "2020",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "2020  ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Температура 101,194 градусов!",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Температура 101 градусов!",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Температура 10.1",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 10.1 - 10.12",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 10 - 10.1",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 101,194 телефон!",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 101 стул!",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 10.1",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 10",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "2020",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 10.1 - 10.12",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 10 - 10.1",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "Это в 10 - 20",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_exp.test.ts",
        input: "7-730",
        reference: OracleDate(2012, 8, 10, 12),
        mode: .strict,
        expectation: .noMatch
    ),
]
