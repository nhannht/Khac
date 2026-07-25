// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/de/de_year.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let deYearCases: [OracleCase] = [
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 234 v.u.Z.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 234 v.u.Z.", index: 0, start: OracleComponents(year: -234, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 88 nuZ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 88 nuZ", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 88 uZ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 88 uZ", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 88 d.g.Z.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 88 d.g.Z.", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 234 v.Chr.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 234 v.Chr.", index: 0, start: OracleComponents(year: -234, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 88 nC",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 88 nC", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 234 v.d.Z.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 234 v.d.Z.", index: 0, start: OracleComponents(year: -234, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 88 ndZ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 88 ndZ", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 234 v.d.g.Z.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 234 v.d.g.Z.", index: 0, start: OracleComponents(year: -234, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "de_year.test.ts",
        input: "10. August 88 ndgZ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10. August 88 ndgZ", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
]
