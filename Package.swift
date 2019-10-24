// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StiKit",
    platforms: [.iOS(SupportedPlatform.IOSVersion.v11)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "StiKit",
            targets: ["StiKit"]),
        .library(
            name: "StiKitTableView",
            targets: ["StiKitTableView"]),
        .library(
            name: "StiKitExtensions",
            targets: ["StiKitExtensions"]),
        .library(
            name: "StiKitUtilities",
            targets: ["StiKitUtilities"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "StiKit",
            dependencies: []),
        .target(
            name: "StiKitTableView",
            dependencies: ["StiKitUtilities"]),
        .target(
            name: "StiKitExtensions",
            dependencies: []),
        .target(
            name: "StiKitUtilities",
            dependencies: ["StiKitExtensions"]),
        .testTarget(
            name: "StiKitTests",
            dependencies: ["StiKit"]),
    ]
)
