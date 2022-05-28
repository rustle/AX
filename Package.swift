// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AX",
    platforms: [
        .macOS(.v11)
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
