//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunSharedLive
import Suppressions

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Suppressions.Unsubscribe.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Suppressions.Unsubscribe.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain
        
        return Self(
            get: { address in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, address: address)),
                    decodingTo: Suppressions.Unsubscribe.Record.self
                )
            },
            
            delete: { address in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, address: address)),
                    decodingTo: Suppressions.Unsubscribe.Delete.Response.self
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Suppressions.Unsubscribe.List.Response.self
                )
            },
            
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Suppressions.Unsubscribe.Create.Response.self
                )
            },
            
            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Suppressions.Unsubscribe.Delete.All.Response.self
                )
            },
            
            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Suppressions.Unsubscribe.Import.Response.self
                )
            }
        )
    }
}
