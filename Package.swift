// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Hasm",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "Hasm",
            targets: ["Hasm"]
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
            name: "Hasm",
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
            name: "HasmTests",
            dependencies: ["Hasm"]
        ),
    ]
)
