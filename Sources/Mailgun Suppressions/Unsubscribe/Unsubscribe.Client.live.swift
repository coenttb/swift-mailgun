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
import Mailgun_Suppressions_Types
@_exported import enum Mailgun_Types.Mailgun

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Suppressions.Unsubscribe.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Suppressions.Unsubscribe.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            get: { address in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, address: address)),
                    decodingTo: Mailgun.Suppressions.Unsubscribe.Record.self
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
                    decodingTo: Mailgun.Suppressions.Unsubscribe.Delete.All.Response.self
                )
            },

            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Unsubscribe.Import.Response.self
                )
            }
        )
    }
}
