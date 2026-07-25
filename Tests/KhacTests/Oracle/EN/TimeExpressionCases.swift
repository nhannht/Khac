// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_time_exp.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let timeExpressionCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "  11 AM ",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "11 AM", index: 2)
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "2020 at  11 AM ",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "at  11 AM", index: 5)
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "20:32:13",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "20:32:13", start: OracleComponents(hour: 20, minute: 32, second: 13))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "1 at night",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "1 at night", start: OracleComponents(hour: 1))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "1 in the afternoon",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "1 in the afternoon", start: OracleComponents(hour: 13))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "05/31/2024 14:15",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "05/31/2024 14:15", start: OracleComponents(year: 2024, month: 5, day: 31, hour: 14, minute: 15))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "05/31/2024.14:15",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "05/31/2024.14:15", start: OracleComponents(year: 2024, month: 5, day: 31, hour: 14, minute: 15))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "05/31/2024:14:15",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "05/31/2024:14:15", start: OracleComponents(year: 2024, month: 5, day: 31, hour: 14, minute: 15))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "05/31/2024-14:15",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "05/31/2024-14:15", start: OracleComponents(year: 2024, month: 5, day: 31, hour: 14, minute: 15))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "14:15 05/31/2024",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "14:15 05/31/2024", start: OracleComponents(year: 2024, month: 5, day: 31, hour: 14, minute: 15))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "8:23 AM, Jul 9",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "8:23 AM, Jul 9", start: OracleComponents(year: 2016, month: 7, day: 9, hour: 8, minute: 23))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "8:23 AM ∙ Jul 9",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "8:23 AM ∙ Jul 9", start: OracleComponents(year: 2016, month: 7, day: 9, hour: 8, minute: 23))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "10:00:00 - 21:45:00",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "10:00:00 - 21:45:00", start: OracleComponents(hour: 10, minute: 0, second: 0), end: OracleComponents(hour: 21, minute: 45, second: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "10:00:00 until 21:45:00",
        reference: OracleDate(2016, 10, 1, 11),
        expectation: .match(text: "10:00:00 until 21:45:00", start: OracleComponents(hour: 10, minute: 0, second: 0), end: OracleComponents(hour: 21, minute: 45, second: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "10:00:00 till 21:45:00",
        reference: OracleDate(2016, 10, 1, 11),
        expectation: .match(text: "10:00:00 till 21:45:00", start: OracleComponents(hour: 10, minute: 0, second: 0), end: OracleComponents(hour: 21, minute: 45, second: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "10:00:00 through 21:45:00",
        reference: OracleDate(2016, 10, 1, 11),
        expectation: .match(text: "10:00:00 through 21:45:00", start: OracleComponents(hour: 10, minute: 0, second: 0), end: OracleComponents(hour: 21, minute: 45, second: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "10:00:00 - 15/15",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "10:00:00", start: OracleComponents(hour: 10, minute: 0, second: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "11 at night",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "11 at night", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 23))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "11 tonight",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "11 tonight", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 23))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "6 in the morning",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "6 in the morning", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 6, minute: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "6 in the afternoon",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "6 in the afternoon", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 18, minute: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "10 - 11 at night",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "10 - 11 at night", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 22), end: OracleComponents(year: 2016, month: 10, day: 1, hour: 23))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "8pm - 11",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "8pm - 11", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 20), end: OracleComponents(year: 2016, month: 10, day: 1, hour: 23))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "8 - 11pm",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "8 - 11pm", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 20), end: OracleComponents(year: 2016, month: 10, day: 1, hour: 23))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "7 - 8",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "7 - 8", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 7), end: OracleComponents(year: 2016, month: 10, day: 1, hour: 8))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "1pm-3",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "1pm-3", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 13, minute: 0), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 15, minute: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "1am-3",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 1, minute: 0), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 3, minute: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "11pm-3",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 23, minute: 0), end: OracleComponents(year: 2012, month: 8, day: 11, hour: 3, minute: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "12-3am",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 0, minute: 0), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 3, minute: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "12-3pm",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12, minute: 0), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 15, minute: 0))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "December 31, 2022 10:00 pm - 1:00 am",
        reference: OracleDate(2017, 7, 7),
        expectation: .match(start: OracleComponents(year: 2022, month: 12, day: 31, hour: 22))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "December 31, 2022 10:00 pm - 12:00 am",
        reference: OracleDate(2017, 7, 7),
        expectation: .match(start: OracleComponents(year: 2022, month: 12, day: 31, hour: 22))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "at 1",
        expectation: .match(text: "at 1", start: OracleComponents(hour: 1))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "at 12",
        expectation: .match(text: "at 12", start: OracleComponents(hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "at 12.30",
        expectation: .match(text: "at 12.30", start: OracleComponents(hour: 12, minute: 30))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "2020",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "2020  ",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "2019 to 2020",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 101,194 points!",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 101 points!",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 10.1",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 10.1 - 10.12",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 10 - 10.1",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 101,194 points!",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 101 points!",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 10.1",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 10",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "2020",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 10.1 - 10.12",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 10 - 10.1",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "I'm at 10 - 20",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "7-730",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "1am",
        reference: OracleDate(2022, 5, 26, 1, 57),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2022, month: 5, day: 27, hour: 1))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "11am",
        reference: OracleDate(2016, 10, 1, 12),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2016, month: 10, day: 2, hour: 11))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "  11am to 1am  ",
        reference: OracleDate(2016, 10, 1, 12),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2016, month: 10, day: 2, hour: 11), end: OracleComponents(year: 2016, month: 10, day: 3, hour: 1))
    ),
    OracleCase(
        sourceFile: "en_time_exp.test.ts",
        input: "  10am to 12pm  ",
        reference: OracleDate(2016, 10, 1, 11),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2016, month: 10, day: 2, hour: 10), end: OracleComponents(year: 2016, month: 10, day: 2, hour: 12))
    ),
]
