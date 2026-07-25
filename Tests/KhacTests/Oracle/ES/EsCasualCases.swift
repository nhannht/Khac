// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/es/es_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let esCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite es ahora",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "ahora", index: 19, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8, minute: 9, second: 10, millisecond: 11), startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite es hoy",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "hoy", index: 19, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite es Mañana",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Mañana", index: 19, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite es mañana",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(startDate: OracleDate(2012, 8, 11, 1))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite fue ayer",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ayer", index: 20, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite fue ayer de noche ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ayer de noche", index: 20, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 22), startDate: OracleDate(2012, 8, 9, 22))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite fue esta mañana ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "esta mañana", index: 20, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite fue esta tarde ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "esta tarde", index: 20, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15), startDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "La fecha límite es hoy a las 5PM",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "hoy a las 5PM", index: 19, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17), startDate: OracleDate(2012, 8, 10, 17))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "esta noche",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "esta noche", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 22))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "esta noche 8pm",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "esta noche 8pm", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "esta noche a las 8",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "esta noche a las 8", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "jueves",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "jueves", start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "viernes",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "viernes", start: OracleComponents(weekday: 5))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "el mediodía",
        reference: OracleDate(2020, 9, 1, 11),
        expectation: .match(start: OracleComponents(hour: 12), startDate: OracleDate(2020, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "la medianoche",
        reference: OracleDate(2020, 9, 1, 11),
        expectation: .match(start: OracleComponents(hour: 0), startDate: OracleDate(2020, 9, 2))
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "nohoy",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "hymañana",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "xayer",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "porhora",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "es_casual.test.ts",
        input: "ahoraxsd",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
