// swift-tools-version:5.10
import PackageDescription

// A separate package so the Khac library itself stays dependency-free. This one
// pulls in a competitor (SwiftyChrono) purely to measure it.
let package = Package(
    name: "KhacBenchmarks",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "BenchRunner", targets: ["BenchRunner"]),
    ],
    dependencies: [
        .package(name: "Khac", path: ".."),
        .package(
            url: "https://github.com/quire-io/SwiftyChrono.git",
            revision: "0d5da73cc59de3efe2bbb0c0ef77d0f8ff8c6c99"
        ),
    ],
    targets: [
        .executableTarget(
            name: "BenchRunner",
            dependencies: [
                .product(name: "Khac", package: "Khac"),
                .product(name: "SwiftyChrono", package: "SwiftyChrono"),
            ],
            path: "Sources/BenchRunner"
        ),
    ]
)
