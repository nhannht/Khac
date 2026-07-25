// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fr/fr_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let frWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fr_weekday.test.ts",
        input: "Lundi",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Lundi", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1), startDate: OracleDate(2012, 8, 6, 12))
    ),
    OracleCase(
        sourceFile: "fr_weekday.test.ts",
        input: "Lundi (forward dates only)",
        reference: OracleDate(2012, 8, 9),
        forwardDate: true,
        expectation: .match(text: "Lundi", index: 0, start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1), startDate: OracleDate(2012, 8, 13, 12))
    ),
    OracleCase(
        sourceFile: "fr_weekday.test.ts",
        input: "Jeudi",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Jeudi", index: 0, start: OracleComponents(year: 2012, month: 8, day: 9, weekday: 4), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "fr_weekday.test.ts",
        input: "Dimanche",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Dimanche", index: 0, start: OracleComponents(year: 2012, month: 8, day: 12, weekday: 0), startDate: OracleDate(2012, 8, 12, 12))
    ),
    OracleCase(
        sourceFile: "fr_weekday.test.ts",
        input: "la deadline était vendredi dernier...",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "vendredi dernier", index: 18, start: OracleComponents(year: 2012, month: 8, day: 3, weekday: 5), startDate: OracleDate(2012, 8, 3, 12))
    ),
    OracleCase(
        sourceFile: "fr_weekday.test.ts",
        input: "Planifions une réuinion vendredi prochain",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "vendredi prochain", index: 24, start: OracleComponents(year: 2015, month: 4, day: 24, weekday: 5), startDate: OracleDate(2015, 4, 24, 12))
    ),
    OracleCase(
        sourceFile: "fr_weekday.test.ts",
        input: "Dimanche 7 décembre 2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Dimanche 7 décembre 2014", index: 0, start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0), startDate: OracleDate(2014, 12, 7, 12))
    ),
    OracleCase(
        sourceFile: "fr_weekday.test.ts",
        input: "Dimanche 7/12/2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Dimanche 7/12/2014", index: 0, start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0), startDate: OracleDate(2014, 12, 7, 12))
    ),
]
