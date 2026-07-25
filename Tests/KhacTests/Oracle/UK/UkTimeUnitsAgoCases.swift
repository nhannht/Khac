// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/uk/uk_time_units_ago.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ukTimeUnitsAgoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "5 днів тому щось відбулось",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "5 днів тому", index: 0, startDate: OracleDate(2012, 7, 5))
    ),
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "5 хвилин тому щось відбулось",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "5 хвилин тому", index: 0, startDate: OracleDate(2012, 7, 9, 23, 55))
    ),
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "півгодини тому щось відбулось",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "півгодини тому", index: 0, startDate: OracleDate(2012, 7, 9, 23, 30))
    ),
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "5 днів 2 години тому щось відбулось",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "5 днів 2 години тому", index: 0, startDate: OracleDate(2012, 7, 4, 22))
    ),
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "5 хвилин 20 секунд тому щось сталось",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "5 хвилин 20 секунд тому", index: 0, startDate: OracleDate(2012, 7, 9, 23, 54, 40))
    ),
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "2 години 5 хвилин тому щось сталось",
        reference: OracleDate(2012, 7, 10),
        expectation: .match(text: "2 години 5 хвилин тому", index: 0, startDate: OracleDate(2012, 7, 9, 21, 55))
    ),
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "15 годин 29 хв.",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "декілька годин",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "uk_time_units_ago.test.ts",
        input: "5 днів",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
