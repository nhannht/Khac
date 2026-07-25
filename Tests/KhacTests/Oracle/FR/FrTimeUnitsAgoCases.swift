// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fr/fr_time_units_ago.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let frTimeUnitsAgoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fr_time_units_ago.test.ts",
        input: "il y a 5 jours, on a fait quelque chose",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "il y a 5 jours", index: 0, start: OracleComponents(year: 2012, month: 8, day: 5), startDate: OracleDate(2012, 8, 5))
    ),
    OracleCase(
        sourceFile: "fr_time_units_ago.test.ts",
        input: "il y a 10 jours, on a fait quelque chose",
        reference: OracleDate(2012, 8, 10, 13, 30),
        expectation: .match(text: "il y a 10 jours", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31), startDate: OracleDate(2012, 7, 31, 13, 30))
    ),
    OracleCase(
        sourceFile: "fr_time_units_ago.test.ts",
        input: "il y a 15 minutes",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "il y a 15 minutes", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "fr_time_units_ago.test.ts",
        input: "   il y a    12 heures",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "il y a    12 heures", index: 3, start: OracleComponents(hour: 0, minute: 14), startDate: OracleDate(2012, 8, 10, 0, 14))
    ),
    OracleCase(
        sourceFile: "fr_time_units_ago.test.ts",
        input: "il y a 12 heures il s'est passé quelque chose",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "il y a 12 heures", index: 0, start: OracleComponents(hour: 0, minute: 14), startDate: OracleDate(2012, 8, 10, 0, 14))
    ),
    OracleCase(
        sourceFile: "fr_time_units_ago.test.ts",
        input: "il y a 5 mois, on a fait quelque chose",
        reference: OracleDate(2012, 10, 10),
        expectation: .match(text: "il y a 5 mois", index: 0, start: OracleComponents(year: 2012, month: 5, day: 10), startDate: OracleDate(2012, 5, 10))
    ),
    OracleCase(
        sourceFile: "fr_time_units_ago.test.ts",
        input: "il y a 5 ans, on a fait quelque chose",
        reference: OracleDate(2012, 8, 10, 22, 22),
        expectation: .match(text: "il y a 5 ans", index: 0, start: OracleComponents(year: 2007, month: 8, day: 10), startDate: OracleDate(2007, 8, 10, 22, 22))
    ),
    OracleCase(
        sourceFile: "fr_time_units_ago.test.ts",
        input: "il y a une semaine, on a fait quelque chose",
        reference: OracleDate(2012, 8, 3, 8, 34),
        expectation: .match(text: "il y a une semaine", index: 0, start: OracleComponents(year: 2012, month: 7, day: 27), startDate: OracleDate(2012, 7, 27, 8, 34))
    ),
]
