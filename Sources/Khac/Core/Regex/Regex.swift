// Regex.swift - NSRegularExpression helpers and the TextMatch wrapper.
//
// NSRegularExpression (ICU) is chosen over Swift Regex for JS-semantic parity:
// named capture groups, lookahead, and Unicode property support that mirror the
// patterns chrono relies on. Group VALUES are read from the normalized text;
// the reported index and matched text come from the ORIGINAL text via the map.

import Foundation

/// One regex match. Group access returns substrings of the NORMALIZED text (for
/// parsing values). `index` and `originalText` report positions in the ORIGINAL
/// text so consumers can highlight the user's actual input.
public struct TextMatch {
    let result: NSTextCheckingResult
    let normalizedNS: NSString
    let normalization: NormalizedText

    /// The whole match's range in the normalized text (UTF-16).
    public var range: NSRange { result.range }

    /// The whole matched substring, from the normalized text.
    public var text: String { normalizedNS.substring(with: result.range) }

    /// The substring of a numbered capture group, or nil if it did not match.
    public func string(at group: Int) -> String? {
        guard group < result.numberOfRanges else { return nil }
        let r = result.range(at: group)
        guard r.location != NSNotFound else { return nil }
        return normalizedNS.substring(with: r)
    }

    /// The substring of a named capture group, or nil if it did not match.
    public func string(named name: String) -> String? {
        let r = result.range(withName: name)
        guard r.location != NSNotFound else { return nil }
        return normalizedNS.substring(with: r)
    }

    /// Integer value of a numbered group, or nil.
    public func int(at group: Int) -> Int? { string(at: group).flatMap { Int($0) } }

    /// Integer value of a named group, or nil.
    public func int(named name: String) -> Int? { string(named: name).flatMap { Int($0) } }

    /// True when a numbered group participated in the match.
    public func hasGroup(_ group: Int) -> Bool {
        guard group < result.numberOfRanges else { return false }
        return result.range(at: group).location != NSNotFound
    }

    /// True when a named group participated in the match.
    public func hasGroup(named name: String) -> Bool {
        result.range(withName: name).location != NSNotFound
    }

    /// Start offset of the match in the ORIGINAL text, UTF-16 units.
    public var index: Int {
        normalization.originalUTF16Offset(forNormalizedUTF16: range.location)
    }

    /// The matched substring taken from the ORIGINAL text.
    public var originalText: String {
        let start = range.location
        let end = range.location + range.length
        return normalization.originalSubstring(forNormalizedUTF16: start..<end)
    }
}

/// Compile a case-insensitive NSRegularExpression, trapping only on a
/// programmer-authored bad pattern (locale patterns are validated in review).
func makeRegex(_ pattern: String, options: NSRegularExpression.Options = [.caseInsensitive]) -> NSRegularExpression {
    do {
        return try NSRegularExpression(pattern: pattern, options: options)
    } catch {
        fatalError("Invalid regex pattern: \(pattern) - \(error)")
    }
}

/// A regex that never matches, for parser stubs and empty configurations.
func neverMatchingRegex() -> NSRegularExpression {
    makeRegex("(?!)")
}

/// Escape a literal word for safe inclusion in a regex alternation.
func regexEscape(_ literal: String) -> String {
    NSRegularExpression.escapedPattern(for: literal)
}

/// Build a non-capturing alternation from words, escaped and longest-first so
/// multi-word entries win over their prefixes. Returns nil for an empty list.
func regexAlternation(_ words: [String]) -> String? {
    guard !words.isEmpty else { return nil }
    let sorted = words.sorted { $0.count > $1.count }
    let escaped = sorted.map(regexEscape)
    return "(?:" + escaped.joined(separator: "|") + ")"
}
