// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/uk/uk_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ukWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "uk_weekday.test.ts",
        input: "понеділок",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "понеділок", index: 0, startDate: OracleDate(2012, 8, 6, 12))
    ),
    OracleCase(
        sourceFile: "uk_weekday.test.ts",
        input: "Дедлайн у п'ятницю...",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "у п'ятницю", index: 8, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "uk_weekday.test.ts",
        input: "Дедлайн в минулий четвер!",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "в минулий четвер", index: 8, startDate: OracleDate(2012, 8, 2, 12))
    ),
    OracleCase(
        sourceFile: "uk_weekday.test.ts",
        input: "Дедлайн в наступний вівторок!",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "в наступний вівторок", index: 8, startDate: OracleDate(2015, 4, 21, 12))
    ),
    OracleCase(
        sourceFile: "uk_weekday.test.ts",
        input: "Подзвони в середу вранці",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "в середу вранці", index: 9, startDate: OracleDate(2015, 4, 15, 6))
    ),
    OracleCase(
        sourceFile: "uk_weekday.test.ts",
        input: "неділя, 7 грудня 2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "неділя, 7 грудня 2014", index: 0, startDate: OracleDate(2014, 12, 7, 12))
    ),
    OracleCase(
        sourceFile: "uk_weekday.test.ts",
        input: "У понеділок?",
        reference: OracleDate(2012, 8, 9),
        forwardDate: true,
        expectation: .match(text: "У понеділок", index: 0, startDate: OracleDate(2012, 8, 13, 12))
    ),
]
