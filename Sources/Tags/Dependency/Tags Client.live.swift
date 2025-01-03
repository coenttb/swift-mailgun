//
//  Tags.Client.live.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Coenttb_Web
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Tags.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Tags.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Tag.List.Response.self,
                    session: session
                )
            },
            
            get: { tag in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, tag: tag)),
                    decodingTo: Tag.self,
                    session: session
                )
            },
            
            update: { tag, description in
                try await handleRequest(
                    for: makeRequest(.update(domain: domain, tag: tag, description: description)),
                    decodingTo: Tag.self,
                    session: session
                )
            },
            
            delete: { tag in
                let response = try await handleRequest(
                    for: makeRequest(.delete(domain: domain, tag: tag)),
                    decodingTo: Tag.Delete.Response.self,
                    session: session
                )
                return response.message
            },
            
            stats: { tag, request in
                try await handleRequest(
                    for: makeRequest(.stats(domain: domain, tag: tag, request: request)),
                    decodingTo: Tag.Stats.Response.self,
                    session: session
                )
            },
            
            aggregates: { tag, request in
                try await handleRequest(
                    for: makeRequest(.aggregates(domain: domain, tag: tag, request: request)),
                    decodingTo: Tag.Aggregates.Response.self,
                    session: session
                )
            },
            
            limits: {
                try await handleRequest(
                    for: makeRequest(.limits(domain: domain)),
                    decodingTo: Tag.Limits.Response.self,
                    session: session
                )
            }
        )
    }
}



private let jsonEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    return encoder
}()
