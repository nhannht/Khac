// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fr/fr_time_units_casual_relative.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let frTimeUnitsCasualRelativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "le mois d'avril",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "le mois d'avril prochain",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "la semaine prochaine",
        reference: OracleDate(2017, 5, 12),
        expectation: .match(text: "la semaine prochaine", start: OracleComponents(year: 2017, month: 5, day: 19))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "les 2 prochaines semaines",
        reference: OracleDate(2017, 5, 12, 18, 11),
        expectation: .match(text: "les 2 prochaines semaines", start: OracleComponents(year: 2017, month: 5, day: 26, hour: 18, minute: 11))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "les trois prochaines semaines",
        reference: OracleDate(2017, 5, 12),
        expectation: .match(text: "les trois prochaines semaines", start: OracleComponents(year: 2017, month: 6, day: 2))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "le mois dernier",
        reference: OracleDate(2017, 5, 12),
        expectation: .match(text: "le mois dernier", start: OracleComponents(year: 2017, month: 4, day: 12))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "les 30 jours précédents",
        reference: OracleDate(2017, 5, 12),
        expectation: .match(text: "les 30 jours précédents", start: OracleComponents(year: 2017, month: 4, day: 12))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "les 24 heures passées",
        reference: OracleDate(2017, 5, 12, 11, 27),
        expectation: .match(text: "les 24 heures passées", start: OracleComponents(year: 2017, month: 5, day: 11, hour: 11, minute: 27))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "les 90 secondes suivantes",
        reference: OracleDate(2017, 5, 12, 11, 27, 3),
        expectation: .match(text: "les 90 secondes suivantes", start: OracleComponents(year: 2017, month: 5, day: 12, hour: 11, minute: 28, second: 33))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "les huit dernieres minutes",
        reference: OracleDate(2017, 5, 12, 11, 27),
        expectation: .match(text: "les huit dernieres minutes", start: OracleComponents(year: 2017, month: 5, day: 12, hour: 11, minute: 19, second: 0))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "le dernier trimestre",
        reference: OracleDate(2017, 5, 12, 11, 27),
        expectation: .match(text: "le dernier trimestre", start: OracleComponents(year: 2017, month: 2, day: 12, hour: 11, minute: 27, second: 0))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "l'année prochaine",
        reference: OracleDate(2017, 5, 12, 11, 27),
        expectation: .match(text: "l'année prochaine", start: OracleComponents(year: 2018, month: 5, day: 12, hour: 11, minute: 27, second: 0))
    ),
    OracleCase(
        sourceFile: "fr_time_units_casual_relative.test.ts",
        input: "la derniere homme",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
