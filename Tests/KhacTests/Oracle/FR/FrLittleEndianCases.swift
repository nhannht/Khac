// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fr/fr_little_endian.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let frLittleEndianCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Août 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Août 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "8 Février",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8 Février", index: 0, start: OracleComponents(year: 2013, month: 2, day: 8), startDate: OracleDate(2013, 2, 8, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "1er Août 2012",
        reference: OracleDate(2012, 8, 1),
        expectation: .match(text: "1er Août 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 1), startDate: OracleDate(2012, 8, 1, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Août 234 AC",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Août 234 AC", index: 0, start: OracleComponents(year: -234, month: 8, day: 10), startDate: OracleDate(-234, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Août 88 p. Chr. n.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Août 88 p. Chr. n.", index: 0, start: OracleComponents(year: 88, month: 8, day: 10))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "Dim 15 Sept",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "Dim 15 Sept", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "DIM 15SEPT",
        reference: OracleDate(2013, 8, 10),
        expectation: .match(text: "DIM 15SEPT", index: 0, start: OracleComponents(year: 2013, month: 9, day: 15), startDate: OracleDate(2013, 9, 15, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "La date limite est le 10 Août",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Août", index: 22, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "La date limite est le Mardi 10 janvier",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Mardi 10 janvier", index: 22, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "La date limite est Mar 10 Jan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Mar 10 Jan", index: 19, start: OracleComponents(year: 2013, month: 1, day: 10, weekday: 2), startDate: OracleDate(2013, 1, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "31 mars 2016",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "31 mars 2016", index: 0, start: OracleComponents(year: 2016, month: 3, day: 31), startDate: OracleDate(2016, 3, 31, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 - 22 août 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 - 22 août 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 au 22 août 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 au 22 août 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 22), endDate: OracleDate(2012, 8, 22, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 août - 12 septembre",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 août - 12 septembre", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 9, day: 12), endDate: OracleDate(2012, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 août - 12 septembre 2013",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 août - 12 septembre 2013", index: 0, start: OracleComponents(year: 2013, month: 8, day: 10), startDate: OracleDate(2013, 8, 10, 12), end: OracleComponents(year: 2013, month: 9, day: 12), endDate: OracleDate(2013, 9, 12, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "12 juillet à 19:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12 juillet à 19:00", index: 0, start: OracleComponents(year: 2012, month: 7, day: 12), startDate: OracleDate(2012, 7, 12, 19))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "5 mai 12:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 mai 12:00", index: 0, start: OracleComponents(year: 2012, month: 5, day: 5), startDate: OracleDate(2012, 5, 5, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "7 Mai 11:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "7 Mai 11:00", index: 0, start: OracleComponents(year: 2012, month: 5, day: 7, hour: 11), startDate: OracleDate(2012, 5, 7, 11))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Août 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Août 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Février 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Février 2012", index: 0, start: OracleComponents(year: 2012, month: 2, day: 10), startDate: OracleDate(2012, 2, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Décembre 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Décembre 2012", index: 0, start: OracleComponents(year: 2012, month: 12, day: 10), startDate: OracleDate(2012, 12, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Aout 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Aout 2012", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Fevrier 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Fevrier 2012", index: 0, start: OracleComponents(year: 2012, month: 2, day: 10), startDate: OracleDate(2012, 2, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "10 Decembre 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Decembre 2012", index: 0, start: OracleComponents(year: 2012, month: 12, day: 10), startDate: OracleDate(2012, 12, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "32 Août 2014",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "29 Février 2014",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "32 Aout",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "29 Fevrier",
        reference: OracleDate(2013, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "12 juil. 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "12 juil. 2012", start: OracleComponents(year: 2012, month: 7, day: 12))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "15 déc. 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "15 déc. 2012", start: OracleComponents(year: 2012, month: 12, day: 15))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "15 déc 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "15 déc 2012", start: OracleComponents(year: 2012, month: 12, day: 15))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "1 janv. 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "1 janv. 2012", start: OracleComponents(year: 2012, month: 1, day: 1))
    ),
    OracleCase(
        sourceFile: "fr_little_endian.test.ts",
        input: "22 févr. 2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "22 févr. 2012", start: OracleComponents(year: 2012, month: 2, day: 22))
    ),
]
