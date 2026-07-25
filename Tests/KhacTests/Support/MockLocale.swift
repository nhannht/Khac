// MockLocale.swift - a minimal locale for exercising the generic engine.
//
// Lives in the TEST target only. It carries just enough vocabulary to drive the
// generic parsers end to end without pulling a real locale into Sources. This is
// how the engine proves itself independently of the EN/VI executors.

import Foundation
@testable import Khac

struct MockLocale: KhacLocale {
    var id: LocaleID = .english

    var vocabulary: Vocabulary = Vocabulary(
        weekdays: [
            "sunday": 0, "monday": 1, "tuesday": 2, "wednesday": 3,
            "thursday": 4, "friday": 5, "saturday": 6,
        ],
        months: [
            "january": 1, "february": 2, "march": 3, "april": 4,
            "may": 5, "june": 6, "july": 7, "august": 8,
            "september": 9, "october": 10, "november": 11, "december": 12,
        ],
        integerWords: ["one": 1, "two": 2, "three": 3, "four": 4, "five": 5],
        ordinals: ["first": 1, "second": 2, "third": 3],
        timeUnits: [
            "day": .day, "days": .day, "week": .weekOfYear, "weeks": .weekOfYear,
            "month": .month, "months": .month, "year": .year, "years": .year,
        ],
        relativeModifiers: ["this": 0, "next": 1, "last": -1, "past": -1],
        dayReferences: ["today": 0, "tomorrow": 1, "yesterday": -1],
        meridiem: ["am": .am, "pm": .pm],
        timeOfDay: [
            "morning": (6, .am), "afternoon": (15, .pm), "evening": (20, .pm),
            "night": (22, .pm), "tonight": (22, .pm),
            "noon": (12, nil), "midnight": (0, nil),
        ],
        eraMarkers: ["bc": -1, "ad": 1]
    )

    var patterns: PatternSet = PatternSet(
        timePrefixWords: ["at"],
        dateConnectorWords: ["of"],
        clockHourWords: ["o'clock"],
        relativePastWords: ["ago"],
        relativeFutureWords: ["in"],
        rangeConnectorWords: ["to", "until"],
        nowWords: ["now"]
    )

    var options: LocaleOptions = LocaleOptions(dateOrder: .monthDay, weekStart: 1)
}
