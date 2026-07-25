// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_merging_relative_dates.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let mergingRelativeDatesCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_merging_relative_dates.test.ts",
        input: "2 weeks after yesterday",
        reference: OracleDate(2022, 2, 2),
        expectation: .match(text: "2 weeks after yesterday", start: OracleComponents(year: 2022, month: 2, day: 15, weekday: 2), startDate: OracleDate(2022, 2, 15))
    ),
    OracleCase(
        sourceFile: "en_merging_relative_dates.test.ts",
        input: "2 months before 02/02",
        reference: OracleDate(2022, 2, 2),
        expectation: .match(text: "2 months before 02/02", start: OracleComponents(year: 2021, month: 12, day: 2), startDate: OracleDate(2021, 12, 2, 12))
    ),
    OracleCase(
        sourceFile: "en_merging_relative_dates.test.ts",
        input: "2 days after next Friday",
        reference: OracleDate(2022, 2, 2),
        expectation: .match(text: "2 days after next Friday", start: OracleComponents(year: 2022, month: 2, day: 13), startDate: OracleDate(2022, 2, 13, 12))
    ),
]
