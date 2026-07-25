// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_month_name_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlMonthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "10 augustus 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 augustus 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "3 februari 82",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3 februari 82", index: 0, start: OracleComponents(year: 1982, month: 2, day: 3), startDate: OracleDate(1982, 2, 3, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "10 augustus 234 voor Christus",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 augustus 234 voor Christus", index: 0, start: OracleComponents(year: -234, month: 8, day: 10), startDate: OracleDate(-234, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "10 augustus 88 na Christus",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 augustus 88 na Christus", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "Zon 15 Sept",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "Zon 15 Sept", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "ZON 15 SEPT",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "ZON 15 SEPT", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "De deadline is 10 augustus",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 augustus", index: 15, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "De deadline is dinsdag, 10 januari",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "dinsdag, 10 januari", index: 15, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "De deadline is di, 10 januari",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "di, 10 januari", index: 15, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "31ste maart 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "31ste maart 2016", index: 0, start: OracleComponents(year: 2016, month: 3, day: 31), startDate: OracleDate(2016, 3, 31, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "23ste februari 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "23ste februari 2016", index: 0, start: OracleComponents(year: 2016, month: 2, day: 23), startDate: OracleDate(2016, 2, 23, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "10 - 22 augustus 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 - 22 augustus 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "10 tot 22 augustus 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 tot 22 augustus 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "10 augustus - 12 september",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 augustus - 12 september", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 9, day: 12), endDate: OracleDate(2012, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "10 augustus - 12 september 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 augustus - 12 september 2013", index: 0, start: OracleComponents(year: 2013, month: 8, day: 10), startDate: OracleDate(2013, 8, 10, 12), end: OracleComponents(year: 2013, month: 9, day: 12), endDate: OracleDate(2013, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "12de juli om 19:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12de juli om 19:00", index: 0, start: OracleComponents(year: 2012, month: 7, day: 12), startDate: OracleDate(2012, 7, 12, 19))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "5 mei 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 mei 12:00", index: 0, start: OracleComponents(year: 2012, month: 5, day: 5), startDate: OracleDate(2012, 5, 5, 12))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "7 mei 11:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "7 mei 11:00", index: 0, start: OracleComponents(year: 2012, month: 5, day: 7, hour: 11), startDate: OracleDate(2012, 5, 7, 11))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "vierentwintigste mei",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "vierentwintigste mei", start: OracleComponents(year: 2012, month: 5, day: 24))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "achtste tot elfde mei 2010",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "achtste tot elfde mei 2010", start: OracleComponents(year: 2010, month: 5, day: 8), end: OracleComponents(year: 2010, month: 5, day: 11))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "24ste oktober, 9:00",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24ste oktober, 9:00", start: OracleComponents(month: 10, day: 24, hour: 9))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "24ste oktober, 21:00",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24ste oktober, 21:00", start: OracleComponents(month: 10, day: 24, hour: 21))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "24 oktober, 21:00",
        reference: OracleDate(2017, 7, 7, 15),
        expectation: .match(text: "24 oktober, 21:00", start: OracleComponents(month: 10, day: 24, hour: 21))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "03 aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "03 aug 96", start: OracleComponents(year: 1996, month: 8, day: 3))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "3 aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "3 aug 96", start: OracleComponents(year: 1996, month: 8, day: 3))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "9 aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "9 aug 96", start: OracleComponents(year: 1996, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "22-23 februari om 19:00",
        reference: OracleDate(2016, 3, 15),
        expectation: .match(start: OracleComponents(year: 2016, month: 2, day: 22, hour: 19), end: OracleComponents(year: 2016, month: 2, day: 23, hour: 19))
    ),
    OracleCase(
        sourceFile: "nl_month_name_little_endian.test.ts",
        input: "22-23 februari om 19:00",
        reference: OracleDate(2016, 3, 15),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2017, month: 2, day: 22, hour: 19), end: OracleComponents(year: 2017, month: 2, day: 23, hour: 19))
    ),
]
