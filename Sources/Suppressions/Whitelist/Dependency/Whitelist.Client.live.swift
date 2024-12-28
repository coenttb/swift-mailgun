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

extension Whitelist.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Whitelist.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        return Self(
            get: { value in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, value: value)),
                    decodingTo: Whitelist.Record.self,
                    session: session
                )
            },
            
            delete: { value in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, value: value)),
                    decodingTo: Whitelist.Delete.Response.self,
                    session: session
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Whitelist.List.Response.self,
                    session: session
                )
            },
            
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Whitelist.Create.Response.self,
                    session: session
                )
            },
            
            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Whitelist.Delete.All.Response.self,
                    session: session
                )
            },
            
            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Whitelist.Import.Response.self,
                    session: session
                )
            }
        )
    }
}
