// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_time_units_ago.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itTimeUnitsAgoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "5 giorni fa abbiamo fatto qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 giorni fa", index: 0, start: OracleComponents(year: 2012, month: 8, day: 5), startDate: OracleDate(2012, 8, 5))
    ),
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "10 giorni fa abbiamo fatto qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 giorni fa", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31), startDate: OracleDate(2012, 7, 31))
    ),
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "15 minuti fa",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minuti fa", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "un giorno fa abbiamo fatto qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "un giorno fa", index: 0, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9))
    ),
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "una settimana fa abbiamo fatto qualcosa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "una settimana fa", index: 0, start: OracleComponents(year: 2012, month: 8, day: 3), startDate: OracleDate(2012, 8, 3))
    ),
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "5 giorni e 12 ore fa",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5 giorni e 12 ore fa", index: 0, start: OracleComponents(day: 5, hour: 0, minute: 14), startDate: OracleDate(2012, 8, 5, 0, 14))
    ),
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "3 settimane e 2 giorni fa",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "3 settimane e 2 giorni fa", index: 0, start: OracleComponents(month: 7, day: 18), startDate: OracleDate(2012, 7, 18, 12, 14))
    ),
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "2020",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_time_units_ago.test.ts",
        input: "numero di 5 ore",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
