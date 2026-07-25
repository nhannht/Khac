// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/de/de_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let deWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "Montag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1), startDate: OracleDate(2012, 8, 6, 12))
    ),
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "am Donnerstag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "am Donnerstag", start: OracleComponents(year: 2012, month: 8, day: 9, weekday: 4), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "Sonntag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Sonntag", start: OracleComponents(year: 2012, month: 8, day: 12, weekday: 0), startDate: OracleDate(2012, 8, 12, 12))
    ),
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "Die Deadline war letzten Freitag...",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "letzten Freitag", index: 17, start: OracleComponents(year: 2012, month: 8, day: 3, weekday: 5), startDate: OracleDate(2012, 8, 3, 12))
    ),
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "Treffen wir uns am Freitag nächste Woche",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "am Freitag nächste Woche", index: 16, start: OracleComponents(year: 2015, month: 4, day: 24, weekday: 5), startDate: OracleDate(2015, 4, 24, 12))
    ),
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "Ich habe vor, am Dienstag nächste Woche freizunehmen",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "am Dienstag nächste Woche", index: 14, start: OracleComponents(year: 2015, month: 4, day: 21, weekday: 2), startDate: OracleDate(2015, 4, 21, 12))
    ),
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "diesen Freitag bis diesen Montag",
        reference: OracleDate(2016, 8, 4),
        forwardDate: true,
        expectation: .match(text: "diesen Freitag bis diesen Montag", index: 0, start: OracleComponents(year: 2016, month: 8, day: 5, weekday: 5), startDate: OracleDate(2016, 8, 5, 12), end: OracleComponents(year: 2016, month: 8, day: 8, weekday: 1), endDate: OracleDate(2016, 8, 8, 12))
    ),
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "Sonntag, den 7. Dezember 2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Sonntag, den 7. Dezember 2014", index: 0, start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0), startDate: OracleDate(2014, 12, 7, 12))
    ),
    OracleCase(
        sourceFile: "de_weekday.test.ts",
        input: "Sonntag 7.12.2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "Sonntag 7.12.2014", start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0), startDate: OracleDate(2014, 12, 7, 12))
    ),
]
