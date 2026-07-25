// GENERATED FILE - do not hand-edit. Regenerate via the extraction pipeline in
// scratch/chrono-en/extract.py + emit_swift.py, run against wanasit/chrono (MIT)
// test/en/negative_cases.test.ts.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let negativeCases: [OracleCase] = [
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: " 3",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "       1",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "  11 ",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: " 0.5 ",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: " 35.49 ",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "12.53%",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "6358fe2310> *5.0* / 5 Outstanding",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "6358fe2310> *1.5* / 5 Outstanding",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Total: $1,194.09 [image: View Reservation",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "at 6.5 kilograms",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "ah that is unusual",
        forwardDate: true,
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "%e7%b7%8a",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "https://tenor.com/view/%e3%83%89%e3%82%ad%e3%83%89%e3%82%ad-\" +\n            \"%e7%b7%8a%e5%bc%b5-%e5%a5%bd%e3%81%8d-%e3%83%8f%e3%83%bc%e3%83%88\" +\n            \"-%e5%8f%af%e6%84%9b%e3%81%84-gif-15876325",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "1-2",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "1-2-3",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "4-5-6",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "20-30-12",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "2012",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "2012-14",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "2012-1400",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "2200-25",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "February 29, 2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "02/29/2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "June 31, 2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "06/31/2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "14PM",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "25:12",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "An appointment on 13/31/2018",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "February 20 - 29, 2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "June 10 - 31, 2022",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Version: 1.1.3",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Version: 1.1.30",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "Version: 1.10.30",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "for the year",
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "1.5.3 - 2015-09-24",
        expectation: .match(text: "2015-09-24")
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "1.5.30 - 2015-09-24",
        expectation: .match(text: "2015-09-24")
    ),
    OracleCase(
        sourceFile: "negative_cases.test.ts",
        input: "1.50.30 - 2015-09-24",
        expectation: .match(text: "2015-09-24")
    ),
]
