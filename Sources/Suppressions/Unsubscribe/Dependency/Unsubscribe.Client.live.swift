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

extension Unsubscribe.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Unsubscribe.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        return Self(
            get: { address in
                try await Shared.handleRequest(
                    for: makeRequest(.get(domain: domain, address: address)),
                    decodingTo: Unsubscribe.Record.self,
                    session: session
                )
            },
            
            delete: { address in
                try await Shared.handleRequest(
                    for: makeRequest(.delete(domain: domain, address: address)),
                    decodingTo: Unsubscribe.Delete.Response.self,
                    session: session
                )
            },
            
            list: { request in
                try await Shared.handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Unsubscribe.List.Response.self,
                    session: session
                )
            },
            
            create: { request in
                try await Shared.handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Unsubscribe.Create.Response.self,
                    session: session
                )
            },
            
            deleteAll: {
                try await Shared.handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Unsubscribe.Delete.All.Response.self,
                    session: session
                )
            },
            
            importList: { request in
                try await Shared.handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Unsubscribe.Import.Response.self,
                    session: session
                )
            }
        )
    }
}
