// swift-tools-version:5.7

import PackageDescription

let package = Package(

  name: "CodeEditor",

  platforms: [
    .iOS(.v16)
  ],

  products: [
    .library(name: "CodeEditor", targets: [ "CodeEditor" ])
  ],

  dependencies: [
    .package(url: "https://github.com/raspu/Highlightr", from: "2.1.2"),
    .package(url: "https://github.com/ls1intum/artemis-ios-core-modules", from: "3.3.2"),
  ],

  targets: [
    .target(name: "CodeEditor", dependencies: [ "Highlightr", .product(name: "SharedModels", package: "artemis-ios-core-modules")])
  ]
)
