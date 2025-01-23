
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
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
        makeRequest: @escaping @Sendable (_ route: Stats.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
        return Self(
            total: { request in
                try await handleRequest(
                    for: makeRequest(.total(request: request)),
                    decodingTo: Stats.StatsList.self
                )
            },
            filter: { request in
                try await handleRequest(
                    for: makeRequest(.filter(request: request)),
                    decodingTo: Stats.StatsList.self
                )
            },
            aggregateProviders: {
                try await handleRequest(
                    for: makeRequest(.aggregateProviders(domain: domain)),
                    decodingTo: Stats.AggregatesProviders.self
                )
            },
            aggregateDevices: {
                try await handleRequest(
                    for: makeRequest(.aggregateDevices(domain: domain)),
                    decodingTo: Stats.AggregatesDevices.self
                )
            },
            aggregateCountries: {
                try await handleRequest(
                    for: makeRequest(.aggregateCountries(domain: domain)),
                    decodingTo: Stats.AggregatesCountries.self
                )
            }
        )
    }
}
