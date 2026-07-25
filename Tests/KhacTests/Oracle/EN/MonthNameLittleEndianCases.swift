// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_month_name_little_endian.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let monthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10 August 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "3rd Feb 82",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3rd Feb 82", index: 0, start: OracleComponents(year: 1982, month: 2, day: 3), startDate: OracleDate(1982, 2, 3, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "Sun 15Sep",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "Sun 15Sep", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "SUN 15SEP",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "SUN 15SEP", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "The Deadline is 10 August",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "The Deadline is Tuesday, 10 January",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Tuesday, 10 January", index: 16, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "The Deadline is Tue, 10 January",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Tue, 10 January", index: 16, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "31st March, 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "31st March, 2016", index: 0, start: OracleComponents(year: 2016, month: 3, day: 31), startDate: OracleDate(2016, 3, 31, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "23rd february, 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "23rd february, 2016", index: 0, start: OracleComponents(year: 2016, month: 2, day: 23), startDate: OracleDate(2016, 2, 23, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10-August 2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10-August 2012", startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10-August-2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10-August-2012", startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10/August 2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10/August 2012", startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10/August/2012",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "10/August/2012", startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "09-JAN-2017",
        reference: OracleDate(2017, 8, 8),
        expectation: .match(text: "09-JAN-2017", startDate: OracleDate(2017, 1, 9, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "09/JAN/2017",
        reference: OracleDate(2017, 8, 8),
        expectation: .match(text: "09/JAN/2017", startDate: OracleDate(2017, 1, 9, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "21-APR-16",
        reference: OracleDate(2017, 8, 8),
        expectation: .match(text: "21-APR-16", startDate: OracleDate(2016, 4, 21, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10 - 22 August 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 - 22 August 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10 to 22 August 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 to 22 August 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10 August - 12 September",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August - 12 September", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 9, day: 12), endDate: OracleDate(2012, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10 August - 12 September 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August - 12 September 2013", index: 0, start: OracleComponents(year: 2013, month: 8, day: 10), startDate: OracleDate(2013, 8, 10, 12), end: OracleComponents(year: 2013, month: 9, day: 12), endDate: OracleDate(2013, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "10 August 2013 - 12 September",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August 2013 - 12 September", index: 0, start: OracleComponents(year: 2013, month: 8, day: 10), startDate: OracleDate(2013, 8, 10, 12), end: OracleComponents(year: 2013, month: 9, day: 12), endDate: OracleDate(2013, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: " 17 August 2013 to 19 August 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "17 August 2013 to 19 August 2013", start: OracleComponents(year: 2013, month: 8, day: 17), end: OracleComponents(year: 2013, month: 8, day: 19))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "12th of July at 19:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12th of July at 19:00", index: 0, start: OracleComponents(year: 2012, month: 7, day: 12), startDate: OracleDate(2012, 7, 12, 19))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "5 May 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 May 12:00", index: 0, start: OracleComponents(year: 2012, month: 5, day: 5), startDate: OracleDate(2012, 5, 5, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "7 May 11:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "7 May 11:00", index: 0, start: OracleComponents(year: 2012, month: 5, day: 7, hour: 11), startDate: OracleDate(2012, 5, 7, 11))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "Twenty-fourth of May",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Twenty-fourth of May", start: OracleComponents(year: 2012, month: 5, day: 24))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "Eighth to eleventh May 2010",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Eighth to eleventh May 2010", start: OracleComponents(year: 2010, month: 5, day: 8), end: OracleComponents(year: 2010, month: 5, day: 11))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "24th October, 9 am",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24th October, 9 am", start: OracleComponents(month: 10, day: 24, hour: 9))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "24th October, 9 pm",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24th October, 9 pm", start: OracleComponents(month: 10, day: 24, hour: 21))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "24 October, 9 pm",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24 October, 9 pm", start: OracleComponents(month: 10, day: 24, hour: 21))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "24 October, 9 p.m.",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24 October, 9 p.m.", start: OracleComponents(month: 10, day: 24, hour: 21))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "24 October 10 o clock",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24 October 10 o clock", start: OracleComponents(month: 10, day: 24, hour: 10))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "03 Aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "03 Aug 96", start: OracleComponents(year: 1996, month: 8, day: 3))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "3 Aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3 Aug 96", start: OracleComponents(year: 1996, month: 8, day: 3))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "9 Aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "9 Aug 96", start: OracleComponents(year: 1996, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "22-23 Feb at 7pm",
        reference: OracleDate(2016, 3, 15),
        expectation: .match(start: OracleComponents(year: 2016, month: 2, day: 22, hour: 19), end: OracleComponents(year: 2016, month: 2, day: 23, hour: 19))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "22-23 Feb at 7pm",
        reference: OracleDate(2016, 3, 15),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2017, month: 2, day: 22, hour: 19), end: OracleComponents(year: 2017, month: 2, day: 23, hour: 19))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "17 August 2013 - 19 August 2013",
        expectation: .match(start: OracleComponents(year: 2013, month: 8, day: 17), end: OracleComponents(year: 2013, month: 8, day: 19))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "32 August 2014",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "29 February 2014",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "32 August",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "29 February",
        reference: OracleDate(2013, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "Jan 1 3000, 9:30",
        expectation: .match(text: "Jan 1 3000, 9:30", index: 0, start: OracleComponents(year: 3000, month: 1, day: 1, hour: 9, minute: 30), startDate: OracleDate(3000, 1, 1, 9, 30))
    ),
    OracleCase(
        sourceFile: "en_month_name_little_endian.test.ts",
        input: "Jan 1 2025, 9:30",
        expectation: .match(text: "Jan 1 2025, 9:30", index: 0, start: OracleComponents(year: 2025, month: 1, day: 1, hour: 9, minute: 30), startDate: OracleDate(2025, 1, 1, 9, 30))
    ),
]
