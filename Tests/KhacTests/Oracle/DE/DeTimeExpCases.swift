// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/de/de_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let deTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "18:10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "18:10", index: 0, start: OracleComponents(hour: 18, minute: 10), startDate: OracleDate(2012, 8, 10, 18, 10))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 14 Uhr",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 14, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 16h",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 16, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 7 morgens",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 7, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "11:00 Uhr vormittags",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "11:00 Uhr vormittags", start: OracleComponents(hour: 11, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 7 morgens",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 7, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "11:00 Uhr vormittags",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "11:00 Uhr vormittags", start: OracleComponents(hour: 11, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 8 Uhr nachmittags",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "um 8 Uhr nachmittags", start: OracleComponents(hour: 20, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 8 Uhr in der Nacht",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "um 8 Uhr in der Nacht", start: OracleComponents(hour: 20, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 5 Uhr in der Nacht",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "um 5 Uhr in der Nacht", start: OracleComponents(hour: 5, minute: 0))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "18:10 - 22.32",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "18:10 - 22.32", index: 0, start: OracleComponents(hour: 18, minute: 10), startDate: OracleDate(2012, 8, 10, 18, 10), end: OracleComponents(hour: 22, minute: 32), endDate: OracleDate(2012, 8, 10, 22, 32))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: " von 6:30 bis 23:00 ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "von 6:30 bis 23:00", index: 1, start: OracleComponents(hour: 6, minute: 30), startDate: OracleDate(2012, 8, 10, 6, 30), end: OracleComponents(hour: 23, minute: 0), endDate: OracleDate(2012, 8, 10, 23))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: " von 6h30 bis 23h00 ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "von 6h30 bis 23h00", index: 1, start: OracleComponents(hour: 6, minute: 30), startDate: OracleDate(2012, 8, 10, 6, 30), end: OracleComponents(hour: 23, minute: 0), endDate: OracleDate(2012, 8, 10, 23))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: " von 6h30 morgens bis 11 am Abend",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "von 6h30 morgens bis 11 am Abend", index: 1, start: OracleComponents(hour: 6, minute: 30), startDate: OracleDate(2012, 8, 10, 6, 30), end: OracleComponents(hour: 23, minute: 0), endDate: OracleDate(2012, 8, 10, 23))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 14 Uhr",
        reference: OracleDate(2016, 2, 28),
        expectation: .match(text: "um 14 Uhr")
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 14 Uhr CET",
        reference: OracleDate(2016, 2, 28),
        expectation: .match(text: "um 14 Uhr CET", start: OracleComponents(timezoneOffset: 60))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "14 Uhr cet",
        reference: OracleDate(2016, 5, 28),
        expectation: .match(text: "14 Uhr cet", start: OracleComponents(timezoneOffset: 120))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "um 12",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "um 12")
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "am Mittag",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Mittag", start: OracleComponents(hour: 12))
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "am Freitag um 14 Uhr cetteln wir etwas an",
        reference: OracleDate(2016, 2, 28),
        expectation: .match(text: "am Freitag um 14 Uhr")
    ),
    OracleCase(
        sourceFile: "de_time_exp.test.ts",
        input: "Freitag um 14 Uhr CET",
        reference: OracleDate(2016, 5, 28),
        expectation: .match(text: "Freitag um 14 Uhr CET", start: OracleComponents(timezoneOffset: 120))
    ),
]
