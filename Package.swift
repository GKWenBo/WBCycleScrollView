// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "WBCycleScrollView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "WBCycleScrollView",
            targets: ["WBCycleScrollView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "WBCycleScrollView",
            dependencies: ["SDWebImage"],
            path: "WBCycleScrollView",
            exclude: [],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ],
            publicHeadersPath: ""
        )
    ]
) 