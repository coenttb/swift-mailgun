//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Reporting_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Reporting.Metrics.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Reporting.Metrics.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            getAccountMetrics: { request in
                try await handleRequest(
                    for: makeRequest(.getAccountMetrics(request: request)),
                    decodingTo: Mailgun.Reporting.Metrics.GetAccountMetrics.Response.self
                )
            },

            getAccountUsageMetrics: { request in
                try await handleRequest(
                    for: makeRequest(.getAccountUsageMetrics(request: request)),
                    decodingTo: Mailgun.Reporting.Metrics.GetAccountUsageMetrics.Response.self
                )
            }
        )
    }
}

extension Mailgun.Reporting.Metrics {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.Reporting.Metrics.API,
        Mailgun.Reporting.Metrics.API.Router,
        Mailgun.Reporting.Metrics.Client
    >
}

extension Mailgun.Reporting.Metrics: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Reporting.Metrics.Authenticated {
        try! Mailgun.Reporting.Metrics.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Reporting.Metrics.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Reporting.Metrics.API.Router = .init()
}
