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
import Mailgun_Keys_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Keys.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Keys.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: {
                try await handleRequest(
                    for: makeRequest(.list),
                    decodingTo: Mailgun.Keys.List.Response.self
                )
            },
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Keys.Create.Response.self
                )
            },
            delete: { keyId in
                try await handleRequest(
                    for: makeRequest(.delete(keyId: keyId)),
                    decodingTo: Mailgun.Keys.Delete.Response.self
                )
            },
            addPublicKey: { request in
                try await handleRequest(
                    for: makeRequest(.addPublicKey(request: request)),
                    decodingTo: Mailgun.Keys.PublicKey.Response.self
                )
            }
        )
    }
}

extension Mailgun.Keys.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Keys.API,
        Mailgun.Keys.API.Router,
        Mailgun.Keys.Client
    >
}

extension Mailgun.Keys.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Keys.Client.Authenticated {
        try! Mailgun.Keys.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Keys.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Keys.API.Router = .init()
}
