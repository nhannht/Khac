// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_relative.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let relativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "this week",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "this week", start: OracleComponents(year: 2017, month: 11, day: 19, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "this month",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "this month", start: OracleComponents(year: 2017, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "this month",
        reference: OracleDate(2017, 11, 1, 12),
        expectation: .match(text: "this month", start: OracleComponents(year: 2017, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "this year",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "this year", start: OracleComponents(year: 2017, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "last week",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "last week", start: OracleComponents(year: 2016, month: 9, day: 24, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "lastmonth",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "lastmonth", start: OracleComponents(year: 2016, month: 9, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "last day",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "last day", start: OracleComponents(year: 2016, month: 9, day: 30, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "last month",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "last month", start: OracleComponents(year: 2016, month: 9, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "past week",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "past week", start: OracleComponents(year: 2016, month: 9, day: 24, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next hour",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "next hour", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 13))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next week",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "next week", start: OracleComponents(year: 2016, month: 10, day: 8, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next day",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "next day", start: OracleComponents(year: 2016, month: 10, day: 2, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next month",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "next month", start: OracleComponents(year: 2016, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next year",
        reference: OracleDate(2020, 11, 22, 12, 11, 32, 6),
        expectation: .match(text: "next year", start: OracleComponents(year: 2021, month: 11, day: 22, hour: 12, minute: 11, second: 32, millisecond: 6))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next quarter",
        reference: OracleDate(2021, 1, 22, 12),
        expectation: .match(text: "next quarter", start: OracleComponents(year: 2021, month: 4, day: 22, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next qtr",
        reference: OracleDate(2021, 10, 22, 12),
        expectation: .match(text: "next qtr", start: OracleComponents(year: 2022, month: 1, day: 22, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next two quarter",
        reference: OracleDate(2021, 1, 22, 12),
        expectation: .match(text: "next two quarter", start: OracleComponents(year: 2021, month: 7, day: 22, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "after this year",
        reference: OracleDate(2020, 11, 22, 12, 11, 32, 6),
        expectation: .match(text: "after this year", start: OracleComponents(year: 2021, month: 11, day: 22, hour: 12, minute: 11, second: 32, millisecond: 6))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "Connect back after this year",
        reference: OracleDate(2022, 4, 16, 12),
        expectation: .match(start: OracleComponents(year: 2023, month: 4, day: 16))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next hour",
        reference: OracleDate(2016, 10, 7, 12),
        expectation: .match(text: "next hour", start: OracleComponents(year: 2016, month: 10, day: 7, hour: 13))
    ),
    OracleCase(
        sourceFile: "en_relative.test.ts",
        input: "next month",
        reference: OracleDate(2016, 10, 7, 12),
        expectation: .match(text: "next month", start: OracleComponents(year: 2016, month: 11, day: 7, hour: 12))
    ),
]
