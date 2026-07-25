// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fi/fi_time_units_casual_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let fiTimeUnitsCasualRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "seuraavat 2 viikkoa",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "seuraavat 2 viikkoa", start: OracleComponents(year: 2016, month: 10, day: 15))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "seuraavat 2 päivää",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "seuraavat 2 päivää", start: OracleComponents(year: 2016, month: 10, day: 3, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "seuraavat kaksi vuotta",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "seuraavat kaksi vuotta", start: OracleComponents(year: 2018, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "seuraavat 2 viikkoa 3 päivää",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "seuraavat 2 viikkoa 3 päivää", start: OracleComponents(year: 2016, month: 10, day: 18, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "seuraava yksi vuotta",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "seuraava yksi vuotta", start: OracleComponents(year: 2017, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "edelliset 2 viikkoa",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "edelliset 2 viikkoa", start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "viimeiset 2 päivää",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "viimeiset 2 päivää", start: OracleComponents(year: 2016, month: 9, day: 29, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "kuluneet kaksi viikkoa",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "kuluneet kaksi viikkoa", start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "+2 kuukautta 5 päivää",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "+2 kuukautta 5 päivää", start: OracleComponents(year: 2016, month: 12, day: 6, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "+15 minuuttia",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15 minuuttia", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "+15min",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15min", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "+1 päivä 2 tuntia",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+1 päivä 2 tuntia", start: OracleComponents(day: 11, hour: 14, minute: 14), startDate: OracleDate(2012, 7, 11, 14, 14))
    ),
    OracleCase(
        sourceFile: "fi_time_units_casual_relative.test.ts",
        input: "-3vuotta",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .match(text: "-3vuotta", start: OracleComponents(year: 2012, month: 7, day: 10, hour: 12, minute: 14), startDate: OracleDate(2012, 7, 10, 12, 14))
    ),
]
