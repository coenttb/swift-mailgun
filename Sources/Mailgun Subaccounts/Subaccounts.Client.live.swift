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
import Mailgun_Subaccounts_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Subaccounts.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Subaccounts.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            get: { subaccountId in
                try await handleRequest(
                    for: makeRequest(.get(subaccountId: subaccountId)),
                    decodingTo: Mailgun.Subaccounts.Subaccount.self
                )
            },
            list: {
                try await handleRequest(
                    for: makeRequest(.list),
                    decodingTo: Mailgun.Subaccounts.List.Response.self
                )
            },
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Subaccounts.Subaccount.self
                )
            },
            delete: {
                try await handleRequest(
                    for: makeRequest(.delete),
                    decodingTo: Mailgun.Subaccounts.Delete.Response.self
                )
            },
            disable: { subaccountId in
                try await handleRequest(
                    for: makeRequest(.disable(subaccountId: subaccountId)),
                    decodingTo: Mailgun.Subaccounts.Disable.Response.self
                )
            },
            enable: { subaccountId in
                try await handleRequest(
                    for: makeRequest(.enable(subaccountId: subaccountId)),
                    decodingTo: Mailgun.Subaccounts.Enable.Response.self
                )
            },
            getCustomLimit: { subaccountId in
                try await handleRequest(
                    for: makeRequest(.getCustomLimit(subaccountId: subaccountId)),
                    decodingTo: Mailgun.Subaccounts.CustomLimit.Response.self
                )
            },
            updateCustomLimit: { subaccountId, request in
                try await handleRequest(
                    for: makeRequest(.updateCustomLimit(subaccountId: subaccountId, request: request)),
                    decodingTo: Mailgun.Subaccounts.CustomLimit.Response.self
                )
            },
            deleteCustomLimit: { subaccountId in
                try await handleRequest(
                    for: makeRequest(.deleteCustomLimit(subaccountId: subaccountId)),
                    decodingTo: Mailgun.Subaccounts.CustomLimit.DeleteResponse.self
                )
            },
            updateFeatures: { subaccountId, request in
                try await handleRequest(
                    for: makeRequest(.updateFeatures(subaccountId: subaccountId, request: request)),
                    decodingTo: Mailgun.Subaccounts.Features.Response.self
                )
            }
        )
    }
}

extension Mailgun.Subaccounts.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Subaccounts.API,
        Mailgun.Subaccounts.API.Router,
        Mailgun.Subaccounts.Client
    >
}

extension Mailgun.Subaccounts.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Subaccounts.Client.Authenticated {
        try! Mailgun.Subaccounts.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Subaccounts.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Subaccounts.API.Router = .init()
}
