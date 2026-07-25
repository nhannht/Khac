// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/sv/sv_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let svWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "sv_weekday.test.ts",
        input: "måndag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "måndag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "sv_weekday.test.ts",
        input: "på måndag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "på måndag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "sv_weekday.test.ts",
        input: "nästa måndag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "nästa måndag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1))
    ),
    OracleCase(
        sourceFile: "sv_weekday.test.ts",
        input: "förra måndag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "förra måndag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "sv_weekday.test.ts",
        input: "söndag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 0))
    ),
    OracleCase(
        sourceFile: "sv_weekday.test.ts",
        input: "tisdag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 2))
    ),
    OracleCase(
        sourceFile: "sv_weekday.test.ts",
        input: "fredag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 5))
    ),
    OracleCase(
        sourceFile: "sv_weekday.test.ts",
        input: "lördag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 6))
    ),
]
