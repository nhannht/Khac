// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_month_name_middle_endian.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let monthNameMiddleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "She is getting married soon (July 2017).",
        expectation: .match(text: "July 2017", index: 29, start: OracleComponents(year: 2017, month: 7, day: 1), startDate: OracleDate(2017, 7, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "She is leaving in August.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August", index: 18, start: OracleComponents(year: 2012, month: 8, day: 1), startDate: OracleDate(2012, 8, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "I am arriving sometime in August, 2012, probably.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August, 2012", index: 26, start: OracleComponents(year: 2012, month: 8, day: 1), startDate: OracleDate(2012, 8, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "August 10, 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August 10, 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Nov 12, 2011",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Nov 12, 2011", index: 0, start: OracleComponents(year: 2011, month: 11, day: 12), startDate: OracleDate(2011, 11, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "The Deadline is August 10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August 10", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "The Deadline is August 10 2555 BE",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August 10 2555 BE", index: 16, startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "The Deadline is August 10, 345 BC",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August 10, 345 BC", index: 16, startDate: OracleDate(-345, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "The Deadline is August 10, 8 AD",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August 10, 8 AD", index: 16)
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "The Deadline is Tuesday, January 10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Tuesday, January 10", start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Sun, Mar. 6, 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2016, month: 3, day: 6))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Sun, March 6, 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2016, month: 3, day: 6))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Sun., March 6, 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2016, month: 3, day: 6))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Sunday, March 6, 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2016, month: 3, day: 6))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Sunday, March 6, 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2016, month: 3, day: 6))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Sunday, March, 6th 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Sunday, March, 6th 2016", start: OracleComponents(year: 2016, month: 3, day: 6))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Wed, Jan 20th, 2016             ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Wed, Jan 20th, 2016", start: OracleComponents(year: 2016, month: 1, day: 20))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Dec. 21",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Dec. 21", start: OracleComponents(year: 2012, month: 12, day: 21))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "August 10 - 22, 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August 10 - 22, 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "August 10 to 22, 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August 10 to 22, 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "August 10 - November 12",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August 10 - November 12", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 11, day: 12), endDate: OracleDate(2012, 11, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Aug 10 to Nov 12",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Aug 10 to Nov 12", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 11, day: 12), endDate: OracleDate(2012, 11, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Aug 10 - Nov 12, 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Aug 10 - Nov 12, 2013", index: 0, start: OracleComponents(year: 2013, month: 8, day: 10), startDate: OracleDate(2013, 8, 10, 12), end: OracleComponents(year: 2013, month: 11, day: 12), endDate: OracleDate(2013, 11, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Aug 10 - Nov 12, 2011",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Aug 10 - Nov 12, 2011", index: 0, start: OracleComponents(year: 2011, month: 8, day: 10), startDate: OracleDate(2011, 8, 10, 12), end: OracleComponents(year: 2011, month: 11, day: 12), endDate: OracleDate(2011, 11, 12, 12))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "May eighth, 2010",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "May eighth, 2010", index: 0, start: OracleComponents(year: 2010, month: 5, day: 8))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "May twenty-fourth",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "May twenty-fourth", index: 0, start: OracleComponents(year: 2012, month: 5, day: 24))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "May eighth - tenth, 2010",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "May eighth - tenth, 2010", index: 0, start: OracleComponents(year: 2010, month: 5, day: 8), end: OracleComponents(year: 2010, month: 5, day: 10))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "January 1st",
        reference: OracleDate(2016, 2, 15),
        expectation: .match(start: OracleComponents(year: 2016, month: 1, day: 1))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "January 1st",
        reference: OracleDate(2016, 2, 15),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2017, month: 1, day: 1))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Aug 9, 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Aug 9, 96", start: OracleComponents(year: 1996, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Aug 9 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Aug 9 96", start: OracleComponents(year: 1996, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "Dec. 21",
        reference: OracleDate(2023, 13, 10),
        expectation: .match(start: OracleComponents(year: 2023, month: 12, day: 21))
    ),
    // REMOVED, deliberately: a second "Dec. 21" case with this same input and
    // this same reference expected year 2021, month 12, no day - reading "21" as
    // a YEAR rather than a day. Both cannot hold at once for a deterministic
    // parser, so this is a defect in the ported fixture, not in the engine.
    //
    // In chrono's source test the two assertions run against two DIFFERENT
    // Chrono instances: createCasualConfiguration(false) yields the 2023 reading
    // kept above, and createCasualConfiguration(true) - a day-first English
    // variant - yields the 2021 reading, via an ambiguity guard that exists only
    // in that configuration. extract.py flattened both into one table without
    // recording which configuration each came from.
    //
    // Khac's ENLocale is monthDay, so only the first reading is in scope, and
    // day-first English (en.GB) is ALREADY a documented deferral on KHAC-3. Do
    // not re-add this case without also modelling that configuration.
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "August 32, 2014",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "February 29, 2014",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "August 32",
        reference: OracleDate(2012, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "February 29",
        reference: OracleDate(2014, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month_name_middle_endian.test.ts",
        input: "February 151998",
        reference: OracleDate(2014, 8, 10),
        mode: .strict,
        expectation: .noMatch
    ),
]
