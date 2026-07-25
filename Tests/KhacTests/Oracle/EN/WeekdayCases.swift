// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_weekday.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let weekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Monday",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Monday", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1), startDate: OracleDate(2012, 8, 6, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Thursday",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Thursday", index: 0, start: OracleComponents(year: 2012, month: 8, day: 9, weekday: 4), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Sunday",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Sunday", index: 0, start: OracleComponents(year: 2012, month: 8, day: 12, weekday: 0), startDate: OracleDate(2012, 8, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "The Deadline is last Friday...",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "last Friday", index: 16, start: OracleComponents(year: 2012, month: 8, day: 3, weekday: 5), startDate: OracleDate(2012, 8, 3, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "The Deadline is past Friday...",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "past Friday", index: 16, start: OracleComponents(year: 2012, month: 8, day: 3, weekday: 5), startDate: OracleDate(2012, 8, 3, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Let's have a meeting on Friday next week",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "on Friday next week", index: 21, start: OracleComponents(year: 2015, month: 4, day: 24, weekday: 5), startDate: OracleDate(2015, 4, 24, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "I plan on taking the day off on Tuesday, next week",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "on Tuesday, next week", index: 29, start: OracleComponents(year: 2015, month: 4, day: 21, weekday: 2), startDate: OracleDate(2015, 4, 21, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "This Saturday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 6))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "This Sunday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 7))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "This Wednesday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 3))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "This Saturday",
        reference: OracleDate(2022, 8, 7),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 13))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "This Sunday",
        reference: OracleDate(2022, 8, 7),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 7))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "This Wednesday",
        reference: OracleDate(2022, 8, 7),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Last Saturday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 7, day: 30))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Last Sunday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 7, day: 31))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Last Wednesday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 7, day: 27))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Saturday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 13))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Sunday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 14))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Wednesday",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Saturday",
        reference: OracleDate(2022, 8, 6),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 13))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Sunday",
        reference: OracleDate(2022, 8, 6),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 14))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Wednesday",
        reference: OracleDate(2022, 8, 6),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Saturday",
        reference: OracleDate(2022, 8, 7),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 13))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Sunday",
        reference: OracleDate(2022, 8, 7),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 14))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Next Wednesday",
        reference: OracleDate(2022, 8, 7),
        expectation: .match(start: OracleComponents(year: 2022, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "last weekend",
        reference: OracleDate(2024, 10, 18, 12),
        expectation: .match(text: "last weekend", startDate: OracleDate(2024, 10, 13, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "this weekend",
        reference: OracleDate(2024, 10, 18, 12),
        expectation: .match(text: "this weekend", startDate: OracleDate(2024, 10, 19, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "next weekend",
        reference: OracleDate(2024, 10, 18, 12),
        expectation: .match(text: "next weekend", startDate: OracleDate(2024, 10, 26, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "last weekday",
        reference: OracleDate(2024, 10, 18, 12),
        expectation: .match(text: "last weekday", startDate: OracleDate(2024, 10, 17, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "next weekday",
        reference: OracleDate(2024, 10, 18, 12),
        expectation: .match(text: "next weekday", startDate: OracleDate(2024, 10, 21, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "last weekday",
        reference: OracleDate(2024, 10, 19, 12),
        expectation: .match(text: "last weekday", startDate: OracleDate(2024, 10, 18, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "next weekday",
        reference: OracleDate(2024, 10, 19, 12),
        expectation: .match(text: "next weekday", startDate: OracleDate(2024, 10, 21, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Lets meet on Tuesday morning",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "on Tuesday morning", index: 10, start: OracleComponents(year: 2015, month: 4, day: 21, hour: 6, weekday: 2), startDate: OracleDate(2015, 4, 21, 6))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Sunday, December 7, 2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Sunday, December 7, 2014", index: 0, start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0), startDate: OracleDate(2014, 12, 7, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Sunday 12/7/2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Sunday 12/7/2014", index: 0, start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0), startDate: OracleDate(2014, 12, 7, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Friday to Monday",
        reference: OracleDate(2023, 4, 9),
        expectation: .match(start: OracleComponents(year: 2023, month: 4, day: 7, weekday: 5), end: OracleComponents(year: 2023, month: 4, day: 10, weekday: 1))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Monday to Friday",
        reference: OracleDate(2023, 4, 9),
        expectation: .match(start: OracleComponents(year: 2023, month: 4, day: 10, weekday: 1), end: OracleComponents(year: 2023, month: 4, day: 14, weekday: 5))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Tuesday of next week",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Tuesday of next week", start: OracleComponents(year: 2022, month: 8, day: 9, weekday: 2), startDate: OracleDate(2022, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Friday of next week",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Friday of next week", start: OracleComponents(year: 2022, month: 8, day: 12, weekday: 5), startDate: OracleDate(2022, 8, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Monday of next week",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Monday of next week", start: OracleComponents(year: 2022, month: 8, day: 8, weekday: 1), startDate: OracleDate(2022, 8, 8, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Tuesday of last week",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Tuesday of last week", start: OracleComponents(year: 2022, month: 7, day: 26, weekday: 2), startDate: OracleDate(2022, 7, 26, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Friday of last week",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Friday of last week", start: OracleComponents(year: 2022, month: 7, day: 29, weekday: 5), startDate: OracleDate(2022, 7, 29, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Wednesday of this week",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Wednesday of this week", start: OracleComponents(year: 2022, month: 8, day: 3, weekday: 3), startDate: OracleDate(2022, 8, 3, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Tuesday of this week",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Tuesday of this week", start: OracleComponents(year: 2022, month: 8, day: 2, weekday: 2), startDate: OracleDate(2022, 8, 2, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Tuesday of next week after 2pm",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Tuesday of next week after 2pm", start: OracleComponents(year: 2022, month: 8, day: 9, hour: 14), startDate: OracleDate(2022, 8, 9, 14))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Friday of next week at 9am",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "Friday of next week at 9am", start: OracleComponents(year: 2022, month: 8, day: 12, hour: 9), startDate: OracleDate(2022, 8, 12, 9))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Let's sync on Tuesday of next week",
        reference: OracleDate(2022, 8, 2),
        expectation: .match(text: "on Tuesday of next week", start: OracleComponents(year: 2022, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "Monday (forward dates only)",
        reference: OracleDate(2012, 8, 9),
        forwardDate: true,
        expectation: .match(text: "Monday", index: 0, start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1), startDate: OracleDate(2012, 8, 13, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "this Friday to this Monday",
        reference: OracleDate(2016, 8, 4),
        forwardDate: true,
        expectation: .match(text: "this Friday to this Monday", index: 0, start: OracleComponents(year: 2016, month: 8, day: 5, weekday: 5), startDate: OracleDate(2016, 8, 5, 12), end: OracleComponents(year: 2016, month: 8, day: 8, weekday: 1), endDate: OracleDate(2016, 8, 8, 12))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "sunday morning",
        reference: OracleDate(2021, 8, 15, 20),
        forwardDate: true,
        expectation: .match(text: "sunday morning", index: 0, start: OracleComponents(year: 2021, month: 8, day: 22, weekday: 0), startDate: OracleDate(2021, 8, 22, 6))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "vacation monday - friday",
        reference: OracleDate(2019, 6, 13),
        forwardDate: true,
        expectation: .match(text: "monday - friday", start: OracleComponents(year: 2019, month: 6, day: 17), end: OracleComponents(year: 2019, month: 6, day: 21))
    ),
    OracleCase(
        sourceFile: "en_weekday.test.ts",
        input: "timeoff monday 7 to 9am",
        reference: OracleDate(2019, 6, 13),
        forwardDate: true,
        expectation: .match(text: "monday 7 to 9am", start: OracleComponents(year: 2019, month: 6, day: 17), end: OracleComponents(year: 2019, month: 6, day: 17))
    ),
]
