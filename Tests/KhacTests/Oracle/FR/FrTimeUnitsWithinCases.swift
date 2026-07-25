// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fr/fr_time_units_within.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let frTimeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "On doit faire quelque chose dans 5 jours.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "dans 5 jours", index: 28, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "On doit faire quelque chose dans cinq jours.",
        reference: OracleDate(2012, 8, 10, 11, 12),
        expectation: .match(text: "dans cinq jours", index: 28, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15, 11, 12))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "dans 5 minutes",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "dans 5 minutes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "pour 5 minutes",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "pour 5 minutes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "en 1 heure",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "en 1 heure", index: 0, startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "régler une minuterie de 5 minutes",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "de 5 minutes", index: 21, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "Dans 5 minutes je vais rentrer chez moi",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Dans 5 minutes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "Dans 5 secondes une voiture va bouger",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Dans 5 secondes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 14, 5))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "dans deux semaines",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "dans deux semaines", index: 0, startDate: OracleDate(2012, 8, 24, 12, 14))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "dans un mois",
        reference: OracleDate(2012, 8, 10, 7, 14),
        expectation: .match(text: "dans un mois", index: 0, startDate: OracleDate(2012, 9, 10, 7, 14))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "dans quelques mois",
        reference: OracleDate(2012, 7, 10, 22, 14),
        expectation: .match(text: "dans quelques mois", index: 0, startDate: OracleDate(2012, 10, 10, 22, 14))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "en une année",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "en une année", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "dans une Année",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "dans une Année", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "Dans 5 Minutes une voiture doit être bougée",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Dans 5 Minutes", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "fr_time_units_within.test.ts",
        input: "Dans 5 mins une voiture doit être bougée",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Dans 5 mins", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
]
