// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "friedapps",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "friedapps", targets: ["friedapps"]),
    ],
    targets: [
        .target(
            name: "friedapps",
            path: "src"
        ),
    ]
)
