// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/uk/uk_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ukCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн сьогодні",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "сьогодні", index: 8, startDate: OracleDate(2012, 8, 10, 17, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн завтра",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "завтра", index: 8, startDate: OracleDate(2012, 8, 11, 17, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн післязавтра",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "післязавтра", index: 8, startDate: OracleDate(2012, 8, 12, 17, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн післяпіслязавтра",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "післяпіслязавтра", index: 8, startDate: OracleDate(2012, 8, 13, 17, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн вчора",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "вчора", index: 8, startDate: OracleDate(2012, 8, 9, 17, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн позавчора",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "позавчора", index: 8, startDate: OracleDate(2012, 8, 8, 17, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн позапозавчора",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "позапозавчора", index: 8, startDate: OracleDate(2012, 8, 7, 17, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн зараз",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "зараз", index: 8, startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн вранці",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "вранці", index: 8, startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн цього ранку",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "цього ранку", index: 8, startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн опівдні",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "опівдні", index: 8, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн минулого вечора",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "минулого вечора", index: 8, startDate: OracleDate(2012, 8, 9, 20))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн ввечері",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "ввечері", index: 8, startDate: OracleDate(2012, 8, 10, 20))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн минулої ночі",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "минулої ночі", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн сьогодні вночі",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "сьогодні вночі", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн цієї ночі",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "цієї ночі", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн вночі",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "вночі", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн опівночі",
        reference: OracleDate(2012, 8, 10, 2, 9, 10, 11),
        expectation: .match(text: "опівночі", index: 8, startDate: OracleDate(2012, 8, 10))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн вчора ввечері",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "вчора ввечері", index: 8, startDate: OracleDate(2012, 8, 9, 20))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Дедлайн завтра вранці",
        reference: OracleDate(2012, 9, 10, 14),
        expectation: .match(text: "завтра вранці", index: 8, startDate: OracleDate(2012, 9, 11, 6))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Подія від сьогодні і до післязавтра",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "від сьогодні і до післязавтра", index: 6, startDate: OracleDate(2012, 8, 4, 12), endDate: OracleDate(2012, 8, 6, 12))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "Подія сьогодні-завтра",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "сьогодні-завтра", index: 6, startDate: OracleDate(2012, 8, 10, 12), endDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "несьогодні",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "звтра",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "ввчора",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "uk_casual.test.ts",
        input: "січен",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
