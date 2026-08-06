// Khac.swift - public entry point for the Khắc natural-language date parser.

import Foundation

/// Parse free text into structured dates, intervals, and components.
///
///     let k = Khac()
///     let results = k.parse("next Friday at 5pm")
///     let date = k.parseDate("họp lúc 3 giờ chiều mai")
public struct Khac {
    /// Prepared, not raw: each locale carries the patterns compiled from it, so
    /// the first parse compiles and every later one reuses. Hold on to the Khac
    /// instance to get that - a fresh one starts cold. See PreparedLocale.
    ///
    /// Copying a Khac shares the prepared locales rather than duplicating them,
    /// which is the intent: the compiled patterns are identical either way.
    private let locales: [PreparedLocale]

    /// All registered locales.
    public init() {
        self.locales = defaultLocales().map(PreparedLocale.init)
    }

    /// Only the named locales, in the given order. The order is meaningful: a
    /// result tying exactly across locales (a bare "8/5") goes to the locale
    /// listed first.
    public init(locales ids: [LocaleID]) {
        let byID = Dictionary(defaultLocales().map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.locales = ids.compactMap { byID[$0] }.map(PreparedLocale.init)
    }

    /// Explicit locale instances. Used by tests and advanced callers.
    public init(localeInstances: [KhacLocale]) {
        self.locales = localeInstances.map(PreparedLocale.init)
    }

    /// Parse all date/time expressions in `text`.
    public func parse(_ text: String, reference: ReferencePoint = .now, options: Options = Options()) -> [ParsedResult] {
        Engine.run(text: text, reference: reference, options: options, locales: locales)
    }

    /// Convenience: the first resolved date, if any.
    public func parseDate(_ text: String, reference: ReferencePoint = .now, options: Options = Options()) -> Date? {
        parse(text, reference: reference, options: options).first?.date
    }
}

/// The built-in locales, in the order `Khac()` tries them. The order also
/// breaks exact cross-locale ties: a reading every other overlap key leaves
/// open goes to the earlier locale (see ParsedResult.localeRank).
///
/// Both public initializers resolve through here - `Khac()` takes this list whole
/// and `Khac(locales:)` selects from it by id - so a locale is reachable from the
/// public API only once it is listed. A locale type that exists but is missing
/// here parses nothing for every caller who does not name the instance directly,
/// which is why PublicAPITests exercises the no-argument initializer.
func defaultLocales() -> [KhacLocale] {
    [ENLocale(), VILocale()]
}
