// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_weekday.test.ts",
        input: "понедельник",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "понедельник", index: 0, startDate: OracleDate(2012, 8, 6, 12))
    ),
    OracleCase(
        sourceFile: "ru_weekday.test.ts",
        input: "Дедлайн в пятницу...",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "в пятницу", index: 8, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ru_weekday.test.ts",
        input: "Дедлайн в прошлый четверг!",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "в прошлый четверг", index: 8, startDate: OracleDate(2012, 8, 2, 12))
    ),
    OracleCase(
        sourceFile: "ru_weekday.test.ts",
        input: "Дедлайн в следующий вторник",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "в следующий вторник", index: 8, startDate: OracleDate(2015, 4, 21, 12))
    ),
    OracleCase(
        sourceFile: "ru_weekday.test.ts",
        input: "Позвони в среду утром",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "в среду утром", index: 8, startDate: OracleDate(2015, 4, 15, 6))
    ),
    OracleCase(
        sourceFile: "ru_weekday.test.ts",
        input: "воскресенье, 7 декабря 2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "воскресенье, 7 декабря 2014", index: 0, startDate: OracleDate(2014, 12, 7, 12))
    ),
    OracleCase(
        sourceFile: "ru_weekday.test.ts",
        input: "В понедельник?",
        reference: OracleDate(2012, 8, 9),
        forwardDate: true,
        expectation: .match(text: "В понедельник", index: 0, startDate: OracleDate(2012, 8, 13, 12))
    ),
]
