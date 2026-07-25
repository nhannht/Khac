// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/uk/uk_month.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ukMonthCases: [OracleCase] = [
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "Вересень 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Вересень 2012", index: 0, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "верес 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "верес 2012", index: 0, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "верес. 2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "верес. 2012", index: 0, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "верес-2012",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "верес-2012", index: 0, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "в січні",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "в січні", index: 0, startDate: OracleDate(2021, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "в січ",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "в січ", index: 0, startDate: OracleDate(2021, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "травень",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(text: "травень", index: 0, startDate: OracleDate(2021, 5, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "Це було у вересні 2012 перед новим роком",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "у вересні 2012", index: 8, startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "сер 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "сер 96", index: 0, startDate: OracleDate(1996, 8, 1, 12))
    ),
    OracleCase(
        sourceFile: "uk_month.test.ts",
        input: "96 сер 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "сер 96", index: 3, startDate: OracleDate(1996, 8, 1, 12))
    ),
]
