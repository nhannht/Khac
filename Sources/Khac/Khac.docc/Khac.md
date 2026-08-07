# ``Khac``

A natural-language date and time parser for Swift. Fourteen languages, one
engine.

## Overview

Khắc reads free text and returns structured dates, intervals, and components.
It handles casual, relative, and absolute expressions in English, Vietnamese,
Chinese, Japanese, German, Dutch, Swedish, French, Spanish, Italian,
Portuguese, Finnish, Russian, and Ukrainian.

One language at a time. `Khac()` parses English; every other language is
selected by name. Deciding which language a text is in is a separate job for a
separate tool - Khắc parses, it does not guess.

```swift
import Khac

let khac = Khac()                           // English

khac.parseDate("next Friday at 5pm")        // Date?
khac.parse("from Aug 10 to Aug 14")         // [ParsedResult], each with .interval

let vi = Khac(locales: [.vietnamese])
vi.parseDate("sáng mai")                    // Date?
```

Relative expressions resolve against a ``ReferencePoint``, which defaults to
now. Pass your own to make parsing deterministic, and to parse on behalf of a
user in another time zone.

Hold on to your `Khac` instance: patterns are compiled once per instance, on
first use, and reused after that. Constructing a fresh instance for every call
throws the compiled patterns away.

## Topics

### Parsing

- ``Khac/Khac``
- ``Options``
- ``ReferencePoint``

### Results

- ``ParsedResult``
- ``ParsingComponents``
- ``Certainty``

### Locales

- ``LocaleID``
- ``KhacLocale``
