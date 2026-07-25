// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_year_month_day.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itYearMonthDayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_year_month_day.test.ts",
        input: "2012-8-10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012-8-10", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_year_month_day.test.ts",
        input: "2012/8/10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/8/10", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_year_month_day.test.ts",
        input: "Il 2012/8/10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/8/10", index: 3, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_year_month_day.test.ts",
        input: "2012/8/10 - 2012/8/15",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/8/10 - 2012/8/15", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 15), endDate: OracleDate(2012, 8, 15, 12))
    ),
    OracleCase(
        sourceFile: "it_year_month_day.test.ts",
        input: "2012/8/32",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_year_month_day.test.ts",
        input: "2012/0/10",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_year_month_day.test.ts",
        input: "2012/8/0",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
