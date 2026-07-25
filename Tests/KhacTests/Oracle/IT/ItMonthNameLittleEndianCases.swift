// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_month_name_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itMonthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "10 agosto 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "3 febbraio 82",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3 febbraio 82", index: 0, start: OracleComponents(year: 1982, month: 2, day: 3), startDate: OracleDate(1982, 2, 3, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "domenica 15 settembre",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "domenica 15 settembre", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "La scadenza è il 10 agosto",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "il 10 agosto", index: 14, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "La scadenza è martedì 10 gennaio",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "martedì 10 gennaio", index: 14, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "10 - 22 agosto 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 - 22 agosto 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "10 agosto - 12 settembre",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto - 12 settembre", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 9, day: 12), endDate: OracleDate(2012, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "10 agosto - 12 settembre 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto - 12 settembre 2013", index: 0, start: OracleComponents(year: 2013, month: 8, day: 10), startDate: OracleDate(2013, 8, 10, 12), end: OracleComponents(year: 2013, month: 9, day: 12), endDate: OracleDate(2013, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "5 maggio 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 maggio 12:00", index: 0, start: OracleComponents(year: 2012, month: 5, day: 5, hour: 12), startDate: OracleDate(2012, 5, 5, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "5 maggio alle 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 maggio alle 12:00", index: 0, start: OracleComponents(year: 2012, month: 5, day: 5, hour: 12), startDate: OracleDate(2012, 5, 5, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "primo maggio",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "primo maggio", index: 0, start: OracleComponents(year: 2012, month: 5, day: 1), startDate: OracleDate(2012, 5, 1, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "secondo agosto 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "secondo agosto 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 2), startDate: OracleDate(2012, 8, 2, 12))
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "29 febbraio 2014",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_month_name_little_endian.test.ts",
        input: "fare qualcosa il 32",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
