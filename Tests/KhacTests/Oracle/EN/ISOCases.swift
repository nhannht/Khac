// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_inter_std.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let isoCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_inter_std.test.ts",
        input: "Let's finish this before this 2013-2-7.",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(start: OracleComponents(year: 2013, month: 2, day: 7))
    ),
    OracleCase(
        sourceFile: "en_inter_std.test.ts",
        input: "1994-11-05T08:15:30-05:30",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "1994-11-05T08:15:30-05:30", start: OracleComponents(year: 1994, month: 11, day: 5, hour: 8, minute: 15, second: 30, timezoneOffset: -330))
    ),
    OracleCase(
        sourceFile: "en_inter_std.test.ts",
        input: "1994-11-05T13:15:30Z",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "1994-11-05T13:15:30Z", start: OracleComponents(year: 1994, month: 11, day: 5, hour: 13, minute: 15, second: 30, timezoneOffset: 0))
    ),
    OracleCase(
        sourceFile: "en_inter_std.test.ts",
        input: "1994-11-05T13:15:30Z",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "1994-11-05T13:15:30Z", start: OracleComponents(year: 1994, month: 11, day: 5, hour: 13, minute: 15, second: 30, timezoneOffset: 0))
    ),
    OracleCase(
        sourceFile: "en_inter_std.test.ts",
        input: "- 1994-11-05T13:15:30Z",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "1994-11-05T13:15:30Z", index: 2, start: OracleComponents(year: 1994, month: 11, day: 5, hour: 13, minute: 15, second: 30, timezoneOffset: 0))
    ),
    OracleCase(
        sourceFile: "en_inter_std.test.ts",
        input: "2016-05-07T23:45:00.487+01:00",
        reference: OracleDate(2012, 8, 8),
        mode: .strict,
        expectation: .match(text: "2016-05-07T23:45:00.487+01:00", start: OracleComponents(year: 2016, month: 5, day: 7, hour: 23, minute: 45, second: 0, timezoneOffset: 60))
    ),
    OracleCase(
        sourceFile: "en_inter_std.test.ts",
        input: "1994-11-05T13:15:30",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "1994-11-05T13:15:30", start: OracleComponents(year: 1994, month: 11, day: 5, hour: 13, minute: 15, second: 30, millisecond: 0), startDate: OracleDate(1994, 11, 5, 13, 15, 30))
    ),
    OracleCase(
        sourceFile: "en_inter_std.test.ts",
        input: "2015-07-31T12:00:00",
        reference: OracleDate(2012, 8, 8),
        expectation: .match(text: "2015-07-31T12:00:00", start: OracleComponents(year: 2015, month: 7, day: 31, hour: 12, minute: 0, second: 0, millisecond: 0), startDate: OracleDate(2015, 7, 31, 12))
    ),
]
