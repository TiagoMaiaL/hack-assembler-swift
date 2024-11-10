// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "hasm",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "hasm",
            targets: ["hasm"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.3.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "hasm",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "hasm-tests",
            dependencies: ["hasm"]
        ),
    ]
)
