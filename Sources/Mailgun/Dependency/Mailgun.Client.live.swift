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
import Coenttb_Authentication

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain
    ) -> Shared.AuthenticatedClient<Mailgun.API, Mailgun.API.Router, Mailgun.Client> {
        
        @Dependency(\.mailgunRouter) var mailgunRouter
        
        return Shared.AuthenticatedClient(
            apiKey: apiKey,
            baseUrl: baseUrl,
            router: mailgunRouter) { makeRequest in
                Mailgun.Client.init(
                    messages: .live(
                        domain: domain,
                        makeRequest: { try makeRequest(Mailgun.API.messages($0)) }
                    ),
                    mailingLists: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        makeRequest: { try makeRequest(Mailgun.API.lists($0)) }
                    ),
                    events: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        domain: domain,
                        makeRequest: { try makeRequest(Mailgun.API.events($0)) }
                    ),
                    suppressions: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        domain: domain,
                        makeRequest: { try makeRequest(Mailgun.API.suppressions($0)) }
                    ),
                    webhooks: .live(
                        apiKey: apiKey,
                        baseUrl: baseUrl,
                        domain: domain,
                        makeRequest: { try makeRequest(Mailgun.API.webhooks($0)) }
                    )
                )
            }
    }
}


