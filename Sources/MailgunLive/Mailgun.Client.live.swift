//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Foundation
import Coenttb_Web
import DependenciesMacros
import MailgunSharedLive
import Mailgun
import Coenttb_Authentication

import MailgunCredentialsLive
import MailgunCustomMessageLimitLive
import MailgunDomainsLive
import MailgunEventsLive
import MailgunIPAllowlistLive
import MailgunIPPoolsLive
import MailgunIPsLive
import MailgunKeysLive
import MailgunListsLive
import MailgunMessagesLive
import MailgunReportingLive
import MailgunRoutesLive
import MailgunSubaccountsLive
import MailgunSuppressionsLive
import MailgunTagsLive
import MailgunTemplatesLive
import MailgunUsersLive
import MailgunWebhooksLive

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain
    ) throws -> MailgunSharedLive.AuthenticatedClient<Mailgun.API, Mailgun.API.Router, Mailgun.Client> {
        
        @Dependency(\.mailgunRouter) var mailgunRouter
        
        return try MailgunSharedLive.AuthenticatedClient(
            apiKey: apiKey,
            baseUrl: baseUrl,
            router: mailgunRouter) { makeRequest in
                Mailgun.Client.init(
                    messages: .live(
                        makeRequest: { try makeRequest(Mailgun.API.messages($0)) }
                    ),
                    mailingLists: .live(
                        makeRequest: { try makeRequest(Mailgun.API.lists($0)) }
                    ),
                    events: .live(
                        makeRequest: { try makeRequest(Mailgun.API.events($0)) }
                    ),
                    suppressions: .live(
                        makeRequest: { try makeRequest(Mailgun.API.suppressions($0)) }
                    ),
                    webhooks: .live(
                        makeRequest: { try makeRequest(Mailgun.API.webhooks($0)) }
                    )
                )
            }
    }
}

extension Mailgun.Client {
    public typealias AuthenticatedClient = MailgunSharedLive.AuthenticatedClient<Mailgun.API, Mailgun.API.Router, Mailgun.Client>
}

extension Mailgun.Client: @retroactive TestDependencyKey {
    static public let testValue: Mailgun.Client.AuthenticatedClient? = Mailgun.Client.testValue.map { client in
        do {
            return try .init(
                apiKey: .init(rawValue: "test-api-key"),
                baseUrl: .init(string: "localhost:8080")!,
                router: .init()
            ) { _ in
                    .init(
                        messages: .testValue,
                        mailingLists: .testValue,
                        events: .testValue,
                        suppressions: .testValue,
                        webhooks: .testValue
                    )
            }
        } catch {
            print(error)
            fatalError()
        }
    }
}

extension DependencyValues {
    public var mailgunClient: Mailgun.Client.AuthenticatedClient? {
        get { self[Mailgun.Client.self] }
        set { self[Mailgun.Client.self] = newValue }
    }
}
