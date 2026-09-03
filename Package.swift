// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-mailgun",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27"),
    ],
    products: [
        .library(name: "Mailgun", targets: ["Mailgun"]),
        .library(name: "Mailgun AccountManagement", targets: ["Mailgun AccountManagement"]),
        .library(name: "Mailgun Credentials", targets: ["Mailgun Credentials"]),
        .library(name: "Mailgun CustomMessageLimit", targets: ["Mailgun CustomMessageLimit"]),
        .library(name: "Mailgun Domains", targets: ["Mailgun Domains"]),
        .library(name: "Mailgun DynamicIPPools", targets: ["Mailgun DynamicIPPools"]),
        .library(name: "Mailgun IPAddressWarmup", targets: ["Mailgun IPAddressWarmup"]),
        .library(name: "Mailgun IPAllowlist", targets: ["Mailgun IPAllowlist"]),
        .library(name: "Mailgun IPPools", targets: ["Mailgun IPPools"]),
        .library(name: "Mailgun IPs", targets: ["Mailgun IPs"]),
        .library(name: "Mailgun Keys", targets: ["Mailgun Keys"]),
        .library(name: "Mailgun Lists", targets: ["Mailgun Lists"]),
        .library(name: "Mailgun Messages", targets: ["Mailgun Messages"]),
        .library(name: "Mailgun Reporting", targets: ["Mailgun Reporting"]),
        .library(name: "Mailgun Routes", targets: ["Mailgun Routes"]),
        .library(name: "Mailgun Subaccounts", targets: ["Mailgun Subaccounts"]),
        .library(name: "Mailgun Suppressions", targets: ["Mailgun Suppressions"]),
        .library(name: "Mailgun Templates", targets: ["Mailgun Templates"]),
        .library(name: "Mailgun Users", targets: ["Mailgun Users"]),
        .library(name: "Mailgun Webhooks", targets: ["Mailgun Webhooks"]),
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
            name: "Mailgun AccountManagement",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard"), .product(name: "EmailAddress Standard", package: "swift-emailaddress-standard")]
        ),
        .target(
            name: "Mailgun Credentials",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard"), .product(name: "Domain Standard", package: "swift-domain-standard")]
        ),
        .target(
            name: "Mailgun CustomMessageLimit",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Domains",
            // Domain Keys, Domains, Domain Tracking, DKIM Security sub-clients share this target.
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard"), .product(name: "Domain Standard", package: "swift-domain-standard")]
        ),
        .target(
            name: "Mailgun DynamicIPPools",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun IPAddressWarmup",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun IPAllowlist",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun IPPools",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun IPs",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Keys",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Lists",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard"), .product(name: "EmailAddress Standard", package: "swift-emailaddress-standard")]
        ),
        .target(
            name: "Mailgun Messages",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Reporting",
            // Events, Logs, Metrics, Stats, Tags sub-clients share this target.
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Routes",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Subaccounts",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Suppressions",
            // Allowlist, Bounces, Complaints, Unsubscribe sub-clients share this target.
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard"), .product(name: "EmailAddress Standard", package: "swift-emailaddress-standard")]
        ),
        .target(
            name: "Mailgun Templates",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Users",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun Webhooks",
            dependencies: [.product(name: "Mailgun Standard", package: "swift-mailgun-standard")]
        ),
        .target(
            name: "Mailgun",
            dependencies: [
                .product(name: "Mailgun Standard", package: "swift-mailgun-standard"),
                .product(name: "Domain Standard", package: "swift-domain-standard"),
                .product(name: "EmailAddress Standard", package: "swift-emailaddress-standard"),
                .target(name: "Mailgun AccountManagement"),
                .target(name: "Mailgun Credentials"),
                .target(name: "Mailgun CustomMessageLimit"),
                .target(name: "Mailgun Domains"),
                .target(name: "Mailgun DynamicIPPools"),
                .target(name: "Mailgun IPAddressWarmup"),
                .target(name: "Mailgun IPAllowlist"),
                .target(name: "Mailgun IPPools"),
                .target(name: "Mailgun IPs"),
                .target(name: "Mailgun Keys"),
                .target(name: "Mailgun Lists"),
                .target(name: "Mailgun Messages"),
                .target(name: "Mailgun Reporting"),
                .target(name: "Mailgun Routes"),
                .target(name: "Mailgun Subaccounts"),
                .target(name: "Mailgun Suppressions"),
                .target(name: "Mailgun Templates"),
                .target(name: "Mailgun Users"),
                .target(name: "Mailgun Webhooks"),
            ]
        ),
        .testTarget(
            name: "Mailgun Tests",
            dependencies: [.target(name: "Mailgun")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
