// Khac.swift - public entry point for the Khắc natural-language date parser.

import Foundation

/// Parse free text into structured dates, intervals, and components.
///
///     let k = Khac()
///     let results = k.parse("next Friday at 5pm")
///     let date = k.parseDate("họp lúc 3 giờ chiều mai")
public struct Khac {
    private let locales: [KhacLocale]

    /// All registered locales.
    public init() {
        self.locales = defaultLocales()
    }

    /// Only the named locales, in the given order.
    public init(locales ids: [LocaleID]) {
        let byID = Dictionary(defaultLocales().map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.locales = ids.compactMap { byID[$0] }
    }

    /// Explicit locale instances. Used by tests and advanced callers.
    public init(localeInstances: [KhacLocale]) {
        self.locales = localeInstances
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

/// The built-in locales. Empty until the EN/VI executors' locale types land;
/// the Leader wires ENLocale()/VILocale() here at integration so the core module
/// never hard-depends on types it does not own. Engine tests use MockLocale and
/// Khac(localeInstances:) and are never blocked on this.
func defaultLocales() -> [KhacLocale] {
    []
}
