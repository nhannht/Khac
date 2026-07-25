// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/es/es_time_units_within.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let esTimeUnitsWithinCases: [OracleCase] = [
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "Tenemos que hacer algo en 5 días.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "en 5 días", index: 23, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "Tenemos que hacer algo en cinco días.",
        reference: OracleDate(2012, 8, 10, 11, 12),
        expectation: .match(text: "en cinco días", index: 23, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15, 11, 12))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "en 5 minutos",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "en 5 minutos", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "por 5 minutos",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "por 5 minutos", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "en 1 hora",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "en 1 hora", index: 0, startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "establecer un temporizador de 5 minutos",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "de 5 minutos", index: 27, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "En 5 minutos me voy a casa",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "En 5 minutos", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "En 5 segundos un auto se moverá",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "En 5 segundos", index: 0, startDate: OracleDate(2012, 8, 10, 12, 14, 5))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "en dos semanas",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "en dos semanas", index: 0, startDate: OracleDate(2012, 8, 24, 12, 14))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "dentro de un mes",
        reference: OracleDate(2012, 8, 10, 7, 14),
        expectation: .match(text: "dentro de un mes", index: 0, startDate: OracleDate(2012, 9, 10, 7, 14))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "en algunos meses",
        reference: OracleDate(2012, 7, 10, 22, 14),
        expectation: .match(text: "en algunos meses", index: 0, startDate: OracleDate(2012, 10, 10, 22, 14))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "en un año",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "en un año", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "dentro de un año",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "dentro de un año", index: 0, startDate: OracleDate(2013, 8, 10, 12, 14))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "En 5 Minutos hay que mover un coche",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "En 5 Minutos", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
    OracleCase(
        sourceFile: "es_time_units_within.test.ts",
        input: "En 5 minutos hay que mover un coche.",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "En 5 minutos", index: 0, startDate: OracleDate(2012, 8, 10, 12, 19))
    ),
]
