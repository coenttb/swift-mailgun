//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import CoenttbWeb
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Metrics.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        makeRequest: @escaping @Sendable (_ route: Metrics.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        return Self(
            getAccountMetrics: { request in
                try await handleRequest(
                    for: makeRequest(.getAccountMetrics(request: request)),
                    decodingTo: Metrics.GetAccountMetrics.Response.self,
                    session: session
                )
            },
            
            getAccountUsageMetrics: { request in
                try await handleRequest(
                    for: makeRequest(.getAccountUsageMetrics(request: request)),
                    decodingTo: Metrics.GetAccountUsageMetrics.Response.self,
                    session: session
                )
            }
        )
    }
}
