// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_time_units_ago.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlTimeUnitsAgoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "5 dagen geleden, hebben we wat gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 dagen geleden", index: 0, start: OracleComponents(year: 2012, month: 8, day: 5), startDate: OracleDate(2012, 8, 5))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "10 dagen geleden, hebben we wat gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 dagen geleden", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31), startDate: OracleDate(2012, 7, 31))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "15 minuten geleden",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minuten geleden", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "15 minuten eerder",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minuten eerder", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "15 minuten voor",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minuten voor", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "   12 uur geleden",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 uur geleden", index: 3, start: OracleComponents(hour: 0, minute: 14), startDate: OracleDate(2012, 8, 10, 0, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "1u geleden",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "1u geleden", index: 0, start: OracleComponents(hour: 11, minute: 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "   half uur geleden",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "half uur geleden", index: 3, start: OracleComponents(hour: 11, minute: 44), startDate: OracleDate(2012, 8, 10, 11, 44))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "12 uur geleden deed ik iets",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 uur geleden", index: 0, start: OracleComponents(hour: 0, minute: 14), startDate: OracleDate(2012, 8, 10, 0, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "12 seconden geleden deed ik iets",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 seconden geleden", index: 0, start: OracleComponents(hour: 12, minute: 13, second: 48), startDate: OracleDate(2012, 8, 10, 12, 13, 48))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "drie seconden geleden deed ik iets",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "drie seconden geleden", index: 0, start: OracleComponents(hour: 12, minute: 13, second: 57), startDate: OracleDate(2012, 8, 10, 12, 13, 57))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "5 dagen geleden, hebben we iets gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 dagen geleden", index: 0, start: OracleComponents(year: 2012, month: 8, day: 5), startDate: OracleDate(2012, 8, 5))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "Een dag geleden, hebben we wat gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Een dag geleden", index: 0, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "een minuut geleden",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "een minuut geleden", index: 0, start: OracleComponents(hour: 12, minute: 13), startDate: OracleDate(2012, 8, 10, 12, 13))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "5 maanden geleden, hebben we iets gedaan",
        reference: OracleDate(2012, 10, 10),
        expectation: .match(text: "5 maanden geleden", index: 0, start: OracleComponents(year: 2012, month: 5, day: 10), startDate: OracleDate(2012, 5, 10))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "5 jaar geleden,  hebben we iets gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 jaar geleden", index: 0, start: OracleComponents(year: 2007, month: 8, day: 10), startDate: OracleDate(2007, 8, 10))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "een week geleden, hebben we iets gedaan",
        reference: OracleDate(2012, 8, 3),
        expectation: .match(text: "een week geleden", index: 0, start: OracleComponents(year: 2012, month: 7, day: 27), startDate: OracleDate(2012, 7, 27))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "paar dagen geleden, hebben we iets gedaan",
        reference: OracleDate(2012, 8, 2),
        expectation: .match(text: "paar dagen geleden", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31), startDate: OracleDate(2012, 7, 31))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "15 uur 29 minuten geleden",
        reference: OracleDate(2012, 8, 10, 22, 30),
        expectation: .match(text: "15 uur 29 minuten geleden", start: OracleComponents(day: 10, hour: 7, minute: 1))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "1 dag 21 uur geleden ",
        reference: OracleDate(2012, 8, 10, 22, 30),
        expectation: .match(text: "1 dag 21 uur geleden", start: OracleComponents(day: 9, hour: 1, minute: 30))
    ),
    OracleCase(
        sourceFile: "nl_time_units_ago.test.ts",
        input: "3 min 49 sec geleden ",
        reference: OracleDate(2012, 8, 10, 22, 30),
        expectation: .match(text: "3 min 49 sec geleden", start: OracleComponents(day: 10, hour: 22, minute: 26, second: 11))
    ),
]
