// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Half",

    platforms: [
        .iOS("8.0"),
        .macOS("10.10"),
        .tvOS("9.0"),
        .watchOS("2.0")
    ],

    products: [
        .library(name: "Half", targets: ["Half", "CHalf"])
    ],

    targets: [
        .target(name: "CHalf"),
        .testTarget(name: "CHalfTests", dependencies: ["CHalf"]),

        .target(name: "Half", dependencies: ["CHalf"]),
        .testTarget(name: "HalfTests", dependencies: ["Half"])
    ],

    swiftLanguageVersions: [.version("4"), .version("4.2"), .version("5")]
)
