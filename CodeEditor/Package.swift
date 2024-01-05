// swift-tools-version:5.9

import PackageDescription

let package = Package(

  name: "CodeEditor",

  platforms: [
    .iOS(.v17)
  ],

  products: [
    .library(name: "CodeEditor", targets: [ "CodeEditor" ])
  ],

  dependencies: [
    .package(url: "https://github.com/raspu/Highlightr", from: "2.1.2"),
    .package(url: "https://github.com/ls1intum/artemis-ios-core-modules", from: "8.0.0"),
  ],

  targets: [
    .target(name: "CodeEditor", dependencies: [ "Highlightr", .product(name: "SharedModels", package: "artemis-ios-core-modules")])
  ]
)
