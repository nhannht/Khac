// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/en_month.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let monthCases: [OracleCase] = [
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "September 2012",
        expectation: .match(text: "September 2012", start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "Sept 2012",
        expectation: .match(text: "Sept 2012", start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "Sep 2012",
        expectation: .match(text: "Sep 2012", start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "Sep. 2012",
        expectation: .match(text: "Sep. 2012", start: OracleComponents(year: 2012, month: 9, day: 1), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "Sep-2012",
        expectation: .match(text: "Sep-2012", index: 0, start: OracleComponents(year: 2012, month: 9), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "in June of 2022",
        expectation: .match(start: OracleComponents(year: 2022, month: 6))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "Statement of comprehensive income for the year ended Dec. 2021",
        expectation: .match(text: "Dec. 2021", start: OracleComponents(year: 2021, month: 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "In January",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(start: OracleComponents(year: 2021, month: 1, day: 1), startDate: OracleDate(2021, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "in Jan",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(start: OracleComponents(year: 2021, month: 1, day: 1), startDate: OracleDate(2021, 1, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "May",
        reference: OracleDate(2020, 11, 22),
        expectation: .match(start: OracleComponents(year: 2021, month: 5, day: 1), startDate: OracleDate(2021, 5, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "From May to December",
        reference: OracleDate(2023, 4, 9),
        expectation: .match(start: OracleComponents(year: 2023, month: 5), end: OracleComponents(year: 2023, month: 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "From December to May",
        reference: OracleDate(2023, 4, 9),
        expectation: .match(start: OracleComponents(year: 2022, month: 12), end: OracleComponents(year: 2023, month: 5))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "From May to December, 2022",
        reference: OracleDate(2023, 4, 9),
        expectation: .match(start: OracleComponents(year: 2022, month: 5), end: OracleComponents(year: 2022, month: 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "From December to May 2022",
        reference: OracleDate(2023, 4, 9),
        expectation: .match(start: OracleComponents(year: 2021, month: 12), end: OracleComponents(year: 2022, month: 5))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "From December to May 2020",
        reference: OracleDate(2023, 4, 9),
        expectation: .match(start: OracleComponents(year: 2019, month: 12), end: OracleComponents(year: 2020, month: 5))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "From December to May 2025",
        reference: OracleDate(2023, 4, 9),
        expectation: .match(start: OracleComponents(year: 2024, month: 12), end: OracleComponents(year: 2025, month: 5))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "in December",
        reference: OracleDate(2023, 4, 9),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2023, month: 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "in May",
        reference: OracleDate(2023, 4, 9),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2023, month: 5))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "From May to December",
        reference: OracleDate(2023, 4, 9),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2023, month: 5), end: OracleComponents(year: 2023, month: 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "From December to May",
        reference: OracleDate(2023, 4, 9),
        forwardDate: true,
        expectation: .match(start: OracleComponents(year: 2023, month: 12), end: OracleComponents(year: 2024, month: 5))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "The date is Sep 2012 is the date",
        expectation: .match(text: "Sep 2012", index: 12, start: OracleComponents(year: 2012, month: 9), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "By Angie Mar November 2019",
        expectation: .match(text: "November 2019", start: OracleComponents(year: 2019, month: 11), startDate: OracleDate(2019, 11, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "9/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "9/2012", index: 0, start: OracleComponents(year: 2012, month: 9), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "09/2012",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "09/2012", index: 0, start: OracleComponents(year: 2012, month: 9), startDate: OracleDate(2012, 9, 1, 12))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "Aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Aug 96", start: OracleComponents(year: 1996, month: 8))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "96 Aug 96",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "Aug 96", start: OracleComponents(year: 1996, month: 8))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "People visiting Buñol towards the end of August get a good chance to participate in La Tomatina (under normal circumstances)",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "August", start: OracleComponents(year: 2012, month: 8))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "The mountain may not move",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "May not be correct",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "2024 Aug",
        expectation: .match(text: "2024 Aug", start: OracleComponents(year: 2024, month: 8, day: 1))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "2024 August",
        expectation: .match(text: "2024 August", start: OracleComponents(year: 2024, month: 8, day: 1))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "2023 Sept",
        expectation: .match(text: "2023 Sept", start: OracleComponents(year: 2023, month: 9, day: 1))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "2024-August",
        expectation: .match(text: "2024-August", start: OracleComponents(year: 2024, month: 8))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "2024/August",
        expectation: .match(text: "2024/August", start: OracleComponents(year: 2024, month: 8))
    ),
    OracleCase(
        sourceFile: "en_month.test.ts",
        input: "2024 AD August",
        expectation: .match(text: "2024 AD August", start: OracleComponents(year: 2024, month: 8))
    ),
]
