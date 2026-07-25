// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_timezone_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itTimezoneExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_timezone_exp.test.ts",
        input: "10 agosto 2012 10:00 CET",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 2012 10:00 CET", start: OracleComponents(year: 2012, month: 8, day: 10, hour: 10, minute: 0, timezoneOffset: 120))
    ),
    OracleCase(
        sourceFile: "it_timezone_exp.test.ts",
        input: "10 agosto 2012 10:00 CEST",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 2012 10:00 CEST", start: OracleComponents(hour: 10, timezoneOffset: 120))
    ),
    OracleCase(
        sourceFile: "it_timezone_exp.test.ts",
        input: "10 agosto 2012 10:00 +0100",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 2012 10:00 +0100", start: OracleComponents(hour: 10, timezoneOffset: 60))
    ),
    OracleCase(
        sourceFile: "it_timezone_exp.test.ts",
        input: "10 agosto 2012 10:00 +01:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 2012 10:00 +01:00", start: OracleComponents(hour: 10, timezoneOffset: 60))
    ),
    OracleCase(
        sourceFile: "it_timezone_exp.test.ts",
        input: "10 agosto 2012 10:00 +02:00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 agosto 2012 10:00 +02:00", start: OracleComponents(hour: 10, timezoneOffset: 120))
    ),
]
