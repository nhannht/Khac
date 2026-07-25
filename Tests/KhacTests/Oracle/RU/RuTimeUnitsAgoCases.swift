// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_time_units_ago.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruTimeUnitsAgoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "5 дней назад что-то было",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "5 дней назад", index: 0, startDate: OracleDate(2012, 7, 5))
    ),
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "5 минут назад что-то было",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "5 минут назад", index: 0, startDate: OracleDate(2012, 7, 9, 23, 55))
    ),
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "полчаса назад что-то было",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "полчаса назад", index: 0, startDate: OracleDate(2012, 7, 9, 23, 30))
    ),
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "5 дней 2 часа назад что-то было",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "5 дней 2 часа назад", index: 0, startDate: OracleDate(2012, 7, 4, 22))
    ),
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "5 минут 20 секунд назад что-то было",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "5 минут 20 секунд назад", index: 0, startDate: OracleDate(2012, 7, 9, 23, 54, 40))
    ),
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "2 часа 5 минут назад что-то было",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "2 часа 5 минут назад", index: 0, startDate: OracleDate(2012, 7, 9, 21, 55))
    ),
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "15 часов 29 мин",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "несколько часов",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_time_units_ago.test.ts",
        input: "5 дней",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
