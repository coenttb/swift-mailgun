//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared
@_exported import Mailgun_Suppressions_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Suppressions.Unsubscribe.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Suppressions.Unsubscribe.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgun.domain) var domain

        return Self(
            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Unsubscribe.Import.Response.self
                )
            },
            
            get: { address in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, address: address)),
                    decodingTo: Mailgun.Suppressions.Unsubscribe.Get.Response.self
                )
            },

            delete: { address in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, address: address)),
                    decodingTo: Mailgun.Suppressions.Unsubscribe.Delete.Response.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Unsubscribe.List.Response.self
                )
            },

            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Unsubscribe.Create.Response.self
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Mailgun.Suppressions.Unsubscribe.DeleteAll.Response.self
                )
            }
        )
    }
}

extension Mailgun.Suppressions.Unsubscribe {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.Suppressions.Unsubscribe.API,
        Mailgun.Suppressions.Unsubscribe.API.Router,
        Mailgun.Suppressions.Unsubscribe.Client
    >
}

extension Mailgun.Suppressions.Unsubscribe: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Suppressions.Unsubscribe.Authenticated {
        try! Mailgun.Suppressions.Unsubscribe.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Suppressions.Unsubscribe.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Suppressions.Unsubscribe.API.Router = .init()
}
