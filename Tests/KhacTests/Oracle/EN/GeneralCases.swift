// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let generalCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en.test.ts",
        input: "Something happen on 2014-04-18 13:00 - 16:00 as",
        expectation: .match(text: "2014-04-18 13:00 - 16:00", startDate: OracleDate(2014, 4, 18, 13), endDate: OracleDate(2014, 4, 18, 16))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "between 3:30-4:30pm",
        reference: OracleDate(2020, 7, 6),
        expectation: .match(text: "3:30-4:30pm", startDate: OracleDate(2020, 7, 6, 15, 30), endDate: OracleDate(2020, 7, 6, 16, 30))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "between '3:30-4:30pm'",
        reference: OracleDate(2020, 7, 6),
        expectation: .match(startDate: OracleDate(2020, 7, 6, 15, 30), endDate: OracleDate(2020, 7, 6, 16, 30))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "The date is '2014-04-18'",
        expectation: .match(startDate: OracleDate(2014, 4, 18, 12))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "Tuesday",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "6/10/2018",
        expectation: .match(startDate: OracleDate(2018, 6, 10, 12))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "Adam <Adam@supercalendar.com> написал(а):\\nThe date is 02.07.2013",
        expectation: .match(text: "02.07.2013")
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "174 November 1,2001- March 31,2002",
        expectation: .match(text: "November 1,2001- March 31,2002")
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "...Thursday, December 15, 2011 Best Available Rate ",
        expectation: .match(text: "Thursday, December 15, 2011", start: OracleComponents(year: 2011))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "SUN 15SEP 11:05 AM - 12:50 PM",
        expectation: .match(text: "SUN 15SEP 11:05 AM - 12:50 PM", end: OracleComponents(hour: 12, minute: 50))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "FRI 13SEP 1:29 PM - FRI 13SEP 3:29 PM",
        expectation: .match(text: "FRI 13SEP 1:29 PM - FRI 13SEP 3:29 PM", start: OracleComponents(day: 13, hour: 13, minute: 29), end: OracleComponents(day: 13, hour: 15, minute: 29))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "9:00 AM to 5:00 PM, Tuesday, 20 May 2013",
        expectation: .match(text: "9:00 AM to 5:00 PM, Tuesday, 20 May 2013", startDate: OracleDate(2013, 5, 20, 9), endDate: OracleDate(2013, 5, 20, 17))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "Monday afternoon to last night",
        reference: OracleDate(2017, 7, 7),
        expectation: .match(text: "Monday afternoon to last night", start: OracleComponents(month: 7, day: 3), end: OracleComponents(month: 7, day: 7))
    ),
    OracleCase(
        sourceFile: "en.test.ts",
        input: "07-27-2022, 02:00 AM",
        reference: OracleDate(2017, 7, 7),
        expectation: .match(text: "07-27-2022, 02:00 AM", start: OracleComponents(year: 2022, month: 7, day: 27, hour: 2))
    ),
    // NOT PORTED from en.test.ts: the "Thursday 9AM" case in "Test - Customize
    // by removing time extraction". It runs a CUSTOM chrono with
    // ENTimeExpressionParser deleted from the parser list - the assertion
    // (text "Thursday" alone, the 9AM ignored) is a property of that surgery,
    // not of the parsing engine, and a single-engine port cannot express a
    // configuration with its time parser removed. Same class as the removed
    // contradictory "Dec. 21" case (see KHAC-1).
]
