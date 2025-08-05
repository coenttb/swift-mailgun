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
import Mailgun_Routes_Types
@_exported import enum Mailgun_Types.Mailgun

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Routes.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Routes.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Routes.Create.Response.self
                )
            },
            list: { limit, skip in
                try await handleRequest(
                    for: makeRequest(.list(limit: limit, skip: skip)),
                    decodingTo: Mailgun.Routes.List.Response.self
                )
            },
            get: { routeId in
                try await handleRequest(
                    for: makeRequest(.get(id: routeId)),
                    decodingTo: Mailgun.Routes.Route.self
                )
            },
            update: { routeId, request in
                try await handleRequest(
                    for: makeRequest(.update(id: routeId, request: request)),
                    decodingTo: Mailgun.Routes.Update.Response.self
                )
            },
            delete: { routeId in
                try await handleRequest(
                    for: makeRequest(.delete(id: routeId)),
                    decodingTo: Mailgun.Routes.Delete.Response.self
                )
            },
            match: { recipient in
                try await handleRequest(
                    for: makeRequest(.match(recipient: recipient)),
                    decodingTo: Mailgun.Routes.Match.Response.self
                )
            }
        )
    }
}

extension Mailgun.Routes.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Routes.API,
        Mailgun.Routes.API.Router,
        Mailgun.Routes.Client
    >
}

extension Mailgun.Routes.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Routes.Client.Authenticated {
        try! Mailgun.Routes.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Routes.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Routes.API.Router = .init()
}