// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_relative.test.ts",
        input: "la settimana prossima",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "la settimana prossima", start: OracleComponents(year: 2016, month: 10, day: 8))
    ),
    OracleCase(
        sourceFile: "it_relative.test.ts",
        input: "la settimana scorsa",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "la settimana scorsa", start: OracleComponents(year: 2016, month: 9, day: 24))
    ),
    OracleCase(
        sourceFile: "it_relative.test.ts",
        input: "il mese prossimo",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "il mese prossimo", start: OracleComponents(year: 2016, month: 11, day: 1))
    ),
    OracleCase(
        sourceFile: "it_relative.test.ts",
        input: "il mese scorso",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "il mese scorso", start: OracleComponents(year: 2016, month: 9, day: 1))
    ),
    OracleCase(
        sourceFile: "it_relative.test.ts",
        input: "l'anno prossimo",
        reference: OracleDate(2020, 11, 22, 12, 11, 32, 6),
        expectation: .match(text: "l'anno prossimo", start: OracleComponents(year: 2021, month: 11, day: 22))
    ),
    OracleCase(
        sourceFile: "it_relative.test.ts",
        input: "l'anno scorso",
        reference: OracleDate(2020, 11, 22, 12, 11, 32, 6),
        expectation: .match(text: "l'anno scorso", start: OracleComponents(year: 2019, month: 11, day: 22))
    ),
]
