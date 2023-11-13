// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Half",

    platforms: [
        .iOS("12.0"),
        .macOS("10.13"),
        .tvOS("12.0"),
        .watchOS("4.0")
    ],

    products: [
        .library(name: "Half", targets: ["Half", "CHalf"])
    ],

    targets: [
        .target(name: "CHalf"),
        .testTarget(name: "CHalfTests", dependencies: ["CHalf", "Half"]),

        .target(name: "Half", dependencies: ["CHalf"]),
        .testTarget(name: "HalfTests", dependencies: ["Half"])
    ]
)
