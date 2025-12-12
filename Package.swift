// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NYT360Video",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "NYT360Video",
            targets: ["NYT360Video"]
        )
    ],
    targets: [
        .target(
            name: "NYT360Video",
            path: "Sources",
            publicHeadersPath: ".",
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("SceneKit"),
                .linkedFramework("SpriteKit"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreMotion")
            ]
        )
    ]
)

