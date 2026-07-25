// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fi/fi_month_name_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let fiMonthNameLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fi_month_name_little_endian.test.ts",
        input: "15. elokuuta",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "fi_month_name_little_endian.test.ts",
        input: "15 elokuuta 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "fi_month_name_little_endian.test.ts",
        input: "15. elo 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "fi_month_name_little_endian.test.ts",
        input: "3 tammikuuta",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2013, month: 1, day: 3))
    ),
    OracleCase(
        sourceFile: "fi_month_name_little_endian.test.ts",
        input: "1 joulukuuta 2023",
        reference: OracleDate(2023, 11, 1),
        expectation: .match(start: OracleComponents(year: 2023, month: 12, day: 1))
    ),
    OracleCase(
        sourceFile: "fi_month_name_little_endian.test.ts",
        input: "15-16 elokuuta",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 15), end: OracleComponents(year: 2012, month: 8, day: 16))
    ),
    OracleCase(
        sourceFile: "fi_month_name_little_endian.test.ts",
        input: "32 elokuuta",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
]
