// BenchRunner - runs one parsing engine over a benchmark corpus and emits JSONL.
//
// Every engine emits the same record shape, so a single scorer can compare them.
// The runner never decides whether an answer is right; it only reports what the
// engine returned. Scoring lives in ../score/score.mjs.
//
// Usage:
//   BenchRunner --engine <name> --corpus <path> --reference <iso8601> --tz <id>
//   BenchRunner --engine <name> --corpus <path> --reference <iso8601> --tz <id> --throughput 5

import Foundation
import NaturalLanguage
import Khac
import SwiftyChrono

// MARK: - Argument parsing

func argument(_ name: String) -> String? {
    let args = CommandLine.arguments
    guard let i = args.firstIndex(of: "--\(name)"), i + 1 < args.count else { return nil }
    return args[i + 1]
}

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(("BenchRunner: " + message + "\n").data(using: .utf8)!)
    exit(1)
}

func requireArgument(_ name: String) -> String {
    guard let value = argument(name) else { fail("missing --\(name)") }
    return value
}

let engineName = requireArgument("engine")
let corpusPath = requireArgument("corpus")
let referenceISO = requireArgument("reference")
let tzIdentifier = requireArgument("tz")
let throughputRounds = Int(argument("throughput") ?? "0") ?? 0
// Set when a previous attempt died on a specific input: skip everything up to
// and including that case and carry on. An engine that crashes on user input
// is reporting a real property, and the harness measures it rather than
// letting one bad case take the whole run down.
let resumeAfter = argument("resume-after")

// Line-buffer stdout. Block buffering loses the last few records when the
// process traps, which makes the surviving output lie about how far the engine
// actually got - and that is exactly the moment the output has to be trusted.
setvbuf(stdout, nil, _IOLBF, 0)

guard let timeZone = TimeZone(identifier: tzIdentifier) else {
    fail("unknown time zone \(tzIdentifier)")
}

// NSDataDetector and SwiftyChrono read the process time zone rather than taking
// one as a parameter. If the process zone disagrees with the requested zone,
// those two engines would silently be measured in a different zone from Khac,
// so refuse to run instead of producing numbers that cannot be compared.
guard TimeZone.current.identifier == tzIdentifier else {
    fail("""
    process time zone is \(TimeZone.current.identifier) but --tz is \(tzIdentifier).
    NSDataDetector and SwiftyChrono take no time zone parameter, so the harness
    must be launched with TZ=\(tzIdentifier) for the comparison to be valid.
    """)
}

let isoParser = ISO8601DateFormatter()
isoParser.formatOptions = [.withInternetDateTime]
guard let referenceInstant = isoParser.date(from: referenceISO) else {
    fail("could not parse --reference \(referenceISO) as ISO8601")
}

let isoOut = ISO8601DateFormatter()
isoOut.formatOptions = [.withInternetDateTime]
isoOut.timeZone = TimeZone(identifier: "UTC")!

// NSDataDetector has no reference-date API: it always resolves relative
// expressions against the system clock. The whole harness therefore runs with
// reference = wall clock now. Guard the skew rather than assume it.
if engineName == "nsdatadetector" {
    let skew = abs(Date().timeIntervalSince(referenceInstant))
    if skew > 120 {
        fail("""
        --reference is \(Int(skew))s from the system clock. NSDataDetector cannot
        be given a reference date, so it would answer relative cases against a
        different instant from the other engines. Re-run with reference = now.
        """)
    }
}

// MARK: - Corpus

struct Case {
    let id: String
    let lang: String
    let text: String
}

let corpusData = try String(contentsOfFile: corpusPath, encoding: .utf8)
var cases: [Case] = []
for line in corpusData.split(separator: "\n", omittingEmptySubsequences: true) {
    let trimmed = String(line).trimmingCharacters(in: CharacterSet.whitespaces)
    if trimmed.isEmpty || trimmed.hasPrefix("//") { continue }
    guard
        let obj = try JSONSerialization.jsonObject(with: Data(trimmed.utf8)) as? [String: Any],
        let id = obj["id"] as? String,
        let lang = obj["lang"] as? String,
        let text = obj["text"] as? String
    else {
        fail("malformed corpus line: \(trimmed.prefix(120))")
    }
    cases.append(Case(id: id, lang: lang, text: text))
}

if let resumeAfter {
    guard let index = cases.firstIndex(where: { $0.id == resumeAfter }) else {
        fail("--resume-after names \(resumeAfter), which is not in this corpus")
    }
    cases = Array(cases[(index + 1)...])
}

// MARK: - Engine output

/// One date expression an engine claims to have found.
struct Hit {
    let text: String
    let index: Int
    let start: Date
    let end: Date?
}

// MARK: - Khac

let khacLocaleByCode: [String: LocaleID] = Dictionary(
    uniqueKeysWithValues: LocaleID.allCases.map { ($0.rawValue, $0) }
)

/// One parser per locale, built once. Building a Khac inside the timed loop
/// would measure construction, not parsing.
var khacByLocale: [LocaleID: Khac] = [:]
for id in LocaleID.allCases {
    khacByLocale[id] = Khac(locales: [id])
}

let khacReference = ReferencePoint(instant: referenceInstant, timeZone: timeZone)

func runKhac(_ text: String, locale: LocaleID) -> [Hit] {
    let parser = khacByLocale[locale]!
    return parser.parse(text, reference: khacReference).map {
        Hit(text: $0.text, index: $0.index, start: $0.date, end: $0.interval?.end)
    }
}

// MARK: - Language recognition (the khac-auto configuration)

// Khac parses one language at a time by design, so the configuration its README
// recommends is a language identifier in front of it. That is also the only
// like-for-like comparison against NSDataDetector, which auto-detects.
let nlToLocale: [NLLanguage: LocaleID] = [
    .english: .english,
    .vietnamese: .vietnamese,
    .german: .german,
    .spanish: .spanish,
    .finnish: .finnish,
    .french: .french,
    .italian: .italian,
    .japanese: .japanese,
    .dutch: .dutch,
    .portuguese: .portuguese,
    .russian: .russian,
    .swedish: .swedish,
    .ukrainian: .ukrainian,
    .simplifiedChinese: .chinese,
    .traditionalChinese: .chinese,
]

let recognizerConstraints = Array(nlToLocale.keys)

// One recognizer, reset between strings. Allocating a fresh NLLanguageRecognizer
// per call costs several hundred microseconds and no real app would do it, so
// measuring it that way would be a strawman against Khac's own headline
// configuration.
//
// Reusing the instance is safe HERE because this runner is single-threaded.
// NLLanguageRecognizer is not documented as thread-safe, so this is a property
// of the harness and not advice to carry into a concurrent app.
let sharedRecognizer: NLLanguageRecognizer = {
    let r = NLLanguageRecognizer()
    r.languageConstraints = recognizerConstraints
    return r
}()

/// Returns the Khac locale chosen, and the same choice as a corpus language code
/// so the scorer can tell a detection miss from a parsing miss. Reporting
/// NLLanguage's own tag would not compare: it distinguishes zh-Hans from
/// zh-Hant, and Khac has one Chinese locale.
func detectLocale(_ text: String) -> (LocaleID, String) {
    sharedRecognizer.reset()
    // Re-assigned after EVERY reset, and this is not redundant. Measured on
    // macOS 26: after reset() the languageConstraints property still reads back
    // the full list, but the recognizer stops honoring it - "deadline
    // 2012-08-10" constrained to [en, vi, nl, de] returned "nl" on the first
    // call and "id" (Indonesian, never in the list) on the second. Dropping this
    // line silently unconstrains every call after the first.
    sharedRecognizer.languageConstraints = recognizerConstraints
    sharedRecognizer.processString(text)
    guard let language = sharedRecognizer.dominantLanguage, let id = nlToLocale[language] else {
        // No signal at all. English is the sensible default for a Swift library
        // and is what an app would fall back to.
        return (.english, "und")
    }
    return (id, id.rawValue)
}

// MARK: - NSDataDetector

let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)

func runNSDataDetector(_ text: String) -> [Hit] {
    let ns = text as NSString
    let matches = detector.matches(in: text, range: NSRange(location: 0, length: ns.length))
    return matches.compactMap { match in
        guard let date = match.date else { return nil }
        // NSDataDetector models a range as a start plus a duration rather than
        // as two endpoints, so reconstruct the end the only way it allows.
        let end = match.duration > 0 ? date.addingTimeInterval(match.duration) : nil
        return Hit(text: ns.substring(with: match.range), index: match.range.location, start: date, end: end)
    }
}

// MARK: - SwiftyChrono

// SwiftyChrono ships 7 languages. Where it has the corpus language, it is told
// which one it is: that is its most favourable configuration and removes any
// argument that the comparison handicapped it. Where it has no such language,
// it is left on its own detection, which is the only thing it can do.
let swiftyLanguageByCode: [String: SwiftyChrono.Language] = [
    "en": .english,
    "es": .spanish,
    "fr": .french,
    "ja": .japanese,
    "de": .german,
    "zh": .chinese,
]

let swiftyChrono = SwiftyChrono.Chrono.casual

func runSwiftyChrono(_ text: String, lang: String) -> [Hit] {
    SwiftyChrono.Chrono.preferredLanguage = swiftyLanguageByCode[lang]
    return swiftyChrono.parse(text: text, refDate: referenceInstant).map {
        Hit(text: $0.text, index: $0.index, start: $0.start.date, end: $0.end?.date)
    }
}

// MARK: - Dispatch

func parse(_ c: Case) -> (hits: [Hit], detected: String?) {
    switch engineName {
    case "khac-oracle":
        guard let locale = khacLocaleByCode[c.lang] else { fail("no Khac locale for \(c.lang)") }
        return (runKhac(c.text, locale: locale), nil)
    case "khac-auto":
        let (locale, tag) = detectLocale(c.text)
        return (runKhac(c.text, locale: locale), tag)
    case "nsdatadetector":
        return (runNSDataDetector(c.text), nil)
    case "swiftychrono":
        return (runSwiftyChrono(c.text, lang: c.lang), nil)
    default:
        fail("unknown engine \(engineName). Expected khac-oracle, khac-auto, nsdatadetector, or swiftychrono.")
    }
}

// MARK: - Throughput mode

if throughputRounds > 0 {
    // Best of N rounds over the whole corpus. Best-of rather than mean because
    // the interesting number is the engine's own cost, not the scheduler noise
    // layered on top of it.
    var bestNanos = UInt64.max
    for _ in 0 ..< throughputRounds {
        let started = DispatchTime.now().uptimeNanoseconds
        for c in cases {
            _ = parse(c)
        }
        let elapsed = DispatchTime.now().uptimeNanoseconds - started
        bestNanos = min(bestNanos, elapsed)
    }
    let seconds = Double(bestNanos) / 1_000_000_000
    let record: [String: Any] = [
        "engine": engineName,
        "mode": "throughput",
        "cases": cases.count,
        "rounds": throughputRounds,
        "bestSeconds": seconds,
        "parsesPerSecond": Double(cases.count) / seconds,
        "usPerParse": seconds * 1_000_000 / Double(cases.count),
    ]
    let data = try JSONSerialization.data(withJSONObject: record, options: [.sortedKeys])
    print(String(data: data, encoding: .utf8)!)
    exit(0)
}

// MARK: - Accuracy mode

for c in cases {
    let started = DispatchTime.now().uptimeNanoseconds
    let (hits, detected) = parse(c)
    let elapsed = DispatchTime.now().uptimeNanoseconds - started

    let encodedHits: [[String: Any]] = hits.map { hit in
        var h: [String: Any] = [
            "text": hit.text,
            "index": hit.index,
            "start": isoOut.string(from: hit.start),
        ]
        h["end"] = hit.end.map { isoOut.string(from: $0) } ?? NSNull()
        return h
    }

    var record: [String: Any] = [
        "id": c.id,
        "engine": engineName,
        "lang": c.lang,
        "results": encodedHits,
        "ns": elapsed,
    ]
    record["detectedLang"] = detected ?? NSNull()

    let data = try JSONSerialization.data(withJSONObject: record, options: [.sortedKeys])
    print(String(data: data, encoding: .utf8)!)
}
