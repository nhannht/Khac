// PreparedLocale.swift - a locale paired with everything derived from it.
//
// A pattern is a pure function of exactly three things: the DERIVATION being
// asked for, the locale, and the parse Options. Never the input text, never the
// reference instant. The Parser protocol already states part of that ("generic
// parsers are stateless: they read all configuration from context.locale, so a
// single shared instance serves every locale"), and Options reaches a pattern
// through one door only, RelativeUnitParser's strict-mode unit table.
//
// So a derived value can be built once and handed to every later parse with the
// same key. That is the whole of this type. Before it existed, every call to
// parse rebuilt and recompiled all of them: 3.9 ms of a 5.0 ms English parse, of
// which 3.4 ms was ICU compiling alternations up to 8,874 characters long.
//
// The key is the DERIVATION, not the parser. That distinction is load-bearing
// and was learned the second time: keying on parser type covered only values
// returned from `Parser.pattern`, so three kinds of work escaped the cache and
// recompiled on every call.
//
//   1. Refiners are not Parsers. MergeRelativeAnchorRefiner reaches
//      DurationExpression.relative, which compiled three direction regexes per
//      invocation - and a merging refiner runs over every PAIR of results.
//   2. Work done inside `extract` rather than `pattern`. The old key could only
//      ever see one value per parser, so a second regex built during extraction
//      was invisible to it.
//   3. Derived values that are not regexes at all, such as a WordTable.
//
// Measured on a 1000-case English corpus: those three together were between a
// quarter and a half of total parse time, with the refiner path alone at 20.9%.
// A cache keyed by derivation covers all three, and covers whatever comes next
// without another hole. Any component holding a ParsingContext can ask.
//
// It is a CLASS because it caches, and because a locale is a struct with no
// identity for an external table to key on. Owning the locale and its derived
// values together is what makes the identity question disappear - two locales
// that report the same LocaleID cannot collide here, which a table keyed by
// LocaleID would get wrong (the test suite's MockLocale declares .english).

import Foundation

final class PreparedLocale: @unchecked Sendable {
    let locale: KhacLocale

    /// Names one derivation over this locale. An enum rather than a string tag
    /// so the set is closed, collision-free, and readable in one place: adding a
    /// cached value means adding a case here, which is the review prompt.
    ///
    /// `parserPattern` carries the parser TYPE, which is sound because parsers
    /// hold no instance state. Third-party parsers supplied through
    /// `additionalParsers` are covered by the same case.
    enum Derivation: Hashable {
        case parserPattern(ObjectIdentifier)

        // DurationExpression, re-read by MergeRelativeAnchorRefiner on every
        // candidate pair. These were the dominant cost in the engine.
        case durationLeadingMinus
        case durationLeadingPlus
        case durationPastSuffix
        case durationFutureSuffix
        case durationFuturePrefix
        case durationCapturingClause
        case durationUnitTable
        case durationQuantifierTable
        case durationIntegerTable

        // MonthNameParser reads these back during extraction, not while
        // building its pattern, so the old parser-type key never saw them.
        case monthNameMonthTable
        case monthNameEraTable
        case monthNameOrdinalTable
    }

    /// Everything a derived value depends on.
    ///
    /// Options are part of the key for EVERY derivation, though only some read
    /// them. Asking each call site to declare whether it is options-sensitive
    /// would shrink the table by at most a factor of four and would put a
    /// correctness burden on every future author, to save entries in a table
    /// bounded at derivations x 4.
    private struct Key: Hashable {
        let derivation: Derivation
        let mode: Options.Mode
        let forwardDate: Bool
    }

    private var store: [Key: Any] = [:]
    private let lock = NSLock()

    /// Derivations actually built and stored. The invariant this type exists for
    /// is that this stops growing once the keys are warm, which is what
    /// PatternCacheTests asserts - a timing assertion would only measure the
    /// machine it ran on.
    private(set) var compileCount = 0

    init(_ locale: KhacLocale) {
        self.locale = locale
    }

    /// The derived value for this key, built on first use.
    ///
    /// `build` must be a pure function of the key. It may read the locale and
    /// the options; it must not read the input text or the reference instant.
    func cached<T>(_ derivation: Derivation, mode: Options.Mode, forwardDate: Bool, build: () -> T) -> T {
        let key = Key(derivation: derivation, mode: mode, forwardDate: forwardDate)

        lock.lock()
        let hit = store[key]
        lock.unlock()
        if let hit { return checkedCast(hit, key) }

        // Built OUTSIDE the lock. `build` calls into locale code a consumer
        // supplied, and holding a lock across a call out of this type is how
        // deadlocks are made. Two threads racing the same cold key both build,
        // and the loser's copy is dropped below: wasted once, never wrong,
        // because the value is a pure function of the key.
        let built = build()

        lock.lock()
        defer { lock.unlock() }
        if let raced = store[key] { return checkedCast(raced, key) }
        store[key] = built
        compileCount += 1
        return built
    }

    /// The type is carried by convention: one derivation always stores one type.
    /// A mismatch is a programmer error at the call site, so say which key broke
    /// rather than trapping on an anonymous bad cast.
    private func checkedCast<T>(_ value: Any, _ key: Key) -> T {
        guard let typed = value as? T else {
            preconditionFailure(
                "PreparedLocale derivation \(key.derivation) was stored as "
                + "\(type(of: value)) and read back as \(T.self). One derivation "
                + "must always hold one type."
            )
        }
        return typed
    }

    /// The parser's pattern for this context's options, compiled on first use.
    func regex(for parser: Parser, context: ParsingContext) -> NSRegularExpression {
        cached(
            .parserPattern(ObjectIdentifier(type(of: parser))),
            mode: context.options.mode,
            forwardDate: context.options.forwardDate
        ) {
            parser.pattern(context)
        }
    }
}
