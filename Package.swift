// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let mailgun: Self = "Mailgun"
    static let credentials: Self = "Credentials"
    static let customMessageLimit: Self = "CustomMessageLimit"
    static let domains: Self = "Domains"
    static let events: Self = "Events"
    static let iPAllowlist: Self = "IPAllowlist"
    static let ipPools: Self = "IPPools"
    static let ips: Self = "IPs"
    static let keys: Self = "Keys"
    static let lists: Self = "Lists"
    static let messages: Self = "Messages"
    static let reporting: Self = "Reporting"
    static let routes: Self = "Routes"
    static let subaccounts: Self = "Subaccounts"
    static let suppressions: Self = "Suppressions"
    static let tags: Self = "Tags"
    static let templates: Self = "Templates"
    static let users: Self = "Users"
    static let webhooks: Self = "Webhooks"
    static let shared: Self = "Shared"
}

extension Target.Dependency {
    static var mailgun: Self { .target(name: .mailgun) }
    static var credentials: Self { .target(name: .credentials) }
    static var customMessageLimit: Self { .target(name: .customMessageLimit) }
    static var domains: Self { .target(name: .domains) }
    static var events: Self { .target(name: .events) }
    static var iPAllowlist: Self { .target(name: .iPAllowlist) }
    static var ipPools: Self { .target(name: .ipPools) }
    static var ips: Self { .target(name: .ips) }
    static var keys: Self { .target(name: .keys) }
    static var lists: Self { .target(name: .lists) }
    static var messages: Self { .target(name: .messages) }
    static var reporting: Self { .target(name: .reporting) }
    static var routes: Self { .target(name: .routes) }
    static var subaccounts: Self { .target(name: .subaccounts) }
    static var suppressions: Self { .target(name: .suppressions) }
    static var tags: Self { .target(name: .tags) }
    static var templates: Self { .target(name: .templates) }
    static var users: Self { .target(name: .users) }
    static var webhooks: Self { .target(name: .webhooks) }
    static var shared: Self { .target(name: .shared) }
}

extension Target.Dependency {
    static var coenttbWeb: Self { .product(name: "Coenttb Web", package: "coenttb-web") }
    static var basicAuth: Self { .product(name: "BasicAuth", package: "swift-authentication") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }
    static var coenttbAuthentication: Self { .product(name: "Coenttb Authentication", package: "coenttb-authentication") }
}

let package = Package(
    name: "coenttb-mailgun",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: .mailgun, targets: [.mailgun]),
        .library(name: .credentials, targets: [.credentials]),
        .library(name: .customMessageLimit, targets: [.customMessageLimit]),
        .library(name: .domains, targets: [.domains]),
        .library(name: .events, targets: [.events]),
        .library(name: .iPAllowlist, targets: [.iPAllowlist]),
        .library(name: .ipPools, targets: [.ipPools]),
        .library(name: .ips, targets: [.ips]),
        .library(name: .keys, targets: [.keys]),
        .library(name: .lists, targets: [.lists]),
        .library(name: .messages, targets: [.messages]),
        .library(name: .reporting, targets: [.reporting]),
        .library(name: .routes, targets: [.routes]),
        .library(name: .subaccounts, targets: [.subaccounts]),
        .library(name: .suppressions, targets: [.suppressions]),
        .library(name: .tags, targets: [.tags]),
        .library(name: .templates, targets: [.templates]),
        .library(name: .users, targets: [.users]),
        .library(name: .webhooks, targets: [.webhooks]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb-web", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-authentication", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.4.3"),
    ],
    targets: [
        .target(
            name: .shared,
            dependencies: [
                .coenttbWeb,
                .issueReporting,
                .coenttbAuthentication
            ]
        ),
        .target(
            name: .mailgun,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
                .credentials,
                .customMessageLimit,
                .domains,
                .events,
                .iPAllowlist,
                .ipPools,
                .ips,
                .keys,
                .lists,
                .messages,
                .reporting,
                .routes,
                .subaccounts,
                .suppressions,
                .tags,
                .templates,
                .users,
                .webhooks,
            ]
        ),
        .testTarget(
            name: .mailgun + " Tests",
            dependencies: [
                .mailgun,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .credentials,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
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
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
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
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .domains.tests,
            dependencies: [.domains, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .events,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .events.tests,
            dependencies: [.events, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .iPAllowlist,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .iPAllowlist.tests,
            dependencies: [.iPAllowlist, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ipPools,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .ipPools.tests,
            dependencies: [.ipPools, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ips,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .ips.tests,
            dependencies: [.ips, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .keys,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .keys.tests,
            dependencies: [.keys, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .lists,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .lists.tests,
            dependencies: [.lists, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .messages,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .messages.tests,
            dependencies: [.messages, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .reporting,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .reporting.tests,
            dependencies: [.reporting, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .routes,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .routes.tests,
            dependencies: [.routes, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .subaccounts,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .subaccounts.tests,
            dependencies: [.subaccounts, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .suppressions,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .suppressions.tests,
            dependencies: [.suppressions, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .tags,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .tags.tests,
            dependencies: [.tags, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .templates,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .templates.tests,
            dependencies: [.templates, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .users,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .users.tests,
            dependencies: [.users, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .webhooks,
            dependencies: [
                .shared,
                .coenttbWeb,
                .issueReporting,
                .dependenciesMacros,
            ]
        ),
        .testTarget(
            name: .webhooks.tests,
            dependencies: [.webhooks, .shared, .dependenciesTestSupport]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}
