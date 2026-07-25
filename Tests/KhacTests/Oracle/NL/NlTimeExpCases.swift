// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_time_exp.test.ts",
        input: "  11:00 ",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "11:00", index: 2)
    ),
    OracleCase(
        sourceFile: "nl_time_exp.test.ts",
        input: "2020 om  11:00 ",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "om  11:00", index: 5)
    ),
    OracleCase(
        sourceFile: "nl_time_exp.test.ts",
        input: "20:32:13",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "20:32:13", start: OracleComponents(hour: 20, minute: 32, second: 13))
    ),
    OracleCase(
        sourceFile: "nl_time_exp.test.ts",
        input: "10:00:00 - 21:45:00",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "10:00:00 - 21:45:00", start: OracleComponents(hour: 10, minute: 0, second: 0), end: OracleComponents(hour: 21, minute: 45, second: 0))
    ),
    OracleCase(
        sourceFile: "nl_time_exp.test.ts",
        input: "23:00 's avonds",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "23:00 's avonds", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 23))
    ),
    OracleCase(
        sourceFile: "nl_time_exp.test.ts",
        input: "23:00 vanavond",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "23:00 vanavond", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 23))
    ),
    OracleCase(
        sourceFile: "nl_time_exp.test.ts",
        input: "6:00 's ochtends",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "6:00 's ochtends", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 6, minute: 0))
    ),
    OracleCase(
        sourceFile: "nl_time_exp.test.ts",
        input: "6:00 in de namiddag",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "6:00 in de namiddag", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 18, minute: 0))
    ),
]
