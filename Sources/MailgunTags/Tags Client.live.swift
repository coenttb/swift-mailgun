//
//  Tags.Client.live.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Coenttb_Web
import MailgunShared
import TagsTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Tags.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Tags.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Tags.Tag.List.Response.self
                )
            },

            get: { tag in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, tag: tag)),
                    decodingTo: Tags.Tag.self
                )
            },

            update: { tag, description in
                try await handleRequest(
                    for: makeRequest(.update(domain: domain, tag: tag, description: description)),
                    decodingTo: Tags.Tag.self
                )
            },

            delete: { tag in
                let response = try await handleRequest(
                    for: makeRequest(.delete(domain: domain, tag: tag)),
                    decodingTo: Tags.Tag.Delete.Response.self
                )
                return response.message
            },

            stats: { tag, request in
                try await handleRequest(
                    for: makeRequest(.stats(domain: domain, tag: tag, request: request)),
                    decodingTo: Tags.Tag.Stats.Response.self
                )
            },

            aggregates: { tag, request in
                try await handleRequest(
                    for: makeRequest(.aggregates(domain: domain, tag: tag, request: request)),
                    decodingTo: Tags.Tag.Aggregates.Response.self
                )
            },

            limits: {
                try await handleRequest(
                    for: makeRequest(.limits(domain: domain)),
                    decodingTo: Tags.Tag.Limits.Response.self
                )
            }
        )
    }
}

extension Tags.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Tags.API,
        Tags.API.Router,
        Tags.Client
    >
}

extension Tags.Client.Authenticated: @retroactive DependencyKey {
    public static var liveValue: Self {
        try! Tags.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Tags.Client.Authenticated: @retroactive TestDependencyKey {
    public static var testValue: Self {
        return try! Tags.Client.Authenticated { .testValue }
    }
}

extension Tags.API.Router: @retroactive DependencyKey {
    public static let liveValue: Tags.API.Router = .init()
}
