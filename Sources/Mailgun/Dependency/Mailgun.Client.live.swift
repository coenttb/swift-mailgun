//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Foundation
import Coenttb_Web
import DependenciesMacros
import Shared
import Authenticated

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { request in try await URLSession.shared.data(for: request)}
    ) -> Authenticated.Client<Mailgun.API, Mailgun.API.Router, Mailgun.Client> {
        
        @Dependency(\.mailgunRouter) var mailgunRouter
        
        return Authenticated.Client(
            apiKey: apiKey,
            baseUrl: baseUrl,
            session: session,
            router: mailgunRouter) { makeRequest in
                Mailgun.Client.init(
                    messages: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        domain: domain,
                        makeRequest: { try makeRequest(Mailgun.API.messages($0)) },
                        session: session
                    ),
                    mailingLists: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        makeRequest: { try makeRequest(Mailgun.API.lists($0)) },
                        session: session
                    ),
                    events: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        domain: domain,
                        makeRequest: { try makeRequest(Mailgun.API.events($0)) },
                        session: session
                    ),
                    suppressions: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        domain: domain,
                        makeRequest: { try makeRequest(Mailgun.API.suppressions($0)) },
                        session: session
                    ),
                    webhooks: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        domain: domain,
                        makeRequest: { try makeRequest(Mailgun.API.webhooks($0)) },
                        session: session
                    )
                )
            }
    }
}


