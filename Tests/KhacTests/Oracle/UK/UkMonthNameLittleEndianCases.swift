// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/uk/uk_month_name_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ukMonthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10.08.2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10.08.2012", index: 0, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10 серпня 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 серпня 2012", index: 0, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "3 лют 82",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3 лют 82", index: 0, startDate: OracleDate(1982, 2, 3, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "Дедлайн 10 серпня",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 серпня", index: 8, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "Дедлайн Четвер, 10 січня",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Четвер, 10 січня", index: 8, startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10-серпня 2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10-серпня 2012")
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10-серпня-2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10-серпня-2012")
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10/серпня 2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10/серпня 2012")
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10/серпня/2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10/серпня/2012")
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10 - 22 серпня 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 - 22 серпня 2012", index: 0, startDate: OracleDate(2012, 8, 10, 12), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "із 10 по 22 серпня 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "із 10 по 22 серпня 2012", index: 0, startDate: OracleDate(2012, 8, 10, 12), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10 серпня - 12 вересня",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 серпня - 12 вересня", index: 0, startDate: OracleDate(2012, 8, 10, 12), endDate: OracleDate(2012, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "10 серпня - 12 вересня 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 серпня - 12 вересня 2013", index: 0, startDate: OracleDate(2013, 8, 10, 12), endDate: OracleDate(2013, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "5 травня 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 травня 12:00", index: 0, startDate: OracleDate(2012, 5, 5, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "п'яте травня",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "п'яте травня", index: 0, startDate: OracleDate(2012, 5, 5, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "двадцять п'яте травня",
        reference: OracleDate(2012, 2, 10),
        expectation: .match(text: "двадцять п'яте травня", index: 0, startDate: OracleDate(2012, 5, 25, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "24го жовтня, 9:00",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24го жовтня, 9:00", index: 0, startDate: OracleDate(2017, 10, 24, 9))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "03 сер 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "03 сер 96", index: 0, startDate: OracleDate(1996, 8, 3, 12))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "22-23 лют в 7",
        reference: OracleDate(2016, 3, 15),
        forwardDate: true,
        expectation: .match(text: "22-23 лют в 7", index: 0, startDate: OracleDate(2017, 2, 22, 7), endDate: OracleDate(2017, 2, 23, 7))
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "32 серпня 2014",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "29 лютого 2014",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "32 серпня",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "uk_month_name_little_endian.test.ts",
        input: "29 лютого",
        reference: OracleDate(2013, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
]
