// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AX",
    platforms: [
        // The API this wraps deploy as far back 10.0 but AXTextMarker isn't public until macOS 12 Montery
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "AX",
            targets: ["AX"]),
        .executable(
            name: "ObserverExample",
            targets: ["ObserverExample"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AX",
            dependencies: []),
        .executableTarget(
            name: "ObserverExample",
            dependencies: ["AX"]),
        .testTarget(
            name: "AXTests",
            dependencies: ["AX"]),
    ]
)
