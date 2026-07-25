// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/negative_cases.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itNegativeCasesCases: [OracleCase] = [
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Questo è solo testo senza date",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Ciao come stai",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Il prezzo è 1000 euro",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Articolo numero 12345",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "30 febbraio 2020",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "0 marzo 2020",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Chiamami al 123456789",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Costa 1000",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Versione 2.0.1",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
