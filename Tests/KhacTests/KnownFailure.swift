// KnownFailure.swift - a portable stand-in for XCTExpectFailure.
//
// XCTExpectFailure exists only in Apple's XCTest; swift-corelibs-xctest has
// never implemented it, so any file naming it fails to COMPILE on Linux and
// the whole test target dies with it. On Apple platforms a deferral case
// keeps the full expect-failure contract, including the alert when a fixed
// case starts passing. On corelibs platforms the case is not executed at
// all: corelibs offers no way to record a failure and forgive it, and a
// deferral that ran there would fail the suite. The deferral registries in
// the oracle tests stay the single source of truth on every platform.

import XCTest

func expectKnownFailure(_ reason: String, _ body: () -> Void) {
    #if canImport(ObjectiveC)
    XCTExpectFailure(reason, failingBlock: body)
    #else
    _ = reason
    _ = body
    #endif
}
