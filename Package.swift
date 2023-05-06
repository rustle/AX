// swift-tools-version:5.8

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
    dependencies: [
        .package(url: "https://github.com/rustle/dyldoverlay.git",
                 from: "0.1.0")
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
            dependencies: [
                "AX",
                "dyldoverlay",
            ]),
    ]
)
