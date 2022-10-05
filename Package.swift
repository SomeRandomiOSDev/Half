// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Half",

    platforms: [
        .iOS("11.0"),
        .macOS("10.10"),
        .tvOS("11.0"),
        .watchOS("4.0")
    ],

    products: [
        .library(name: "Half", targets: ["Half", "CHalf"])
    ],

    targets: [
        .target(name: "CHalf"),
        .testTarget(name: "CHalfTests", dependencies: ["CHalf", "Half"]),

        .target(name: "Half", dependencies: ["CHalf"], exclude: ["Half.swift.gyb"]),
        .testTarget(name: "HalfTests", dependencies: ["Half"])
    ],

    swiftLanguageVersions: [.version("4"), .version("4.2"), .version("5")]
)
