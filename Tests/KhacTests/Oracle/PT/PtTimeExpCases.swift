// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/pt/pt_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let ptTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "Ficaremos às 6.13 AM",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "às 6.13 AM", index: 10, start: OracleComponents(hour: 6, minute: 13), startDate: OracleDate(2012, 8, 10, 6, 13))
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "8:10 - 12.32",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8:10 - 12.32", index: 0, start: OracleComponents(hour: 8, minute: 10), startDate: OracleDate(2012, 8, 10, 8, 10), end: OracleComponents(hour: 12, minute: 32), endDate: OracleDate(2012, 8, 10, 12, 32))
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: " de 6:30pm a 11:00pm ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "de 6:30pm a 11:00pm", index: 1, start: OracleComponents(hour: 18, minute: 30), startDate: OracleDate(2012, 8, 10, 18, 30), end: OracleComponents(hour: 23, minute: 0), endDate: OracleDate(2012, 8, 10, 23))
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "Algo passou em 10 de Agosto de 2012 10:12:59 pm",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 de Agosto de 2012 10:12:59 pm", index: 15, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22, minute: 12, second: 59, millisecond: 0), startDate: OracleDate(2012, 8, 10, 22, 12, 59))
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "de 1pm a 3",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "de 1pm a 3", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 13, minute: 0, second: 0, millisecond: 0), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 15, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "segunda 4/29/2013 630-930am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "segunda 4/29/2013 630-930am")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "terça 5/1/2013 1115am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "terça 5/1/2013 1115am")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "quarta 5/3/2013 1230pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "quarta 5/3/2013 1230pm")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "domingo 5/6/2013  750am-910am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "domingo 5/6/2013  750am-910am")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "segunda-feira 5/13/2013 630-930am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "segunda-feira 5/13/2013 630-930am")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "quarta-feira 5/15/2013 1030am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "quarta-feira 5/15/2013 1030am")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "quinta 6/21/2013 2:30",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "quinta 6/21/2013 2:30")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "terça-feira 7/2/2013 1-230 pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "terça-feira 7/2/2013 1-230 pm")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "Segunda-feira, 6/24/2013, 7:00pm - 8:30pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Segunda-feira, 6/24/2013, 7:00pm - 8:30pm")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "Quarta, 3 Julho de 2013 às 2pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Quarta, 3 Julho de 2013 às 2pm")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "6pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "6pm")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "6 pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "6 pm")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "7-10pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "7-10pm")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "11.1pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "11.1pm")
    ),
    OracleCase(
        sourceFile: "pt_time_exp.test.ts",
        input: "às 12",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "às 12")
    ),
]
