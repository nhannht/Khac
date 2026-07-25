// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_slash.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let slashCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "    04/2016   ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "04/2016", index: 4)
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "8/10/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8/10/2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: ": 8/1/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8/1/2012", index: 2, start: OracleComponents(year: 2012, month: 8, day: 1), startDate: OracleDate(2012, 8, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "The Deadline is 8/10/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8/10/2012", index: 16, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "The Deadline is Tuesday 11/3/2015",
        reference: OracleDate(2015, 11, 3),
        expectation: .match(text: "Tuesday 11/3/2015", index: 16, startDate: OracleDate(2015, 11, 3, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "2/28/2014",
        mode: .strict,
        expectation: .match(text: "2/28/2014")
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "Friday 12-30-16",
        mode: .strict,
        expectation: .match(text: "Friday 12-30-16", startDate: OracleDate(2016, 12, 30, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "Friday 30-12-16",
        mode: .strict,
        expectation: .match(text: "Friday 30-12-16", startDate: OracleDate(2016, 12, 30, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "06/Nov/2023",
        mode: .strict,
        expectation: .match(text: "06/Nov/2023", startDate: OracleDate(2023, 11, 6, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "06/Nov/2023:06:36:02",
        mode: .strict,
        expectation: .match(text: "06/Nov/2023:06:36:02", startDate: OracleDate(2023, 11, 6, 6, 36, 2))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "06/Nov/2023:06:36:02 +0200",
        mode: .strict,
        expectation: .match(text: "06/Nov/2023:06:36:02 +0200")
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "The event is going ahead (04/2016)",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "04/2016", index: 26, start: OracleComponents(year: 2016, month: 4, day: 1), startDate: OracleDate(2016, 4, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "Published: 06/2004",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "06/2004", index: 11, start: OracleComponents(year: 2004, month: 6, day: 1), startDate: OracleDate(2004, 6, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "8/10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8/10", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "8/10/2012 - 8/15/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8/10/2012 - 8/15/2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 15), endDate: OracleDate(2012, 8, 15, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "from 01/21/2021 10:00 to 01/01/2023 07:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2021, month: 1, day: 21, hour: 10, minute: 0), end: OracleComponents(year: 2023, month: 1, day: 1, hour: 7, minute: 0))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "08/08/2023, 09:15 AM to 08/29/2023, 09:15 AM",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2023, month: 8, day: 8, hour: 9, minute: 15), end: OracleComponents(year: 2023, month: 8, day: 29, hour: 9, minute: 15))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "8/32/2014",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "8/32",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "2/29/2014",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "2014/22/29",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "2014/13/22",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "80-32-89-89",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "02/29/2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "06/31/2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "06/-31/2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "18/13/2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "15/28/2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "4/13/1",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "5/31",
        reference: OracleDate(1999, 6, 1),
        forwardDate: true,
        expectation: .match(text: "5/31", index: 0, start: OracleComponents(year: 2000, month: 5, day: 31), startDate: OracleDate(2000, 5, 31, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "1/8 at 12pm",
        reference: OracleDate(2021, 9, 25, 12),
        forwardDate: true,
        expectation: .match(text: "1/8 at 12pm", start: OracleComponents(year: 2022, month: 1, day: 8), startDate: OracleDate(2022, 1, 8, 12))
    ),
    OracleCase(
        sourceFile: "en_slash.test.ts",
        input: "14/4 90",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 4, day: 14))
    ),
]
