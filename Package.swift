// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "hasm",
    products: [
        .executable(
            name: "hasm",
            targets: ["hasm"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "hasm"
        ),
        .testTarget(
            name: "hasm-tests",
            dependencies: ["hasm"]
        ),
    ]
)
