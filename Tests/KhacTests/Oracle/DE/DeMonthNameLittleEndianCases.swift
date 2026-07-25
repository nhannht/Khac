// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/de/de_month_name_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let deMonthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "10. August 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "10. August 113 v. Chr.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 113 v. Chr.", index: 0, start: OracleComponents(year: -113, month: 8, day: 10), startDate: OracleDate(-113, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "10. August 85 n. Chr.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 85 n. Chr.", index: 0, start: OracleComponents(year: 85, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "So 15.Sep",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "So 15.Sep", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "SO 15.SEPT",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "SO 15.SEPT", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "Die Deadline ist am 10. August",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "am 10. August", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "Die Deadline ist am Dienstag, den 10. Januar",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "am Dienstag, den 10. Januar", index: 17, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "Die Deadline ist Di, 10. Januar",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Di, 10. Januar", index: 17, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "31. März 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "31. März 2016", index: 0, start: OracleComponents(year: 2016, month: 3, day: 31), startDate: OracleDate(2016, 3, 31, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "31.Maerz 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "31.Maerz 2016", index: 0, start: OracleComponents(year: 2016, month: 3, day: 31), startDate: OracleDate(2016, 3, 31, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "10. - 22. August 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. - 22. August 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "10. bis 22. Oktober 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. bis 22. Oktober 2012", index: 0, start: OracleComponents(year: 2012, month: 10, day: 10), startDate: OracleDate(2012, 10, 10, 12), end: OracleComponents(year: 2012, month: 10, day: 22), endDate: OracleDate(2012, 10, 22, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "10. Oktober - 12. Dezember",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. Oktober - 12. Dezember", index: 0, start: OracleComponents(year: 2012, month: 10, day: 10), startDate: OracleDate(2012, 10, 10, 12), end: OracleComponents(year: 2012, month: 12, day: 12), endDate: OracleDate(2012, 12, 12, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "10. August - 12. Oktober 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August - 12. Oktober 2013", index: 0, start: OracleComponents(year: 2013, month: 8, day: 10), startDate: OracleDate(2013, 8, 10, 12), end: OracleComponents(year: 2013, month: 10, day: 12), endDate: OracleDate(2013, 10, 12, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "10. jänner 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. jänner 2012", index: 0, start: OracleComponents(year: 2012, month: 1, day: 10), startDate: OracleDate(2012, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "12. Juli um 19:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12. Juli um 19:00", index: 0, start: OracleComponents(year: 2012, month: 7, day: 12), startDate: OracleDate(2012, 7, 12, 19))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "12. Juli um 19 Uhr",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12. Juli um 19 Uhr", index: 0, start: OracleComponents(year: 2012, month: 7, day: 12), startDate: OracleDate(2012, 7, 12, 19))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "12. Juli um 19:53 Uhr",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12. Juli um 19:53 Uhr", index: 0, start: OracleComponents(year: 2012, month: 7, day: 12), startDate: OracleDate(2012, 7, 12, 19, 53))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "5. Juni 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5. Juni 12:00", index: 0, start: OracleComponents(year: 2012, month: 6, day: 5), startDate: OracleDate(2012, 6, 5, 12))
    ),
    OracleCase(
        sourceFile: "de_month_name_little_endian.test.ts",
        input: "32. Oktober 2015",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
