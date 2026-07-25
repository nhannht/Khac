// MergingRefiner.swift - the shared sweep that collapses adjacent results.
//
// chrono's MergingRefiner (common/abstractRefiners.ts) and the reason it is a
// ROLLING ACCUMULATOR rather than a pairwise sweep. On a successful merge the
// merged result stays as the left-hand side and is offered to the NEXT result,
// so a chain collapses in one pass:
//
//     A B C   ->   AB  offered to C   ->   ABC
//
// Khac previously carried four byte-identical copies of a pairwise loop that
// consumed both sides and stepped past them (`i += 2`). That can merge only one
// pair per neighbourhood, so the third element was stranded no matter how many
// times the refiner ran: "next tuesday +10 days +5 days" applied the first
// duration and left the second for the timezone refiner to misread as an offset,
// giving Aug 24 where chrono gives Aug 29.
//
// Running the pipeline more times would NOT have fixed it. chrono runs each
// refiner exactly once; the accumulator is what makes a single pass sufficient,
// and it is why chrono needs no fixpoint loop.
//
// A conforming refiner supplies only the pairwise decision. Khac folds chrono's
// `shouldMergeResults` and `mergeResults` into one optional-returning call,
// since every implementation here decides and builds in the same step.

import Foundation

/// A refiner that collapses adjacent results pairwise, left to right.
protocol MergingRefiner: Refiner {
    /// The single result `left` and `right` become, or nil to leave them apart.
    ///
    /// `left` may itself be the product of an earlier merge in this same pass,
    /// which is what lets a chain of three or more collapse.
    func merged(_ left: ParsedResult, _ right: ParsedResult, _ context: ParsingContext) -> ParsedResult?
}

extension MergingRefiner {
    func refine(_ context: ParsingContext, _ results: [ParsedResult]) -> [ParsedResult] {
        guard results.count > 1 else { return results }
        let sorted = results.sorted { $0.index < $1.index }

        var output: [ParsedResult] = []
        var current = sorted[0]
        for next in sorted.dropFirst() {
            if let combined = merged(current, next, context) {
                // Keep accumulating. `combined` is the left side next time round,
                // so the run collapses rather than stopping after one pair.
                current = combined
            } else {
                output.append(current)
                current = next
            }
        }
        output.append(current)
        return output
    }
}
