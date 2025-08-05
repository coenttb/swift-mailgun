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

extension Mailgun.Domains.Domain.Keys.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.Domain.Keys.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Mailgun.Domains.Domain.Keys.List.Response.self
                )
            },
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Domains.Domain.Keys.Create.Response.self
                )
            }
        )
    }
}

extension Mailgun.Domains.Domain.Keys.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.Domain.Keys.API,
        Mailgun.Domains.Domain.Keys.API.Router,
        Mailgun.Domains.Domain.Keys.Client
    >
}

extension Mailgun.Domains.Domain.Keys.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.Domain.Keys.Client.Authenticated {
        try! Mailgun.Domains.Domain.Keys.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.Domain.Keys.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.Domain.Keys.API.Router = .init()
}
