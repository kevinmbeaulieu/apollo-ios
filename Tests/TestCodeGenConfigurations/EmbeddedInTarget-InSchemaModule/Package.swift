// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MySwiftPackage",
  platforms: [
    .macOS(.v10_14),
  ],
  products: [
    .library(
      name: "MySwiftPackage",
      targets: ["MySwiftPackage"]
    ),
  ],
  dependencies: [
    .package(name: "apollo-ios", path: "../../.."),
  ],
  targets: [
    .executableTarget(
      name: "MyApp",
      dependencies: [
        "MySwiftPackage",
        "ApolloWrapper"
      ]),
    .target(
      name: "ApolloWrapper",
      dependencies: [
        .product(name: "Apollo", package: "apollo-ios"),
        "MySwiftPackage"
      ]),
    .target(
      name: "MySwiftPackage",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ]),    
    .testTarget(
      name: "MySwiftPackageTests",
      dependencies: [
        "MySwiftPackage",
        .product(name: "Apollo", package: "apollo-ios"),
        .product(name: "ApolloTestSupport", package: "apollo-ios"),
      ]
    ),
  ]
)
