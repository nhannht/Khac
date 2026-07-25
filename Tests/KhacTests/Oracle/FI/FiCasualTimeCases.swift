// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fi/fi_casual_time.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let fiCasualTimeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fi_casual_time.test.ts",
        input: "aamulla",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(text: "aamulla", start: OracleComponents(hour: 6, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_casual_time.test.ts",
        input: "aamupäivällä",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(text: "aamupäivällä", start: OracleComponents(hour: 9, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_casual_time.test.ts",
        input: "päivällä",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(text: "päivällä", start: OracleComponents(hour: 12, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_casual_time.test.ts",
        input: "iltapäivällä",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(text: "iltapäivällä", start: OracleComponents(hour: 15, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_casual_time.test.ts",
        input: "illalla",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(text: "illalla", start: OracleComponents(hour: 18, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_casual_time.test.ts",
        input: "yöllä",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(text: "yöllä", start: OracleComponents(hour: 22, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_casual_time.test.ts",
        input: "keskiyöllä",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(text: "keskiyöllä", start: OracleComponents(hour: 0, minute: 0))
    ),
    OracleCase(
        sourceFile: "fi_casual_time.test.ts",
        input: "viime yönä",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(text: "viime yönä", start: OracleComponents(year: 2012, month: 8, day: 9, hour: 0))
    ),
]
