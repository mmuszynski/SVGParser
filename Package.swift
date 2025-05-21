// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SVGParser",
    platforms: [.macOS(.v13), .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SVGParser",
            targets: ["SVGParser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SVGParser",
            dependencies: ["ExampleExpansionMacros"],
            exclude: ["Info.plist"],
            resources: [.process("Example Images")]),
        .testTarget(
            name: "SVGParserTests",
            dependencies: ["SVGParser"],
            exclude: ["Info.plist"],
            resources: [.process("Example Images")]),
        .macro(
            name: "ExampleExpansionMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
    ]
)
