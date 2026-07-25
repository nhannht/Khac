// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_time_units_ago.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let timeUnitsAgoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5 days ago, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 days ago", index: 0, start: OracleComponents(year: 2012, month: 8, day: 5), startDate: OracleDate(2012, 8, 5))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "10 days ago, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 days ago", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31), startDate: OracleDate(2012, 7, 31))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "15 minute ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minute ago", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "15 minute earlier",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minute earlier", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "15 minute before",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minute before", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "   12 hours ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 hours ago", index: 3, start: OracleComponents(hour: 0, minute: 14), startDate: OracleDate(2012, 8, 10, 0, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "1h ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1h ago", index: 0, start: OracleComponents(hour: 11, minute: 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "1hr ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1hr ago", index: 0, start: OracleComponents(hour: 11, minute: 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "   half an hour ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "half an hour ago", index: 3, start: OracleComponents(hour: 11, minute: 44), startDate: OracleDate(2012, 8, 10, 11, 44))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "12 hours ago I did something",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 hours ago", index: 0, start: OracleComponents(hour: 0, minute: 14), startDate: OracleDate(2012, 8, 10, 0, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "12 seconds ago I did something",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 seconds ago", index: 0, start: OracleComponents(hour: 12, minute: 13, second: 48), startDate: OracleDate(2012, 8, 10, 12, 13, 48))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "three seconds ago I did something",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "three seconds ago", index: 0, start: OracleComponents(hour: 12, minute: 13, second: 57), startDate: OracleDate(2012, 8, 10, 12, 13, 57))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5 Days ago, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 Days ago", index: 0, start: OracleComponents(year: 2012, month: 8, day: 5), startDate: OracleDate(2012, 8, 5))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "   half An hour ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "half An hour ago", index: 3, start: OracleComponents(hour: 11, minute: 44), startDate: OracleDate(2012, 8, 10, 11, 44))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "A days ago, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "A days ago", index: 0, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "a min before",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "a min before", index: 0, start: OracleComponents(hour: 12, minute: 13), startDate: OracleDate(2012, 8, 10, 12, 13))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "the min before",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "the min before", index: 0, start: OracleComponents(hour: 12, minute: 13), startDate: OracleDate(2012, 8, 10, 12, 13))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5 months ago, we did something",
        reference: OracleDate(2012, 10, 10),
        expectation: .match(text: "5 months ago", index: 0, start: OracleComponents(year: 2012, month: 5, day: 10), startDate: OracleDate(2012, 5, 10))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5 years ago, we did something",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 years ago", index: 0, start: OracleComponents(year: 2007, month: 8, day: 10), startDate: OracleDate(2007, 8, 10))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "a week ago, we did something",
        reference: OracleDate(2012, 8, 3),
        expectation: .match(text: "a week ago", index: 0, start: OracleComponents(year: 2012, month: 7, day: 27), startDate: OracleDate(2012, 7, 27))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "a few days ago, we did something",
        reference: OracleDate(2012, 8, 3),
        expectation: .match(text: "a few days ago", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31), startDate: OracleDate(2012, 7, 31))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "15 hours 29 min ago",
        reference: OracleDate(2012, 8, 10, 22, 30),
        expectation: .match(text: "15 hours 29 min ago", start: OracleComponents(day: 10, hour: 7, minute: 1))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "1 day 21 hours ago ",
        reference: OracleDate(2012, 8, 10, 22, 30),
        expectation: .match(text: "1 day 21 hours ago", start: OracleComponents(day: 9, hour: 1, minute: 30))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "1d 21 h 25m ago ",
        reference: OracleDate(2012, 8, 10, 22, 30),
        expectation: .match(text: "1d 21 h 25m ago", start: OracleComponents(day: 9, hour: 1, minute: 5))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "3 min 49 sec ago ",
        reference: OracleDate(2012, 8, 10, 22, 30),
        expectation: .match(text: "3 min 49 sec ago", start: OracleComponents(day: 10, hour: 22, minute: 26, second: 11))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "3m 49s ago ",
        reference: OracleDate(2012, 8, 10, 22, 30),
        expectation: .match(text: "3m 49s ago", start: OracleComponents(day: 10, hour: 22, minute: 26, second: 11))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "2 day before today",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 8))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "the day before yesterday",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 8))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "2 day before yesterday",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 7))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "a week before yesterday",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 2))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5 minutes ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        mode: .strict,
        expectation: .match(start: OracleComponents(hour: 12, minute: 9), startDate: OracleDate(2012, 8, 10, 12, 9))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5m ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5hr before",
        reference: OracleDate(2012, 8, 10, 12, 14),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5 h ago",
        reference: OracleDate(2012, 8, 10, 12, 14),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "2 days ago",
        reference: OracleDate(2024, 9, 10, 12),
        expectation: .match(start: OracleComponents(year: 2024, month: 9, day: 8))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "2 weeks ago",
        reference: OracleDate(2024, 9, 10, 12),
        expectation: .match(start: OracleComponents(year: 2024, month: 8, day: 27))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "2 months ago",
        reference: OracleDate(2024, 9, 10, 12),
        expectation: .match(start: OracleComponents(year: 2024, month: 7, day: 10))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "2 years ago",
        reference: OracleDate(2024, 9, 10, 12),
        expectation: .match(start: OracleComponents(year: 2022, month: 9, day: 10))
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "15 hours 29 min",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "a few hour",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "5 days",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "am ago",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_ago.test.ts",
        input: "them ago",
        expectation: .noMatch
    ),
]
