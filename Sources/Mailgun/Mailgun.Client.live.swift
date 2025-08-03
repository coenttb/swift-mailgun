//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Foundation
import Coenttb_Web
import DependenciesMacros
import MailgunShared
import MailgunTypes
import Coenttb_Authentication
import MailgunCredentials
import MailgunCustomMessageLimit
import MailgunDomains
import MailgunEvents
import MailgunIPAllowlist
import MailgunIPPools
import MailgunIPs
import MailgunKeys
import MailgunLists
import MailgunMessages
import MailgunReporting
import MailgunRoutes
import MailgunSubaccounts
import MailgunSuppressions
import MailgunTags
import MailgunTemplates
import MailgunUsers
import MailgunWebhooks

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Client {
    public static func live(
    ) throws -> MailgunShared.AuthenticatedClient<Mailgun.API, Mailgun.API.Router, Mailgun.Client> {
        
        @Dependency(MailgunRouterKey.self) var mailgunRouter
        @Dependency(\.envVars.mailgunPrivateApiKey) var apiKey
        @Dependency(\.envVars.mailgunBaseUrl) var baseUrl
        @Dependency(\.envVars.mailgunDomain) var domain
        
        return try MailgunShared.AuthenticatedClient(
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
    public typealias AuthenticatedClient = MailgunShared.AuthenticatedClient<Mailgun.API, Mailgun.API.Router, Mailgun.Client>
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
