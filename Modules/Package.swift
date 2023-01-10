// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "DashRepository", targets: ["DashRepository"]),
        .library(name: "DashRepositoryLive", targets: ["DashRepositoryLive"]),
        .library(name: "NetworkProviders", targets: ["NetworkProviders"]),
        .library(name: "DashFeature", targets: ["DashFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket", branch: "master"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main")
    ],
    targets: [
        .target(
            name: "DashRepository",
            dependencies: [
                .product(name: "Dependencies", package: "swift-composable-architecture")
            ]
        ),

        .target(
            name: "DashRepositoryLive",
            dependencies: [
                "DashRepository",
                "NetworkProviders"
            ]
        ),

        .target(
            name: "NetworkProviders",
            dependencies: [
                .product(name: "CocoaAsyncSocket", package: "CocoaAsyncSocket")
            ]
        ),
        
        .target(
            name: "DashFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CocoaAsyncSocket", package: "CocoaAsyncSocket"),
                "DashRepositoryLive",
                "DashRepository"
            ]
        ),

        .testTarget(
            name: "ModuleTests",
            dependencies: []
        )
        
        
    ]
)
