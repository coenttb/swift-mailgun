// swift-tools-version: 6.3.3

import PackageDescription

extension String {
    static let mailgun: Self = "Mailgun"
    static let accountManagement: Self = "Mailgun AccountManagement"
    static let credentials: Self = "Mailgun Credentials"
    static let customMessageLimit: Self = "Mailgun CustomMessageLimit"
    static let domains: Self = "Mailgun Domains"
    static let dynamicIPPools: Self = "Mailgun DynamicIPPools"
    static let ipAddressWarmup: Self = "Mailgun IPAddressWarmup"
    static let ipAllowlist: Self = "Mailgun IPAllowlist"
    static let ipPools: Self = "Mailgun IPPools"
    static let ips: Self = "Mailgun IPs"
    static let keys: Self = "Mailgun Keys"
    static let lists: Self = "Mailgun Lists"
    static let messages: Self = "Mailgun Messages"
    static let reporting: Self = "Mailgun Reporting"
    static let routes: Self = "Mailgun Routes"
    static let subaccounts: Self = "Mailgun Subaccounts"
    static let suppressions: Self = "Mailgun Suppressions"
    static let templates: Self = "Mailgun Templates"
    static let users: Self = "Mailgun Users"
    static let webhooks: Self = "Mailgun Webhooks"
}

extension String {
    var tests: Self { self + " Tests" }
}

extension Target.Dependency {
    static var mailgun: Self { .target(name: .mailgun) }
    static var accountManagement: Self { .target(name: .accountManagement) }
    static var credentials: Self { .target(name: .credentials) }
    static var customMessageLimit: Self { .target(name: .customMessageLimit) }
    static var domains: Self { .target(name: .domains) }
    static var dynamicIPPools: Self { .target(name: .dynamicIPPools) }
    static var ipAddressWarmup: Self { .target(name: .ipAddressWarmup) }
    static var ipAllowlist: Self { .target(name: .ipAllowlist) }
    static var ipPools: Self { .target(name: .ipPools) }
    static var ips: Self { .target(name: .ips) }
    static var keys: Self { .target(name: .keys) }
    static var lists: Self { .target(name: .lists) }
    static var messages: Self { .target(name: .messages) }
    static var reporting: Self { .target(name: .reporting) }
    static var routes: Self { .target(name: .routes) }
    static var subaccounts: Self { .target(name: .subaccounts) }
    static var suppressions: Self { .target(name: .suppressions) }
    static var templates: Self { .target(name: .templates) }
    static var users: Self { .target(name: .users) }
    static var webhooks: Self { .target(name: .webhooks) }
}

extension Target.Dependency {
    static var mailgunStandard: Self { .product(name: "Mailgun Standard", package: "swift-mailgun-standard") }
    static var domainStandard: Self { .product(name: "Domain Standard", package: "swift-domain-standard") }
    static var emailAddressStandard: Self { .product(name: "EmailAddress Standard", package: "swift-emailaddress-standard") }
}

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
        .library(name: .mailgun, targets: [.mailgun]),
        .library(name: .accountManagement, targets: [.accountManagement]),
        .library(name: .credentials, targets: [.credentials]),
        .library(name: .customMessageLimit, targets: [.customMessageLimit]),
        .library(name: .domains, targets: [.domains]),
        .library(name: .dynamicIPPools, targets: [.dynamicIPPools]),
        .library(name: .ipAddressWarmup, targets: [.ipAddressWarmup]),
        .library(name: .ipAllowlist, targets: [.ipAllowlist]),
        .library(name: .ipPools, targets: [.ipPools]),
        .library(name: .ips, targets: [.ips]),
        .library(name: .keys, targets: [.keys]),
        .library(name: .lists, targets: [.lists]),
        .library(name: .messages, targets: [.messages]),
        .library(name: .reporting, targets: [.reporting]),
        .library(name: .routes, targets: [.routes]),
        .library(name: .subaccounts, targets: [.subaccounts]),
        .library(name: .suppressions, targets: [.suppressions]),
        .library(name: .templates, targets: [.templates]),
        .library(name: .users, targets: [.users]),
        .library(name: .webhooks, targets: [.webhooks]),
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
            name: .accountManagement,
            dependencies: [.mailgunStandard, .emailAddressStandard]
        ),
        .target(
            name: .credentials,
            dependencies: [.mailgunStandard, .domainStandard]
        ),
        .target(
            name: .customMessageLimit,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .domains,
            // Domain Keys, Domains, Domain Tracking, DKIM Security sub-clients share this target.
            dependencies: [.mailgunStandard, .domainStandard]
        ),
        .target(
            name: .dynamicIPPools,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .ipAddressWarmup,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .ipAllowlist,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .ipPools,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .ips,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .keys,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .lists,
            dependencies: [.mailgunStandard, .emailAddressStandard]
        ),
        .target(
            name: .messages,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .reporting,
            // Events, Logs, Metrics, Stats, Tags sub-clients share this target.
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .routes,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .subaccounts,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .suppressions,
            // Allowlist, Bounces, Complaints, Unsubscribe sub-clients share this target.
            dependencies: [.mailgunStandard, .emailAddressStandard]
        ),
        .target(
            name: .templates,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .users,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .webhooks,
            dependencies: [.mailgunStandard]
        ),
        .target(
            name: .mailgun,
            dependencies: [
                .mailgunStandard,
                .domainStandard,
                .emailAddressStandard,
                .accountManagement,
                .credentials,
                .customMessageLimit,
                .domains,
                .dynamicIPPools,
                .ipAddressWarmup,
                .ipAllowlist,
                .ipPools,
                .ips,
                .keys,
                .lists,
                .messages,
                .reporting,
                .routes,
                .subaccounts,
                .suppressions,
                .templates,
                .users,
                .webhooks,
            ]
        ),
        .testTarget(
            name: .mailgun.tests,
            dependencies: [.mailgun]
        ),
    ],
    swiftLanguageModes: [.v6]
)
