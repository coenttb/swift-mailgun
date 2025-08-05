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
@_exported import enum Mailgun_Types.Mailgun

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Domains.Domain.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.Domain.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Mailgun.Domains.Domain.List.Response.self
                )
            },
            
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Domains.Domain.Create.Response.self
                )
            },
            
            get: { domain in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain)),
                    decodingTo: Mailgun.Domains.Domain.Get.Response.self
                )
            },
            
            update: { domain, request in
                try await handleRequest(
                    for: makeRequest(.update(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.Domain.Update.Response.self
                )
            },
            
            delete: { domain in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain)),
                    decodingTo: Mailgun.Domains.Domain.Delete.Response.self
                )
            },
            
            verify: { domain in
                try await handleRequest(
                    for: makeRequest(.verify(domain: domain)),
                    decodingTo: Mailgun.Domains.Domain.Verify.Response.self
                )
            }
        )
    }
}

extension Mailgun.Domains.Domain.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.Domain.API,
        Mailgun.Domains.Domain.API.Router,
        Mailgun.Domains.Domain.Client
    >
}

extension Mailgun.Domains.Domain.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.Domain.Client.Authenticated {
        try! Mailgun.Domains.Domain.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.Domain.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.Domain.API.Router = .init()
}