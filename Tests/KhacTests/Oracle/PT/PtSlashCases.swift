// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/pt/pt_slash.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ptSlashCases: [OracleCase] = [
    OracleCase(
        sourceFile: "pt_slash.test.ts",
        input: "segunda 8/2/2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "segunda 8/2/2016", index: 0, start: OracleComponents(year: 2016, month: 2, day: 8), startDate: OracleDate(2016, 2, 8, 12))
    ),
    OracleCase(
        sourceFile: "pt_slash.test.ts",
        input: "Terça-feira 9/2/2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Terça-feira 9/2/2016", index: 0, start: OracleComponents(year: 2016, month: 2, day: 9), startDate: OracleDate(2016, 2, 9, 12))
    ),
]
