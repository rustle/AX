// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AX",
    platforms: [
        .macOS(.v10_10) // The API this wraps deploy as far back 10.0 but Swift doesn't 🤷‍♂️
    ],
    products: [
        .library(
            name: "AX",
            targets: ["AX"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AX",
            dependencies: []),
        .testTarget(
            name: "AXTests",
            dependencies: ["AX"]),
    ]
)
