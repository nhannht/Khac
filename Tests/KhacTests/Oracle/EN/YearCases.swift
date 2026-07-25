// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_year.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let yearCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_year.test.ts",
        input: "10 August 234 BCE",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August 234 BCE", index: 0, start: OracleComponents(year: -234, month: 8, day: 10), startDate: OracleDate(-234, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_year.test.ts",
        input: "10 August 88 CE",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August 88 CE", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "en_year.test.ts",
        input: "10 August 234 BC",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August 234 BC", index: 0, start: OracleComponents(year: -234, month: 8, day: 10), startDate: OracleDate(-234, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_year.test.ts",
        input: "10 August 88 AD",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August 88 AD", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "en_year.test.ts",
        input: "10 August 2555 BE",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 August 2555 BE", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "en_year.test.ts",
        input: "Thu Oct 26 11:00:09 2023",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(start: OracleComponents(year: 2023, month: 10, day: 26, hour: 11, minute: 0, second: 9))
    ),
    OracleCase(
        sourceFile: "en_year.test.ts",
        input: "Thu Oct 26 - 28, 11:00:09 2023",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(start: OracleComponents(year: 2023, month: 10, day: 26, hour: 11, minute: 0, second: 9), end: OracleComponents(year: 2023, month: 10, day: 28, hour: 11, minute: 0, second: 9))
    ),
    OracleCase(
        sourceFile: "en_year.test.ts",
        input: "Thu Oct 26, 10:00 - 11:00:09 2023",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(start: OracleComponents(year: 2023, month: 10, day: 26, hour: 10, minute: 0, second: 0), end: OracleComponents(year: 2023, month: 10, day: 26, hour: 11, minute: 0, second: 9))
    ),
]
