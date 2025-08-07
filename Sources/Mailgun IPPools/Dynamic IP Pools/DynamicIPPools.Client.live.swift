//
//  DynamicIPPools.Client.live.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 05/08/2025.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_IPPools_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.DynamicIPPools.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.DynamicIPPools.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            listHistory: { request in
                try await handleRequest(
                    for: makeRequest(.listHistory(request: request)),
                    decodingTo: Mailgun.DynamicIPPools.HistoryList.Response.self
                )
            },

            removeOverride: { domain in
                try await handleRequest(
                    for: makeRequest(.removeOverride(domain: domain)),
                    decodingTo: Mailgun.DynamicIPPools.RemoveOverride.Response.self
                )
            }
        )
    }
}

extension Mailgun.DynamicIPPools {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.DynamicIPPools.API,
        Mailgun.DynamicIPPools.API.Router,
        Mailgun.DynamicIPPools.Client
    >
}

extension Mailgun.DynamicIPPools: @retroactive DependencyKey {
    public static var liveValue: Mailgun.DynamicIPPools.Authenticated {
        try! Mailgun.DynamicIPPools.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.DynamicIPPools.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.DynamicIPPools.API.Router = .init()
}
