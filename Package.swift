// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "Khac",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(name: "Khac", targets: ["Khac"]),
    ],
    targets: [
        .target(
            name: "Khac",
            path: "Sources/Khac"
        ),
        .testTarget(
            name: "KhacTests",
            dependencies: ["Khac"],
            path: "Tests/KhacTests"
        ),
    ]
)
