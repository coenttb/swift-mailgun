//
//  Tags.Client.live.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Reporting_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Reporting.Tags.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Reporting.Tags.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgun.domain) var domain

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Mailgun.Reporting.Tags.List.Response.self
                )
            },

            get: { tag in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, tag: tag)),
                    decodingTo: Mailgun.Reporting.Tags.Tag.self
                )
            },

            update: { tag, request in
                try await handleRequest(
                    for: makeRequest(.update(domain: domain, tag: tag, request: request)),
                    decodingTo: Mailgun.Reporting.Tags.Update.Response.self
                )
            },

            delete: { tag in
                let response = try await handleRequest(
                    for: makeRequest(.delete(domain: domain, tag: tag)),
                    decodingTo: Mailgun.Reporting.Tags.Delete.Response.self
                )
                return response
            },

            stats: { tag, request in
                try await handleRequest(
                    for: makeRequest(.stats(domain: domain, tag: tag, request: request)),
                    decodingTo: Mailgun.Reporting.Tags.Stats.Response.self
                )
            },

            aggregates: { tag, request in
                try await handleRequest(
                    for: makeRequest(.aggregates(domain: domain, tag: tag, request: request)),
                    decodingTo: Mailgun.Reporting.Tags.Aggregates.Response.self
                )
            },

            limits: {
                try await handleRequest(
                    for: makeRequest(.limits(domain: domain)),
                    decodingTo: Mailgun.Reporting.Tags.Limits.Response.self
                )
            }
        )
    }
}

extension Mailgun.Reporting.Tags {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.Reporting.Tags.API,
        Mailgun.Reporting.Tags.API.Router,
        Mailgun.Reporting.Tags.Client
    >
}

extension Mailgun.Reporting.Tags: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Reporting.Tags.Authenticated {
        try! Mailgun.Reporting.Tags.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Reporting.Tags.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Reporting.Tags.API.Router = .init()
}
