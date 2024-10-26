// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ignite",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "Ignite", targets: ["Ignite"]),
        .executable(name: "IgniteCLI", targets: ["IgniteCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-markdown.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Ignite",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown")
            ],
            resources: [
                .copy("Resources")
            ]
        ),
        .executableTarget(
            name: "IgniteCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "IgniteTests",
            dependencies: ["Ignite"])
    ]
)
