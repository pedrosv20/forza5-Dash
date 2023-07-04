// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "CarDataRepository", targets: ["CarDataRepository"]),
        .library(name: "CarDataRepositoryLive", targets: ["CarDataRepositoryLive"]),
        .library(name: "NetworkProviders", targets: ["NetworkProviders"]),
        .library(name: "DashFeature", targets: ["DashFeature"]),
        .library(name: "DragyFeature", targets: ["DragyFeature"]),
        .library(name: "GForceFeature", targets: ["GForceFeature"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket", branch: "master"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main")
    ],
    targets: [
        .target(
            name: "CarDataRepository",
            dependencies: [
                .product(name: "Dependencies", package: "swift-composable-architecture")
            ]
        ),

        .target(
            name: "CarDataRepositoryLive",
            dependencies: [
                "CarDataRepository",
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
                "CarDataRepository",
                "CoreUI"
            ]
        ),
        
            .target(
                name: "DragyFeature",
                dependencies: [
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    "CarDataRepository",
                    "CoreUI"
                ]
            ),
        
            .target(
                name: "GForceFeature",
                dependencies: [
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    "CarDataRepository",
                    "CoreUI"
                ]
            ),

        .testTarget(
            name: "ModuleTests",
            dependencies: []
        ),
        
        .target(
            name: "CoreUI",
            dependencies: []
        ),        
    ]
)
