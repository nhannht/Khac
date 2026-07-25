// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De deadline is nu",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "nu", index: 15, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8, minute: 9, second: 10, millisecond: 11, timezoneOffset: 420), startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De deadline is vandaag",
        reference: OracleDate(2012, 8, 10, 14, 12),
        expectation: .match(text: "vandaag", index: 15, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 14, 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De deadline is morgen",
        reference: OracleDate(2012, 8, 10, 17, 10),
        expectation: .match(text: "morgen", index: 15, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11, 17, 10))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De deadline is morgen",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(startDate: OracleDate(2012, 8, 11, 1))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De deadline was gisteren",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "gisteren", index: 16, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De Deadline was deze ochtend",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "deze ochtend", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De Deadline was deze namiddag ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "deze namiddag", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 15), startDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De Deadline was deze avond ",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "deze avond", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 20), startDate: OracleDate(2012, 8, 10, 20))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De deadline is vanavond",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "vanavond", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 20))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "The Deadline is om middernacht ",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(text: "middernacht", start: OracleComponents(year: 2012, month: 8, day: 11, hour: 0))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "De deadline is vandaag om 17:00",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "vandaag om 17:00", index: 15, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17), startDate: OracleDate(2012, 8, 10, 17))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "gisterenochtend",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 9, hour: 6), startDate: OracleDate(2012, 8, 9, 6))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "gisterenmiddag",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 9, hour: 12), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "gisterenavond",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 9, hour: 20), startDate: OracleDate(2012, 8, 9, 20))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "vanochtend",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 6), startDate: OracleDate(2012, 8, 10, 6))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "vanmiddag",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "vanavond",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 10, hour: 20), startDate: OracleDate(2012, 8, 10, 20))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "morgenochtend",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11, hour: 6), startDate: OracleDate(2012, 8, 11, 6))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "morgenmiddag",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11, hour: 12), startDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "morgenavond",
        reference: OracleDate(2012, 8, 10, 14),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 11, hour: 20), startDate: OracleDate(2012, 8, 11, 20))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "Het evenement is vandaag - volgende vrijdag",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "vandaag - volgende vrijdag", index: 17, start: OracleComponents(year: 2012, month: 8, day: 4, hour: 12), startDate: OracleDate(2012, 8, 4, 12), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), endDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "Het evenement is vandaag - volgende vrijdag",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "vandaag - volgende vrijdag", index: 17, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 12), startDate: OracleDate(2012, 8, 10, 12), end: OracleComponents(year: 2012, month: 8, day: 17, hour: 12), endDate: OracleDate(2012, 8, 17, 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "jaarlijks verlof vanaf vandaag tot morgennamiddag",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "vandaag tot morgennamiddag", start: OracleComponents(month: 8, day: 4, hour: 12), end: OracleComponents(month: 8, day: 5, hour: 15))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "jaarlijks verlof vanaf deze ochtend tot morgen",
        reference: OracleDate(2012, 8, 4, 12),
        expectation: .match(text: "deze ochtend tot morgen", start: OracleComponents(month: 8, day: 4, hour: 6), end: OracleComponents(month: 8, day: 5, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "vanavond",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "vanavond", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "middag",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "middag", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 12))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "vanavond 22:00",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "vanavond 22:00", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 22))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "vanavond om 21:00",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "vanavond om 21:00", start: OracleComponents(year: 2012, month: 1, day: 1, hour: 21))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "morgen voor 16:00",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "morgen voor 16:00", start: OracleComponents(year: 2012, month: 1, day: 2, hour: 16))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "morgen na 16:00",
        reference: OracleDate(2012, 1, 1, 12),
        expectation: .match(text: "morgen na 16:00", start: OracleComponents(year: 2012, month: 1, day: 2, hour: 16))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "donderdag",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "donderdag", start: OracleComponents(weekday: 4))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "deze avond",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "deze avond", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 20))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "gisterennamiddag",
        reference: OracleDate(2016, 10, 1),
        expectation: .match(text: "gisterennamiddag", start: OracleComponents(year: 2016, month: 9, day: 30, hour: 15))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "morgenochtend",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "morgenochtend", start: OracleComponents(year: 2016, month: 10, day: 2, hour: 6))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "deze namiddag om 15:00",
        reference: OracleDate(2016, 10, 1, 8),
        expectation: .match(text: "deze namiddag om 15:00", start: OracleComponents(year: 2016, month: 10, day: 1, hour: 15))
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "notoday",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "tdtmr",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "xyesterday",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "nowhere",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "noway",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "nl_casual.test.ts",
        input: "knowledge",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
