// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExamKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "ExamKit",
            targets: ["ExamKit"]
        ),
    ],
    targets: [
        .target(
            name: "ExamKit",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ExamKitTests",
            dependencies: ["ExamKit"]
        ),
    ]
)
