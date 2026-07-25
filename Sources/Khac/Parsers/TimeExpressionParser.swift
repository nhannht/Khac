// TimeExpressionParser.swift - clock times: "11 AM", "20:32:13", "3 giờ", "at 5pm".
//
// Reimplements chrono's AbstractTimeExpressionParser primary-time logic in
// idiomatic Swift, parameterized by the locale's meridiem words and time
// prefixes. The false-positive filters (a lone digit, a bare 3-4 digit number, a
// trailing "1a") mirror chrono so plain numbers are not mistaken for times.
//
// The following/range branch ("10-11am") is not yet implemented here; time
// ranges are handled at the refiner layer as that work lands.

import Foundation

struct TimeExpressionParser: Parser {
    static let overlapRank = 60

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let vocab = context.locale.vocabulary
        let prefix = regexAlternation(context.locale.patterns.timePrefixWords)
        let prefixGroup = prefix.map { "(?:" + $0 + "\\s*)?" } ?? ""

        // Trailing time-of-day token: any am/pm word, any hour-dependent word
        // (VI "trưa"/"đêm", EN "night"), or any named time of day used as a
        // suffix ("in the afternoon"). One alternation over all three tables.
        let todWords = Array(Set(
            Array(vocab.meridiem.keys)
                + Array(vocab.meridiemHourRules.keys)
                + Array(vocab.timeOfDay.keys)
        ))
        let todAlt = regexAlternation(todWords) ?? "(?!)"

        // Optional connector between the hour and the trailing word, e.g. English
        // "at" / "in the". Internal spaces match any whitespace run. Empty for a
        // locale whose time-of-day word attaches directly ("3 giờ chiều").
        let connectors = context.locale.patterns.timeOfDayConnectorWords
        let connectorGroup: String
        if connectors.isEmpty {
            connectorGroup = ""
        } else {
            let alt = connectors.sorted { $0.count > $1.count }
                .map { regexEscape($0).replacingOccurrences(of: " ", with: "\\s+") }
                .joined(separator: "|")
            connectorGroup = "(?:(?:" + alt + ")\\s+)?"
        }

        // Minute/second body: numeric separators ("5:30", "20:32:13.487") OR the
        // locale's clock words ("7 giờ 30 phút 15 giây", "7 o'clock"). The clock
        // branch only exists when the locale defines clockHourWords; the minute
        // marker is optional ("7 giờ 30"), the second marker required (to tell a
        // trailing second from an unrelated number).
        let numericBody = "[.:](?<mi>[0-9]{1,2})(?::(?<s>[0-9]{2})(?:\\.(?<ms>[0-9]{1,6}))?)?"
        var timeBody = "(?:" + numericBody + ")?"
        if let clockHour = regexAlternation(context.locale.patterns.clockHourWords) {
            let minuteMarker = regexAlternation(context.locale.patterns.clockMinuteWords)
                .map { "(?:\\s*" + $0 + ")?" } ?? ""
            let secondPart = regexAlternation(context.locale.patterns.clockSecondWords)
                .map { "(?:\\s*(?<cs>[0-9]{1,2})\\s*" + $0 + ")?" } ?? ""
            let clockBody = "\\s*(?<hw>" + clockHour + ")"
                + "(?:\\s*(?<cmi>[0-9]{1,2})" + minuteMarker + secondPart + ")?"
            timeBody = "(?:" + numericBody + "|" + clockBody + ")?"
        }

        return makeRegex(
            "(?<![\\p{L}\\p{N}])" +
            prefixGroup +
            "(?<h>[0-9]{1,4})" +
            timeBody +
            "(?:\\s*" + connectorGroup + "(?<tod>" + todAlt + "))?" +
            "(?!/)(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let vocab = context.locale.vocabulary
        let meridiemTable = WordTable(vocab.meridiem)
        let timeOfDayTable = WordTable(vocab.timeOfDay)
        let strict = context.options.mode == .strict

        guard let hourText = match.string(named: "h"), var hour = Int(hourText) else { return nil }
        let numericMinute = match.string(named: "mi")           // numeric branch ("5:30")
        let clockMinute = match.string(named: "cmi")            // clock-word branch ("7 giờ 30")
        let minuteText = numericMinute ?? clockMinute
        let todText = match.string(named: "tod")
        var minute = 0
        var meridiem: Meridiem? = nil

        // Hours: a 3-4 digit block can be HHMM.
        if hour > 100 {
            if hourText.count == 4 && minuteText == nil && todText == nil { return nil } // a year
            if strict || minuteText != nil { return nil }
            minute = hour % 100
            hour = hour / 100
        }
        if hour > 24 { return nil }

        // Minutes. The "1.1 is not a time" reject applies only to the numeric dot
        // form; a clock-word minute ("7 giờ 5 phút") is a real time.
        if let numericMinute = numericMinute {
            if numericMinute.count == 1 && todText == nil { return nil }
            minute = Int(numericMinute) ?? 0
        } else if let clockMinute = clockMinute {
            minute = Int(clockMinute) ?? 0
        }
        if minute >= 60 { return nil }

        // Strict mode wants a complete time: a bare clock hour with no minute
        // ("5 h", "7 giờ") is not enough - only "7 giờ 30 phút" and the like.
        if strict && match.string(named: "hw") != nil && clockMinute == nil { return nil }

        if hour > 12 { meridiem = .pm }

        // Trailing time-of-day token. Precedence: an hour-DEPENDENT rule (VI
        // "trưa"/"đêm", EN "night") first, then a flat am/pm from the meridiem
        // table, then a named time-of-day word's own meridiem ("in the afternoon").
        if let todText = todText {
            let folded = WordTable<Int>.fold(todText)
            if let rule = vocab.meridiemHourRules[folded] {
                if hour > 12 { return nil }
                if let override = rule.overrides[hour] {
                    hour = override
                    meridiem = hour < 12 ? .am : .pm
                } else {
                    (hour, meridiem) = Self.applyMeridiem(rule.baseline, to: hour)
                }
            } else if let m = meridiemTable.value(for: todText) {
                if hour > 12 { return nil }
                (hour, meridiem) = Self.applyMeridiem(m, to: hour)
            } else if let tod = timeOfDayTable.value(for: todText), let m = tod.meridiem {
                if hour > 12 { return nil }
                (hour, meridiem) = Self.applyMeridiem(m, to: hour)
            }
            // A named time of day with no meridiem ("noon" = (12, nil)) leaves the
            // stated hour unchanged.
        }

        var comps = context.createParsingComponents()
        comps.certain(.hour, hour)
        comps.certain(.minute, minute)
        if let meridiem = meridiem {
            comps.certain(.meridiem, meridiem.rawValue)
        } else {
            comps.imply(.meridiem, hour < 12 ? Meridiem.am.rawValue : Meridiem.pm.rawValue)
        }
        if let msText = match.string(named: "ms") {
            let ms = Int(msText.prefix(3)) ?? 0
            if ms >= 1000 { return nil }
            comps.certain(.millisecond, ms)
        }
        if let sText = match.string(named: "s") ?? match.string(named: "cs"), let second = Int(sText) {
            if second >= 60 { return nil }
            comps.certain(.second, second)
        }

        guard passesLoneNumberFilters(match.text, strict: strict) else { return nil }
        return .components(comps)
    }

    /// Apply a flat am/pm reading to a clock hour: am maps 12 -> 0 (else keeps),
    /// pm maps 12 -> 12 (else +12). Returns the 24h hour and the certain meridiem.
    private static func applyMeridiem(_ m: Meridiem, to hour: Int) -> (Int, Meridiem) {
        switch m {
        case .am: return (hour == 12 ? 0 : hour, .am)
        case .pm: return (hour == 12 ? 12 : hour + 12, .pm)
        }
    }

    /// chrono's checkAndReturnWithoutFollowingPattern: reject matches that are
    /// really plain numbers rather than times.
    private func passesLoneNumberFilters(_ text: String, strict: Bool) -> Bool {
        if range(text, "^[0-9]{1,2}$") { return false }        // bare "1" or "11" is not a time
        if range(text, "^[0-9][0-9][0-9]+$") { return false }  // "203", "2014"
        if range(text, "^[0-9]+\\.[0-9]+$") { return false }   // bare "12.53", "35.49" is a decimal, not a time
        if range(text, "[0-9][apAP]$") { return false }        // "1a", "123p"

        // Trailing bare numbers: "at 25" (>24), "at 1.2" (dot single digit).
        if let ending = firstGroup(text, "[^0-9:.]([0-9][0-9.]+)$") {
            if strict { return false }
            if ending.contains(".") && !range(ending, "[0-9](\\.[0-9]{2})+$") { return false }
            if let value = Int(ending.split(separator: ".").first.map(String.init) ?? ending), value > 24 {
                return false
            }
        }
        return true
    }

    private func range(_ text: String, _ pattern: String) -> Bool {
        let ns = text as NSString
        let re = makeRegex(pattern, options: [])
        return re.firstMatch(in: text, range: NSRange(location: 0, length: ns.length)) != nil
    }

    private func firstGroup(_ text: String, _ pattern: String) -> String? {
        let ns = text as NSString
        let re = makeRegex(pattern, options: [])
        guard let m = re.firstMatch(in: text, range: NSRange(location: 0, length: ns.length)),
              m.numberOfRanges > 1, m.range(at: 1).location != NSNotFound else { return nil }
        return ns.substring(with: m.range(at: 1))
    }
}
