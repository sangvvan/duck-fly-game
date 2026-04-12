// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DuckFlyGame",
    platforms: [
        .iOS(.v15)
    ],
    targets: [
        .executableTarget(
            name: "DuckFlyGame",
            dependencies: []
        )
    ]
)
