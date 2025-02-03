//
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

extension Whitelist.Client {
    public static func live(
        apiKey: ApiKey,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Whitelist.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
        return Self(
            get: { value in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, value: value)),
                    decodingTo: Whitelist.Record.self
                )
            },
            
            delete: { value in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, value: value)),
                    decodingTo: Whitelist.Delete.Response.self
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Whitelist.List.Response.self
                )
            },
            
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Whitelist.Create.Response.self
                )
            },
            
            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Whitelist.Delete.All.Response.self
                )
            },
            
            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Whitelist.Import.Response.self
                )
            }
        )
    }
}
