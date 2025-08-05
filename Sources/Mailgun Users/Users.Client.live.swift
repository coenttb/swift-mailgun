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
import Mailgun_Users_Types
@_exported import enum Mailgun_Types.Mailgun

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Users.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Users.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: {
                try await handleRequest(
                    for: makeRequest(.list),
                    decodingTo: Mailgun.Users.List.Response.self
                )
            },
            get: { userId in
                try await handleRequest(
                    for: makeRequest(.get(userId: userId)),
                    decodingTo: Mailgun.Users.User.self
                )
            },
            me: {
                try await handleRequest(
                    for: makeRequest(.me),
                    decodingTo: Mailgun.Users.User.self
                )
            },
            addToOrganization: { userId, orgId, request in
                try await handleRequest(
                    for: makeRequest(.addToOrganization(userId: userId, orgId: orgId, request: request)),
                    decodingTo: Mailgun.Users.Organization.Response.self
                )
            },
            removeFromOrganization: { userId, orgId in
                try await handleRequest(
                    for: makeRequest(.removeFromOrganization(userId: userId, orgId: orgId)),
                    decodingTo: Mailgun.Users.Organization.Response.self
                )
            }
        )
    }
}

extension Mailgun.Users.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Users.API,
        Mailgun.Users.API.Router,
        Mailgun.Users.Client
    >
}

extension Mailgun.Users.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Users.Client.Authenticated {
        try! Mailgun.Users.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Users.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Users.API.Router = .init()
}
