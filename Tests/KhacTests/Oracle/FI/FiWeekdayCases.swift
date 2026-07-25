// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fi/fi_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let fiWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "maanantai",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "maanantai", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "maanantaina",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "maanantaina", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "ensi maanantai",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "ensi maanantai", index: 0, start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "viime maanantai",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "viime maanantai", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "sunnuntai",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 0))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "tiistai",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 2))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "keskiviikko",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 3))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "torstai",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "perjantai",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 5))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "lauantai",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 6))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "ma",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 1))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "pe",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 5))
    ),
    OracleCase(
        sourceFile: "fi_weekday.test.ts",
        input: "su",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(weekday: 0))
    ),
]
