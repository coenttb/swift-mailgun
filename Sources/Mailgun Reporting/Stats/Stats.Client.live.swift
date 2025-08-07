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

extension Mailgun.Reporting.Stats.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Reporting.Stats.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgun.domain) var domain

        return Self(
            total: { request in
                try await handleRequest(
                    for: makeRequest(.total(request: request)),
                    decodingTo: Mailgun.Reporting.Stats.StatsList.self
                )
            },
            filter: { request in
                try await handleRequest(
                    for: makeRequest(.filter(request: request)),
                    decodingTo: Mailgun.Reporting.Stats.StatsList.self
                )
            },
            aggregateProviders: {
                try await handleRequest(
                    for: makeRequest(.aggregateProviders(domain: domain)),
                    decodingTo: Mailgun.Reporting.Stats.AggregatesProviders.self
                )
            },
            aggregateDevices: {
                try await handleRequest(
                    for: makeRequest(.aggregateDevices(domain: domain)),
                    decodingTo: Mailgun.Reporting.Stats.AggregatesDevices.self
                )
            },
            aggregateCountries: {
                try await handleRequest(
                    for: makeRequest(.aggregateCountries(domain: domain)),
                    decodingTo: Mailgun.Reporting.Stats.AggregatesCountries.self
                )
            }
        )
    }
}

extension Mailgun.Reporting.Stats {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.Reporting.Stats.API,
        Mailgun.Reporting.Stats.API.Router,
        Mailgun.Reporting.Stats.Client
    >
}

extension Mailgun.Reporting.Stats: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Reporting.Stats.Authenticated {
        try! Mailgun.Reporting.Stats.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Reporting.Stats.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Reporting.Stats.API.Router = .init()
}
