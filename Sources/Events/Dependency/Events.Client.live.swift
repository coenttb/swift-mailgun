//
//  File.swift
//  coenttb-mailgun
//
//  Created by coenttb on 26/12/2024.
//

import CoenttbWeb
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Events.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Events.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        return Self(
            list: { query in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, query: query)),
                    decodingTo: Events.List.Response.self,
                    session: session
                )
            }
        )
    }
}
