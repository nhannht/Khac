// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_time_units_within.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlTimeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "we have to make something binnen 5 dagen.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "binnen 5 dagen", index: 26, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "we have to make something binnen vijf dagen.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "binnen vijf dagen", index: 26, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "we have to make something binnen de 10 dagen",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "binnen de 10 dagen", index: 26, start: OracleComponents(year: 2012, month: 8, day: 20), startDate: OracleDate(2012, 8, 20))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "binnen 5 minuten",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "binnen 5 minuten", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "wait voor 5 minuten",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "voor 5 minuten", index: 5, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "binnen 1 uur",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "binnen 1 uur", index: 0, startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen 5 minuten ben ik thuis",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Binnen 5 minuten", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen de 5 minuten moet een auto zich verzetten",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Binnen de 5 minuten", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen 5 seconden moet een auto zich verzetten",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Binnen 5 seconden", index: 0, startDate: OracleDate(2012, 8, 10, 12, 14, 5))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen de 2 weken",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Binnen de 2 weken", index: 0, startDate: OracleDate(2012, 8, 24, 12, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen een maand",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Binnen een maand", index: 0, startDate: OracleDate(2012, 9, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen een jaar",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Binnen een jaar", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen 5 minuten A car need to move",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Binnen 5 minuten", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen 5 min a car need to move",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Binnen 5 min", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "binnen een week",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "binnen een week", start: OracleComponents(year: 2016, month: 10, day: 8))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "Binnen 24 uur",
        reference: OracleDate(2020, 7, 10, 12, 14),
        expectation: .match(start: OracleComponents(year: 2020, month: 7, day: 11, hour: 12, minute: 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "binnen een dag",
        reference: OracleDate(2020, 7, 10, 12, 14),
        expectation: .match(start: OracleComponents(year: 2020, month: 7, day: 11, hour: 12, minute: 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "binnen 2 minuten",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "binnen 2 minuten", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 14, minute: 54))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "binnen 2 uur",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "binnen 2 uur", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 16, minute: 52))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "binnen de 12 maand",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "binnen de 12 maand", start: OracleComponents(year: 2017, month: 10, day: 1, hour: 14, minute: 52))
    ),
    OracleCase(
        sourceFile: "nl_time_units_within.test.ts",
        input: "binnen de 3 dagen",
        reference: OracleDate(2016, 10, 1, 14, 52),
        expectation: .match(text: "binnen de 3 dagen", start: OracleComponents(year: 2016, month: 10, day: 4, hour: 14, minute: 52))
    ),
]
