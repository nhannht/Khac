// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_year_month_day.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let yearMonthDayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2012/8/10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/8/10", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "The Deadline is 2012/8/10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/8/10", index: 16, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2014/2/28",
        mode: .strict,
        expectation: .match(text: "2014/2/28")
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2014/12/28",
        mode: .strict,
        expectation: .match(text: "2014/12/28", startDate: OracleDate(2014, 12, 28, 12))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2014.12.28",
        mode: .strict,
        expectation: .match(text: "2014.12.28", startDate: OracleDate(2014, 12, 28, 12))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2014 12 28",
        mode: .strict,
        expectation: .match(text: "2014 12 28", startDate: OracleDate(2014, 12, 28, 12))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2012/Aug/10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/Aug/10", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "The Deadline is 2012/aug/10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2012/aug/10", index: 16, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "The Deadline is 2018 March 18",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2018 March 18", index: 16, start: OracleComponents(year: 2018, month: 3, day: 18), startDate: OracleDate(2018, 3, 18, 12))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2024/13/1",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2024-13-01",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2024/13/1",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2024, month: 1, day: 13))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2024-13-01",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2024, month: 1, day: 13))
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2012/80/10",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2012 80 10",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2014-08-32",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_year_month_day.test.ts",
        input: "2014-02-30",
        expectation: .noMatch
    ),
]
