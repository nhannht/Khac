// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_casual.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let casualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline is now",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "now", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8, minute: 9, second: 10, millisecond: 11), startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline is today",
        reference: OracleDate(2012, 8, 10, 14, 12),
        expectation: .match(text: "today", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 14, 12))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline is Tomorrow",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "Tomorrow", index: 16, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11, 17, 10))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline is Tomorrow",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(startDate: OracleDate(2012, 8, 11, 1))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline was yesterday",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "yesterday", index: 17, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline was last night ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "last night", index: 17, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 0), startDate: OracleDate(2012, 8, 9))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline was this morning ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "this morning", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline was this afternoon ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "this afternoon", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15), startDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline was this evening ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "this evening", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 20), startDate: OracleDate(2012, 8, 10, 20))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline is midnight ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "midnight", start: OracleComponents(year: 2012, month: 8, day: 11, hour: 0))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline was midnight ",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(text: "midnight", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 0, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline was midnight ",
        reference: OracleDate(2012, 8, 10, 1),
        forwardDate: true,
        expectation: .match(text: "midnight", start: OracleComponents(year: 2012, month: 8, day: 11, hour: 0, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The Deadline is today 5PM",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "today 5PM", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17), startDate: OracleDate(2012, 8, 10, 17))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "Tomorrow at noon",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11, hour: 12), startDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The event is today - next friday",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "today - next friday", index: 13, start: OracleComponents(year: 2012, month: 8, day: 4, hour: 12), startDate: OracleDate(2012, 8, 4, 12), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), endDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "The event is today - next friday",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "today - next friday", index: 13, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 17, hour: 12), endDate: OracleDate(2012, 8, 17, 12))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "annual leave from today morning to tomorrow",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "today morning to tomorrow", start: OracleComponents(month: 8, day: 4, hour: 6), end: OracleComponents(month: 8, day: 5, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "annual leave from today to tomorrow afternoon",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "today to tomorrow afternoon", start: OracleComponents(month: 8, day: 4, hour: 12), end: OracleComponents(month: 8, day: 5, hour: 15))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "tonight",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "tonight", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 22))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "tonight 8pm",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "tonight 8pm", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "tonight at 8",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "tonight at 8", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "tomorrow before 4pm",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "tomorrow before 4pm", start: OracleComponents(year: 2012, month: 1, day: 2, hour: 16))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "tomorrow after 4pm",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "tomorrow after 4pm", start: OracleComponents(year: 2012, month: 1, day: 2, hour: 16))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "thurs",
        expectation: .match(text: "thurs", start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "thurs",
        expectation: .match(text: "thurs", start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "this evening",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "this evening", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "yesterday afternoon",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "yesterday afternoon", start: OracleComponents(year: 2016, month: 9, day: 30, hour: 15))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "tomorrow morning",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "tomorrow morning", start: OracleComponents(year: 2016, month: 10, day: 2, hour: 6))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "this afternoon at 3",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "this afternoon at 3", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 15))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "at midnight on 12th August",
        reference: OracleDate(2012, 8, 10, 15),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 12, hour: 0, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "notoday",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "tdtmr",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "xyesterday",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "nowhere",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "noway",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "knowledge",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "mar",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "jan",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "do I have the money",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "I may by here. May the force be with you. Theresa may become PM soon.",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "XXX is set to be released in the second half of 2025",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_casual.test.ts",
        input: "do I have the money",
        expectation: .noMatch
    ),
]
