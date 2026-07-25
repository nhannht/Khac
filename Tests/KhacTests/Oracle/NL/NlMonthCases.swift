// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_month.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlMonthCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "september 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "september 2012", start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "sept 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "sept 2012", start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "sep 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "sep 2012", start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "sep. 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "sep. 2012", start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "sep-2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "sep-2012", index: 0, start: OracleComponents(year: 2012, month: 9), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "mrt 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "mrt 2012", start: OracleComponents(year: 2012, month: 3, day: 1), startDate: OracleDate(2012, 3, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "In januari",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "januari", start: OracleComponents(year: 2021, month: 1, day: 1), startDate: OracleDate(2021, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "in jan",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "jan", start: OracleComponents(year: 2021, month: 1, day: 1), startDate: OracleDate(2021, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "mei",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "mei", start: OracleComponents(year: 2021, month: 5, day: 1), startDate: OracleDate(2021, 5, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "The date is sep 2012 is the date",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "sep 2012", index: 12, start: OracleComponents(year: 2012, month: 9), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "By Angie ja november 2019",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "november 2019", start: OracleComponents(year: 2019, month: 11), startDate: OracleDate(2019, 11, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "Op 23 MRT. 2022",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "23 MRT. 2022", start: OracleComponents(year: 2022, month: 3, day: 23), startDate: OracleDate(2022, 3, 23, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "9/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "9/2012", index: 0, start: OracleComponents(year: 2012, month: 9), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "09/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "09/2012", index: 0, start: OracleComponents(year: 2012, month: 9), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "aug 96", start: OracleComponents(year: 1996, month: 8))
    ),
    OracleCase(
        sourceFile: "nl_month.test.ts",
        input: "96 aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "aug 96", start: OracleComponents(year: 1996, month: 8))
    ),
]
