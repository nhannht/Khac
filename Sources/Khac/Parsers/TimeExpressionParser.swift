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
        let meridiem = WordTable(context.locale.vocabulary.meridiem).alternation
        let prefix = regexAlternation(context.locale.patterns.timePrefixWords)
        let prefixGroup = prefix.map { "(?:" + $0 + "\\s*)?" } ?? ""

        return makeRegex(
            "(?<![\\p{L}\\p{N}])" +
            prefixGroup +
            "(?<h>[0-9]{1,4})" +
            "(?:[.:](?<mi>[0-9]{1,2})(?::(?<s>[0-9]{2})(?:\\.(?<ms>[0-9]{1,6}))?)?)?" +
            "(?:\\s*(?<ap>" + meridiem + "))?" +
            "(?!/)(?=[^\\p{L}\\p{N}_]|$)"
        )
    }

    func extract(_ context: ParsingContext, _ match: TextMatch) -> ParserResult? {
        let meridiemTable = WordTable(context.locale.vocabulary.meridiem)
        let strict = context.options.mode == .strict

        guard let hourText = match.string(named: "h"), var hour = Int(hourText) else { return nil }
        let minuteText = match.string(named: "mi")
        let ampmText = match.string(named: "ap")
        var minute = 0
        var meridiem: Meridiem? = nil

        // Hours: a 3-4 digit block can be HHMM.
        if hour > 100 {
            if hourText.count == 4 && minuteText == nil && ampmText == nil { return nil } // a year
            if strict || minuteText != nil { return nil }
            minute = hour % 100
            hour = hour / 100
        }
        if hour > 24 { return nil }

        // Minutes.
        if let minuteText = minuteText {
            if minuteText.count == 1 && ampmText == nil { return nil } // "1.1" is not a time
            minute = Int(minuteText) ?? 0
        }
        if minute >= 60 { return nil }

        if hour > 12 { meridiem = .pm }

        // Meridiem word (am/pm or a locale phrase like "in the afternoon").
        if let ampmText = ampmText, let m = meridiemTable.value(for: ampmText) {
            if hour > 12 { return nil }
            if m == .am {
                meridiem = .am
                if hour == 12 { hour = 0 }
            } else {
                meridiem = .pm
                if hour != 12 { hour += 12 }
            }
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
        if let sText = match.string(named: "s"), let second = Int(sText) {
            if second >= 60 { return nil }
            comps.certain(.second, second)
        }

        guard passesLoneNumberFilters(match.text, strict: strict) else { return nil }
        return .components(comps)
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
