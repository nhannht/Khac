// RelativeDuration.swift - a parsed duration and the arithmetic that applies it.
//
// A relative expression is a DURATION applied to an ANCHOR. The anchor is
// usually implicit (the reference), but "2 days after tomorrow" anchors the
// same duration on a neighbouring result instead. Keeping the duration as a
// value - rather than resolving straight to a Date at parse time - is what lets
// one expression be re-anchored later without re-running any regex.
//
// A duration is an ORDERED clause list, largest unit first: "1 day 21 hours" is
// [(.day, 1), (.hour, 21)], not 45 hours. That distinction is load-bearing:
// adding 2 months is not adding a fixed number of days, so a duration can never
// be flattened to a single component without losing meaning.

import Foundation

/// Which way a relative duration moves from its anchor.
enum RelativeDirection {
    case past
    case future

    /// The multiplier this direction applies to every clause count.
    var sign: Int {
        switch self {
        case .past: return -1
        case .future: return 1
        }
    }
}

/// One clause of a duration, before fractions are resolved. `amount` is
/// fractional so a quantifier like "half" survives parsing intact; whole
/// clauses are produced by `RelativeDuration.init`.
struct DurationClause {
    var component: Calendar.Component
    var amount: Double

    init(_ component: Calendar.Component, _ amount: Double) {
        self.component = component
        self.amount = amount
    }
}

struct RelativeDuration {
    /// Whole-number clauses, largest unit first, after fraction cascading.
    let clauses: [(component: Calendar.Component, count: Int)]
    let direction: RelativeDirection

    /// True when nothing survived normalization (e.g. a fraction too small to
    /// express). Callers reject these rather than emitting a zero-shift result.
    var isEmpty: Bool { clauses.isEmpty }

    /// True when any clause names a clock unit. A time-bearing duration moves
    /// the anchor's clock, not just its calendar date ("now + 40minutes").
    var hasTimeClause: Bool {
        clauses.contains { [.hour, .minute, .second, .nanosecond].contains($0.component) }
    }

    /// Build from fractional clauses, cascading each clause's remainder into the
    /// next smaller unit (see `cascade`). Clauses naming the same component are
    /// summed, so "1 hour 30 min" and "1.5 hours" normalize identically.
    init(_ raw: [DurationClause], direction: RelativeDirection) {
        var totals: [Calendar.Component: Double] = [:]
        for clause in raw {
            totals[clause.component, default: 0] += clause.amount
        }

        var resolved: [Calendar.Component: Int] = [:]
        for component in Self.cascadeOrder {
            guard let total = totals[component], total != 0 else { continue }
            let whole = total < 0 ? total.rounded(.up) : total.rounded(.down)
            let fraction = total - whole
            if whole != 0 {
                resolved[component, default: 0] += Int(whole)
            }
            // Push the remainder down to the next unit that can express it.
            if fraction != 0, let (next, factor) = Self.cascade[component] {
                totals[next, default: 0] += fraction * factor
            }
        }

        self.clauses = Self.cascadeOrder.compactMap { component in
            guard let count = resolved[component], count != 0 else { return nil }
            return (component, count)
        }
        self.direction = direction
    }

    /// Apply this duration to an anchor instant. Returns nil when the calendar
    /// cannot represent the result.
    func apply(to anchor: Date, calendar: Calendar) -> Date? {
        var result = anchor
        for clause in clauses {
            let shift = Self.shiftable(clause.component, clause.count * direction.sign)
            guard let shifted = calendar.date(
                byAdding: shift.component,
                value: shift.value,
                to: result
            ) else { return nil }
            result = shifted
        }
        return result
    }

    /// Foundation's Calendar does not shift by `.quarter` - adding one leaves the
    /// date untouched - so express a quarter as three months. Everything else
    /// passes through unchanged.
    static func shiftable(_ component: Calendar.Component, _ value: Int) -> (component: Calendar.Component, value: Int) {
        component == .quarter ? (.month, value * 3) : (component, value)
    }

    // MARK: Fraction cascading

    /// Where a fractional remainder goes, and by what factor. Reproduces
    /// chrono's own cascade (src/calculation/duration.ts) so fractional
    /// quantifiers behave identically: "half an hour" is 30 minutes, not a
    /// floored zero hours.
    ///
    /// Two deliberate notes.
    ///
    /// The month-to-week factor of 4 is chrono's approximation, not a true
    /// month length. It is kept for behavioral parity. No oracle case exercises
    /// a fractional month, so this is parity by construction, not a tested
    /// claim - the only fraction any current case uses is "half an hour".
    ///
    /// `.quarter` has NO cascade in chrono at all: it floors and silently drops
    /// the remainder. That reads as an accidental gap rather than a decision,
    /// so Khac cascades it consistently into months. Also untested by any case.
    private static let cascade: [Calendar.Component: (Calendar.Component, Double)] = [
        .year: (.month, 12),
        .quarter: (.month, 3),
        .month: (.weekOfYear, 4),
        .weekOfYear: (.day, 7),
        .day: (.hour, 24),
        .hour: (.minute, 60),
        .minute: (.second, 60),
        .second: (.nanosecond, 1_000_000_000),
    ]

    /// Largest unit to smallest. Both the cascade walk and the emitted clause
    /// order follow this, so a duration always applies its coarse shifts first
    /// (adding a month then an hour is not the same as the reverse near a
    /// month boundary).
    static let cascadeOrder: [Calendar.Component] = [
        .year, .quarter, .month, .weekOfYear, .day, .hour, .minute, .second, .nanosecond,
    ]
}

// MARK: - Reading a duration out of text

/// Builds the regex fragment for a duration expression and reads the clauses
/// back out of the matched text.
///
/// Deliberately split this way. The parser needs a fragment it can splice into a
/// larger pattern with direction words around it, and a re-anchoring refiner
/// needs to recover the same duration from an already-produced result's text
/// without re-running any parser. One function answers both, so there is exactly
/// one definition of what a duration is - and it is driven entirely by locale
/// DATA, so it serves Vietnamese as readily as English.
enum DurationExpression {
    /// Regex fragment matching one whole duration ("15 hours 29 min",
    /// "a few days", "about ~5 hours"). Contains no capture groups, so it can be
    /// spliced anywhere without disturbing the caller's group names.
    ///
    /// `abbreviations` is false for the modifier-word form. chrono refuses
    /// shorthand there even in casual mode - "last 2m" is not a date - while the
    /// signed form still accepts it ("-3y", "+15min").
    static func fragment(_ context: ParsingContext, abbreviations: Bool = true) -> String {
        let clause = clausePattern(context, abbreviations: abbreviations)
        // Clauses join with whitespace, an optional comma, and an optional
        // connector word: "1d 2hr 5min", "in 1d, 2hr, and 5min".
        let connector = regexAlternation(context.locale.patterns.durationConnectorWords)
            .map { "(?:" + $0 + "\\s{0,3})?" } ?? ""
        let separator = "\\s{0,3},?\\s{0,3}" + connector
        return "(?:" + clause + "(?:" + separator + clause + "){0,4})"
    }

    /// Recover a whole relative expression - duration AND direction - from text
    /// that has already been matched, such as a produced result's own text.
    ///
    /// This is what lets a refiner re-anchor "2 days after tomorrow" without
    /// re-running any parser. Direction comes from the locale's own direction
    /// words, never from hardcoded literals: chrono's equivalent refiners regex
    /// English words ("before", "after", a leading sign) out of the output text,
    /// which cannot serve Vietnamese and would betray the data-driven contract
    /// this engine exists to keep.
    static func relative(in text: String, _ context: ParsingContext) -> RelativeDuration? {
        let patterns = context.locale.patterns
        let trimmed = text.trimmingCharacters(in: .whitespaces)

        func ends(with words: [String]) -> Bool {
            guard let alt = regexAlternation(words) else { return false }
            return matches(trimmed, "\\s" + alt + "$")
        }
        func begins(with words: [String]) -> Bool {
            guard let alt = regexAlternation(words) else { return false }
            return matches(trimmed, "^" + alt + "(?![\\p{L}\\p{N}_])")
        }

        let direction: RelativeDirection
        if matches(trimmed, "^-") {
            direction = .past
        } else if matches(trimmed, "^\\+") {
            direction = .future
        } else if ends(with: patterns.relativePastWords) {
            direction = .past
        } else if ends(with: patterns.futureSuffixWords) || begins(with: patterns.relativeFutureWords) {
            direction = .future
        } else {
            return nil
        }

        let parsed = clauses(in: trimmed, context)
        guard !parsed.isEmpty else { return nil }
        let duration = RelativeDuration(parsed, direction: direction)
        return duration.isEmpty ? nil : duration
    }

    private static func matches(_ text: String, _ pattern: String) -> Bool {
        let ns = text as NSString
        return makeRegex(pattern).firstMatch(in: text, range: NSRange(location: 0, length: ns.length)) != nil
    }

    /// Read the clauses back out of a matched duration substring. Order is
    /// preserved, and an unreadable clause is skipped rather than failing the
    /// whole duration.
    static func clauses(in text: String, _ context: ParsingContext) -> [DurationClause] {
        let vocab = context.locale.vocabulary
        let units = WordTable(vocab.timeUnits)
        let quantifiers = WordTable(vocab.casualQuantifiers)
        let integers = WordTable(vocab.integerWords)

        let regex = makeRegex(capturingClausePattern(context))
        let ns = text as NSString
        let matches = regex.matches(in: text, range: NSRange(location: 0, length: ns.length))

        return matches.compactMap { raw in
            let match = TextMatch(result: raw, normalizedNS: ns, normalization: NormalizedText(original: text))
            guard let unitText = match.string(named: "dunit") ?? match.string(named: "dunitw")
                    ?? match.string(named: "dunite"),
                  let component = units.value(for: unitText)
            else { return nil }

            // No count group at all is the ELIDED form, and it means one. Only a
            // locale that opted in can produce this alternative, so an absent count
            // here is never an English bare unit word slipping through.
            guard let countText = match.string(named: "dcount") ?? match.string(named: "dcountw") else {
                return DurationClause(component, 1)
            }

            let amount: Double
            if let digits = Double(countText) {
                amount = digits
            } else if let vague = quantifiers.value(for: countText) {
                amount = vague
            } else if let word = integers.value(for: countText) {
                amount = Double(word)
            } else {
                return nil
            }
            return DurationClause(component, amount)
        }
    }

    /// One clause, no capture groups.
    private static func clausePattern(_ context: ParsingContext, abbreviations: Bool) -> String {
        let p = clauseParts(context, abbreviations: abbreviations)
        return "(?:" + p.filler + "(?:"
            + "(?:" + p.digits + ")\\s{0,3}(?:" + p.units + ")"
            + "|(?:" + p.words + ")\\s{1,3}(?:" + p.units + ")"
            + p.elided
            + "))"
    }

    /// One clause with the count and unit captured, for reading values back.
    /// Two alternatives means two group-name pairs; `clauses` reads whichever
    /// participated.
    private static func capturingClausePattern(_ context: ParsingContext) -> String {
        let p = clauseParts(context, abbreviations: true)
        return p.filler + "(?:"
            + "(?<dcount>" + p.digits + ")\\s{0,3}(?<dunit>" + p.units + ")"
            + "|(?<dcountw>" + p.words + ")\\s{1,3}(?<dunitw>" + p.units + ")"
            + (p.elided.isEmpty ? "" : "|(?<dunite>" + p.units + ")")
            + ")"
    }

    /// A digit count may abut its unit ("5m"); a WORD count may not.
    ///
    /// That asymmetry is the whole defence against a catastrophic false positive.
    /// With "a" meaning one and "m" meaning minute, an abutting word count reads
    /// "am ago" as one minute ago, and "them ago" the same way - every English
    /// word ending in those letters becomes a duration. Requiring real whitespace
    /// after a spelled-out count costs nothing ("a few days" and "half an hour"
    /// are always spaced) and removes the entire class.
    private static func clauseParts(
        _ context: ParsingContext,
        abbreviations: Bool
    ) -> (filler: String, digits: String, words: String, units: String, elided: String) {
        let vocab = context.locale.vocabulary
        // Strict mode refuses shorthand units, matching RelativeUnitParser. The
        // modifier-word form refuses them in either mode.
        let restrict = !abbreviations || context.options.mode == .strict
        let unitTable = restrict && !vocab.fullTimeUnitNames.isEmpty
            ? vocab.timeUnits.filter { vocab.fullTimeUnitNames.contains(WordTable<Int>.fold($0.key)) }
            : vocab.timeUnits
        let units = WordTable(unitTable).alternation
        let quantifiers = WordTable(vocab.casualQuantifiers).alternation
        let integers = WordTable(vocab.integerWords).alternation
        // Approximation words carry no value and may repeat ("about ~5 hours").
        let filler = regexAlternation(context.locale.patterns.durationFillerWords)
            .map { "(?:" + $0 + "\\s{0,3}){0,2}" } ?? ""
        // A locale that ELIDES the count writes the unit alone and means one:
        // Russian "через неделю" has nothing standing where English puts "a".
        // Opt-in per locale, because a bare unit word is otherwise a duration, and
        // English "week" or "month" alone would silently become one with no oracle
        // case to catch it.
        let elided = context.locale.options.elidesDurationCount ? "|(?:" + units + ")" : ""
        return (filler, "[0-9]{1,4}(?:\\.[0-9]{1,3})?", quantifiers + "|" + integers, units, elided)
    }
}
