// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "deze week",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "deze week", start: OracleComponents(year: 2017, month: 11, day: 19, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "deze maand",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "deze maand", start: OracleComponents(year: 2017, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "dit jaar",
        reference: OracleDate(2017, 11, 19, 12),
        expectation: .match(text: "dit jaar", start: OracleComponents(year: 2017, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "afgelopen week",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "afgelopen week", start: OracleComponents(year: 2016, month: 9, day: 24, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "afgelopen maand",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "afgelopen maand", start: OracleComponents(year: 2016, month: 9, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "afgelopen dag",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "afgelopen dag", start: OracleComponents(year: 2016, month: 9, day: 30, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "vorige week",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "vorige week", start: OracleComponents(year: 2016, month: 9, day: 24, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "komend uur",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "komend uur", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 13))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "volgende week",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "volgende week", start: OracleComponents(year: 2016, month: 10, day: 8, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "volgende dag",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "volgende dag", start: OracleComponents(year: 2016, month: 10, day: 2, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "volgende maand",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "volgende maand", start: OracleComponents(year: 2016, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "aankomende maand",
        reference: OracleDate(2016, 10, 1, 12),
        expectation: .match(text: "aankomende maand", start: OracleComponents(year: 2016, month: 11, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_relative.test.ts",
        input: "volgend jaar",
        reference: OracleDate(2020, 11, 22, 12, 11, 32, 6),
        expectation: .match(text: "volgend jaar", start: OracleComponents(year: 2021, month: 11, day: 22, hour: 12, minute: 11, second: 32, millisecond: 6))
    ),
]
