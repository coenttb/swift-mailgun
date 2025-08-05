//
//  Tags.Client.live.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Dependencies
import Foundation
import MailgunShared
import ReportingTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Reporting.Tags.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Reporting.Tags.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Reporting.Tags.Tag.List.Response.self
                )
            },

            get: { tag in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, tag: tag)),
                    decodingTo: Reporting.Tags.Tag.self
                )
            },

            update: { tag, description in
                try await handleRequest(
                    for: makeRequest(.update(domain: domain, tag: tag, description: description)),
                    decodingTo: Reporting.Tags.Tag.self
                )
            },

            delete: { tag in
                let response = try await handleRequest(
                    for: makeRequest(.delete(domain: domain, tag: tag)),
                    decodingTo: Reporting.Tags.Tag.Delete.Response.self
                )
                return response.message
            },

            stats: { tag, request in
                try await handleRequest(
                    for: makeRequest(.stats(domain: domain, tag: tag, request: request)),
                    decodingTo: Reporting.Tags.Tag.Stats.Response.self
                )
            },

            aggregates: { tag, request in
                try await handleRequest(
                    for: makeRequest(.aggregates(domain: domain, tag: tag, request: request)),
                    decodingTo: Reporting.Tags.Tag.Aggregates.Response.self
                )
            },

            limits: {
                try await handleRequest(
                    for: makeRequest(.limits(domain: domain)),
                    decodingTo: Reporting.Tags.Tag.Limits.Response.self
                )
            }
        )
    }
}

extension Reporting.Tags.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Reporting.Tags.API,
        Reporting.Tags.API.Router,
        Reporting.Tags.Client
    >
}

extension Reporting.Tags.API.Router: @retroactive DependencyKey {
    public static let liveValue: Reporting.Tags.API.Router = .init()
}
