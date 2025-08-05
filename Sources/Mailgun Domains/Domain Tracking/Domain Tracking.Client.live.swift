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
import Mailgun_Domains_Types
@_exported import enum Mailgun_Types.Mailgun

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Domains.DKIM_Tracking.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.DKIM_Tracking.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            get: { domain in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain)),
                    decodingTo: Mailgun.Domains.DKIM_Tracking.Get.Response.self
                )
            },
            updateClick: { domain, request in
                try await handleRequest(
                    for: makeRequest(.updateClick(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.DKIM_Tracking.UpdateClick.Response.self
                )
            },
            updateOpen: { domain, request in
                try await handleRequest(
                    for: makeRequest(.updateOpen(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.DKIM_Tracking.UpdateOpen.Response.self
                )
            },
            updateUnsubscribe: { domain, request in
                try await handleRequest(
                    for: makeRequest(.updateUnsubscribe(domain: domain, request: request)),
                    decodingTo: Mailgun.Domains.DKIM_Tracking.UpdateUnsubscribe.Response.self
                )
            }
        )
    }
}

extension Mailgun.Domains.DKIM_Tracking.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.DKIM_Tracking.API,
        Mailgun.Domains.DKIM_Tracking.API.Router,
        Mailgun.Domains.DKIM_Tracking.Client
    >
}

extension Mailgun.Domains.DKIM_Tracking.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.DKIM_Tracking.Client.Authenticated {
        try! Mailgun.Domains.DKIM_Tracking.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.DKIM_Tracking.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.DKIM_Tracking.API.Router = .init()
}
