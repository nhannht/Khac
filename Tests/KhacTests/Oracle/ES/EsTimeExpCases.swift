// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/es/es_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let esTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "Estaremos a las 6.13 AM",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "las 6.13 AM", index: 12, start: OracleComponents(hour: 6, minute: 13), startDate: OracleDate(2012, 8, 10, 6, 13))
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "8:10 - 12.32",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8:10 - 12.32", index: 0, start: OracleComponents(hour: 8, minute: 10), startDate: OracleDate(2012, 8, 10, 8, 10), end: OracleComponents(hour: 12, minute: 32), endDate: OracleDate(2012, 8, 10, 12, 32))
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: " de 6:30pm a 11:00pm ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "de 6:30pm a 11:00pm", index: 1, start: OracleComponents(hour: 18, minute: 30), startDate: OracleDate(2012, 8, 10, 18, 30), end: OracleComponents(hour: 23, minute: 0), endDate: OracleDate(2012, 8, 10, 23))
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "Algo pasó el 10 de Agosto de 2012 10:12:59 pm",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 de Agosto de 2012 10:12:59 pm", index: 13, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 22, minute: 12, second: 59, millisecond: 0), startDate: OracleDate(2012, 8, 10, 22, 12, 59))
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "de 1pm a 3",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "de 1pm a 3", index: 0, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 13, minute: 0, second: 0, millisecond: 0), end: OracleComponents(year: 2012, month: 8, day: 10, hour: 15, minute: 0, second: 0, millisecond: 0))
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "lunes 4/29/2013 630-930am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "lunes 4/29/2013 630-930am")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "martes 5/1/2013 1115am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "martes 5/1/2013 1115am")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "miércoles 5/3/2013 1230pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "miércoles 5/3/2013 1230pm")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "domingo 5/6/2013  750am-910am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "domingo 5/6/2013  750am-910am")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "lunes 5/13/2013 630-930am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "lunes 5/13/2013 630-930am")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "miércoles 5/15/2013 1030am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "miércoles 5/15/2013 1030am")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "jueves 6/21/2013 2:30",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "jueves 6/21/2013 2:30")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "martes 7/2/2013 1-230 pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "martes 7/2/2013 1-230 pm")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "Lunes, 6/24/2013, 7:00pm - 8:30pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Lunes, 6/24/2013, 7:00pm - 8:30pm")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "Miércoles, 3 Julio de 2013 a las 2pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Miércoles, 3 Julio de 2013 a las 2pm")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "6pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "6pm")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "6 pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "6 pm")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "7-10pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "7-10pm")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "11.1pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "11.1pm")
    ),
    OracleCase(
        sourceFile: "es_time_exp.test.ts",
        input: "las 12",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "las 12")
    ),
]
