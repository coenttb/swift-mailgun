import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared
@_exported import Mailgun_Suppressions_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Suppressions.Bounces.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Suppressions.Bounces.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgun.domain) var domain

        return Self(
            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Bounces.Import.Response.self
                )
            },

            get: { address in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, address: address)),
                    decodingTo: Mailgun.Suppressions.Bounces.Record.self
                )
            },

            delete: { address in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, address: address)),
                    decodingTo: Mailgun.Suppressions.Bounces.Delete.Response.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Bounces.List.Response.self
                )
            },

            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Bounces.Create.Response.self
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Mailgun.Suppressions.Bounces.Delete.All.Response.self
                )
            }
        )
    }
}

extension Mailgun.Suppressions.Bounces {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.Suppressions.Bounces.API,
        Mailgun.Suppressions.Bounces.API.Router,
        Mailgun.Suppressions.Bounces.Client
    >
}

extension Mailgun.Suppressions.Bounces: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Suppressions.Bounces.Authenticated {
        try! Mailgun.Suppressions.Bounces.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Suppressions.Bounces.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Suppressions.Bounces.API.Router = .init()
}
