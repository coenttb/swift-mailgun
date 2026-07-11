// swift-tools-version: 6.3.3

import Foundation
import PackageDescription

extension String {
    static let mailgun: Self = "Mailgun"
    static let accountManagement: Self = "Mailgun AccountManagement"
    static let credentials: Self = "Mailgun Credentials"
    static let customMessageLimit: Self = "Mailgun CustomMessageLimit"
    static let domains: Self = "Mailgun Domains"
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
    static let shared: Self = "Mailgun Shared"
}

extension Target.Dependency {
    static var mailgun: Self { .target(name: .mailgun) }
    static var accountManagement: Self { .target(name: .accountManagement) }
    static var credentials: Self { .target(name: .credentials) }
    static var customMessageLimit: Self { .target(name: .customMessageLimit) }
    static var domains: Self { .target(name: .domains) }
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
    static var shared: Self { .target(name: .shared) }
}

extension Target.Dependency {
    static var dependenciesTestSupport: Self { .product(name: "Dependencies Test Support", package: "swift-dependencies") }
    static var email: Self { .product(name: "Email", package: "swift-email") }
}

extension Target.Dependency {
    static var mailgunLive: Self { .product(name: "Mailgun Live", package: "swift-mailgun-live") }
    static var accountManagementLive: Self { .product(name: "Mailgun AccountManagement Live", package: "swift-mailgun-live") }
    static var credentialsLive: Self { .product(name: "Mailgun Credentials Live", package: "swift-mailgun-live") }
    static var customMessageLimitLive: Self { .product(name: "Mailgun CustomMessageLimit Live", package: "swift-mailgun-live") }
    static var domainsLive: Self { .product(name: "Mailgun Domains Live", package: "swift-mailgun-live") }
    static var eventsLive: Self { .product(name: "Mailgun Reporting Live", package: "swift-mailgun-live") }
    static var ipAllowlistLive: Self { .product(name: "Mailgun IPAllowlist Live", package: "swift-mailgun-live") }
    static var ipPoolsLive: Self { .product(name: "Mailgun IPPools Live", package: "swift-mailgun-live") }
    static var ipsLive: Self { .product(name: "Mailgun IPs Live", package: "swift-mailgun-live") }
    static var keysLive: Self { .product(name: "Mailgun Keys Live", package: "swift-mailgun-live") }
    static var listsLive: Self { .product(name: "Mailgun Lists Live", package: "swift-mailgun-live") }
    static var messagesLive: Self { .product(name: "Mailgun Messages Live", package: "swift-mailgun-live") }
    static var reportingLive: Self { .product(name: "Mailgun Reporting Live", package: "swift-mailgun-live") }
    static var routesLive: Self { .product(name: "Mailgun Routes Live", package: "swift-mailgun-live") }
    static var subaccountsLive: Self { .product(name: "Mailgun Subaccounts Live", package: "swift-mailgun-live") }
    static var suppressionsLive: Self { .product(name: "Mailgun Suppressions Live", package: "swift-mailgun-live") }
    static var tagsLive: Self { .product(name: "Mailgun Reporting Live", package: "swift-mailgun-live") }
    static var templatesLive: Self { .product(name: "Mailgun Templates Live", package: "swift-mailgun-live") }
    static var usersLive: Self { .product(name: "Mailgun Users Live", package: "swift-mailgun-live") }
    static var webhooksLive: Self { .product(name: "Mailgun Webhooks Live", package: "swift-mailgun-live") }
    static var mailgunLiveShared: Self { .product(name: "Mailgun Shared Live", package: "swift-mailgun-live") }
}

let package = Package(
    name: "swift-mailgun",
    platforms: [
        .macOS(.v26),
        .iOS(.v26)
    ],
    products: [
        .library(name: .mailgun, targets: [.mailgun]),
        .library(name: .accountManagement, targets: [.accountManagement]),
        .library(name: .credentials, targets: [.credentials]),
        .library(name: .customMessageLimit, targets: [.customMessageLimit]),
        .library(name: .domains, targets: [.domains]),
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
        .library(name: .shared, targets: [.shared])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-mailgun-live.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-email.git", branch: "main"),
    ],
    targets: [
        .target(
            name: .shared,
            dependencies: [
                .mailgunLiveShared,
            ]
        ),
        .target(
            name: .mailgun,
            dependencies: [
                .shared,
                .mailgunLiveShared,
                .mailgunLive,
                .accountManagement,
                .credentialsLive,
                .customMessageLimit,
                .domainsLive,
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
                .webhooks
            ]
        ),
        .testTarget(
            name: .mailgun.tests,
            dependencies: [
                .mailgun,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .accountManagement,
            dependencies: [
                .shared,
                .mailgunLiveShared,
                .accountManagementLive
            ]
        ),
        .testTarget(
            name: .accountManagement.tests,
            dependencies: [.accountManagement, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .credentials,
            dependencies: [
                .shared,
                .mailgunLiveShared,
                .credentialsLive
            ]
        ),
        .testTarget(
            name: .credentials.tests,
            dependencies: [.credentials, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .customMessageLimit,
            dependencies: [
                .shared,
                .mailgunLiveShared,
                .customMessageLimitLive
            ]
        ),
        .testTarget(
            name: .customMessageLimit.tests,
            dependencies: [.customMessageLimit, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .domains,
            dependencies: [
                .shared,
                .mailgunLiveShared,
                .domainsLive
            ]
        ),
        .testTarget(
            name: .domains.tests,
            dependencies: [.domains, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ipAllowlist,
            dependencies: [
                .shared,
                .mailgunLiveShared,
                .ipAllowlistLive
            ]
        ),
        .testTarget(
            name: .ipAllowlist.tests,
            dependencies: [.ipAllowlist, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ipPools,
            dependencies: [
                .ipPoolsLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .ipPools.tests,
            dependencies: [.ipPools, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ips,
            dependencies: [
                .ipsLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .ips.tests,
            dependencies: [.ips, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .keys,
            dependencies: [
                .keysLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .keys.tests,
            dependencies: [.keys, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .lists,
            dependencies: [
                .listsLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .lists.tests,
            dependencies: [.lists, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .messages,
            dependencies: [
                .messagesLive,
                .shared,
                .mailgunLiveShared,
                .email
            ]
        ),
        .testTarget(
            name: .messages.tests,
            dependencies: [.messages, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .reporting,
            dependencies: [
                .reportingLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .reporting.tests,
            dependencies: [.reporting, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .routes,
            dependencies: [
                .routesLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .routes.tests,
            dependencies: [.routes, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .subaccounts,
            dependencies: [
                .subaccountsLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .subaccounts.tests,
            dependencies: [.subaccounts, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .suppressions,
            dependencies: [
                .suppressionsLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .suppressions.tests,
            dependencies: [.suppressions, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .templates,
            dependencies: [
                .templatesLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .templates.tests,
            dependencies: [.templates, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .users,
            dependencies: [
                .usersLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .users.tests,
            dependencies: [.users, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .webhooks,
            dependencies: [
                .webhooksLive,
                .shared,
                .mailgunLiveShared
            ]
        ),
        .testTarget(
            name: .webhooks.tests,
            dependencies: [.webhooks, .shared, .dependenciesTestSupport]
        )
    ]
)

extension String {
    var tests: Self { self + " Tests" }
    var types: Self { self + " Types" }
}
