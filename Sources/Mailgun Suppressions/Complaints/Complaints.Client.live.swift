// Suppressions.Complaints.Client.live.swift

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared
@_exported import Mailgun_Suppressions_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Suppressions.Complaints.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Suppressions.Complaints.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Complaints.Import.Response.self
                )
            },

            get: { address in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, address: address)),
                    decodingTo: Mailgun.Suppressions.Complaints.Record.self
                )
            },

            delete: { address in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, address: address)),
                    decodingTo: Mailgun.Suppressions.Complaints.Delete.Response.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Complaints.List.Response.self
                )
            },

            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Complaints.Create.Response.self
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Mailgun.Suppressions.Complaints.Delete.All.Response.self
                )
            }
        )
    }
}
