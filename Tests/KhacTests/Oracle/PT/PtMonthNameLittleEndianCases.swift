// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/pt/pt_month_name_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ptMonthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "10 Agosto 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Agosto 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "10 Agosto 234 AC",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Agosto 234 AC", index: 0, start: OracleComponents(year: -234, month: 8, day: 10), startDate: OracleDate(-234, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "10 Agosto 88 d. C.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Agosto 88 d. C.", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "Dom 15Set",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "Dom 15Set", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "DOM 15SET",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "DOM 15SET", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "O prazo é 10 Agosto",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Agosto", index: 10, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "O prazo é terça-feira, 10 de janeiro",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "terça-feira, 10 de janeiro", index: 10, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "O prazo é Qua, 10 Janeiro",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Qua, 10 Janeiro", index: 10, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 3), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "10 de Agosto de 2012",
        reference: OracleDate(2010, 2, 1),
        expectation: .match(text: "10 de Agosto de 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "10 - 22 Agosto 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 - 22 Agosto 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "10 a 22 Agosto 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 a 22 Agosto 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "10 Agosto - 12 Setembro",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Agosto - 12 Setembro", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 9, day: 12), endDate: OracleDate(2012, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "10 Agosto - 12 Setembro 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Agosto - 12 Setembro 2013", index: 0, start: OracleComponents(year: 2013, month: 8, day: 10), startDate: OracleDate(2013, 8, 10, 12), end: OracleComponents(year: 2013, month: 9, day: 12), endDate: OracleDate(2013, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "12 de Julho às 19:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12 de Julho às 19:00", index: 0, start: OracleComponents(year: 2012, month: 7, day: 12), startDate: OracleDate(2012, 7, 12, 19))
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "32 Agosto 2014",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "29 Fevereiro 2014",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "pt_month_name_little_endian.test.ts",
        input: "32 Agosto",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
]
