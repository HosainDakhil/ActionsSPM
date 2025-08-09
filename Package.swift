// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ActionsSPM",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ActionsSPM",
            targets: ["ActionsSPM"]),
    ],
    targets: [
        .target(
            name: "ActionsSPM",
            dependencies: []),
        .testTarget(
            name: "ActionsSPMTests",
            dependencies: ["ActionsSPM"]),
    ]
)
