// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Flossy",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Flossy",
            targets: [
                "Flossy",
                "FlossyData",
                "FlossyStreak",
                "FlossyDesignSystem"
            ]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Flossy"
        ),
        .target(
            name: "FlossyData"
        ),
        .target(
            name: "FlossyStreak"
        ),
        .target(
            name: "FlossyDesignSystem",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "FlossyTests",
            dependencies: ["Flossy"]
        ),
        .testTarget(
            name: "FlossyDataTests",
            dependencies: ["FlossyData"]
        ),
        .testTarget(
            name: "FlossyStreakTests",
            dependencies: ["FlossyStreak"]
        )
    ],
    swiftLanguageModes: [.v6]
)
