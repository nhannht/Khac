// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/ru/ru_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ruRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "на этой неделе",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "на этой неделе", index: 0, start: OracleComponents(year: 2017, month: 11, day: 19, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "в этом месяце",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "в этом месяце", index: 0, start: OracleComponents(year: 2017, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "в этом месяце",
        reference: OracleDate(2017, 11, 1, 12),
        expectation: .match(text: "в этом месяце", index: 0, start: OracleComponents(year: 2017, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "в этом году",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "в этом году", index: 0, start: OracleComponents(year: 2017, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "на прошлой неделе",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "на прошлой неделе", index: 0, start: OracleComponents(year: 2016, month: 9, day: 24, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "в прошлом месяце",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "в прошлом месяце", index: 0, start: OracleComponents(year: 2016, month: 9, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "в прошлом году",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "в прошлом году", index: 0, start: OracleComponents(year: 2015, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "на следующей неделе",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "на следующей неделе", index: 0, start: OracleComponents(year: 2016, month: 10, day: 8, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "в следующем месяце",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "в следующем месяце", index: 0, start: OracleComponents(year: 2016, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "в следующем квартале",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "в следующем квартале", index: 0, start: OracleComponents(year: 2017, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "ru_relative.test.ts",
        input: "в следующем году",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "в следующем году", index: 0, start: OracleComponents(year: 2017, month: 10, day: 1, hour: 12))
    ),
]
