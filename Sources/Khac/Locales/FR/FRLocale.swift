// FRLocale.swift - French locale data for Khac.
//
// Pure DATA per the data-driven locale design: Vocabulary, PatternSet,
// LocaleOptions. Values are ported from wanasit/chrono's own French source
// (src/locales/fr/constants.ts, FRWeekdayParser.ts, FRCasualDateParser.ts,
// FRCasualTimeParser.ts, FRTimeExpressionParser.ts,
// FRSpecificTimeExpressionParser.ts, FRTimeUnitAgoFormatParser.ts,
// FRTimeUnitRelativeFormatParser.ts, FRTimeUnitWithinFormatParser.ts,
// FRMergeDateTimeRefiner.ts, FRMergeDateRangeRefiner.ts - see NOTICE), cross-
// checked against the 154-case FR oracle (Tests/KhacTests/Oracle/FR/).

import Foundation

public struct FRLocale: KhacLocale {
    public let id: LocaleID = .french

    public init() {}

    public var vocabulary: Vocabulary {
        Vocabulary(
            weekdays: Self.weekdays,
            months: Self.months,
            integerWords: Self.integerWords,
            ordinals: [:],
            timeUnits: Self.timeUnits,
            relativeModifiers: Self.relativeModifiers,
            dayReferences: Self.dayReferences,
            meridiem: Self.meridiem,
            timeOfDay: Self.timeOfDay,
            eraMarkers: Self.eraMarkers,
            fullMonthNames: Self.fullMonthNames,
            casualQuantifiers: Self.casualQuantifiers
        )
    }

    public var patterns: PatternSet {
        PatternSet(
            // FRTimeExpressionParser.primaryPrefix: `(?:(?:[àa])\s*)?`. No
            // "les"-equivalent article before a clock time in French, unlike
            // Spanish "a las" - just the bare preposition.
            timePrefixWords: ["à", "a"],
            // "10 de enero"-shape connector: FRMonthNameLittleEndianParser's own
            // hardcoded day-month connector is `(?:-|/|\s*(?:de)?\s*)`.
            dateConnectorWords: ["de"],
            // FRSpecificTimeExpressionParser: bare "h"/"m"/"s" as clock-word
            // markers ("8h10m00s"). Wiring these into the generic
            // TimeExpressionParser's own clock-word mechanism (already reads
            // these three fields, see VI's "giờ"/"phút"/"giây") reproduces
            // chrono's bespoke French clock format as DATA, with no bespoke
            // parser needed.
            clockHourWords: ["h"],
            clockMinuteWords: ["m"],
            clockSecondWords: ["s"],
            // FRTimeUnitAgoFormatParser is "il y a" + duration - a PREFIX, not
            // a suffix. Reported to main (KHAC-6): RelativeUnitParser has no
            // past-direction PREFIX field (relativePastWords is suffix-only,
            // unlike future direction which has both relativeFutureWords and
            // futureSuffixWords). Left EMPTY here for that reason; the 8
            // fr_time_units_ago cases are deferred until the field exists.
            //
            // FRTimeUnitRelativeFormatParser's own postnominal modifier set
            // (`prochaine?s?|derni[eè]re?s?|pass[ée]e?s?|pr[ée]c[ée]dents?|suivante?s?`)
            // splits across TWO Khac mechanisms depending on whether a count
            // is present. "les 30 jours précédents" (count+unit+modifier) is a
            // counted duration with a suffix modifier - the SAME mechanism
            // "ago" uses - so précédent/passé (past direction) belong here as
            // relativePastWords, matching RelativeUnitParser's pastAlt.
            relativePastWords: [
                "précédent", "précédente", "précédents", "précédentes",
                "precedent", "precedente", "precedents", "precedentes",
                "passé", "passée", "passés", "passées",
                "passe", "passee", "passes", "passees",
            ],
            // FRTimeUnitRelativeFormatParser / FRTimeUnitWithinFormatParser:
            // "dans"/"en"/"pour"/"pendant"/"de" all read as FUTURE prefixes.
            relativeFutureWords: ["dans", "en", "pour", "pendant", "de"],
            // "les 90 secondes suivantes" (count+unit+modifier, future
            // direction) - the futureSuffixAlt counterpart to relativePastWords
            // above.
            futureSuffixWords: ["suivant", "suivante", "suivants", "suivantes"],
            // FRMergeDateRangeRefiner: `(à|a|au|-)`. Also covers
            // FRMonthNameLittleEndianParser's own day-range connector
            // (`au|jusqu'au?`) once MonthNameParser reads this field - see the
            // KHAC-6 report on the day-range connector being hardcoded to
            // English words.
            rangeConnectorWords: ["à", "a", "au"],
            nowWords: ["maintenant"],
            // "cet après-midi" (this afternoon): "cet"/"ce"/"cette" anchor the
            // phrase via relativeModifiers' value-0 entries (see below); the
            // particle itself needs no PatternSet field, since
            // CasualDateParser's anchor branch already accepts any
            // value-0 relativeModifiers word directly, with no connector
            // needed between it and the following time-of-day word (unlike
            // ES's "ayer DE noche").
            //
            // "a midi" / "à minuit": chrono bakes the article directly into
            // its own alternative string; here it is decomposed into this
            // field, matching ES's "de" - see the note on `timeOfDay` above.
            timeOfDayPrefixWords: ["à", "a"],
            // MODELING CHOICE, flagged rather than silently applied: French's
            // relative-duration idiom always fronts a determiner ("les 30
            // jours précédents", "les 24 heures passées"), and the oracle
            // asserts the determiner as part of the matched text.
            // `durationFillerWords` is mechanically exactly what is needed - an
            // optional, repeatable, value-less word consumed at the head of a
            // duration clause (RelativeDuration.swift's `clauseParts.filler`) -
            // even though its NAME and doc comment describe hedge words
            // ("about", "around"), not grammatical articles. Confirmed
            // empirically that it fixes the counted-plus-suffix-modifier shape
            // ("les" + count + unit + précédents/passées/suivantes, which
            // routes through DurationExpression via RelativeUnitParser's
            // pastAlt/futureSuffixAlt).
            //
            // It does NOT reach every French relative-duration shape, though -
            // confirmed empirically, not assumed. "la semaine prochaine" (no
            // count) goes through `bareModifierAlt`, which builds its
            // alternation directly from `modifiers`/`units` and never touches
            // DurationExpression, so the filler never applies there. "les 2
            // prochaines semaines" (article+COUNT+MODIFIER+unit) is a third
            // shape RelativeUnitParser has no alternative for at all - not
            // modifierAlt (modifier before count) and not bareModifierAlt (no
            // count). Both gaps are reported to main (KHAC-6); see the
            // deferred fr_time_units_casual_relative cases.
            durationFillerWords: ["les", "la", "le", "l'"],
            // FRMergeDateTimeRefiner: `(T|à|a|au|vers|de|,|-)`. "à"/"a"/"de"
            // are already reachable via timePrefixWords above; "au"/"vers" are
            // not, so they are added here.
            dateTimeGlueWords: ["au", "vers"]
        )
    }

    // French: day-month numeric order ("8/2/2016" = 8 Feb 2016, confirmed by
    // the FR oracle's slash cases), week starts Monday.
    //
    // weekdaySuffixModifier: true - FRWeekdayParser's own "dernier"/"prochain"
    // are a direct SUFFIX on the weekday with no week-word ("vendredi
    // dernier" = last Friday), the same shape VI's suffix option exists for.
    public var options: LocaleOptions {
        LocaleOptions(dateOrder: .dayMonth, weekStart: 2, weekdaySuffixModifier: true)
    }
}

// MARK: - Vocabulary data

private extension FRLocale {
    static let weekdays: [String: Int] = [
        "dimanche": 0, "dim": 0,
        "lundi": 1, "lun": 1,
        "mardi": 2,
        // "mar" is ALSO an abbreviation for "mars" (March) in `months` below -
        // the same real, chrono-inherited collision ES has between "martes"
        // and "marzo". Separate tables, separate parsers, no runtime conflict;
        // no oracle case exercises bare "mar".
        "mar": 2,
        "mercredi": 3, "mer": 3,
        "jeudi": 4, "jeu": 4,
        "vendredi": 5, "ven": 5,
        "samedi": 6, "sam": 6,
    ]

    static let months: [String: Int] = [
        "janvier": 1, "jan": 1, "jan.": 1, "janv": 1, "janv.": 1,
        "février": 2, "fév": 2, "fév.": 2, "févr": 2, "févr.": 2,
        "fevrier": 2, "fev": 2, "fev.": 2, "fevr": 2, "fevr.": 2,
        "mars": 3, "mar.": 3,
        "avril": 4, "avr": 4, "avr.": 4,
        "mai": 5,
        "juin": 6, "juin.": 6, "jun": 6, "jun.": 6,
        "juillet": 7, "juil": 7, "juil.": 7, "jul": 7, "jul.": 7,
        "août": 8, "août.": 8, "aout": 8, "aout.": 8,
        "septembre": 9, "sep": 9, "sep.": 9, "sept": 9, "sept.": 9,
        "octobre": 10, "oct": 10, "oct.": 10,
        "novembre": 11, "nov": 11, "nov.": 11,
        "décembre": 12, "decembre": 12, "dec": 12, "dec.": 12, "déc": 12, "déc.": 12,
    ]

    /// chrono's INTEGER_WORD_DICTIONARY stops at 13, same shape as ES.
    static let integerWords: [String: Int] = [
        "un": 1, "deux": 2, "trois": 3, "quatre": 4, "cinq": 5, "six": 6,
        "sept": 7, "huit": 8, "neuf": 9, "dix": 10, "onze": 11, "douze": 12,
        "treize": 13,
    ]

    /// chrono's TIME_UNIT_DICTIONARY. Note "ans" (plural) and "année"/"années"
    /// (singular/plural) are year, but bare singular "an" is absent from
    /// chrono's own dictionary - not ported as a KHAC extension since no
    /// oracle case exercises it either way, and it is chrono's gap to fix, not
    /// a fact this port should guess at.
    static let timeUnits: [String: Calendar.Component] = [
        "sec": .second, "seconde": .second, "secondes": .second,
        "min": .minute, "mins": .minute, "minute": .minute, "minutes": .minute,
        "h": .hour, "hr": .hour, "hrs": .hour, "heure": .hour, "heures": .hour,
        "jour": .day, "jours": .day,
        "semaine": .weekOfYear, "semaines": .weekOfYear,
        "mois": .month,
        "trimestre": .quarter, "trimestres": .quarter,
        "ans": .year, "année": .year, "années": .year,
    ]

    /// chrono's parseNumberPattern: exact "un"/"une" = 1 (article, ahead of any
    /// regex branch), "quelques?" = 3 ("some"/"a few"), "demi-?" = 0.5 ("half").
    static let casualQuantifiers: [String: Double] = [
        "un": 1, "une": 1,
        "quelques": 3, "quelque": 3,
        "demi": 0.5,
    ]

    /// chrono's FRCasualDateParser: only these three bare words. "cette nuit"
    /// and "la veille" are NOT here - they route through `relativeModifiers`
    /// ("cette" = this, value 0) composed with `timeOfDay`'s "nuit" entry
    /// below, the same way ES composes "esta" + "noche" instead of chrono's
    /// own hardcoded one-piece "esta noche" match. "la veille" (the eve/day
    /// before) has no compositional home in this data model and is not
    /// modeled - flagged to main as a possible gap, not invented here.
    static let dayReferences: [String: Int] = [
        "aujourd'hui": 0,
        "demain": 1,
        "hier": -1,
    ]

    /// chrono's FRSpecificTimeExpressionParser accepts a BARE single-letter
    /// "a"/"p" as well as the full "am"/"pm" ("5:16p", "5h16p" are real oracle
    /// inputs) - unlike EN, where this was left unadded for lack of an oracle
    /// case. French's own oracle exercises the bare form directly, so it is a
    /// real entry here, not a KHAC extension.
    static let meridiem: [String: Meridiem] = [
        "am": .am, "a.m": .am, "a.m.": .am, "a": .am,
        "pm": .pm, "p.m": .pm, "p.m.": .pm, "p": .pm,
    ]

    /// chrono's FRCasualTimeParser switch (matin/soir/après-midi/aprem all
    /// IMPLY their hour, matching an optional "ce"/"cet" prefix - see
    /// `relativeModifiers` below for how that composes) plus FRCasualDateParser's
    /// baked-in "a midi"/"à minuit" (both required their own leading article in
    /// chrono's source; here the article is decomposed into `patterns.timeOfDayPrefixWords`
    /// so "midi"/"minuit" are the real table keys, matching how ES's "de" works).
    /// "nuit" (22, .pm) is the bare word "cette nuit" decomposes onto - see
    /// `dayReferences` above.
    /// "midi" = (12, .am): matches EN's own noon=am quirk (chrono's noon()
    /// helper implies AM as an artifact of its 12-hour math), and
    /// FRCasualTimeParser routes "a midi" through that same helper.
    static let timeOfDay: [String: (hour: Int, meridiem: Meridiem?)] = [
        "matin": (8, .am),
        "soir": (18, .pm),
        "après-midi": (14, .pm),
        "aprem": (14, .pm),
        "midi": (12, .am),
        "minuit": (0, nil),
        "nuit": (22, .pm),
    ]

    /// "cet"/"ce"/"cette" are all "this" (masc before consonant/vowel, fem),
    /// giving them the same real, zero-offset meaning ES's "este"/"esta" and
    /// VI's "này" carry - and, as a side effect, registering them as
    /// CasualDateParser day-anchor words (any value-0 relativeModifiers entry
    /// qualifies) and optional no-op WeekdayParser prefixes ("ce lundi"),
    /// exactly reproducing chrono's own FRWeekdayParser, which consumes "ce"
    /// but never assigns it a modifier.
    /// "prochain(e)(s)"/"derni[eè]re?s?" cover FRWeekdayParser's postfix
    /// (dernier/prochain, no gender agreement needed there) and the
    /// no-count prenominal/postnominal forms in
    /// FRTimeUnitRelativeFormatParser ("la semaine prochaine", "le mois
    /// dernier") via RelativeUnitParser's bareModifierAlt, which already tries
    /// both word orders.
    static let relativeModifiers: [String: Int] = [
        "ce": 0, "cet": 0, "cette": 0,
        "prochain": 1, "prochaine": 1, "prochains": 1, "prochaines": 1,
        "dernier": -1, "derniere": -1, "dernière": -1, "derniers": -1, "dernieres": -1, "dernières": -1,
    ]

    /// Bare month names, same length-based abbreviation guard as ES/EN -
    /// French abbreviations ("mar", "avr", "mai" itself is full-length) carry
    /// the same real-word collision risk. Not oracle-tested either way.
    static let fullMonthNames: Set<String> = [
        "janvier", "février", "fevrier", "mars", "avril", "mai", "juin",
        "juillet", "août", "aout", "septembre", "octobre", "novembre", "décembre", "decembre",
    ]

    /// chrono's YEAR_PATTERN/parseYear: "AC" negates (BC), "AD" or a bare "C"
    /// keeps the sign. Only "AC" is oracle-tested ("10 Août 234 AC");
    /// "AD" is added for the same reason ES's "d.c." was - a real, symmetric
    /// word chrono itself recognizes, not invented.
    /// "p. Chr. n." (Latin "post Christum natum", AD) is chrono's own
    /// YEAR_PATTERN alternative `p\.\s*C(?:hr?)?\.\s*n\.` - oracle-tested as
    /// "88 p. Chr. n.". Modeled as one literal phrase (this exact spacing and
    /// abbreviation) rather than chrono's flexible regex, since it is the only
    /// form the oracle exercises.
    static let eraMarkers: [String: Int] = [
        "ac": -1,
        "ad": 1,
        "p. chr. n.": 1,
    ]
}
