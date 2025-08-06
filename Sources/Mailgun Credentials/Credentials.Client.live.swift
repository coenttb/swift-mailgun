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

@_exported import Mailgun_Credentials_Types
@_exported import Mailgun_Shared

extension Mailgun.Credentials.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Credentials.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            list: { domain in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain)),
                    decodingTo: Mailgun.Credentials.List.Response.self
                )
            },
            create: { domain, request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Mailgun.Credentials.Create.Response.self
                )
            },
            deleteAll: { domain in
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Mailgun.Credentials.Delete.Response.self
                )
            },
            update: { domain, login, request in
                try await handleRequest(
                    for: makeRequest(.update(domain: domain, login: login, request: request)),
                    decodingTo: Mailgun.Credentials.Update.Response.self
                )
            },
            delete: { domain, login in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, login: login)),
                    decodingTo: Mailgun.Credentials.Delete.Response.self
                )
            },
            updateMailbox: { domain, login, request in
                try await handleRequest(
                    for: makeRequest(.updateMailbox(domain: domain, login: login, request: request)),
                    decodingTo: Mailgun.Credentials.Mailbox.Update.Response.self
                )
            }
        )
    }
}

extension Mailgun.Credentials.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Credentials.API,
        Mailgun.Credentials.API.Router,
        Mailgun.Credentials.Client
    >
}

extension Mailgun.Credentials.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Credentials.Client.Authenticated {
        try! Mailgun.Credentials.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Credentials.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Credentials.API.Router = .init()
}
