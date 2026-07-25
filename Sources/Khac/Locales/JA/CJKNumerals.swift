// CJKNumerals.swift - reading numbers written in CJK characters and full-width digits.
//
// Shared by JA and ZH. It lives under Locales/JA/ only because JA was built
// first; the type is deliberately named for the script family, not the locale,
// and it holds no locale data of its own - the digit table is passed in, because
// the tables genuinely differ (ja has no 廿, chrono's zh hant table has no 〇).
// Flagged to engine as a placement question; one file move settles it.
//
// TWO readings, and which one applies is decided by the SLOT the number sits in,
// never by inspecting the characters:
//
//     additive     五十九  = 5*10 + 9 = 59     counts, hours, minutes, seconds
//     positional   二零一六 = "2016"           years
//
// 二零一六 read additively is 2+0+1+6 = 9, so one reader with a content
// heuristic would be wrong on real input. chrono keeps them as two separate
// functions for exactly this reason (jaStringToNumber in locales/ja/constants.ts,
// zhStringToNumber and zhStringToYear in locales/zh/*/constants.ts, where the zh
// pair is byte-identical between hans and hant), and this port keeps them
// separate for the same reason rather than adding a flag to choose between them.

import Foundation

/// Left boundary for a CJK pattern: not inside an ASCII word, and not inside a
/// number of either digit width.
///
/// This is chrono's own boundary for these locales, and getting it right is the
/// whole difference between matching CJK and not. chrono guards with `(\W|^)`,
/// and in JS without the /u flag `\W` is `[^A-Za-z0-9_]` - so a kanji SATISFIES
/// it while an ASCII digit does not. The generic parsers express the same idea as
/// `(?<![\p{L}\p{N}_])`, with the Unicode property, and in a space-free script
/// that one substitution rejects every match.
///
/// The full-width digits go beyond chrono. They are here because a match must not
/// begin in the middle of a number, chrono's patterns treat full-width digits as
/// digits everywhere else, and - unlike chrono, which skips a rejected span
/// wholesale - this engine advances one character after a rejection and so gets a
/// second chance to start mid-number.
let cjkWordBoundary = "(?<![A-Za-z0-9_０-９])"

/// Arabic digits, either width. Every numeric slot in a Japanese pattern takes
/// both, because real input mixes them inside one expression.
let cjkArabicDigit = "[0-9０-９]"

/// Reads a number written in CJK digit characters, in either of the two
/// readings, plus ASCII and full-width Arabic digits.
struct CJKNumerals {
    /// Character to value, e.g. 一 = 1, 十 = 10, 廿 = 20. Locale-supplied.
    let digits: [Character: Int]

    /// The regex character class body for this table's characters, for splicing
    /// into a pattern as `[...]`. Sorted so the compiled pattern is reproducible
    /// across launches (Dictionary key order is randomized per process, SE-0206 -
    /// the same reason regexAlternation sorts).
    var characterClass: String {
        String(digits.keys.sorted())
    }

    /// The ADDITIVE reading, for counts and clock fields: 十一 = 11,
    /// 二十三 = 23, 五十九 = 59, 廿六 = 26.
    ///
    /// chrono's jaStringToNumber / zhStringToNumber: a 十 multiplies what came
    /// before it (or stands for 10 when nothing did), and every other character
    /// adds. 廿 and 卅 are plain table entries worth 20 and 30, so 廿六 adds to
    /// 26 without needing a rule of their own.
    ///
    /// Returns nil on any character outside the table, where chrono would produce
    /// NaN and silently carry it into a component.
    func additive(_ text: String) -> Int? {
        var number = 0
        for character in text {
            guard let value = digits[character] else { return nil }
            if value == 10 {
                number = number == 0 ? 10 : number * 10
            } else {
                number += value
            }
        }
        return number
    }

    /// The POSITIONAL reading, for years: 二零一六 = 2016.
    ///
    /// chrono's zhStringToYear concatenates each character's value as a decimal
    /// STRING and parses the result, so this is digit-by-digit transcription and
    /// not arithmetic. Only ever applied to a year slot.
    func positional(_ text: String) -> Int? {
        var string = ""
        for character in text {
            guard let value = digits[character] else { return nil }
            string += String(value)
        }
        return Int(string)
    }
}

// MARK: - Arabic digits, half and full width

extension CJKNumerals {
    /// Fold full-width Arabic digits (U+FF10 to U+FF19) to ASCII.
    ///
    /// CJK text mixes the two widths freely, including inside one expression -
    /// the JA oracle carries "２０１３年１２月２６日ー2014年1月7日" - so every
    /// numeric slot in a CJK pattern accepts both and folds here before reading.
    ///
    /// Done by explicit scalar arithmetic on that one block rather than through
    /// NFKC. NFKC would fold this correctly but also rewrites ligatures, squared
    /// abbreviations and much else, so it is a far wider change than intended and
    /// its blast radius is not confined to digits. This is chrono's toHankaku
    /// narrowed to the digits that a date or time can actually contain.
    static func foldingFullWidthDigits(_ text: String) -> String {
        String(String.UnicodeScalarView(text.unicodeScalars.map { scalar in
            (0xFF10...0xFF19).contains(scalar.value)
                ? Unicode.Scalar(scalar.value - 0xFEE0)!
                : scalar
        }))
    }

    /// An integer written in ASCII or full-width Arabic digits, or nil.
    static func arabic(_ text: String) -> Int? {
        Int(foldingFullWidthDigits(text))
    }

    /// An integer in whichever form the text uses: Arabic digits of either width,
    /// else the additive CJK reading. Mirrors chrono's
    /// `parseInt(toHankaku(x))` with an `isNaN` fallback to the CJK reader.
    func integer(_ text: String) -> Int? {
        Self.arabic(text) ?? additive(text)
    }
}
