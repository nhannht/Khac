// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_slash.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlSlashCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "    04/2016   ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "04/2016", index: 4)
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "Het evenement gaat door (04/2016)",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "04/2016", index: 25, start: OracleComponents(year: 2016, month: 4, day: 1), startDate: OracleDate(2016, 4, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "Gepubliceerd: 06/2004",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "06/2004", index: 14, start: OracleComponents(year: 2004, month: 6, day: 1), startDate: OracleDate(2004, 6, 1, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "8/10/2012",
        reference: OracleDate(2012, 10, 8),
        expectation: .match(text: "8/10/2012", index: 0, start: OracleComponents(year: 2012, month: 10, day: 8), startDate: OracleDate(2012, 10, 8, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: ": 8/1/2012",
        reference: OracleDate(2012, 1, 8),
        expectation: .match(text: "8/1/2012", index: 2, start: OracleComponents(year: 2012, month: 1, day: 8), startDate: OracleDate(2012, 1, 8, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "8/10",
        reference: OracleDate(2012, 10, 8),
        expectation: .match(text: "8/10", index: 0, start: OracleComponents(year: 2012, month: 10, day: 8), startDate: OracleDate(2012, 10, 8, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "De deadline is 8/10/2012",
        reference: OracleDate(2012, 10, 8),
        expectation: .match(text: "8/10/2012", index: 15, startDate: OracleDate(2012, 10, 8, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "De deadline is dinsdag 11/3/2015",
        reference: OracleDate(2015, 11, 3),
        expectation: .match(text: "dinsdag 11/3/2015", index: 15, startDate: OracleDate(2015, 3, 11, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "28/2/2014",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "28/2/2014")
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "vrijdag 30-12-16",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "vrijdag 30-12-16")
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "8/10/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8/10/2012", index: 0, start: OracleComponents(year: 2012, month: 10, day: 8), startDate: OracleDate(2012, 10, 8, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "vrijdag 30-12-16",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "vrijdag 30-12-16")
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "8 oktober 2012",
        reference: OracleDate(2012, 10, 8),
        expectation: .match(text: "8 oktober 2012", index: 0, start: OracleComponents(year: 2012, month: 10, day: 8), startDate: OracleDate(2012, 10, 8, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "10/8/2012 - 15/8/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10/8/2012 - 15/8/2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 15), endDate: OracleDate(2012, 8, 15, 12))
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "8/32/2014",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "8/32",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "2/29/2014",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "2014/22/29",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "2014/13/22",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_slash.test.ts",
        input: "80-32-89-89",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
]
