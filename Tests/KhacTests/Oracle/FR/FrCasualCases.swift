// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fr/fr_casual.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let frCasualCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est maintenant",
        reference: OracleDate(2012, 8, 10, 8, 9, 10, 11),
        expectation: .match(text: "maintenant", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8, minute: 9, second: 10, millisecond: 11), startDate: OracleDate(2012, 8, 10, 8, 9, 10, 11))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est aujourd'hui",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "aujourd'hui", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10), startDate: OracleDate(2012, 8, 10, 12))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est demain",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "demain", index: 16, start: OracleComponents(year: 2012, month: 8, day: 11), startDate: OracleDate(2012, 8, 11, 12))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est demain",
        reference: OracleDate(2012, 8, 10, 1),
        expectation: .match(startDate: OracleDate(2012, 8, 11, 1))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline était hier",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "hier", index: 18, start: OracleComponents(year: 2012, month: 8, day: 9), startDate: OracleDate(2012, 8, 9, 12))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline était la veille",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "la veille", index: 18, start: OracleComponents(year: 2012, month: 8, day: 9, hour: 0), startDate: OracleDate(2012, 8, 9))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est ce matin",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ce matin", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 8), startDate: OracleDate(2012, 8, 10, 8))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est cet après-midi",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "cet après-midi", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 14), startDate: OracleDate(2012, 8, 10, 14))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est cet aprem",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "cet aprem", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 14), startDate: OracleDate(2012, 8, 10, 14))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est ce soir",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "ce soir", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 18), startDate: OracleDate(2012, 8, 10, 18))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "a midi",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "a midi", start: OracleComponents(hour: 12))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "à minuit",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "à minuit", start: OracleComponents(hour: 0))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "Du 24 août 2023 au 26 août 2023",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "24 août 2023 au 26 août 2023", start: OracleComponents(year: 2023, month: 8, day: 24), end: OracleComponents(year: 2023, month: 8, day: 26))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est aujourd'hui 17:00",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "aujourd'hui 17:00", index: 16, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 17), startDate: OracleDate(2012, 8, 10, 17))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est demain 17:00",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "demain 17:00", index: 16, start: OracleComponents(year: 2012, month: 8, day: 11, hour: 17), startDate: OracleDate(2012, 8, 11, 17))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "La deadline est demain matin 11h",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "demain matin 11h", index: 16, start: OracleComponents(year: 2012, month: 8, day: 11, hour: 11), startDate: OracleDate(2012, 8, 11, 11))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "après-midi à 5",
        reference: OracleDate(2016, 8, 10, 12),
        expectation: .match(text: "après-midi à 5", start: OracleComponents(hour: 17))
    ),
    OracleCase(
        sourceFile: "fr_casual.test.ts",
        input: "soir à 8",
        reference: OracleDate(2016, 8, 10, 12),
        expectation: .match(text: "soir à 8", start: OracleComponents(hour: 20))
    ),
]
