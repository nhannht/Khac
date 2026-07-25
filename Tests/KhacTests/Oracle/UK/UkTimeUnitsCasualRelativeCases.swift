// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/uk/uk_time_units_casual_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ukTimeUnitsCasualRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "наступні 2 тижні",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "наступні 2 тижні", index: 0, start: OracleComponents(year: 2016, month: 10, day: 15, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "наступні 2 дні",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "наступні 2 дні", index: 0, start: OracleComponents(year: 2016, month: 10, day: 3, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "наступні два роки",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "наступні два роки", index: 0, start: OracleComponents(year: 2018, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "наступні 2 тижні 3 дні",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "наступні 2 тижні 3 дні", index: 0, start: OracleComponents(year: 2016, month: 10, day: 18, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "через декілька хвилин",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через декілька хвилин", index: 0, startDate: OracleDate(2016, 10, 1, 12, 2))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "через півгодини",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через півгодини", index: 0, startDate: OracleDate(2016, 10, 1, 12, 30))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "через 2 години",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через 2 години", index: 0, start: OracleComponents(year: 2016, month: 10, day: 1, hour: 14))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "через три місяці",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через три місяці", index: 0, start: OracleComponents(year: 2017, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "через тиждень",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через тиждень", index: 0, start: OracleComponents(year: 2016, month: 10, day: 8, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "через місяць",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "через місяць", index: 0, start: OracleComponents(year: 2016, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "через рік",
        reference: OracleDate(2020, 11, 22, 12, 11, 32, 6),
        expectation: .match(text: "через рік", index: 0, startDate: OracleDate(2021, 11, 22, 12, 11, 32, 6))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "минулі 2 тижні",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "минулі 2 тижні", index: 0, start: OracleComponents(year: 2016, month: 9, day: 17, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "минулі два дні",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "минулі два дні", index: 0, start: OracleComponents(year: 2016, month: 9, day: 29, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "+15 хвилин",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15 хвилин", index: 0, startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "+15хв",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+15хв", index: 0, startDate: OracleDate(2012, 7, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "+1 день 2 години",
        reference: OracleDate(2012, 7, 10, 12, 14),
        expectation: .match(text: "+1 день 2 години", index: 0, startDate: OracleDate(2012, 7, 11, 14, 14))
    ),
    OracleCase(
        sourceFile: "uk_time_units_casual_relative.test.ts",
        input: "-3 роки",
        reference: OracleDate(2015, 7, 10, 12, 14),
        expectation: .match(text: "-3 роки", index: 0, startDate: OracleDate(2012, 7, 10, 12, 14))
    ),
]
