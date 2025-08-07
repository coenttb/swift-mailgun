//
//  IPAddressWarmup.Client.live.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 05/08/2025.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_IPs_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.IPAddressWarmup.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.IPAddressWarmup.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: {
                try await handleRequest(
                    for: makeRequest(.list),
                    decodingTo: Mailgun.IPAddressWarmup.List.Response.self
                )
            },

            get: { ip in
                try await handleRequest(
                    for: makeRequest(.get(ip: ip)),
                    decodingTo: Mailgun.IPAddressWarmup.IPWarmup.self
                )
            },

            create: { ip, request in
                try await handleRequest(
                    for: makeRequest(.create(ip: ip, request: request)),
                    decodingTo: Mailgun.IPAddressWarmup.Create.Response.self
                )
            },

            delete: { ip in
                try await handleRequest(
                    for: makeRequest(.delete(ip: ip)),
                    decodingTo: Mailgun.IPAddressWarmup.Delete.Response.self
                )
            }
        )
    }
}

extension Mailgun.IPAddressWarmup {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.IPAddressWarmup.API,
        Mailgun.IPAddressWarmup.API.Router,
        Mailgun.IPAddressWarmup.Client
    >
}

extension Mailgun.IPAddressWarmup: @retroactive DependencyKey {
    public static var liveValue: Mailgun.IPAddressWarmup.Authenticated {
        try! Mailgun.IPAddressWarmup.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.IPAddressWarmup.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.IPAddressWarmup.API.Router = .init()
}
