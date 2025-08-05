//
//  DynamicIPPools.Client.live.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 05/08/2025.
//

import Dependencies
import Foundation
import IssueReporting
import Mailgun_Shared
import Mailgun_Types_Shared
import Mailgun_IPPools_Types
@_exported import enum Mailgun_Types.Mailgun

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
                    decodingTo: Mailgun.DynamicIPPools.HistoryListResponse.self
                )
            },
            
            removeOverride: { domain in
                try await handleRequest(
                    for: makeRequest(.removeOverride(domain: domain)),
                    decodingTo: Mailgun.DynamicIPPools.RemoveOverrideResponse.self
                )
            }
        )
    }
}

extension Mailgun.DynamicIPPools.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.DynamicIPPools.API,
        Mailgun.DynamicIPPools.API.Router,
        Mailgun.DynamicIPPools.Client
    >
}

extension Mailgun.DynamicIPPools.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.DynamicIPPools.Client.Authenticated {
        try! Mailgun.DynamicIPPools.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.DynamicIPPools.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.DynamicIPPools.API.Router = .init()
}