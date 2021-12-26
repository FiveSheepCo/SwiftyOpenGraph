// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyOpenGraph",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftyOpenGraph",
            targets: ["SwiftyOpenGraph"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Quintschaf/SchafKit.git", .branch("master")),
        .package(url: "https://github.com/scinfu/SwiftSoup", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftyOpenGraph",
            dependencies: ["SwiftSoup", "SchafKit"]
        ),
        .testTarget(
            name: "SwiftyOpenGraphTests",
            dependencies: ["SwiftyOpenGraph"]
        ),
    ]
)
