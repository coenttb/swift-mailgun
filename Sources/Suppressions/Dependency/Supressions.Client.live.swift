//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import CoenttbWeb
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        // Initialize the live clients using their respective .live static functions
        let bouncesClient = Bounces.Client.live(
            apiKey: apiKey,
            baseUrl: baseUrl,
            domain: domain,
            makeRequest: { try makeRequest(.bounces($0)) },
            session: session
        )
        
        let complaintsClient = Complaints.Client.live(
            apiKey: apiKey,
            baseUrl: baseUrl,
            domain: domain,
            makeRequest: { try makeRequest(.complaints($0)) },
            session: session
        )
        
        let unsubscribeClient = Unsubscribe.Client.live(
            apiKey: apiKey,
            baseUrl: baseUrl,
            domain: domain,
            makeRequest: { try makeRequest(.unsubscribe($0)) },
            session: session
        )
        
        let whitelistClient = Whitelist.Client.live(
            apiKey: apiKey,
            baseUrl: baseUrl,
            domain: domain,
            makeRequest: { try makeRequest(.whitelist($0)) },
            session: session
        )
        
        return Self(
            bounces: bouncesClient,
            complaints: complaintsClient,
            unsubscribe: unsubscribeClient,
            whitelist: whitelistClient
        )
    }
}
