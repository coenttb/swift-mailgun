//
//  Tags.Client.live.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared
import Mailgun_Reporting_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Reporting.Tags.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Reporting.Tags.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Mailgun.Reporting.Tags.Tag.List.Response.self
                )
            },

            get: { tag in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, tag: tag)),
                    decodingTo: Mailgun.Reporting.Tags.Tag.self
                )
            },

            update: { tag, description in
                try await handleRequest(
                    for: makeRequest(.update(domain: domain, tag: tag, description: description)),
                    decodingTo: Mailgun.Reporting.Tags.Tag.self
                )
            },

            delete: { tag in
                let response = try await handleRequest(
                    for: makeRequest(.delete(domain: domain, tag: tag)),
                    decodingTo: Mailgun.Reporting.Tags.Tag.Delete.Response.self
                )
                return response.message
            },

            stats: { tag, request in
                try await handleRequest(
                    for: makeRequest(.stats(domain: domain, tag: tag, request: request)),
                    decodingTo: Mailgun.Reporting.Tags.Tag.Stats.Response.self
                )
            },

            aggregates: { tag, request in
                try await handleRequest(
                    for: makeRequest(.aggregates(domain: domain, tag: tag, request: request)),
                    decodingTo: Mailgun.Reporting.Tags.Tag.Aggregates.Response.self
                )
            },

            limits: {
                try await handleRequest(
                    for: makeRequest(.limits(domain: domain)),
                    decodingTo: Mailgun.Reporting.Tags.Tag.Limits.Response.self
                )
            }
        )
    }
}

extension Mailgun.Reporting.Tags.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Reporting.Tags.API,
        Mailgun.Reporting.Tags.API.Router,
        Mailgun.Reporting.Tags.Client
    >
}

extension Mailgun.Reporting.Tags.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Reporting.Tags.Client.Authenticated {
        try! Mailgun.Reporting.Tags.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Reporting.Tags.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Reporting.Tags.API.Router = .init()
}
