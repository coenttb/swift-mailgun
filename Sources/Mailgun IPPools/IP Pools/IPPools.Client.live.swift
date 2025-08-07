//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_IPPools_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.IPPools.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.IPPools.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: {
                try await handleRequest(
                    for: makeRequest(.list),
                    decodingTo: Mailgun.IPPools.List.Response.self
                )
            },

            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.IPPools.Create.Response.self
                )
            },

            get: { poolId in
                try await handleRequest(
                    for: makeRequest(.get(poolId: poolId)),
                    decodingTo: Mailgun.IPPools.IPPool.self
                )
            },

            update: { poolId, request in
                try await handleRequest(
                    for: makeRequest(.update(poolId: poolId, request: request)),
                    decodingTo: Mailgun.IPPools.Update.Response.self
                )
            },

            delete: { poolId, request in
                try await handleRequest(
                    for: makeRequest(.delete(poolId: poolId, request: request)),
                    decodingTo: Mailgun.IPPools.Delete.Response.self
                )
            },

            listDomains: { poolId in
                try await handleRequest(
                    for: makeRequest(.listDomains(poolId: poolId)),
                    decodingTo: Mailgun.IPPools.DomainsList.Response.self
                )
            }
        )
    }
}

extension Mailgun.IPPools.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.IPPools.API,
        Mailgun.IPPools.API.Router,
        Mailgun.IPPools.Client
    >
}

extension Mailgun.IPPools.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.IPPools.Client.Authenticated {
        try! Mailgun.IPPools.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.IPPools.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.IPPools.API.Router = .init()
}
