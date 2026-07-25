// PreparedLocale.swift - a locale paired with the patterns compiled from it.
//
// A parser's pattern is a pure function of exactly three things: the parser
// TYPE, the locale, and the parse Options. Never the input text, never the
// reference instant. The Parser protocol already states the first half of that
// ("generic parsers are stateless: they read all configuration from
// context.locale, so a single shared instance serves every locale"), and
// Options reaches a pattern through one door only, RelativeUnitParser's
// strict-mode unit table.
//
// So a compiled pattern can be built once and handed to every later parse with
// the same key. That is the whole of this type. Before it existed, every call
// to parse rebuilt and recompiled all of them: 3.9 ms of a 5.0 ms English
// parse, of which 3.4 ms was ICU compiling alternations up to 8,874 characters
// long.
//
// It is a CLASS because it caches, and because a locale is a struct with no
// identity for an external table to key on. Owning the locale and its patterns
// together is what makes the identity question disappear - two locales that
// report the same LocaleID cannot collide here, which a table keyed by
// LocaleID would get wrong (the test suite's MockLocale declares .english).

import Foundation

final class PreparedLocale: @unchecked Sendable {
    let locale: KhacLocale

    /// Everything a pattern depends on. The parser is identified by TYPE, which
    /// is sound because parsers hold no instance state.
    ///
    /// Options are part of the key for EVERY parser, though only one parser
    /// reads them. Asking each parser to declare whether its pattern is
    /// options-sensitive would shrink the table by at most a factor of four and
    /// would put a correctness burden on every future parser author, to save
    /// entries in a table bounded at parsers x locales x 4.
    private struct Key: Hashable {
        let parserType: ObjectIdentifier
        let mode: Options.Mode
        let forwardDate: Bool
    }

    private var compiled: [Key: NSRegularExpression] = [:]
    private let lock = NSLock()

    /// Patterns actually compiled and stored. The invariant this type exists for
    /// is that this stops growing once a key is warm, which is what
    /// PatternCacheTests asserts - a timing assertion would only measure the
    /// machine it ran on.
    private(set) var compileCount = 0

    init(_ locale: KhacLocale) {
        self.locale = locale
    }

    /// The parser's pattern for this context's options, compiled on first use.
    func regex(for parser: Parser, context: ParsingContext) -> NSRegularExpression {
        let key = Key(
            parserType: ObjectIdentifier(type(of: parser)),
            mode: context.options.mode,
            forwardDate: context.options.forwardDate
        )

        lock.lock()
        let hit = compiled[key]
        lock.unlock()
        if let hit { return hit }

        // Built OUTSIDE the lock. pattern() calls into locale code a consumer
        // supplied, and holding a lock across a call out of this type is how
        // deadlocks are made. Two threads racing the same cold key both build,
        // and the loser's copy is dropped below: wasted once, never wrong,
        // because the value is a pure function of the key.
        let built = parser.pattern(context)

        lock.lock()
        defer { lock.unlock() }
        if let raced = compiled[key] { return raced }
        compiled[key] = built
        compileCount += 1
        return built
    }
}
