//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import Mailgun_Shared
import Mailgun_Types_Shared
import Mailgun_Domains_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Domains.Domains.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.Domains.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Mailgun.Domains.Domains.List.Response.self
                )
            },
            
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Domains.Domains.Create.Response.self
                )
            },
            
            get: { domain in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain)),
                    decodingTo: Mailgun.Domains.Domains.Get.Response.self
                )
            },
            
            update: { domain, request in
                try await handleRequest(
                    for: makeRequest(.update(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.Domains.Update.Response.self
                )
            },
            
            delete: { domain in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain)),
                    decodingTo: Mailgun.Domains.Domains.Delete.Response.self
                )
            },
            
            verify: { domain in
                try await handleRequest(
                    for: makeRequest(.verify(domain: domain)),
                    decodingTo: Mailgun.Domains.Domains.Verify.Response.self
                )
            }
        )
    }
}

extension Mailgun.Domains.Domains.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.Domains.API,
        Mailgun.Domains.Domains.API.Router,
        Mailgun.Domains.Domains.Client
    >
}

extension Mailgun.Domains.Domains.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.Domains.Client.Authenticated {
        try! Mailgun.Domains.Domains.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.Domains.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.Domains.API.Router = .init()
}
