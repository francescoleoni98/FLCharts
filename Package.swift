// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FLCharts",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "FLCharts",
            targets: ["FLCharts"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FLCharts",
            dependencies: [],
            resources: [
                .process("Assets/Colors.xcassets")
            ])
    ],
    swiftLanguageVersions: [.v5]
)
