// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_time_units_within.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itTimeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_time_units_within.test.ts",
        input: "entro 5 giorni faremo qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "entro 5 giorni", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "it_time_units_within.test.ts",
        input: "entro 15 minuti",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "entro 15 minuti", index: 0, start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 8, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "it_time_units_within.test.ts",
        input: "entro un giorno faremo qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "entro un giorno", index: 0, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11))
    ),
    OracleCase(
        sourceFile: "it_time_units_within.test.ts",
        input: "entro una settimana faremo qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "entro una settimana", index: 0, start: OracleComponents(year: 2012, month: 8, day: 17), startDate: OracleDate(2012, 8, 17))
    ),
    OracleCase(
        sourceFile: "it_time_units_within.test.ts",
        input: "2020",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_time_units_within.test.ts",
        input: "numero di 5 ore",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
