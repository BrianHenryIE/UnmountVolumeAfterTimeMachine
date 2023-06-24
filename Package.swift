// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnmountVolumeAfterTimeMachine",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
                name: "UnmountVolumeAfterTimeMachine",
                targets: ["UnmountVolumeAfterTimeMachine"]
        ),
    ],
    dependencies: [
        .package(
                url: "https://github.com/BrianHenryIE/SwiftTimeMachine",
                branch: "master"
        ),
        .package(
                url: "https://github.com/apple/swift-argument-parser.git",
                from: "1.2.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "UnmountVolumeAfterTimeMachine",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftTimeMachine", package: "SwiftTimeMachine")
            ]),
        .testTarget(
            name: "UnmountVolumeAfterTimeMachineTests",
            dependencies: ["UnmountVolumeAfterTimeMachine"]),
    ]
)
