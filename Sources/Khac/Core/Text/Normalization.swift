// Normalization.swift - NFC folding with an index map back to the original text.
//
// The engine matches against an NFC-normalized copy of the input so that
// decomposed text (a real bug for Vietnamese, where "ế" may arrive as U+0065
// U+0302 U+0301 instead of U+1EBF) matches patterns written in composed form.
//
// Case is handled by the regex .caseInsensitive flag, not by mutating text.
// Diacritics are preserved (accent stripping is an explicit non-goal). NFC is
// therefore the only length-changing transform, and it never crosses grapheme
// boundaries: it only recomposes marks WITHIN a grapheme cluster, never merges
// or splits clusters. So per-grapheme NFC equals whole-string NFC, and we can
// record a boundary map to translate any normalized offset back to the original.

import Foundation

/// The NFC-normalized form of a text plus a map from normalized UTF-16 offsets
/// (at grapheme boundaries) back to positions in the original text.
public struct NormalizedText {
    /// The caller's original, un-normalized text.
    public let original: String
    /// The NFC-normalized text the engine matches against.
    public let normalized: String

    /// Grapheme-boundary offsets in `normalized`, UTF-16 units, ascending,
    /// including 0 and the end. Parallel to `originalBoundaryIndices`.
    private let normalizedBoundaries: [Int]
    /// Parallel original String.Index at each boundary.
    private let originalBoundaryIndices: [String.Index]
    /// Parallel original UTF-16 offset at each boundary, ascending. The same
    /// positions as `originalBoundaryIndices`, counted rather than indexed, so a
    /// caller holding an original OFFSET can binary-search instead of walking.
    private let originalBoundaryOffsets: [Int]

    public init(original: String) {
        self.original = original

        var norm = ""
        norm.reserveCapacity(original.count)
        var nBoundaries: [Int] = [0]
        var oIndices: [String.Index] = [original.startIndex]
        var oOffsets: [Int] = [0]

        var normalizedOffset = 0
        var originalOffset = 0
        var originalIndex = original.startIndex
        for character in original {
            let composed = String(character).precomposedStringWithCanonicalMapping
            norm += composed
            normalizedOffset += composed.utf16.count
            originalOffset += String(character).utf16.count
            originalIndex = original.index(after: originalIndex)
            nBoundaries.append(normalizedOffset)
            oIndices.append(originalIndex)
            oOffsets.append(originalOffset)
        }

        self.normalized = norm
        self.normalizedBoundaries = nBoundaries
        self.originalBoundaryIndices = oIndices
        self.originalBoundaryOffsets = oOffsets
    }

    /// Index of the last boundary at or before `offset` in an ascending boundary
    /// array. Shared by both directions so they snap the same way.
    private static func boundary(atOrBefore offset: Int, in boundaries: [Int]) -> Int {
        var low = 0
        var high = boundaries.count - 1
        while low < high {
            let mid = (low + high + 1) / 2
            if boundaries[mid] <= offset {
                low = mid
            } else {
                high = mid - 1
            }
        }
        return low
    }

    /// The original String.Index for a normalized UTF-16 offset. Matches from the
    /// generic parsers land on grapheme boundaries; a mid-grapheme offset (only
    /// possible from a pathological custom pattern) snaps down to the enclosing
    /// boundary so the returned index is always valid.
    public func originalIndex(forNormalizedUTF16 offset: Int) -> String.Index {
        originalBoundaryIndices[Self.boundary(atOrBefore: offset, in: normalizedBoundaries)]
    }

    /// The INVERSE of `originalUTF16Offset(forNormalizedUTF16:)`: the normalized
    /// UTF-16 offset for an original one.
    ///
    /// This is what lets a refiner scanning FORWARD from a result work in the
    /// coordinates the engine matches in. `ParsedResult.index`, `matchLength` and
    /// `rangeEnd` are all ORIGINAL offsets, so a refiner starting from one has no
    /// other route into normalized space, and matching a vocabulary-built pattern
    /// against the original string is the bug this exists to prevent - patterns
    /// are folded to NFC, real input often is not.
    ///
    /// Snaps DOWN to the enclosing grapheme boundary, exactly as the forward
    /// direction does. Offsets that come from a `ParsedResult` are already on a
    /// boundary, so the snap only ever fires on a hand-built offset.
    public func normalizedUTF16Offset(forOriginalUTF16 offset: Int) -> Int {
        normalizedBoundaries[Self.boundary(atOrBefore: offset, in: originalBoundaryOffsets)]
    }

    /// The original-text range for a normalized UTF-16 range.
    public func originalRange(forNormalizedUTF16 range: Range<Int>) -> Range<String.Index> {
        let start = originalIndex(forNormalizedUTF16: range.lowerBound)
        let end = originalIndex(forNormalizedUTF16: range.upperBound)
        return start..<end
    }

    /// The original-text UTF-16 offset for a normalized UTF-16 offset. Reads the
    /// boundary array rather than re-walking the string, so it agrees with
    /// `normalizedUTF16Offset(forOriginalUTF16:)` by construction instead of by
    /// two implementations happening to round the same way.
    public func originalUTF16Offset(forNormalizedUTF16 offset: Int) -> Int {
        originalBoundaryOffsets[Self.boundary(atOrBefore: offset, in: normalizedBoundaries)]
    }

    /// The original substring for a normalized UTF-16 range.
    public func originalSubstring(forNormalizedUTF16 range: Range<Int>) -> String {
        String(original[originalRange(forNormalizedUTF16: range)])
    }
}
