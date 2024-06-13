// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "CoreDataRepository",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .macCatalyst(.v15),
    ],
    products: [
        .library(
            name: "CoreDataRepository",
            targets: ["CoreDataRepository"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-custom-dump.git",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "CoreDataRepository",
            resources: [.process("Resources")],
            swiftSettings: .swiftSix
        ),
        .testTarget(
            name: "CoreDataRepositoryTests",
            dependencies: [
                "CoreDataRepository",
                .product(name: "CustomDump", package: "swift-custom-dump"),
            ],
            swiftSettings: .swiftSix
        ),
    ]
)

extension [SwiftSetting] {
    static let swiftSix: Self = [
        .enableUpcomingFeature("BareSlashRegexLiterals"),
        .enableUpcomingFeature("ConciseMagicFile"),
        .enableUpcomingFeature("DeprecateApplicationMain"),
        .enableUpcomingFeature("DisableOutwardActorInference"),
        .enableUpcomingFeature("ForwardTrailingClosures"),
        .enableUpcomingFeature("ImportObjcForwardDeclarations"),
        .enableExperimentalFeature("StrictConcurrency"),
    ]
}
