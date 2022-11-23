// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XLogConsole",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "XLogConsole",
            targets: ["XLogConsole"])
    ],	
    dependencies: [
    ],
    targets: [
        .target(
            name: "XLogConsole",
            dependencies: [],
            path: "Sources",
            sources: ["Classes","Helper/Swift"],
            resources: [.copy("Assets/Images.xcassets")]
        )
    ]
)
