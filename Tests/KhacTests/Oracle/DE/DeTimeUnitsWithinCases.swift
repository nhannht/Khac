// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/de/de_time_units_within.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let deTimeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "Wir müssen etwas in 5 Tagen erledigen.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "in 5 Tagen", index: 17, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "Wir müssen etwas in fünf Tagen erledigen.",
        reference: OracleDate(2012, 8, 10, 11, 12),
        expectation: .match(text: "in fünf Tagen", index: 17, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15, 11, 12))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "in 5 Minuten",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in 5 Minuten", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "für 5 minuten",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "für 5 minuten", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "in einer Stunde",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in einer Stunde", index: 0, startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "starte einen Timer für 5 Minuten",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "für 5 Minuten", index: 19, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "In 5 Minuten gehe ich nach Hause",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 Minuten", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "In 5 Sekunden wird ein Auto fahren",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 Sekunden", index: 0, startDate: OracleDate(2012, 8, 10, 12, 14, 5))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "in zwei Wochen",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in zwei Wochen", index: 0, startDate: OracleDate(2012, 8, 24, 12, 14))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "in einem Monat",
        reference: OracleDate(2012, 8, 10, 7, 14),
        expectation: .match(text: "in einem Monat", index: 0, startDate: OracleDate(2012, 9, 10, 7, 14))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "in einigen Monaten",
        reference: OracleDate(2012, 7, 10, 22, 14),
        expectation: .match(text: "in einigen Monaten", index: 0, startDate: OracleDate(2012, 10, 10, 22, 14))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "in einem Jahr",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in einem Jahr", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "in 20 Jahren",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in 20 Jahren", index: 0, startDate: OracleDate(2032, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "In 5 Minuten wird ein Auto fahren",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 Minuten", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "de_time_units_within.test.ts",
        input: "In 5 Min wird ein Auto fahren",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "In 5 Min", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
]
