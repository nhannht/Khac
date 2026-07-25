// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_time_units_casual_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlTimeUnitsCasualRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "komende 2 weken",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "komende 2 weken", start: OracleComponents(year: 2016, month: 10, day: 15))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "komende 2 dagen",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "komende 2 dagen", start: OracleComponents(year: 2016, month: 10, day: 3, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "komende 2 jaar",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "komende 2 jaar", start: OracleComponents(year: 2018, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "komende 2 weken 3 dagen",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "komende 2 weken 3 dagen", start: OracleComponents(year: 2016, month: 10, day: 18, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "afgelopen 2 weken",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "afgelopen 2 weken", start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "afgelopen twee weken",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "afgelopen twee weken", start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "afgelopen 2 dagen",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "afgelopen 2 dagen", start: OracleComponents(year: 2016, month: 9, day: 29, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "+2 maanden 5 dagen",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "+2 maanden 5 dagen", start: OracleComponents(year: 2016, month: 12, day: 6, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "+15 minuten",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15 minuten", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "+15min",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15min", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "+1 dag 2 uur",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+1 dag 2 uur", start: OracleComponents(day: 11, hour: 14, minute: 14), startDate: OracleDate(2012, 7, 11, 14, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "-3jr",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .match(text: "-3jr", start: OracleComponents(year: 2012, month: 7, day: 10, hour: 12, minute: 14), startDate: OracleDate(2012, 7, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_casual_relative.test.ts",
        input: "-2u5min",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "-2u5min", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 9, minute: 55))
    ),
]
