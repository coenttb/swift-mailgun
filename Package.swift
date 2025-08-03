// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let mailgun: Self = "MailgunLive"
    static let credentials: Self = "MailgunCredentialsLive"
    static let customMessageLimit: Self = "MailgunCustomMessageLimitLive"
    static let domains: Self = "MailgunDomainsLive"
    static let events: Self = "MailgunEventsLive"
    static let iPAllowlist: Self = "MailgunIPAllowlistLive"
    static let ipPools: Self = "MailgunIPPoolsLive"
    static let ips: Self = "MailgunIPsLive"
    static let keys: Self = "MailgunKeysLive"
    static let lists: Self = "MailgunListsLive"
    static let messages: Self = "MailgunMessagesLive"
    static let reporting: Self = "MailgunReportingLive"
    static let routes: Self = "MailgunRoutesLive"
    static let subaccounts: Self = "MailgunSubaccountsLive"
    static let suppressions: Self = "MailgunSuppressionsLive"
    static let tags: Self = "MailgunTagsLive"
    static let templates: Self = "MailgunTemplatesLive"
    static let users: Self = "MailgunUsersLive"
    static let webhooks: Self = "MailgunWebhooksLive"
    static let shared: Self = "MailgunSharedLive"
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
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }
    static var coenttbAuthentication: Self { .product(name: "Coenttb Authentication", package: "coenttb-authentication") }
}

extension Target.Dependency {
    static var mailgunSwiftMailgun: Self {
        .product(
            name: "Mailgun",
            package: "swift-mailgun"
//            moduleAliases: ["Mailgun": "MailgunSwiftMailgun"]
        )
    }
    static var credentialsSwiftMailgun: Self {
        .product(
            name: "Credentials",
            package: "swift-mailgun"
//            moduleAliases: ["Credentials": "CredentialsSwiftMailgun"]
        )
    }
    static var customMessageLimitSwiftMailgun: Self {
        .product(
            name: "CustomMessageLimit",
            package: "swift-mailgun"
//            moduleAliases: ["CustomMessageLimit": "CustomMessageLimitSwiftMailgun"]
        )
    }
    static var domainsSwiftMailgun: Self {
        .product(
            name: "Domains",
            package: "swift-mailgun"
//            moduleAliases: ["Domains": "DomainsSwiftMailgun"]
        )
    }
    static var eventsSwiftMailgun: Self {
        .product(
            name: "Events",
            package: "swift-mailgun"
//            moduleAliases: ["Events": "EventsSwiftMailgun"]
        )
    }
    static var ipAllowlistSwiftMailgun: Self {
        .product(
            name: "IPAllowlist",
            package: "swift-mailgun"
//            moduleAliases: ["IPAllowlist": "IPAllowlistSwiftMailgun"]
        )
    }
    static var ipPoolsSwiftMailgun: Self {
        .product(
            name: "IPPools",
            package: "swift-mailgun"
//            moduleAliases: ["IPPools": "IPPoolsSwiftMailgun"]
        )
    }
    static var ipsSwiftMailgun: Self {
        .product(
            name: "IPs",
            package: "swift-mailgun"
//            moduleAliases: ["IPs": "IPsSwiftMailgun"]
        )
    }
    static var keysSwiftMailgun: Self {
        .product(
            name: "Keys",
            package: "swift-mailgun"
//            moduleAliases: ["Keys": "KeysSwiftMailgun"]
        )
    }
    static var listsSwiftMailgun: Self {
        .product(
            name: "Lists",
            package: "swift-mailgun"
//            moduleAliases: ["Lists": "ListsSwiftMailgun"]
        )
    }
    static var messagesSwiftMailgun: Self {
        .product(
            name: "Messages",
            package: "swift-mailgun"
//            moduleAliases: ["Messages": "MessagesSwiftMailgun"]
        )
    }
    static var reportingSwiftMailgun: Self {
        .product(
            name: "Reporting",
            package: "swift-mailgun"
//            moduleAliases: ["Reporting": "ReportingSwiftMailgun"]
        )
    }
    static var routesSwiftMailgun: Self {
        .product(
            name: "Routes",
            package: "swift-mailgun"
//            moduleAliases: ["Routes": "RoutesSwiftMailgun"]
        )
    }
    static var subaccountsSwiftMailgun: Self {
        .product(
            name: "Subaccounts",
            package: "swift-mailgun"
//            moduleAliases: ["Subaccounts": "SubaccountsSwiftMailgun"]
        )
    }
    static var suppressionsSwiftMailgun: Self {
        .product(
            name: "Suppressions",
            package: "swift-mailgun"
//            moduleAliases: ["Suppressions": "SuppressionsSwiftMailgun"]
        )
    }
    static var tagsSwiftMailgun: Self {
        .product(
            name: "Tags",
            package: "swift-mailgun"
//            moduleAliases: ["Tags": "TagsSwiftMailgun"]
        )
    }
    static var templatesSwiftMailgun: Self {
        .product(
            name: "Templates",
            package: "swift-mailgun"
//            moduleAliases: ["Templates": "TemplatesSwiftMailgun"]
        )
    }
    static var usersSwiftMailgun: Self {
        .product(
            name: "Users",
            package: "swift-mailgun"
//            moduleAliases: ["Users": "UsersSwiftMailgun"]
        )
    }
    static var webhooksSwiftMailgun: Self {
        .product(
            name: "Webhooks",
            package: "swift-mailgun"
//            moduleAliases: ["Webhooks": "WebhooksSwiftMailgun"]
        )
    }
    static var sharedSwiftMailgun: Self {
        .product(
            name: "Shared",
            package: "swift-mailgun"
//            moduleAliases: ["Shared": "SharedSwiftMailgun"]
        )
    }
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
        .library(name: .shared, targets: [.shared]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb-web", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-server", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-authentication", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-mailgun", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.4.3"),
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
                .sharedSwiftMailgun
                
            ]
        ),
        .target(
            name: .mailgun,
            dependencies: [
                .shared,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .eventsSwiftMailgun,
                .shared,
                .coenttbWeb,
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .coenttbServer,
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
