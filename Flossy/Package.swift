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
                "FlossyData",
                "FlossyCore",
                "FlossyDesignSystem",
                "FlossyReminders"
            ]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FlossyData"
        ),
        .target(
            name: "FlossyCore",
            dependencies: ["FlossyData", "FlossyReminders"]
        ),
        .target(
            name: "FlossyDesignSystem",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "FlossyReminders"
        ),
        .testTarget(
            name: "FlossyDataTests",
            dependencies: ["FlossyData"]
        ),
        .testTarget(
            name: "FlossyCoreTests",
            dependencies: ["FlossyCore"]
        ),
        .testTarget(
            name: "FlossyRemindersTests",
            dependencies: ["FlossyReminders"]
        )
    ],
    swiftLanguageModes: [.v6]
)
