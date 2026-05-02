// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "AX",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "AX",
            targets: ["AX"]),
        .executable(
            name: "ObserverExample",
            targets: ["ObserverExample"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AX",
            dependencies: []),
        .executableTarget(
            name: "ObserverExample",
            dependencies: ["AX"]),
        .testTarget(
            name: "AXTests",
            dependencies: [
                "AX",
            ]),
    ],
    swiftLanguageModes: [.v6]
)
