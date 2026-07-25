// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/sv/sv_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let svCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "idag",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "imorgon",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "igår",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "förrgår",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 8))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "idag på morgonen",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "idag på förmiddagen",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 9))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "idag på middagen",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "idag på eftermiddagen",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "idag på kvällen",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 20))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "idag på natten",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 2))
    ),
    OracleCase(
        sourceFile: "sv_casual.test.ts",
        input: "idag vid midnatt",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 0))
    ),
]
