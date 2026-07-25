// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_weekday.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlWeekdayCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "maandag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "maandag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 6, weekday: 1), startDate: OracleDate(2012, 8, 6, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "maandag (forward dates only)",
        reference: OracleDate(2012, 8, 9),
        forwardDate: true,
        expectation: .match(text: "maandag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 13, weekday: 1), startDate: OracleDate(2012, 8, 13, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "donderdag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "donderdag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 9, weekday: 4), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "zondag",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "zondag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 12, weekday: 0), startDate: OracleDate(2012, 8, 12, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "De deadline is vorige vrijdag...",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "vorige vrijdag", index: 15, start: OracleComponents(year: 2012, month: 8, day: 3, weekday: 5), startDate: OracleDate(2012, 8, 3, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "De deadline is vorige vrijdag...",
        reference: OracleDate(2012, 8, 12),
        expectation: .match(text: "vorige vrijdag", index: 15, start: OracleComponents(year: 2012, month: 8, day: 10, weekday: 5), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "Laten we een meeting hebben op volgende week vrijdag",
        reference: OracleDate(2015, 4, 16),
        expectation: .match(text: "op volgende week vrijdag", index: 28, start: OracleComponents(year: 2015, month: 4, day: 24, weekday: 5), startDate: OracleDate(2015, 4, 24, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "Ik plan een vrije dag op volgende week dinsdag",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "op volgende week dinsdag", index: 22, start: OracleComponents(year: 2015, month: 4, day: 21, weekday: 2), startDate: OracleDate(2015, 4, 21, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "Laten we op dinsdag ochtend afspreken",
        reference: OracleDate(2015, 4, 18),
        expectation: .match(text: "op dinsdag ochtend", index: 9, start: OracleComponents(year: 2015, month: 4, day: 21, hour: 6, weekday: 2), startDate: OracleDate(2015, 4, 21, 6))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "zondag, 7 december 2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "zondag, 7 december 2014", index: 0, start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0), startDate: OracleDate(2014, 12, 7, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "zondag 7/12/2014",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "zondag 7/12/2014", index: 0, start: OracleComponents(year: 2014, month: 12, day: 7, weekday: 0), startDate: OracleDate(2014, 12, 7, 12))
    ),
    OracleCase(
        sourceFile: "nl_weekday.test.ts",
        input: "deze vrijdag tot deze maandag",
        reference: OracleDate(2016, 8, 4),
        forwardDate: true,
        expectation: .match(text: "deze vrijdag tot deze maandag", index: 0, start: OracleComponents(year: 2016, month: 8, day: 5, weekday: 5), startDate: OracleDate(2016, 8, 5, 12), end: OracleComponents(year: 2016, month: 8, day: 8, weekday: 1), endDate: OracleDate(2016, 8, 8, 12))
    ),
]
