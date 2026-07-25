// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн сегодня",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "сегодня", index: 8, startDate: OracleDate(2012, 8, 10, 17, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн завтра",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "завтра", index: 8, startDate: OracleDate(2012, 8, 11, 17, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн послезавтра",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "послезавтра", index: 8, startDate: OracleDate(2012, 8, 12, 17, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн послепослезавтра",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "послепослезавтра", index: 8, startDate: OracleDate(2012, 8, 13, 17, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн вчера",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "вчера", index: 8, startDate: OracleDate(2012, 8, 9, 17, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн позавчера",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "позавчера", index: 8, startDate: OracleDate(2012, 8, 8, 17, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн позапозавчера",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "позапозавчера", index: 8, startDate: OracleDate(2012, 8, 7, 17, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн сейчас",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "сейчас", index: 8, startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн утром",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "утром", index: 8, startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн этим утром",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "этим утром", index: 8, startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн в полдень",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "в полдень", index: 8, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн прошлым вечером",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "прошлым вечером", index: 8, startDate: OracleDate(2012, 8, 9, 20))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн вечером",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "вечером", index: 8, startDate: OracleDate(2012, 8, 10, 20))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн прошлой ночью",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "прошлой ночью", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн прошлой ночью",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "прошлой ночью", index: 8, startDate: OracleDate(2012, 8, 9))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн сегодня ночью",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "сегодня ночью", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн этой ночью",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "этой ночью", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн ночью",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "ночью", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн в полночь",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "в полночь", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн вчера вечером",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "вчера вечером", index: 8, startDate: OracleDate(2012, 8, 9, 20))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Дедлайн завтра утром",
        reference: OracleDate(2012, 9, 10, 14),
        expectation: .match(text: "завтра утром", index: 8, startDate: OracleDate(2012, 9, 11, 6))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Событие с сегодня и до послезавтра",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "с сегодня и до послезавтра", index: 8, startDate: OracleDate(2012, 8, 4, 12), endDate: OracleDate(2012, 8, 6, 12))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "Событие сегодня-завтра",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "сегодня-завтра", index: 8, startDate: OracleDate(2012, 8, 10, 12), endDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "несегодня",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "зявтра",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "вчеера",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_casual.test.ts",
        input: "январ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
