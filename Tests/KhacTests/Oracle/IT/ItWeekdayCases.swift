// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "Lunedì",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Lunedì", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "Lunedì (forward dates only)",
        reference: OracleDate(2012, 8, 9),
        forwardDate: true,
        expectation: .match(text: "Lunedì", index: 0, start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "giovedì",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "giovedì", index: 0, start: OracleComponents(year: 2012, month: 8, day: 9, weekday: 4))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "domenica",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "domenica", index: 0, start: OracleComponents(year: 2012, month: 8, day: 12, weekday: 0))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "La scadenza è venerdì prossimo...",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "venerdì prossimo", index: 14, start: OracleComponents(year: 2012, month: 8, day: 17, weekday: 5))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "Andrò questo venerdì",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "questo venerdì", index: 6, start: OracleComponents(year: 2012, month: 8, day: 10, weekday: 5))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "Lunedì mattina",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Lunedì mattina", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, hour: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "domenica, 7 dicembre 2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "domenica, 7 dicembre 2014", index: 0, start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "questo sabato",
        reference: OracleDate(2021, 8, 14),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2021, month: 8, day: 14, weekday: 6))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "questo sabato",
        reference: OracleDate(2021, 8, 15),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2021, month: 8, day: 21, weekday: 6))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "sabato",
        reference: OracleDate(2021, 8, 15),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2021, month: 8, day: 21, weekday: 6))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "lunedì-venerdì",
        reference: OracleDate(2024, 2, 6),
        expectation: .match(text: "lunedì-venerdì", index: 0, start: OracleComponents(year: 2024, month: 2, day: 5, weekday: 1), end: OracleComponents(year: 2024, month: 2, day: 9, weekday: 5))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "lunedì scorso",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "lunedì scorso", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "martedì scorso",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "martedì scorso", index: 0, start: OracleComponents(year: 2012, month: 8, day: 7, weekday: 2))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "mercoledì scorso",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "mercoledì scorso", index: 0, start: OracleComponents(year: 2012, month: 8, day: 8, weekday: 3))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "giovedì scorso",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "giovedì scorso", index: 0, start: OracleComponents(year: 2012, month: 8, day: 2, weekday: 4))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "venerdì scorso",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "venerdì scorso", index: 0, start: OracleComponents(year: 2012, month: 8, day: 3, weekday: 5))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "sabato scorso",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "sabato scorso", index: 0, start: OracleComponents(year: 2012, month: 8, day: 4, weekday: 6))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "domenica scorsa",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "domenica scorsa", index: 0, start: OracleComponents(year: 2012, month: 8, day: 5, weekday: 0))
    ),
    OracleCase(
        sourceFile: "it_weekday.test.ts",
        input: "informazioni",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
