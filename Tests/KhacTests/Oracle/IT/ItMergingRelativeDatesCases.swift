// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/it/it_merging_relative_dates.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let itMergingRelativeDatesCases: [OracleCase] = [
    OracleCase(
        sourceFile: "it_merging_relative_dates.test.ts",
        input: "domani alle 13:00",
        reference: OracleDate(2012, 8, 10, 8, 9),
        expectation: .match(text: "domani alle 13:00", start: OracleComponents(day: 11, hour: 13, minute: 0))
    ),
    OracleCase(
        sourceFile: "it_merging_relative_dates.test.ts",
        input: "ieri alle 10:00",
        reference: OracleDate(2012, 8, 10, 8, 9),
        expectation: .match(text: "ieri alle 10:00", start: OracleComponents(day: 9, hour: 10, minute: 0))
    ),
    OracleCase(
        sourceFile: "it_merging_relative_dates.test.ts",
        input: "venerdì prossimo alle 18:00",
        reference: OracleDate(2012, 8, 9),
        expectation: .match(text: "venerdì prossimo alle 18:00", start: OracleComponents(day: 17, hour: 18, minute: 0))
    ),
]
