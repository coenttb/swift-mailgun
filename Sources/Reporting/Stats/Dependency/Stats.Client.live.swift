
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

extension Stats.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Stats.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        return Self(
            total: { request in
                try await handleRequest(
                    for: makeRequest(.total(request: request)),
                    decodingTo: Stats.StatsList.self,
                    session: session
                )
            },
            filter: { request in
                try await handleRequest(
                    for: makeRequest(.filter(request: request)),
                    decodingTo: Stats.StatsList.self,
                    session: session
                )
            },
            aggregateProviders: {
                try await handleRequest(
                    for: makeRequest(.aggregateProviders(domain: domain)),
                    decodingTo: Stats.AggregatesProviders.self,
                    session: session
                )
            },
            aggregateDevices: {
                try await handleRequest(
                    for: makeRequest(.aggregateDevices(domain: domain)),
                    decodingTo: Stats.AggregatesDevices.self,
                    session: session
                )
            },
            aggregateCountries: {
                try await handleRequest(
                    for: makeRequest(.aggregateCountries(domain: domain)),
                    decodingTo: Stats.AggregatesCountries.self,
                    session: session
                )
            }
        )
    }
}
