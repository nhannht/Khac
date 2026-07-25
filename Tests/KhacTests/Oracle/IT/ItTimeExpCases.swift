// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "Proviamo a incontrarci alle 6:00",
        reference: OracleDate(2012, 8, 10, 8, 9),
        expectation: .match(text: "alle 6:00", index: 23, start: OracleComponents(hour: 6, minute: 0), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "Proviamo a incontrarci alle 6:00 PM",
        reference: OracleDate(2012, 8, 10, 8, 9),
        expectation: .match(text: "alle 6:00 PM", index: 23, start: OracleComponents(hour: 18, minute: 0), startDate: OracleDate(2012, 8, 10, 18))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "Proviamo a incontrarci alle 6:00 AM",
        reference: OracleDate(2012, 8, 10, 8, 9),
        expectation: .match(text: "alle 6:00 AM", index: 23, start: OracleComponents(hour: 6, minute: 0), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "8:00 - 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8:00 - 12:00", index: 0, start: OracleComponents(hour: 8, minute: 0), startDate: OracleDate(2012, 8, 10, 8), end: OracleComponents(hour: 12, minute: 0), endDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: " dalle 6:00 alle 9:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "dalle 6:00 alle 9:00", index: 1, start: OracleComponents(hour: 6, minute: 0), startDate: OracleDate(2012, 8, 10, 6), end: OracleComponents(hour: 9, minute: 0), endDate: OracleDate(2012, 8, 10, 9))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "qualcosa alle 6:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "alle 6:00", index: 9, start: OracleComponents(hour: 6, minute: 0))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "1pm a 3",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "1pm a 3", index: 0, start: OracleComponents(hour: 13, minute: 0), end: OracleComponents(hour: 15, minute: 0))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "sabato 30 aprile 2016, 10:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "sabato 30 aprile 2016, 10:00", start: OracleComponents(year: 2016, month: 4, day: 30, hour: 10, minute: 0))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "sabato 30 aprile 2016 alle 10:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "sabato 30 aprile 2016 alle 10:00", start: OracleComponents(year: 2016, month: 4, day: 30, hour: 10, minute: 0))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "2020",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "2020  ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "  2020",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "1234567890",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "alle 10:00",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(start: OracleComponents(hour: 10, minute: 0), startDate: OracleDate(2012, 8, 10, 10))
    ),
    OracleCase(
        sourceFile: "it_time_exp.test.ts",
        input: "alle 10:00",
        reference: OracleDate(2012, 8, 10, 12, 14),
        forwardDate: true,
        expectation: .match(start: OracleComponents(hour: 10, minute: 0), startDate: OracleDate(2012, 8, 11, 10))
    ),
]
