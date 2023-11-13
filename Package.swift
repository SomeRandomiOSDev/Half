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

        .target(name: "Half", dependencies: ["CHalf"]),
        .testTarget(name: "HalfTests", dependencies: ["Half"])
    ]
)
