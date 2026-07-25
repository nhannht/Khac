// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_time_units_later.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let timeUnitsLaterCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "2 days later",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "2 days later", index: 0, start: OracleComponents(year: 2012, month: 8, day: 12), startDate: OracleDate(2012, 8, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "5 minutes later",
        reference: OracleDate(2012, 8, 10, 10),
        expectation: .match(text: "5 minutes later", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 10, minute: 5), startDate: OracleDate(2012, 8, 10, 10, 5))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "3 week later",
        reference: OracleDate(2012, 7, 10, 10),
        expectation: .match(text: "3 week later", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31), startDate: OracleDate(2012, 7, 31, 10))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "3w later",
        reference: OracleDate(2012, 7, 10, 10),
        expectation: .match(text: "3w later", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "3mo later",
        reference: OracleDate(2012, 7, 10, 10),
        expectation: .match(text: "3mo later", index: 0, start: OracleComponents(year: 2012, month: 10, day: 10))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "5 days from now, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 days from now", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "10 days from now, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 days from now", index: 0, start: OracleComponents(year: 2012, month: 8, day: 20), startDate: OracleDate(2012, 8, 20))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "15 minute from now",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minute from now", index: 0, start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 8, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "15 minutes earlier",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minutes earlier", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "15 minute out",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minute out", index: 0, start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 8, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "   12 hours from now",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 hours from now", index: 3, start: OracleComponents(day: 11, hour: 0, minute: 14), startDate: OracleDate(2012, 8, 11, 0, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "   12 hrs from now",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 hrs from now", index: 3, start: OracleComponents(day: 11, hour: 0, minute: 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "   half an hour from now",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "half an hour from now", index: 3, start: OracleComponents(hour: 12, minute: 44), startDate: OracleDate(2012, 8, 10, 12, 44))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "12 hours from now I did something",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 hours from now", index: 0, start: OracleComponents(day: 11, hour: 0, minute: 14), startDate: OracleDate(2012, 8, 11, 0, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "12 seconds from now I did something",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 seconds from now", index: 0, start: OracleComponents(hour: 12, minute: 14, second: 12), startDate: OracleDate(2012, 8, 10, 12, 14, 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "three seconds from now I did something",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "three seconds from now", index: 0, start: OracleComponents(hour: 12, minute: 14, second: 3), startDate: OracleDate(2012, 8, 10, 12, 14, 3))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "5 Days from now, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 Days from now", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "   half An hour from now",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "half An hour from now", index: 3, start: OracleComponents(hour: 12, minute: 44), startDate: OracleDate(2012, 8, 10, 12, 44))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "A days from now, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "A days from now", index: 0, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "a min out",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "a min out", index: 0, start: OracleComponents(hour: 12, minute: 15), startDate: OracleDate(2012, 8, 10, 12, 15))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "in 1 hour",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in 1 hour", index: 0, start: OracleComponents(hour: 13, minute: 14), startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "in 1 mon",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in 1 mon", index: 0, startDate: OracleDate(2012, 9, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "in 1.5 hours",
        reference: OracleDate(2012, 8, 10, 12, 40),
        expectation: .match(text: "in 1.5 hours", index: 0, start: OracleComponents(hour: 14, minute: 10), startDate: OracleDate(2012, 8, 10, 14, 10))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "in 1d 2hr 5min",
        reference: OracleDate(2012, 8, 10, 12, 40),
        expectation: .match(text: "in 1d 2hr 5min", index: 0, start: OracleComponents(day: 11, hour: 14, minute: 45), startDate: OracleDate(2012, 8, 11, 14, 45))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "in 1d, 2hr, and 5min",
        reference: OracleDate(2012, 8, 10, 12, 40),
        expectation: .match(text: "in 1d, 2hr, and 5min", index: 0, start: OracleComponents(day: 11, hour: 14, minute: 45), startDate: OracleDate(2012, 8, 11, 14, 45))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "the min after",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "the min after", index: 0, start: OracleComponents(hour: 12, minute: 15), startDate: OracleDate(2012, 8, 10, 12, 15))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "15 minutes from now",
        reference: OracleDate(2012, 8, 10, 12, 14),
        mode: .strict,
        expectation: .match(text: "15 minutes from now", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 8, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "25 minutes later",
        reference: OracleDate(2012, 8, 10, 12, 40),
        mode: .strict,
        expectation: .match(text: "25 minutes later", index: 0, start: OracleComponents(hour: 13, minute: 5), startDate: OracleDate(2012, 8, 10, 13, 5))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "15m from now",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "15s later",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "2 day after today",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "the day after tomorrow",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "2 day after tomorrow",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2 day after tomorrow", start: OracleComponents(year: 2012, month: 8, day: 13))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "a week after tomorrow",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "a week after tomorrow", start: OracleComponents(year: 2012, month: 8, day: 18))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "next tuesday +10 days",
        reference: OracleDate(2023, 12, 29),
        expectation: .match(start: OracleComponents(year: 2024, month: 1, day: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "2023-12-29 -10days",
        reference: OracleDate(2023, 12, 29),
        expectation: .match(start: OracleComponents(year: 2023, month: 12, day: 19))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "now + 40minutes",
        reference: OracleDate(2023, 12, 29, 8, 30),
        expectation: .match(start: OracleComponents(year: 2023, month: 12, day: 29, hour: 9, minute: 10))
    ),
    OracleCase(
        sourceFile: "en_time_units_later.test.ts",
        input: "tell them later",
        expectation: .noMatch
    ),
]
