// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_time_units_casual_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruTimeUnitsCasualRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "следующие 2 недели",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "следующие 2 недели", index: 0, start: OracleComponents(year: 2016, month: 10, day: 15, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "следующие 2 дня",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "следующие 2 дня", index: 0, start: OracleComponents(year: 2016, month: 10, day: 3, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "следующие два года",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "следующие два года", index: 0, start: OracleComponents(year: 2018, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "следующие 2 недели 3 дня",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "следующие 2 недели 3 дня", index: 0, start: OracleComponents(year: 2016, month: 10, day: 18, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "через пару минут",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через пару минут", index: 0, start: OracleComponents(year: 2016, month: 10, day: 1, hour: 12, minute: 2))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "через полчаса",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через полчаса", index: 0, start: OracleComponents(year: 2016, month: 10, day: 1, hour: 12, minute: 30))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "через 2 часа",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через 2 часа", index: 0, start: OracleComponents(year: 2016, month: 10, day: 1, hour: 14))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "спустя 2 часа",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "спустя 2 часа", index: 0, start: OracleComponents(year: 2016, month: 10, day: 1, hour: 14))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "через три месяца",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через три месяца", index: 0, start: OracleComponents(year: 2017, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "через неделю",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через неделю", index: 0, start: OracleComponents(year: 2016, month: 10, day: 8, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "через месяц",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через месяц", index: 0, start: OracleComponents(year: 2016, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "прошлые 2 недели",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "прошлые 2 недели", index: 0, start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "прошлые два дня",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "прошлые два дня", index: 0, start: OracleComponents(year: 2016, month: 9, day: 29, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "+15 минут",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15 минут", index: 0, start: OracleComponents(year: 2012, month: 7, day: 10, hour: 12, minute: 29))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "+15мин",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15мин", index: 0, start: OracleComponents(year: 2012, month: 7, day: 10, hour: 12, minute: 29))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "+1 день 2 часа",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+1 день 2 часа", index: 0, start: OracleComponents(year: 2012, month: 7, day: 11, hour: 14, minute: 14))
    ),
    OracleCase(
        sourceFile: "ru_time_units_casual_relative.test.ts",
        input: "-3 года",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .match(text: "-3 года", index: 0, start: OracleComponents(year: 2012, month: 7, day: 10, hour: 12, minute: 14))
    ),
]
