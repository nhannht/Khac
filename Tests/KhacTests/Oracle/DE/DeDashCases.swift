// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/de/de_dash.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let deDashCases: [OracleCase] = [
    OracleCase(
        sourceFile: "de_dash.test.ts",
        input: "30-12-16",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2016, month: 12, day: 30))
    ),
    OracleCase(
        sourceFile: "de_dash.test.ts",
        input: "Freitag 30-12-16",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Freitag 30-12-16", start: OracleComponents(year: 2016, month: 12, day: 30))
    ),
    OracleCase(
        sourceFile: "de_dash.test.ts",
        input: "30.12.16",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2016, month: 12, day: 30))
    ),
    OracleCase(
        sourceFile: "de_dash.test.ts",
        input: "Freitag 30.12.16",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Freitag 30.12.16", start: OracleComponents(year: 2016, month: 12, day: 30))
    ),
]
