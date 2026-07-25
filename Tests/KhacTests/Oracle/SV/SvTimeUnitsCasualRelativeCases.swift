// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/sv/sv_time_units_casual_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let svTimeUnitsCasualRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "nästa 2 veckor",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "nästa 2 veckor", start: OracleComponents(year: 2016, month: 10, day: 15))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "nästa 2 dagar",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "nästa 2 dagar", start: OracleComponents(year: 2016, month: 10, day: 3, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "nästa två år",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "nästa två år", start: OracleComponents(year: 2018, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "nästa 2 veckor 3 dagar",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "nästa 2 veckor 3 dagar", start: OracleComponents(year: 2016, month: 10, day: 18, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "efter ett år",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "efter ett år", start: OracleComponents(year: 2017, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "efter en timme",
        reference: OracleDate(2016, 10, 1, 15),
        expectation: .match(text: "efter en timme", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 16))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "förra 2 veckor",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "förra 2 veckor", start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "förra två veckor",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "förra två veckor", start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "passerade 2 dagar",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "passerade 2 dagar", start: OracleComponents(year: 2016, month: 9, day: 29, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "+2 månader, 5 dagar",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "+2 månader, 5 dagar", start: OracleComponents(year: 2016, month: 12, day: 6, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "+15 minuter",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15 minuter", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "+15min",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15min", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "+1 dag 2 timmar",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+1 dag 2 timmar", start: OracleComponents(day: 11, hour: 14, minute: 14), startDate: OracleDate(2012, 7, 11, 14, 14))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "+1min",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+1min", start: OracleComponents(hour: 12, minute: 15), startDate: OracleDate(2012, 7, 10, 12, 15))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "-3år",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .match(text: "-3år", start: OracleComponents(year: 2012, month: 7, day: 10, hour: 12, minute: 14), startDate: OracleDate(2012, 7, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "sv_time_units_casual_relative.test.ts",
        input: "-2tim5min",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "-2tim5min", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 9, minute: 55))
    ),
]
