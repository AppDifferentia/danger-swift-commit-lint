// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "DangerSwiftCommitLint",
    products: [
        .library(name: "DangerSwiftCommitLint", targets: ["DangerSwiftCommitLint"]),
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]), // dev
    ],
    dependencies: [
        .package(name: "danger-swift", url: "https://github.com/danger/swift", from: "3.0.0"),
        // Dev dependencies.
        .package(name: "DangerSwiftCoverage", url: "https://github.com/f-meloni/danger-swift-coverage", .upToNextMajor(from: "1.2.1")), // dev
        .package(url: "https://github.com/shibapm/Komondor", from: "1.0.0"), // dev
        .package(url: "https://github.com/shibapm/Rocket", from: "1.2.0"), // dev
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.48.0"), // dev
        .package(url: "https://github.com/realm/SwiftLint", from: "0.43.0"), // dev
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: [.product(name: "Danger", package: "danger-swift"), "DangerSwiftCoverage", "DangerSwiftCommitLint"]), // dev
        .target(name: "DangerSwiftCommitLint", dependencies: [.product(name: "Danger", package: "danger-swift")]),
        .testTarget(
            name: "DangerSwiftCommitLintTests",
            dependencies: ["DangerSwiftCommitLint"]
        ),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-commit": [
                "swift test --generate-linuxmain",
                "swift run swiftformat .",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
        "rocket": [
            "after": [
                "push",
            ],
        ],
    ]).write()
#endif
