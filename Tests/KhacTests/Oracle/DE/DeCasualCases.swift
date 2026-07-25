// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/de/de_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let deCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline ist jetzt",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "jetzt", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8, minute: 9, second: 10, millisecond: 11), startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline ist heute",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "heute", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline ist morgen",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "morgen", index: 17, start: OracleComponents(year: 2012, month: 8, day: 11))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline ist morgen",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11, hour: 1))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline war gestern",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "gestern", index: 17, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline war letzte Nacht ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "letzte Nacht", index: 17, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 0), startDate: OracleDate(2012, 8, 9))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline war gestern Nacht ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "gestern Nacht", index: 17, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 22), startDate: OracleDate(2012, 8, 9, 22))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline war heute Morgen ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "heute Morgen", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline war heute Nachmittag ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "heute Nachmittag", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15), startDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline war heute Abend ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "heute Abend", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 18), startDate: OracleDate(2012, 8, 10, 18))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline ist mittags",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "mittags", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12, minute: 0, second: 0))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "um Mitternacht",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11, hour: 0, minute: 0, second: 0))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "um Mitternacht",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 0, minute: 0, second: 0))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline ist heute 17 Uhr",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "heute 17 Uhr", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17), startDate: OracleDate(2012, 8, 10, 17))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Die Deadline ist heute um 17 Uhr",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "heute um 17 Uhr", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17), startDate: OracleDate(2012, 8, 10, 17))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Der Event ist heute - nächsten Freitag",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "heute - nächsten Freitag", index: 14, start: OracleComponents(year: 2012, month: 8, day: 4, hour: 12), startDate: OracleDate(2012, 8, 4, 12), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), endDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Der Event ist heute - nächsten Freitag",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "heute - nächsten Freitag", index: 14, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 17, hour: 12), endDate: OracleDate(2012, 8, 17, 12))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "heute Nacht",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "heute Nacht", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 22))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "heute Nacht um 20 Uhr",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "heute Nacht um 20 Uhr", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "heute Abend um 8",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "heute Abend um 8", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "8 Uhr abends",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "8 Uhr abends", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Do",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Do", start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "Donnerstag",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Donnerstag", start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "gestern Nachmittag",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "gestern Nachmittag", start: OracleComponents(year: 2016, month: 9, day: 30, hour: 15))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "morgen Morgen",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "morgen Morgen", start: OracleComponents(year: 2016, month: 10, day: 2, hour: 6))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "uebermorgen Abend",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "uebermorgen Abend", start: OracleComponents(year: 2016, month: 10, day: 3, hour: 18))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "vorgestern Vormittag",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "vorgestern Vormittag", start: OracleComponents(year: 2016, month: 9, day: 29, hour: 9))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "nicheute",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "heutenicht",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "angestern",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "jetztig",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "ljetztlich",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "nachmittag um 5",
        reference: OracleDate(2016, 8, 10, 12),
        expectation: .match(text: "nachmittag um 5", start: OracleComponents(hour: 17))
    ),
    OracleCase(
        sourceFile: "de_casual.test.ts",
        input: "abend um 5",
        reference: OracleDate(2016, 8, 10, 12),
        expectation: .match(text: "abend um 5", start: OracleComponents(hour: 17))
    ),
]
