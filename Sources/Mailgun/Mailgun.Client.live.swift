//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Authenticating
import DependenciesMacros
import Foundation
import Mailgun_Types_Shared
import Mailgun_Types
import Mailgun_AccountManagement
import Mailgun_Credentials
import Mailgun_CustomMessageLimit
import Mailgun_Domains
import Mailgun_IPAllowlist
import Mailgun_IPPools
import Mailgun_IPs
import Mailgun_Keys
import Mailgun_Lists
import Mailgun_Messages
import Mailgun_Reporting
import Mailgun_Routes
import Mailgun_Shared
import Mailgun_Subaccounts
import Mailgun_Suppressions
import Mailgun_Templates
import Mailgun_Users
import Mailgun_Webhooks
import Dependencies
@_exported import enum Mailgun_Types.Mailgun
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Client {
    public static func live(
    ) throws -> Mailgun_Shared.AuthenticatedClient<Mailgun.API, Mailgun.API.Router, Mailgun.Client> {

        @Dependency(Mailgun.API.Router.self) var mailgunRouter
        @Dependency(\.envVars.mailgunPrivateApiKey) var apiKey
        @Dependency(\.envVars.mailgunBaseUrl) var baseUrl
        @Dependency(\.envVars.mailgunDomain) var domain

        return try Mailgun_Shared.AuthenticatedClient(
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
                    ),
                    domains: .live(
                        makeRequest: { try makeRequest(Mailgun.API.domains($0)) }
                    ),
                    templates: .live(
                        makeRequest: { try makeRequest(Mailgun.API.templates($0)) }
                    ),
                    routes: .live(
                        makeRequest: { try makeRequest(Mailgun.API.routes($0)) }
                    ),
                    ips: .live(
                        makeRequest: { try makeRequest(Mailgun.API.ips($0)) }
                    ),
                    ipPools: .live(
                        makeRequest: { try makeRequest(Mailgun.API.ipPools($0)) }
                    ),
                    ipAllowlist: .live(
                        makeRequest: { try makeRequest(Mailgun.API.ipAllowlist($0)) }
                    ),
                    keys: .live(
                        makeRequest: { try makeRequest(Mailgun.API.keys($0)) }
                    ),
                    users: .live(
                        makeRequest: { try makeRequest(Mailgun.API.users($0)) }
                    ),
                    subaccounts: .live(
                        makeRequest: { try makeRequest(Mailgun.API.subaccounts($0)) }
                    ),
                    credentials: .live(
                        makeRequest: { try makeRequest(Mailgun.API.credentials($0)) }
                    ),
                    customMessageLimit: .live(
                        makeRequest: { try makeRequest(Mailgun.API.customMessageLimit($0)) }
                    ),
                    accountManagement: .live(
                        makeRequest: { try makeRequest(Mailgun.API.accountManagement($0)) }
                    ),
                    reporting: .live(
                        makeRequest: { try makeRequest(Mailgun.API.reporting($0)) }
                    )
                )
            }
    }
}

extension Mailgun.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<Mailgun.API, Mailgun.API.Router, Mailgun.Client>
}

extension Mailgun.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Client.Authenticated {
        try! Mailgun.Client.live()
    }
}

extension Mailgun.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.API.Router = .init()
}

extension DependencyValues {
    public var mailgun: Mailgun.Client.Authenticated {
        get { self[Mailgun.Client.self] }
        set { self[Mailgun.Client.self] = newValue }
    }
}
