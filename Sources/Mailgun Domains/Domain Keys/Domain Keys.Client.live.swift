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

extension Mailgun.Domains.DKIM_Keys.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.DKIM_Keys.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Mailgun.Domains.DKIM_Keys.List.Response.self
                )
            },
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Domains.DKIM_Keys.Create.Response.self
                )
            }
        )
    }
}

extension Mailgun.Domains.DKIM_Keys.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.DKIM_Keys.API,
        Mailgun.Domains.DKIM_Keys.API.Router,
        Mailgun.Domains.DKIM_Keys.Client
    >
}

extension Mailgun.Domains.DKIM_Keys.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.DKIM_Keys.Client.Authenticated {
        try! Mailgun.Domains.DKIM_Keys.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.DKIM_Keys.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.DKIM_Keys.API.Router = .init()
}