// GENERATED FILE - do not hand-edit. Ported from wanasit/chrono v2.10.1 (MIT),
// test/fr/fr_time_exp.test.ts.
// Produced by the extraction pipeline, which is kept with this project's private
// research rather than in this repo - see Oracle/README.md.
//
// Ported CASE DATA ONLY (input text, reference date, expected date/components) -
// the facts chrono's own tests assert. Not chrono's test code. See NOTICE and
// Oracle/README.md for the prior-art credit.

import Foundation

public let frTimeExpCases: [OracleCase] = [
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8h10",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8h10", index: 0, start: OracleComponents(hour: 8, minute: 10), startDate: OracleDate(2012, 8, 10, 8, 10))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8h10m",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8h10m", index: 0, start: OracleComponents(hour: 8, minute: 10), startDate: OracleDate(2012, 8, 10, 8, 10))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8h10m00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8h10m00", index: 0, start: OracleComponents(hour: 8, minute: 10), startDate: OracleDate(2012, 8, 10, 8, 10))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8h10m00s",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8h10m00s", index: 0, start: OracleComponents(hour: 8, minute: 10), startDate: OracleDate(2012, 8, 10, 8, 10))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8:10 PM",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8:10 PM", index: 0, start: OracleComponents(hour: 20, minute: 10), startDate: OracleDate(2012, 8, 10, 20, 10))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8h10 PM",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8h10 PM", index: 0, start: OracleComponents(hour: 20, minute: 10), startDate: OracleDate(2012, 8, 10, 20, 10))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "1230pm",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "1230pm", index: 0, start: OracleComponents(hour: 12, minute: 30), startDate: OracleDate(2012, 8, 10, 12, 30))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "5:16p",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5:16p", index: 0, start: OracleComponents(hour: 17, minute: 16), startDate: OracleDate(2012, 8, 10, 17, 16))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "5h16p",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5h16p", index: 0, start: OracleComponents(hour: 17, minute: 16), startDate: OracleDate(2012, 8, 10, 17, 16))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "5h16mp",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5h16mp", index: 0, start: OracleComponents(hour: 17, minute: 16), startDate: OracleDate(2012, 8, 10, 17, 16))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "5:16 p.m.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5:16 p.m.", index: 0, start: OracleComponents(hour: 17, minute: 16), startDate: OracleDate(2012, 8, 10, 17, 16))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "5h16 p.m.",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "5h16 p.m.", index: 0, start: OracleComponents(hour: 17, minute: 16), startDate: OracleDate(2012, 8, 10, 17, 16))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "RDV à 6.13 AM",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "à 6.13 AM", index: 4, start: OracleComponents(hour: 6, minute: 13), startDate: OracleDate(2012, 8, 10, 6, 13))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "13h-15h",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "13h-15h", index: 0, start: OracleComponents(hour: 13, minute: 0), startDate: OracleDate(2012, 8, 10, 13), end: OracleComponents(hour: 15, minute: 0), endDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "13-15h",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "13-15h", index: 0, start: OracleComponents(hour: 13, minute: 0), startDate: OracleDate(2012, 8, 10, 13), end: OracleComponents(hour: 15, minute: 0), endDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "1-3pm",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "1-3pm", index: 0, start: OracleComponents(hour: 13, minute: 0), startDate: OracleDate(2012, 8, 10, 13), end: OracleComponents(hour: 15, minute: 0), endDate: OracleDate(2012, 8, 10, 15))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "11pm-2",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "11pm-2", index: 0, start: OracleComponents(hour: 23, minute: 0), startDate: OracleDate(2012, 8, 10, 23), end: OracleComponents(hour: 2, minute: 0), endDate: OracleDate(2012, 8, 11, 2))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8:10 - 12.32",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8:10 - 12.32", index: 0, start: OracleComponents(hour: 8, minute: 10), startDate: OracleDate(2012, 8, 10, 8, 10), end: OracleComponents(hour: 12, minute: 32), endDate: OracleDate(2012, 8, 10, 12, 32))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8:10 - 12h32",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "8:10 - 12h32", index: 0, start: OracleComponents(hour: 8, minute: 10), startDate: OracleDate(2012, 8, 10, 8, 10), end: OracleComponents(hour: 12, minute: 32), endDate: OracleDate(2012, 8, 10, 12, 32))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: " de 6:30pm à 11:00pm ",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(start: OracleComponents(hour: 18, minute: 30), startDate: OracleDate(2012, 8, 10, 18, 30), end: OracleComponents(hour: 23, minute: 0), endDate: OracleDate(2012, 8, 10, 23))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: " 2012 à 10:12:59",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "à 10:12:59", index: 6, start: OracleComponents(hour: 10, minute: 12, second: 59))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "8:62",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "25:12",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "12h12:99s",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "13.12 PM",
        reference: OracleDate(2012, 8, 10),
        expectation: .noMatch
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Quelque chose se passe le 2014-04-18 à 3h00",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2014-04-18 à 3h00", index: 26, start: OracleComponents(year: 2014, month: 4, day: 18, hour: 3, minute: 0, second: 0, millisecond: 0), startDate: OracleDate(2014, 4, 18, 3))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Quelque chose se passe le 10 Août 2012 à 10:12:59",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "10 Août 2012 à 10:12:59", index: 26, start: OracleComponents(year: 2012, month: 8, day: 10, hour: 10, minute: 12, second: 59, millisecond: 0), startDate: OracleDate(2012, 8, 10, 10, 12, 59))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Quelque chose se passe le 15juin 2016 20h",
        reference: OracleDate(2016, 7, 10),
        expectation: .match(text: "15juin 2016 20h", index: 26, start: OracleComponents(year: 2016, month: 6, day: 15, hour: 20, minute: 0, second: 0, millisecond: 0), startDate: OracleDate(2016, 6, 15, 20))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Quelque chose se passe le 2014-04-18 7:00 - 8h00 ...",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2014-04-18 7:00 - 8h00", index: 26, start: OracleComponents(year: 2014, month: 4, day: 18, hour: 7, minute: 0, second: 0, millisecond: 0), startDate: OracleDate(2014, 4, 18, 7), end: OracleComponents(year: 2014, month: 4, day: 18, hour: 8, minute: 0, second: 0, millisecond: 0), endDate: OracleDate(2014, 4, 18, 8))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Quelque chose se passe le 2014-04-18 de 7:00 à 20:00 ...",
        reference: OracleDate(2012, 8, 10),
        expectation: .match(text: "2014-04-18 de 7:00 à 20:00", index: 26, start: OracleComponents(year: 2014, month: 4, day: 18, hour: 7, minute: 0, second: 0, millisecond: 0), startDate: OracleDate(2014, 4, 18, 7), end: OracleComponents(year: 2014, month: 4, day: 18, hour: 20, minute: 0, second: 0, millisecond: 0), endDate: OracleDate(2014, 4, 18, 20))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Vendredi à 2 pm",
        reference: OracleDate(2016, 4, 28),
        expectation: .match(text: "Vendredi à 2 pm")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "vendredi 2 pm EST",
        reference: OracleDate(2016, 4, 28),
        expectation: .match(text: "vendredi 2 pm EST", start: OracleComponents(timezoneOffset: -300))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "vendredi 15h CET",
        reference: OracleDate(2016, 2, 28),
        expectation: .match(text: "vendredi 15h CET", start: OracleComponents(timezoneOffset: 60))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "vendredi 15h cest",
        reference: OracleDate(2016, 2, 28),
        expectation: .match(text: "vendredi 15h cest", start: OracleComponents(timezoneOffset: 120))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Vendredi à 2 pm est",
        reference: OracleDate(2016, 4, 28),
        expectation: .match(text: "Vendredi à 2 pm est", start: OracleComponents(timezoneOffset: -300))
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Vendredi à 2 pm j'ai rdv...",
        reference: OracleDate(2016, 4, 28),
        expectation: .match(text: "Vendredi à 2 pm")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Vendredi à 2 pm je vais faire quelque chose",
        reference: OracleDate(2016, 4, 28),
        expectation: .match(text: "Vendredi à 2 pm")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "lundi 29/4/2013 630-930am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "lundi 29/4/2013 630-930am")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "mercredi 1/5/2013 1115am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "mercredi 1/5/2013 1115am")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "vendredi 3/5/2013 1230pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "vendredi 3/5/2013 1230pm")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "dimanche 6/5/2013  750am-910am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "dimanche 6/5/2013  750am-910am")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "lundi 13/5/2013 630-930am",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "lundi 13/5/2013 630-930am")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Vendredi 21/6/2013 2:30",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Vendredi 21/6/2013 2:30")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "mardi 7/2/2013 1-230 pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "mardi 7/2/2013 1-230 pm")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "mardi 7/2/2013 1-23h0",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "mardi 7/2/2013 1-23h0")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "mardi 7/2/2013 1h-23h0m",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "mardi 7/2/2013 1h-23h0m")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Lundi, 24/6/2013, 7:00pm - 8:30pm",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Lundi, 24/6/2013, 7:00pm - 8:30pm")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Jeudi6/5/2013 de 7h à 10h",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Jeudi6/5/2013 de 7h à 10h")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "18h",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "18h")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "18-22h",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "18-22h")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "11h-13",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "11h-13")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "à 12h",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "à 12h")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "Mercredi, 3 juil 2013 14h",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .match(text: "Mercredi, 3 juil 2013 14h")
    ),
    OracleCase(
        sourceFile: "fr_time_exp.test.ts",
        input: "that I need to know or am I covered?",
        reference: OracleDate(2012, 8, 10, 12),
        expectation: .noMatch
    ),
]
