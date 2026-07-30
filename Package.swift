// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-mailgun",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Mailgun",
            targets: ["Mailgun"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-standards/swift-mailgun-standard.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-standards/swift-domain-standard.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-standards/swift-emailaddress-standard.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Mailgun",
            dependencies: [
                .product(name: "Mailgun Standard", package: "swift-mailgun-standard"),
                // `Domain` parameter type on the domain-scoped clients (Credentials, Domains,
                // Domain Keys, Domain Tracking, DKIM Security).
                .product(name: "Domain Standard", package: "swift-domain-standard"),
                // `EmailAddress` parameter type across Messages, Lists, Suppressions,
                // AccountManagement, and Users clients.
                .product(name: "EmailAddress Standard", package: "swift-emailaddress-standard"),
            ]
        ),
        .testTarget(
            name: "Mailgun Tests",
            dependencies: ["Mailgun"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
