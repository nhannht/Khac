// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/sv/sv_month_name_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let svMonthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "sv_month_name_little_endian.test.ts",
        input: "den 15 augusti",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "sv_month_name_little_endian.test.ts",
        input: "15 augusti 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "sv_month_name_little_endian.test.ts",
        input: "15 aug 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "sv_month_name_little_endian.test.ts",
        input: "15-16 augusti",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15), end: OracleComponents(year: 2012, month: 8, day: 16))
    ),
    OracleCase(
        sourceFile: "sv_month_name_little_endian.test.ts",
        input: "15 till 16 augusti",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15), end: OracleComponents(year: 2012, month: 8, day: 16))
    ),
    OracleCase(
        sourceFile: "sv_month_name_little_endian.test.ts",
        input: "32 augusti",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
]
