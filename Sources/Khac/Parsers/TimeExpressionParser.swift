// TimeExpressionParser.swift - clock times and time ranges.
//
// "11 AM", "20:32:13", "3 giờ", "at 5pm", "1pm-3", "8 - 11pm", "10-11 at night".
//
// Reimplements chrono's AbstractTimeExpressionParser in idiomatic Swift,
// parameterized by the locale's meridiem words and time prefixes. The
// false-positive filters (a lone digit, a bare 3-4 digit number, a trailing
// "1a") mirror chrono so plain numbers are not mistaken for times.
//
// RANGES LIVE HERE, not in a refiner, and that is forced by the grammar rather
// than chosen. The bare end of a range never parses as a time on its own - the
// "3" in "1pm-3" is just a number - so no refiner can ever see a second result
// to merge. Worse, the end's meridiem propagates BACKWARDS: in "8 - 11pm" the
// explicit 11pm rewrites the start from 8 to 20. A merge refiner that only adds
// implied fields to one side cannot express that.

import Foundation

struct TimeExpressionParser: Parser {
    static let overlapRank = 60

    /// One side of a time expression, before range resolution.
    private struct TimeParts {
        var hour: Int
        var minute: Int
        var second: Int?
        var millisecond: Int?
        var meridiem: Meridiem?
        /// True when the text stated am/pm (or an hour-of-day word) for THIS side.
        var meridiemIsCertain: Bool
        /// True when the text stated a minute rather than defaulting to zero.
        var minuteWasStated: Bool
    }

    func pattern(_ context: ParsingContext) -> NSRegularExpression {
        let prefix = regexAlternation(context.locale.patterns.timePrefixWords)
        let prefixGroup = prefix.map { "(?:" + $0 + "\\s*)?" } ?? ""

        // A range connector: the locale's words, or a plain hyphen/dash.
        let connectorWords = regexAlternation(context.locale.patterns.rangeConnectorWords)
            .map { $0 + "|" } ?? ""
        let rangeConnector = "\\s{0,3}(?:" + connectorWords + "\\-|\\u2013)\\s{0,3}"

        return makeRegex(
            "(?<![\\p{L}\\p{N}])" +
            prefixGroup +
            side(context, "") +
            "(?:" + rangeConnector + side(context, "2") + ")?" +
            "(?!/)(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    /// One side of the expression, with every capture group suffixed so the two
    /// sides can coexist in one pattern.
    private func side(_ context: ParsingContext, _ s: String) -> String {
        let vocab = context.locale.vocabulary

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
        var connectorGroup = ""
        if !connectors.isEmpty {
            let alt = connectors.sorted { $0.count > $1.count }
                .map { regexEscape($0).replacingOccurrences(of: " ", with: "\\s+") }
                .joined(separator: "|")
            connectorGroup = "(?:(?:" + alt + ")\\s+)?"
        }

        // Minute/second body: numeric separators ("5:30", "20:32:13.487") OR the
        // locale's clock words ("7 giờ 30 phút 15 giây", "7 o'clock").
        let numericBody = "[.:](?<mi\(s)>[0-9]{1,2})(?::(?<s\(s)>[0-9]{2})(?:\\.(?<ms\(s)>[0-9]{1,6}))?)?"
        var timeBody = "(?:" + numericBody + ")?"
        if let clockHour = regexAlternation(context.locale.patterns.clockHourWords) {
            let minuteMarker = regexAlternation(context.locale.patterns.clockMinuteWords)
                .map { "(?:\\s*" + $0 + ")?" } ?? ""
            let secondPart = regexAlternation(context.locale.patterns.clockSecondWords)
                .map { "(?:\\s*(?<cs\(s)>[0-9]{1,2})\\s*" + $0 + ")?" } ?? ""
            let clockBody = "\\s*(?<hw\(s)>" + clockHour + ")"
                + "(?:\\s*(?<cmi\(s)>[0-9]{1,2})" + minuteMarker + secondPart + ")?"
            timeBody = "(?:" + numericBody + "|" + clockBody + ")?"
        }

        return "(?<h\(s)>[0-9]{1,4})" + timeBody
            + "(?:\\s*" + connectorGroup + "(?<tod\(s)>" + todAlt + "))?"
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let strict = context.options.mode == .strict
        guard var start = parseSide(context, match, "", strict: strict) else { return nil }
        guard passesLoneNumberFilters(match.text, strict: strict) else { return nil }

        // A match beginning immediately after a decimal point is only a time if
        // it states a minute. "05/31/2024.14:15" really does carry the time
        // 14:15, but in "10.1 - 10.12" the engine can resume inside "10.1" and
        // read the trailing "1" as an hour, inventing a range out of two version
        // numbers. Requiring a stated minute separates the two without
        // forbidding a time after a dot outright.
        if !start.minuteWasStated, match.range.location > 0 {
            let preceding = (context.text as NSString)
                .substring(with: NSRange(location: match.range.location - 1, length: 1))
            if preceding == "." { return nil }
        }

        // No following side: a single time.
        guard var end = parseSide(context, match, "2", strict: strict) else {
            return .components(components(context, start))
        }

        resolveRange(&start, &end)

        var startComponents = components(context, start)
        var endComponents = components(context, end)

        // Day rollover: if the end lands before the start, it is the next day.
        // A plain resolved-value comparison, not a special-cased rule, and it
        // must happen BEFORE any interval is built - a backwards DateInterval
        // traps rather than merely being wrong (SPEC 3a-H5).
        if endComponents.date() < startComponents.date() {
            let calendar = context.reference.calendar
            if let rolled = calendar.date(byAdding: .day, value: 1, to: endComponents.date()) {
                endComponents.imply(.day, calendar.component(.day, from: rolled))
                endComponents.imply(.month, calendar.component(.month, from: rolled))
                endComponents.imply(.year, calendar.component(.year, from: rolled))
            }
        }
        _ = startComponents

        return .result(context.createResult(match: match, start: startComponents, end: endComponents))
    }

    /// chrono's ordered meridiem propagation between the two sides of a range.
    private func resolveRange(_ start: inout TimeParts, _ end: inout TimeParts) {
        if end.meridiemIsCertain {
            // The end stated its own am/pm. It can reach BACK and fix a start
            // that did not: "8 - 11pm" makes the start 20:00, using the START's
            // own hour plus 12, not the end's.
            guard !start.meridiemIsCertain else { return }
            if end.meridiem == .am {
                start.meridiem = .am
                if start.hour == 12 { start.hour = 0 }
            } else {
                start.meridiem = .pm
                if start.hour != 12 { start.hour += 12 }
            }
            return
        }

        // The end is a bare number. Whether it inherits pm depends on whether it
        // could plausibly be later in the same afternoon.
        if start.meridiemIsCertain && start.hour > 12 {
            if start.hour - 12 > end.hour {
                // "11pm-3": 11 > 3, so the end is early MORNING and rolls over.
                end.meridiem = .am
            } else if end.hour <= 12 {
                // "1pm-3": 1 is not > 3, so the end is the same afternoon.
                end.hour += 12
                end.meridiem = .pm
                end.meridiemIsCertain = true
            }
        } else if end.hour > 12 {
            end.meridiem = .pm
        } else {
            end.meridiem = .am
        }
    }

    /// Read one side's groups. Returns nil when that side is absent or invalid.
    private func parseSide(
        _ context: ParsingContext,
        _ match: TextMatch,
        _ s: String,
        strict: Bool
    ) -> TimeParts? {
        let vocab = context.locale.vocabulary
        let meridiemTable = WordTable(vocab.meridiem)
        let timeOfDayTable = WordTable(vocab.timeOfDay)

        guard let hourText = match.string(named: "h\(s)"), var hour = Int(hourText) else { return nil }
        let numericMinute = match.string(named: "mi\(s)")
        let clockMinute = match.string(named: "cmi\(s)")
        let minuteText = numericMinute ?? clockMinute
        let todText = match.string(named: "tod\(s)")
        var minute = 0
        var minuteWasStated = minuteText != nil
        var meridiem: Meridiem? = nil
        var meridiemIsCertain = false

        // Hours: a 3-4 digit block can be HHMM.
        if hour > 100 {
            if hourText.count == 4 && minuteText == nil && todText == nil { return nil } // a year
            if strict || minuteText != nil { return nil }
            minute = hour % 100
            hour = hour / 100
            minuteWasStated = true
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
        if strict && match.string(named: "hw\(s)") != nil && clockMinute == nil { return nil }

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
                meridiemIsCertain = true
            } else if let m = meridiemTable.value(for: todText) {
                if hour > 12 { return nil }
                (hour, meridiem) = Self.applyMeridiem(m, to: hour)
                meridiemIsCertain = true
            } else if let tod = timeOfDayTable.value(for: todText), let m = tod.meridiem {
                if hour > 12 { return nil }
                (hour, meridiem) = Self.applyMeridiem(m, to: hour)
                meridiemIsCertain = true
            }
            // A named time of day with no meridiem ("noon" = (12, nil)) leaves the
            // stated hour unchanged.
        }

        var second: Int? = nil
        if let sText = match.string(named: "s\(s)") ?? match.string(named: "cs\(s)"), let value = Int(sText) {
            if value >= 60 { return nil }
            second = value
        }
        var millisecond: Int? = nil
        if let msText = match.string(named: "ms\(s)") {
            let value = Int(msText.prefix(3)) ?? 0
            if value >= 1000 { return nil }
            millisecond = value
        }

        return TimeParts(
            hour: hour, minute: minute, second: second, millisecond: millisecond,
            meridiem: meridiem, meridiemIsCertain: meridiemIsCertain,
            minuteWasStated: minuteWasStated
        )
    }

    private func components(_ context: ParsingContext, _ parts: TimeParts) -> ParsingComponents {
        var comps = context.createParsingComponents()
        comps.certain(.hour, parts.hour)
        // Only a STATED minute is certain. Marking the default 0 certain inflated
        // this parser's certain-count on every bare-hour match, and certain-count
        // is the first key in the overlap order (SPEC 3a-H0), so a bare hour
        // could beat a longer, genuinely more specific match from another parser.
        if parts.minuteWasStated {
            comps.certain(.minute, parts.minute)
        } else {
            comps.imply(.minute, parts.minute)
        }
        if let meridiem = parts.meridiem {
            if parts.meridiemIsCertain {
                comps.certain(.meridiem, meridiem.rawValue)
            } else {
                comps.imply(.meridiem, meridiem.rawValue)
            }
        } else {
            comps.imply(.meridiem, parts.hour < 12 ? Meridiem.am.rawValue : Meridiem.pm.rawValue)
        }
        if let second = parts.second { comps.certain(.second, second) }
        if let millisecond = parts.millisecond { comps.certain(.millisecond, millisecond) }
        return comps
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
    /// really plain numbers rather than times. The trailing-number clause also
    /// carries the range guards - a decimal end ("10 - 10.1") or a bare-to-bare
    /// range in strict mode voids the WHOLE match, both sides, not just the end.
    private func passesLoneNumberFilters(_ text: String, strict: Bool) -> Bool {
        // A single bare digit is never a time. A bare TWO-digit number is
        // accepted here, exactly as chrono does: it must survive so "-5d 00"
        // can merge its "00" onto the date. Whatever bare number does NOT merge
        // into a larger expression is dropped later by UnlikelyFilterRefiner's
        // digits-only rule - parser and filter are a matched pair.
        if range(text, "^[0-9]$") { return false }
        if range(text, "^[0-9][0-9][0-9]+$") { return false }  // "203", "2014"
        if range(text, "^[0-9]+\\.[0-9]+$") { return false }   // bare "12.53", "35.49" is a decimal, not a time
        if range(text, "[0-9][apAP]$") { return false }        // "1a", "123p"
        if range(text, "^[0-9]+\\-[0-9]+$") { return false }   // "1-2" with no spaces is not a range

        // A trailing bare-number RANGE has to be valid on BOTH sides, and an
        // invalid side voids the whole match rather than just trimming the range.
        // "10.1 - 10.12" is two version numbers, not a time range, and it is the
        // START that gives it away - a single digit after the dot.
        if let sides = twoGroups(text, "[^0-9:.]([0-9][0-9.]*)\\s{0,3}[-\\u2013]\\s{0,3}([0-9][0-9.]*)$") {
            if strict { return false }
            for side in [sides.0, sides.1] {
                if side.contains("."), !range(side, "^[0-9]{1,2}(\\.[0-9]{2})+$") { return false }
                let whole = side.split(separator: ".").first.map(String.init) ?? side
                if let value = Int(whole), value > 24 { return false }
            }
        }

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

    private func twoGroups(_ text: String, _ pattern: String) -> (String, String)? {
        let ns = text as NSString
        let re = makeRegex(pattern, options: [])
        guard let m = re.firstMatch(in: text, range: NSRange(location: 0, length: ns.length)),
              m.numberOfRanges > 2,
              m.range(at: 1).location != NSNotFound,
              m.range(at: 2).location != NSNotFound else { return nil }
        return (ns.substring(with: m.range(at: 1)), ns.substring(with: m.range(at: 2)))
    }

    private func firstGroup(_ text: String, _ pattern: String) -> String? {
        let ns = text as NSString
        let re = makeRegex(pattern, options: [])
        guard let m = re.firstMatch(in: text, range: NSRange(location: 0, length: ns.length)),
              m.numberOfRanges > 1, m.range(at: 1).location != NSNotFound else { return nil }
        return ns.substring(with: m.range(at: 1))
    }
}
