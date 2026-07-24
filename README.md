# Khắc

A natural-language date and time parser for Swift.

Khắc reads free text and returns structured dates, intervals, and components.
It handles casual, relative, and absolute expressions in multiple languages.

```swift
import Khac

let k = Khac()
k.parseDate("next Friday at 5pm")                 // -> Date?
k.parseDate("họp lúc 3 giờ chiều mai")            // -> Date?
k.parse("from Aug 10 to Aug 14", reference: .now) // -> [ParsedResult] (with .interval)
```

## Status

Early development. Phase 1: core engine + English + Vietnamese (v0.1).
Phase 2: the remaining 12 locales as data on the proven engine (v1.0).

## Design

Data-driven locales on one shared engine, strong Swift types for
certain-vs-implied date components, Unicode (NFC) normalization in the core,
and deterministic overlap scoring. See `SPEC.md`.

## Install

Swift Package Manager:

```swift
.package(url: "https://github.com/nhannht/Khac.git", from: "0.1.0")
```

## License

MIT. See `LICENSE` and `NOTICE`. Prior art and test oracle: wanasit/chrono (MIT).
