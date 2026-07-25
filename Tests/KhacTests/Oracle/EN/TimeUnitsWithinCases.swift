// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_time_units_within.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let timeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "we have to make something in 5 days.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "in 5 days", index: 26, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "we have to make something in five days.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "in five days", index: 26, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "we have to make something within 10 day",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "within 10 day", index: 26, start: OracleComponents(year: 2012, month: 8, day: 20), startDate: OracleDate(2012, 8, 20))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in 5 minutes",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in 5 minutes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "wait for 5 minutes",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "for 5 minutes", index: 5, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within 1 hour",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "within 1 hour", index: 0, startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In 5 minutes I will go home",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 minutes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In 5 minutes A car need to move",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 minutes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In 5 seconds A car need to move",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 seconds", index: 0, startDate: OracleDate(2012, 8, 10, 12, 14, 5))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within half an hour",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "within half an hour", index: 0, startDate: OracleDate(2012, 8, 10, 12, 44))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within two weeks",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "within two weeks", index: 0, startDate: OracleDate(2012, 8, 24, 12, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within a month",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "within a month", index: 0, startDate: OracleDate(2012, 9, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within a few months",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "within a few months", index: 0, startDate: OracleDate(2012, 10, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within one year",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "within one year", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within one Year",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "within one Year", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within One year",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "within One year", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In 5 Minutes A car need to move",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 Minutes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In 5 mins a car need to move",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 mins", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in a week",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "in a week", start: OracleComponents(year: 2016, month: 10, day: 8))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In around 5 hours",
        reference: OracleDate(2016, 10, 1, 13),
        expectation: .match(text: "In around 5 hours", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 18))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In about ~5 hours",
        reference: OracleDate(2016, 10, 1, 13),
        expectation: .match(start: OracleComponents(year: 2016, month: 10, day: 1, hour: 18))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in 1 month",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "in 1 month", start: OracleComponents(year: 2016, month: 11, day: 1))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "set a timer for 5 minutes 30 seconds",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "for 5 minutes 30 seconds", index: 12, startDate: OracleDate(2012, 8, 10, 12, 19, 30))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "set a timer for 5 minutes, 30 seconds",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "for 5 minutes, 30 seconds", index: 12, startDate: OracleDate(2012, 8, 10, 12, 19, 30))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "set a timer for 1 hour, 5 minutes, 30 seconds",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "for 1 hour, 5 minutes, 30 seconds", index: 12, startDate: OracleDate(2012, 8, 10, 13, 19, 30))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "set a timer for 5 minutes and 30 seconds",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "for 5 minutes and 30 seconds", index: 12, startDate: OracleDate(2012, 8, 10, 12, 19, 30))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "set a timer for 1 hour, 5 minutes, and 30 seconds",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "for 1 hour, 5 minutes, and 30 seconds", index: 12, startDate: OracleDate(2012, 8, 10, 13, 19, 30))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In  about 5 hours",
        reference: OracleDate(2012, 8, 10, 12, 49),
        expectation: .match(text: "In  about 5 hours", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17, minute: 49))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within around 3 hours",
        reference: OracleDate(2012, 8, 10, 12, 49),
        expectation: .match(text: "within around 3 hours", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15, minute: 49))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In several hours",
        reference: OracleDate(2012, 8, 10, 12, 49),
        expectation: .match(text: "In several hours", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 19, minute: 49))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "In a couple of days",
        reference: OracleDate(2012, 8, 10, 12, 49),
        expectation: .match(text: "In a couple of days", start: OracleComponents(year: 2012, month: 8, day: 12, hour: 12, minute: 49))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in 24 hours",
        reference: OracleDate(2020, 7, 10, 12, 14),
        expectation: .match(start: OracleComponents(year: 2020, month: 7, day: 11, hour: 12, minute: 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in one day",
        reference: OracleDate(2020, 7, 10, 12, 14),
        expectation: .match(start: OracleComponents(year: 2020, month: 7, day: 11, hour: 12, minute: 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in 2 minute",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "in 2 minute", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 14, minute: 54))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in 2hour",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "in 2hour", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 16, minute: 52))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in a few year",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "in a few year", start: OracleComponents(year: 2019, month: 10, day: 1, hour: 14, minute: 52))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within 12 month",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "within 12 month", start: OracleComponents(year: 2017, month: 10, day: 1, hour: 14, minute: 52))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within 3 days",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "within 3 days", start: OracleComponents(year: 2016, month: 10, day: 4, hour: 14, minute: 52))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "give it 2 months",
        reference: OracleDate(2016, 10, 1, 14, 52),
        forwardDate: true,
        expectation: .match(text: "2 months", start: OracleComponents(year: 2016, month: 12, day: 1, hour: 14, minute: 52))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in 2hour",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(start: OracleComponents(hour: 16, minute: 52))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in 15m",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "within 5hr",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "1 hour",
        reference: OracleDate(2012, 8, 10, 12, 14),
        forwardDate: true,
        expectation: .match(text: "1 hour", startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "1 month",
        reference: OracleDate(2016, 10, 1, 14, 52),
        forwardDate: true,
        expectation: .match(text: "1 month", start: OracleComponents(year: 2016, month: 11, day: 1))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in 1 month",
        reference: OracleDate(2016, 10, 1, 14, 52),
        forwardDate: true,
        expectation: .match(text: "in 1 month", start: OracleComponents(year: 2016, month: 11, day: 1))
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in am",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "in them",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_within.test.ts",
        input: "the second half",
        expectation: .noMatch
    ),
]
