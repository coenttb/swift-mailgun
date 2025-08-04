// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let mailgun: Self = "Mailgun"
    static let credentials: Self = "MailgunCredentials"
    static let customMessageLimit: Self = "MailgunCustomMessageLimit"
    static let domains: Self = "MailgunDomains"
    static let events: Self = "MailgunEvents"
    static let iPAllowlist: Self = "MailgunIPAllowlist"
    static let ipPools: Self = "MailgunIPPools"
    static let ips: Self = "MailgunIPs"
    static let keys: Self = "MailgunKeys"
    static let lists: Self = "MailgunLists"
    static let messages: Self = "MailgunMessages"
    static let reporting: Self = "MailgunReporting"
    static let routes: Self = "MailgunRoutes"
    static let subaccounts: Self = "MailgunSubaccounts"
    static let suppressions: Self = "MailgunSuppressions"
    static let tags: Self = "MailgunTags"
    static let templates: Self = "MailgunTemplates"
    static let users: Self = "MailgunUsers"
    static let webhooks: Self = "MailgunWebhooks"
    static let shared: Self = "MailgunShared"
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
    static var coenttbServer: Self { .product(name: "Coenttb Server", package: "coenttb-server") }
    static var coenttbAuthentication: Self { .product(name: "Coenttb Authentication", package: "coenttb-authentication") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }
}

extension Target.Dependency {
    static var mailgunTypes: Self { .product(name: "Mailgun".types, package: "swift-mailgun-types" ) }
    static var credentialsTypes: Self { .product(name: "Credentials".types, package: "swift-mailgun-types" ) }
    static var customMessageLimitTypes: Self { .product(name: "CustomMessageLimit".types, package: "swift-mailgun-types" ) }
    static var domainsTypes: Self { .product(name: "Domains".types, package: "swift-mailgun-types" ) }
    static var eventsTypes: Self { .product(name: "Events".types, package: "swift-mailgun-types" ) }
    static var ipAllowlistTypes: Self { .product(name: "IPAllowlist".types, package: "swift-mailgun-types" ) }
    static var ipPoolsTypes: Self { .product(name: "IPPools".types, package: "swift-mailgun-types" ) }
    static var ipsTypes: Self { .product(name: "IPs".types, package: "swift-mailgun-types" ) }
    static var keysTypes: Self { .product(name: "Keys".types, package: "swift-mailgun-types" ) }
    static var listsTypes: Self { .product(name: "Lists".types, package: "swift-mailgun-types" ) }
    static var messagesTypes: Self { .product(name: "Messages".types, package: "swift-mailgun-types" ) }
    static var reportingTypes: Self { .product(name: "Reporting".types, package: "swift-mailgun-types" ) }
    static var routesTypes: Self { .product(name: "Routes".types, package: "swift-mailgun-types" ) }
    static var subaccountsTypes: Self { .product(name: "Subaccounts".types, package: "swift-mailgun-types" ) }
    static var suppressionsTypes: Self { .product(name: "Suppressions".types, package: "swift-mailgun-types" ) }
    static var tagsTypes: Self { .product(name: "Tags".types, package: "swift-mailgun-types" ) }
    static var templatesTypes: Self { .product(name: "Templates".types, package: "swift-mailgun-types" ) }
    static var usersTypes: Self { .product(name: "Users".types, package: "swift-mailgun-types" ) }
    static var webhooksTypes: Self { .product(name: "Webhooks".types, package: "swift-mailgun-types" ) }
    static var mailgunTypesShared: Self { .product(name: "MailgunTypesShared", package: "swift-mailgun-types" ) }
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
        .library(name: .shared, targets: [.shared])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb-web", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-server", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-authentication", branch: "main"),
//        .package(url: "https://github.com/coenttb/swift-mailgun-types", from: "0.0.1"),
        .package(path: "../swift-mailgun-types"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.4.3")
    ],
    targets: [
        .target(
            name: .shared,
            dependencies: [
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .coenttbAuthentication,
                .coenttbServer,
                .mailgunTypesShared

            ]
        ),
        .target(
            name: .mailgun,
            dependencies: [
                .shared,
                .mailgunTypesShared,
                .mailgunTypes,
                .coenttbWeb,
                .coenttbServer,
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
                .webhooks
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
                .mailgunTypesShared,
                .credentialsTypes,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
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
                .mailgunTypesShared,
                .customMessageLimitTypes,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
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
                .mailgunTypesShared,
                .domainsTypes,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .domains.tests,
            dependencies: [.domains, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .events,
            dependencies: [
                .eventsTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
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
                .mailgunTypesShared,
                .ipAllowlistTypes,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .iPAllowlist.tests,
            dependencies: [.iPAllowlist, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ipPools,
            dependencies: [
                .ipPoolsTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .ipPools.tests,
            dependencies: [.ipPools, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ips,
            dependencies: [
                .ipsTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .ips.tests,
            dependencies: [.ips, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .keys,
            dependencies: [
                .keysTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .keys.tests,
            dependencies: [.keys, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .lists,
            dependencies: [
                .listsTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .lists.tests,
            dependencies: [.lists, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .messages,
            dependencies: [
                .messagesTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .messages.tests,
            dependencies: [.messages, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .reporting,
            dependencies: [
                .reportingTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .reporting.tests,
            dependencies: [.reporting, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .routes,
            dependencies: [
                .routesTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .routes.tests,
            dependencies: [.routes, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .subaccounts,
            dependencies: [
                .subaccountsTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .subaccounts.tests,
            dependencies: [.subaccounts, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .suppressions,
            dependencies: [
                .suppressionsTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .suppressions.tests,
            dependencies: [.suppressions, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .tags,
            dependencies: [
                .tagsTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .tags.tests,
            dependencies: [.tags, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .templates,
            dependencies: [
                .templatesTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .templates.tests,
            dependencies: [.templates, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .users,
            dependencies: [
                .usersTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .users.tests,
            dependencies: [.users, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .webhooks,
            dependencies: [
                .webhooksTypes,
                .shared,
                .mailgunTypesShared,
                .coenttbWeb,
                .coenttbServer,
                .issueReporting,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .webhooks.tests,
            dependencies: [.webhooks, .shared, .dependenciesTestSupport]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var types: Self { self + "Types" }
}
