//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@_exported import Mailgun_Domains_Types
@_exported import Mailgun_Shared

extension Mailgun.Domains.DKIM_Security.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.DKIM_Security.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            updateRotation: { domain, request in
                try await handleRequest(
                    for: makeRequest(.updateRotation(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.DKIM_Security.Rotation.Update.Response.self
                )
            },
            rotateManually: { domain in
                try await handleRequest(
                    for: makeRequest(.rotateManually(domain: domain)),
                    decodingTo: Mailgun.Domains.DKIM_Security.Rotation.Manual.Response.self
                )
            }
        )
    }
}

extension Mailgun.Domains.DKIM_Security.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.DKIM_Security.API,
        Mailgun.Domains.DKIM_Security.API.Router,
        Mailgun.Domains.DKIM_Security.Client
    >
}

extension Mailgun.Domains.DKIM_Security.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.DKIM_Security.Client.Authenticated {
        try! Mailgun.Domains.DKIM_Security.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.DKIM_Security.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.DKIM_Security.API.Router = .init()
}
