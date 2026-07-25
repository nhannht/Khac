// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/de/de_time_units_casual_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let deTimeUnitsCasualRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "kommende Woche",
        reference: OracleDate(2017, 5, 12),
        expectation: .match(text: "kommende Woche", start: OracleComponents(year: 2017, month: 5, day: 19))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "in 2 Wochen",
        reference: OracleDate(2017, 5, 12, 18, 11),
        expectation: .match(text: "in 2 Wochen", start: OracleComponents(year: 2017, month: 5, day: 26, hour: 18, minute: 11))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "in drei Wochen",
        reference: OracleDate(2017, 5, 12),
        expectation: .match(text: "in drei Wochen", start: OracleComponents(year: 2017, month: 6, day: 2))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "letzten Monat",
        reference: OracleDate(2017, 5, 12),
        expectation: .match(text: "letzten Monat", start: OracleComponents(year: 2017, month: 4, day: 12))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "in den 30 vorangegangenen Tagen",
        reference: OracleDate(2017, 5, 12),
        expectation: .match(text: "30 vorangegangenen Tagen", start: OracleComponents(year: 2017, month: 4, day: 12))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "die vergangenen 24 Stunden",
        reference: OracleDate(2017, 5, 12, 11, 27),
        expectation: .match(text: "vergangenen 24 Stunden", start: OracleComponents(year: 2017, month: 5, day: 11, hour: 11, minute: 27))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "in den folgenden 90 sekunden",
        reference: OracleDate(2017, 5, 12, 11, 27, 3),
        expectation: .match(text: "folgenden 90 sekunden", start: OracleComponents(year: 2017, month: 5, day: 12, hour: 11, minute: 28, second: 33))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "die letzten acht Minuten",
        reference: OracleDate(2017, 5, 12, 11, 27),
        expectation: .match(text: "letzten acht Minuten", start: OracleComponents(year: 2017, month: 5, day: 12, hour: 11, minute: 19, second: 0))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "letztes Quartal",
        reference: OracleDate(2017, 5, 12, 11, 27),
        expectation: .match(text: "letztes Quartal", start: OracleComponents(year: 2017, month: 2, day: 12, hour: 11, minute: 27, second: 0))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "kommendes Jahr",
        reference: OracleDate(2017, 5, 12, 11, 27),
        expectation: .match(text: "kommendes Jahr", start: OracleComponents(year: 2018, month: 5, day: 12, hour: 11, minute: 27, second: 0))
    ),
    OracleCase(
        sourceFile: "de_time_units_casual_relative.test.ts",
        input: "Letzte Aktualisierun 03/12/2025",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "03/12/2025", start: OracleComponents(year: 2025, month: 12, day: 3))
    ),
]
