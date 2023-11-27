// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftui-map-clusterizer",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MapClusterizer",
            targets: ["MapClusterizer"]),
    ],
    targets: [
        .target(
            name: "MapClusterizer"),
        .testTarget(
            name: "SwiftUIMapClusterizerTests",
            dependencies: ["MapClusterizer"]),
    ]
)
