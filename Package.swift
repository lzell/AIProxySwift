// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AIProxy",
    platforms: [
         .iOS(.v15),
         .macOS(.v13),
         .visionOS(.v1),
         .watchOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AIProxy",
            targets: ["AIProxy"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AIProxy",
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6),

                // From the docs, this should work to set the default isolation to nonisolated.
                // But I've found that I still need to manually annotate types/functions with `nonisolated`.
                // Apple's docs state:
                //
                //   The compiler defaults to inferring unannotated code as nonisolated if unspecified,
                //   or if the isolation parameter is set to nil.
                //
                // Source: https://developer.apple.com/documentation/packagedescription/swiftsetting/defaultisolation(_:_:)
                //
                // Doug Gregor recommends nonisolated as the default for libraries in "Embracing Swift Concurrency" WWDC
                // https://developer.apple.com/videos/play/wwdc2025/268/?time=849
                //
                // I don't fully adhere to that in the lib, because many of the public async APIs I annotate with @AIProxyActor.
                // My thinking is that it's better to automatically get off the main thread without placing any burden on the caller.
                .defaultIsolation(nil),

                .enableUpcomingFeature("NonisolatedNonsendingByDefault")
            ]
        ),
        .testTarget(
            name: "AIProxyTests",
            dependencies: ["AIProxy"]
        ),
    ]
)
