// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftWasmZlib",
    products: [
        .library(
            name: "SwiftWasmZlib",
            targets: ["SwiftWasmZlib"]),
    ],
    targets: [
        .target(
            name: "SwiftWasmZlib",
            dependencies: []),
        .testTarget(
            name: "SwiftWasmZlibTests",
            dependencies: ["SwiftWasmZlib"]),
    ]
)
