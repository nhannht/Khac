// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/pt/pt_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ptCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo é agora",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "agora", index: 10, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8, minute: 9, second: 10, millisecond: 11), startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo é hoje",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "hoje", index: 10, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo é Amanhã",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Amanhã", index: 10, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo é Amanhã",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(startDate: OracleDate(2012, 8, 11, 1))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo foi ontem",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ontem", index: 12, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo foi ontem à noite ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ontem à noite", index: 12, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 22), startDate: OracleDate(2012, 8, 9, 22))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo foi esta manhã ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "esta manhã", index: 12, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo foi esta tarde ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "esta tarde", index: 12, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15), startDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "O prazo é hoje às 5PM",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "hoje às 5PM", index: 10, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17), startDate: OracleDate(2012, 8, 10, 17))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "esta noite",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "esta noite", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 22))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "esta noite 8pm",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "esta noite 8pm", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "esta noite às 8",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "esta noite às 8", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "quinta",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "quinta", start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "sexta",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "sexta", start: OracleComponents(weekday: 5))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "ao meio-dia",
        reference: OracleDate(2020, 9, 1, 11),
        expectation: .match(start: OracleComponents(hour: 12), startDate: OracleDate(2020, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "a meia-noite",
        reference: OracleDate(2020, 9, 1, 11),
        expectation: .match(start: OracleComponents(hour: 0), startDate: OracleDate(2020, 9, 2))
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "naohoje",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "hyamanhã",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "xontem",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "porhora",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "pt_casual.test.ts",
        input: "agoraxsd",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
