// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fi/fi_time_units_within.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let fiTimeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "pitää tehdä jotain 5 päivää sisällä",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 päivää sisällä", start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "5 minuuttia sisällä",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5 minuuttia sisällä", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "1 tuntia sisällä",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1 tuntia sisällä", index: 0, startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "2 viikkoa sisällä",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "2 viikkoa sisällä", startDate: OracleDate(2012, 8, 24, 12, 14))
    ),
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "5 päivää kuluessa",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 päivää kuluessa", start: OracleComponents(year: 2012, month: 8, day: 15))
    ),
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "yksi vuotta kuluessa",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "yksi vuotta kuluessa", startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "5 minuuttia päästä",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "5 minuuttia päästä", startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "3 päivää päästä",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "3 päivää päästä", start: OracleComponents(year: 2012, month: 8, day: 13))
    ),
    OracleCase(
        sourceFile: "fi_time_units_within.test.ts",
        input: "2 viikkoa päästä",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "2 viikkoa päästä", start: OracleComponents(year: 2016, month: 10, day: 15))
    ),
]
