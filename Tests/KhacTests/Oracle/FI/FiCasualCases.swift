// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fi/fi_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let fiCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "tänään",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "huomenna",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "eilen",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 9))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "ylihuomenna",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 12))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "toissapäivänä",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 8))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "tänään aamulla",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "tänään aamupäivällä",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 9))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "tänään päivällä",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "tänään iltapäivällä",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "tänään illalla",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 18))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "tänään yöllä",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "tänään keskiyöllä",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 0))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "iltapäivällä klo 5",
        reference: OracleDate(2016, 8, 10, 12),
        expectation: .match(text: "iltapäivällä klo 5", start: OracleComponents(hour: 17))
    ),
    OracleCase(
        sourceFile: "fi_casual.test.ts",
        input: "illalla klo 8",
        reference: OracleDate(2016, 8, 10, 12),
        expectation: .match(text: "illalla klo 8", start: OracleComponents(hour: 20))
    ),
]
