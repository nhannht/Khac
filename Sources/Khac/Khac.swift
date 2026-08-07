// Khac.swift - public entry point for the Khắc natural-language date parser.

import Foundation

/// Parse free text into structured dates, intervals, and components.
///
/// One language at a time. `Khac()` parses English; name a different locale to
/// parse a different language. Deciding WHICH language a text is in is a
/// separate job for a separate tool (NLLanguageRecognizer or similar) - Khắc
/// only parses, it never guesses the language.
///
///     let en = Khac()
///     en.parse("next Friday at 5pm")
///
///     let vi = Khac(locales: [.vietnamese])
///     vi.parseDate("họp lúc 3 giờ chiều mai")
public struct Khac {
    /// Prepared, not raw: each locale carries the patterns compiled from it, so
    /// the first parse compiles and every later one reuses. Hold on to the Khac
    /// instance to get that - a fresh one starts cold. See PreparedLocale.
    ///
    /// Copying a Khac shares the prepared locales rather than duplicating them,
    /// which is the intent: the compiled patterns are identical either way.
    private let locales: [PreparedLocale]

    /// English. The default is ONE language, deliberately: locale vocabularies
    /// collide across languages (Swedish abbreviates onsdag as "on", Finnish
    /// abbreviates torstai as "to"), so a parse-everything default would sprout
    /// phantom weekdays in ordinary prose. The caller knows the language;
    /// Khắc does not guess it.
    public init() {
        self.init(locales: [.english])
    }

    /// Only the named locales, in the given order. The order is meaningful: a
    /// result tying exactly across locales (a bare "8/5") goes to the locale
    /// listed first.
    ///
    /// Listing more than one locale is a deliberate blend for genuinely mixed
    /// text. It carries a cost the single-locale default does not: one
    /// language's short vocabulary is another language's ordinary word, and a
    /// blend accepts both readings.
    public init(locales ids: [LocaleID]) {
        let byID = Dictionary(allLocales().map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
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

/// The registry: every locale the package ships, one instance each. This is
/// availability, not defaults - `Khac()` selects English from it and
/// `Khac(locales:)` selects by id, so a locale is reachable from the public API
/// only once it is listed here. A locale type that exists but is missing here
/// parses nothing for every caller who does not name the instance directly,
/// which is why PublicAPITests resolves every LocaleID through Khac(locales:).
func allLocales() -> [KhacLocale] {
    [
        ENLocale(), VILocale(),
        ZHLocale(), JALocale(),
        DELocale(), NLLocale(), SVLocale(),
        FRLocale(), ESLocale(), ITLocale(), PTLocale(),
        FILocale(),
        RULocale(), UKLocale(),
    ]
}
