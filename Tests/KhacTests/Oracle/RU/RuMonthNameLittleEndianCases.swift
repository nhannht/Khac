// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_month_name_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruMonthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10.08.2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10.08.2012", index: 0, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10 августа 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 августа 2012", index: 0, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "третье фев 82",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "третье фев 82", index: 0, startDate: OracleDate(1982, 2, 3, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "Дедлайн 10 августа",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 августа", index: 8, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "Дедлайн Четверг, 10 января",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Четверг, 10 января", index: 8, startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10-августа 2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10-августа 2012")
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10-августа-2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10-августа-2012")
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10/августа 2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10/августа 2012")
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10/августа/2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10/августа/2012")
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10 - 22 августа 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 - 22 августа 2012", index: 0, startDate: OracleDate(2012, 8, 10, 12), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "с 10 по 22 августа 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "с 10 по 22 августа 2012", index: 0, startDate: OracleDate(2012, 8, 10, 12), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10 августа - 12 сентября",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 августа - 12 сентября", index: 0, startDate: OracleDate(2012, 8, 10, 12), endDate: OracleDate(2012, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "10 августа - 12 сентября 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 августа - 12 сентября 2013", index: 0, startDate: OracleDate(2013, 8, 10, 12), endDate: OracleDate(2013, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "5 мая 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 мая 12:00", index: 0, startDate: OracleDate(2012, 5, 5, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "двадцать пятое мая",
        reference: OracleDate(2012, 2, 10),
        expectation: .match(text: "двадцать пятое мая", index: 0, startDate: OracleDate(2012, 5, 25, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "двадцать пятое мая 2020 года",
        reference: OracleDate(2012, 2, 10),
        expectation: .match(text: "двадцать пятое мая 2020 года", index: 0, startDate: OracleDate(2020, 5, 25, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "24го октября, 9:00",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24го октября, 9:00", index: 0, startDate: OracleDate(2017, 10, 24, 9))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "03 авг 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "03 авг 96", index: 0, startDate: OracleDate(1996, 8, 3, 12))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "22-23 фев в 7",
        reference: OracleDate(2016, 3, 15),
        forwardDate: true,
        expectation: .match(text: "22-23 фев в 7", index: 0, startDate: OracleDate(2017, 2, 22, 7), endDate: OracleDate(2017, 2, 23, 7))
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "32 августа 2014",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "29 февраля 2014",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "32 августа",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "ru_month_name_little_endian.test.ts",
        input: "29 февраля",
        reference: OracleDate(2013, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
]
