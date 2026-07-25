// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza è adesso",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "adesso", index: 14, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8, minute: 9, second: 10, millisecond: 11), startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza è oggi",
        reference: OracleDate(2012, 8, 10, 14, 12),
        expectation: .match(text: "oggi", index: 14, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 14, 12))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza è domani",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "domani", index: 14, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11, 17, 10))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza è domani",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(startDate: OracleDate(2012, 8, 11, 1))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza era ieri",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ieri", index: 16, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza era ieri sera ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ieri sera", index: 16, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 20), startDate: OracleDate(2012, 8, 9, 20))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza era stamattina ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "stamattina", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza era questo pomeriggio ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "pomeriggio", index: 23, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15), startDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza era stasera ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "stasera", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22), startDate: OracleDate(2012, 8, 10, 22))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza è mezzanotte ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "mezzanotte", start: OracleComponents(year: 2012, month: 8, day: 11, hour: 0))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza era mezzanotte ",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(text: "mezzanotte", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 0, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza era mezzanotte ",
        reference: OracleDate(2012, 8, 10, 1),
        forwardDate: true,
        expectation: .match(text: "mezzanotte", start: OracleComponents(year: 2012, month: 8, day: 11, hour: 0, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "La scadenza è oggi alle 17",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "oggi alle 17", index: 14, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17), startDate: OracleDate(2012, 8, 10, 17))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "Domani a mezzogiorno",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11, hour: 12), startDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "L'evento è oggi - venerdì prossimo",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "oggi - venerdì prossimo", index: 11, start: OracleComponents(year: 2012, month: 8, day: 4, hour: 12), startDate: OracleDate(2012, 8, 4, 12), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), endDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "L'evento è oggi - venerdì prossimo",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "oggi - venerdì prossimo", index: 11, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 17, hour: 12), endDate: OracleDate(2012, 8, 17, 12))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "ferie da stamattina a domani",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "stamattina a domani", start: OracleComponents(month: 8, day: 5, hour: 6), end: OracleComponents(month: 8, day: 5, hour: 12))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "ferie da oggi a domani pomeriggio",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "oggi a domani pomeriggio", start: OracleComponents(month: 8, day: 4, hour: 12), end: OracleComponents(month: 8, day: 5, hour: 15))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "stasera",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "stasera", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 22))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "stasera alle 20",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "stasera alle 20", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "stasera alle 8",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "stasera alle 8", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "gio",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "gio", start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "questa sera",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "questa sera", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "ieri pomeriggio",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "ieri pomeriggio", start: OracleComponents(year: 2016, month: 9, day: 30, hour: 15))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "domani mattina",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "domani mattina", start: OracleComponents(year: 2016, month: 10, day: 2, hour: 6))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "questo pomeriggio alle 3",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "pomeriggio alle 3", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 15))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "a mezzanotte il 12 agosto",
        reference: OracleDate(2012, 8, 10, 15),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 12, hour: 0, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "nonoggi",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "xieri",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "it_casual.test.ts",
        input: "domaniX",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
