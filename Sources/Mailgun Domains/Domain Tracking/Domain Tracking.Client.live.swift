//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Domains_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Domains.Domains.Tracking.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.Domains.Tracking.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            get: { domain in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain)),
                    decodingTo: Mailgun.Domains.Domains.Tracking.Get.Response.self
                )
            },
            updateClick: { domain, request in
                try await handleRequest(
                    for: makeRequest(.updateClick(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.Domains.Tracking.UpdateClick.Response.self
                )
            },
            updateOpen: { domain, request in
                try await handleRequest(
                    for: makeRequest(.updateOpen(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.Domains.Tracking.UpdateOpen.Response.self
                )
            },
            updateUnsubscribe: { domain, request in
                try await handleRequest(
                    for: makeRequest(.updateUnsubscribe(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Response.self
                )
            }
        )
    }
}

extension Mailgun.Domains.Domains.Tracking.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.Domains.Tracking.API,
        Mailgun.Domains.Domains.Tracking.API.Router,
        Mailgun.Domains.Domains.Tracking.Client
    >
}

extension Mailgun.Domains.Domains.Tracking.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.Domains.Tracking.Client.Authenticated {
        try! Mailgun.Domains.Domains.Tracking.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.Domains.Tracking.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.Domains.Tracking.API.Router = .init()
}
