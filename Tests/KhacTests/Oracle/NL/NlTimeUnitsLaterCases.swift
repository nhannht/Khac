// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/nl/nl_time_units_later.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let nlTimeUnitsLaterCases: [OracleCase] = [
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "2 dagen later",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "2 dagen later", index: 0, start: OracleComponents(year: 2012, month: 8, day: 12), startDate: OracleDate(2012, 8, 12, 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "5 minuten later",
        reference: OracleDate(2012, 8, 10, 10),
        expectation: .match(text: "5 minuten later", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 10, minute: 5), startDate: OracleDate(2012, 8, 10, 10, 5))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "3 weken later",
        reference: OracleDate(2012, 7, 10, 10),
        expectation: .match(text: "3 weken later", index: 0, start: OracleComponents(year: 2012, month: 7, day: 31), startDate: OracleDate(2012, 7, 31, 10))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "5 dagen vanaf nu we hebben iets gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5 dagen vanaf nu", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "10 dagen vanaf nu we hebben iets gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 dagen vanaf nu", index: 0, start: OracleComponents(year: 2012, month: 8, day: 20), startDate: OracleDate(2012, 8, 20))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "15 minuten vanaf nu",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minuten vanaf nu", index: 0, start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 8, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "15 minuten eerder",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minuten eerder", index: 0, start: OracleComponents(hour: 11, minute: 59), startDate: OracleDate(2012, 8, 10, 11, 59))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "15 minuten uit",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "15 minuten uit", index: 0, start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 8, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "   12 uur vanaf nu",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "12 uur vanaf nu", index: 3, start: OracleComponents(day: 11, hour: 0, minute: 14), startDate: OracleDate(2012, 8, 11, 0, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "   half uur vanaf nu",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "half uur vanaf nu", index: 3, start: OracleComponents(hour: 12, minute: 44), startDate: OracleDate(2012, 8, 10, 12, 44))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "Over 12 uur heb ik iets gedaan",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Over 12 uur", index: 0, start: OracleComponents(day: 11, hour: 0, minute: 14), startDate: OracleDate(2012, 8, 11, 0, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "Over 12 seconden heb ik iets gedaan",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "Over 12 seconden", index: 0, start: OracleComponents(hour: 12, minute: 14, second: 12), startDate: OracleDate(2012, 8, 10, 12, 14, 12))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "over drie seconden heb ik iets gedaan",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "over drie seconden", index: 0, start: OracleComponents(hour: 12, minute: 14, second: 3), startDate: OracleDate(2012, 8, 10, 12, 14, 3))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "Over 5 dagen hebben we iets gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Over 5 dagen", index: 0, start: OracleComponents(year: 2012, month: 8, day: 15), startDate: OracleDate(2012, 8, 15))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "   half uur vanaf nu",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "half uur vanaf nu", index: 3, start: OracleComponents(hour: 12, minute: 44), startDate: OracleDate(2012, 8, 10, 12, 44))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "Over een dag hebben we iets gedaan",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Over een dag", index: 0, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "een minuutje uit",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "een minuutje uit", index: 0, start: OracleComponents(hour: 12, minute: 15), startDate: OracleDate(2012, 8, 10, 12, 15))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "in 1 uur",
        reference: OracleDate(2012, 8, 10, 12, 14),
        expectation: .match(text: "in 1 uur", index: 0, start: OracleComponents(hour: 13, minute: 14), startDate: OracleDate(2012, 8, 10, 13, 14))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "over 1,5 uur",
        reference: OracleDate(2012, 8, 10, 12, 40),
        expectation: .match(text: "over 1,5 uur", index: 0, start: OracleComponents(hour: 14, minute: 10), startDate: OracleDate(2012, 8, 10, 14, 10))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "15 minuten vanaf nu",
        reference: OracleDate(2012, 8, 10, 12, 14),
        mode: .strict,
        expectation: .match(text: "15 minuten vanaf nu", start: OracleComponents(hour: 12, minute: 29), startDate: OracleDate(2012, 8, 10, 12, 29))
    ),
    OracleCase(
        sourceFile: "nl_time_units_later.test.ts",
        input: "25 minuten later",
        reference: OracleDate(2012, 8, 10, 12, 40),
        mode: .strict,
        expectation: .match(text: "25 minuten later", index: 0, start: OracleComponents(hour: 13, minute: 5), startDate: OracleDate(2012, 8, 10, 13, 5))
    ),
]
