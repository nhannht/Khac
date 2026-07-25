// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_time_units_later.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itTimeUnitsLaterCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "tra 5 giorni faremo qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "tra 5 giorni", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "fra 10 giorni faremo qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "fra 10 giorni", index: 0, start: OracleComponents(year: 2012, month: 8, day: 20), startDate: OracleDate(2012, 8, 20))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "tra 15 minuti",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "tra 15 minuti", index: 0, start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 8, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "tra un giorno faremo qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "tra un giorno", index: 0, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "fra una settimana faremo qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "fra una settimana", index: 0, start: OracleComponents(year: 2012, month: 8, day: 17), startDate: OracleDate(2012, 8, 17))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "5 minuti dopo",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5 minuti dopo", index: 0, start: OracleComponents(hour: 12, minute: 19), startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "5 minuti più tardi",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5 minuti più tardi", index: 0, start: OracleComponents(hour: 12, minute: 19), startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "tra 5 giorni e 12 ore",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "tra 5 giorni e 12 ore", index: 0, start: OracleComponents(day: 16, hour: 0, minute: 14), startDate: OracleDate(2012, 8, 16, 0, 14))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "fra 3 settimane e 2 giorni",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "fra 3 settimane e 2 giorni", index: 0, start: OracleComponents(month: 9, day: 2), startDate: OracleDate(2012, 9, 2, 12, 14))
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "2020",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_time_units_later.test.ts",
        input: "numero di 5 ore",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
