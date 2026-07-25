// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/uk/uk_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ukRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "на цьому тижні",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "на цьому тижні", index: 0, start: OracleComponents(year: 2017, month: 11, day: 19, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "у цьому місяці",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "у цьому місяці", index: 0, start: OracleComponents(year: 2017, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "цього місяця",
        reference: OracleDate(2017, 11, 1, 12),
        expectation: .match(text: "цього місяця", index: 0, start: OracleComponents(year: 2017, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "у цьому році",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "у цьому році", index: 0, start: OracleComponents(year: 2017, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "на минулому тижні",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "на минулому тижні", index: 0, start: OracleComponents(year: 2016, month: 9, day: 24, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "минулого місяця",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "минулого місяця", index: 0, start: OracleComponents(year: 2016, month: 9, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "у минулому році",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "у минулому році", index: 0, start: OracleComponents(year: 2015, month: 10, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "на наступному тижні",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "на наступному тижні", index: 0, start: OracleComponents(year: 2016, month: 10, day: 8, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "наступного місяця",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "наступного місяця", index: 0, start: OracleComponents(year: 2016, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "в наступному кварталі",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "в наступному кварталі", index: 0, start: OracleComponents(year: 2017, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "uk_relative.test.ts",
        input: "наступного року",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "наступного року", index: 0, start: OracleComponents(year: 2017, month: 10, day: 1, hour: 12))
    ),
]
