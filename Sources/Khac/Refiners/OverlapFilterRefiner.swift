// OverlapFilterRefiner.swift - deterministic, order-independent overlap resolution.
//
// The spec's hardest requirement (point 4, testing gate, open risks): the winner
// of two overlapping results must NOT depend on parser registration order. Two
// stages, both order-independent:
//   1. Containment pre-pass: drop any result STRICTLY inside another's span. The
//      wider match wins containment outright (chrono's behavior), so a short
//      all-certain fragment ("now") cannot evict the wider span that holds it
//      ("5 days from now"). This is why isPreferred can be certain-count-first
//      (SPEC 3a-H0) without a fragment beating its container on score.
//   2. Greedy keep by a TOTAL preference order derived only from each result's
//      own fields (score, match length, index, parserRank, localeRank, stable
//      signature).
// Two runs over the same result set in any input order produce identical output.

import Foundation

struct OverlapFilterRefiner: Refiner {
    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        guard results.count > 1 else { return results }

        // Containment pre-pass: a result whose span is STRICTLY inside another's
        // is dropped before ranking, so the wider match always wins containment
        // regardless of certain-count. Without this, a short all-certain fragment
        // ("now") would evict the wider span that contains it ("5 days from now").
        let uncontained = results.filter { candidate in
            !results.contains { strictlyContains($0, candidate) }
        }

        // Best-first, by a total order. Independent of the incoming order.
        let ranked = uncontained.sorted { $0.isPreferred(over: $1) }

        var kept: [ParsedResult] = []
        for candidate in ranked where !kept.contains(where: { overlaps(candidate, $0) }) {
            kept.append(candidate)
        }

        return kept.sorted { $0.index < $1.index }
    }

    /// Half-open span overlap on original-text UTF-16 offsets.
    private func overlaps(_ a: ParsedResult, _ b: ParsedResult) -> Bool {
        a.index < b.rangeEnd && b.index < a.rangeEnd
    }

    /// True when `outer`'s span strictly contains `inner`'s: it covers inner and
    /// is strictly wider on at least one side. Equal spans do not contain each
    /// other (they stay competitors for the ranking to break).
    private func strictlyContains(_ outer: ParsedResult, _ inner: ParsedResult) -> Bool {
        outer.index <= inner.index && inner.rangeEnd <= outer.rangeEnd
            && (outer.index < inner.index || inner.rangeEnd < outer.rangeEnd)
    }
}
