//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunShared
import SuppressionsTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Suppressions.Whitelist.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Suppressions.Whitelist.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            get: { value in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, value: value)),
                    decodingTo: Suppressions.Whitelist.Record.self
                )
            },

            delete: { value in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, value: value)),
                    decodingTo: Suppressions.Whitelist.Delete.Response.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Suppressions.Whitelist.List.Response.self
                )
            },

            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Suppressions.Whitelist.Create.Response.self
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Suppressions.Whitelist.Delete.All.Response.self
                )
            },

            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Suppressions.Whitelist.Import.Response.self
                )
            }
        )
    }
}
