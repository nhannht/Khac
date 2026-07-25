// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_time_units_casual_relative.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let timeUnitsCasualRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "next 2 weeks",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "next 2 weeks", start: OracleComponents(year: 2016, month: 10, day: 15))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "next 2 days",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "next 2 days", start: OracleComponents(year: 2016, month: 10, day: 3, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "next two years",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "next two years", start: OracleComponents(year: 2018, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "next 2 weeks 3 days",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "next 2 weeks 3 days", start: OracleComponents(year: 2016, month: 10, day: 18, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "after a year",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "after a year", start: OracleComponents(year: 2017, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "after an hour",
        reference: OracleDate(2016, 10, 1, 15),
        expectation: .match(text: "after an hour", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 16))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "last 2 weeks",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "last 2 weeks", start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "last two weeks",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "last two weeks", start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "past 2 days",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "past 2 days", start: OracleComponents(year: 2016, month: 9, day: 29, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "+2 months, 5 days",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "+2 months, 5 days", start: OracleComponents(year: 2016, month: 12, day: 6, hour: 12))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "+15 minutes",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15 minutes", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "+15min",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15min", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "+1 day 2 hour",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+1 day 2 hour", start: OracleComponents(day: 11, hour: 14, minute: 14), startDate: OracleDate(2012, 7, 11, 14, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "+1m",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+1m", start: OracleComponents(hour: 12, minute: 15), startDate: OracleDate(2012, 7, 10, 12, 15))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "-3y",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .match(text: "-3y", start: OracleComponents(year: 2012, month: 7, day: 10, hour: 12, minute: 14), startDate: OracleDate(2012, 7, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "-2hr5min",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "-2hr5min", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 9, minute: 55))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "-5d 00",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "-5d 00", start: OracleComponents(year: 2016, month: 9, day: 26, hour: 0, minute: 0), startDate: OracleDate(2016, 9, 26))
    ),
    // The next two cases come from chrono's "Without custom parser without
    // abbreviations" block, which runs a CUSTOM configuration: en.strict.clone()
    // plus ENTimeUnitCasualRelativeFormatParser(false). Ported as .strict - the
    // faithful single-engine equivalent, since strict is exactly the mode that
    // refuses shorthand units. As casual they would contradict the "-3y" match
    // case above, which chrono runs on the DEFAULT casual config.
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "-3y",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "last 2m",
        mode: .strict,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "-2 hours 5 minutes",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "-2 hours 5 minutes", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 9, minute: 55))
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "3y",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "1 m",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "the day",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "a day",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "+am",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_time_units_casual_relative.test.ts",
        input: "+them",
        expectation: .noMatch
    ),
]
