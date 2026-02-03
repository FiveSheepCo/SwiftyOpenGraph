// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyOpenGraph",
    platforms: [
        .macOS(.v12),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftyOpenGraph",
            targets: ["SwiftyOpenGraph"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/FiveSheepCo/AsyncNetworking.git", .branch("main")),
        .package(url: "https://github.com/scinfu/SwiftSoup", .branch("master")),
        .package(url: "https://github.com/FiveSheepCo/FiveKit.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftyOpenGraph",
            dependencies: ["SwiftSoup", "AsyncNetworking", "FiveKit"]
        ),
        .testTarget(
            name: "SwiftyOpenGraphTests",
            dependencies: ["SwiftyOpenGraph"],
            resources: [.copy("Examples")]
        ),
    ]
)
