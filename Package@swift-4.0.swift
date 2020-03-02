// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Half",

    products: [
        .library(name: "Half", targets: ["Half", "CHalf"])
    ],

    targets: [
        .target(name: "CHalf"),
        .testTarget(name: "CHalfTests", dependencies: ["CHalf"]),

        .target(name: "Half", dependencies: ["CHalf"]),
        .testTarget(name: "HalfTests", dependencies: ["Half"])
    ],

    swiftLanguageVersions: [4]
)
