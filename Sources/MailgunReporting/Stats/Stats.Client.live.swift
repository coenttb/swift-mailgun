//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import MailgunShared
import ReportingTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Reporting.Stats.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Reporting.Stats.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            total: { request in
                try await handleRequest(
                    for: makeRequest(.total(request: request)),
                    decodingTo: Reporting.Stats.StatsList.self
                )
            },
            filter: { request in
                try await handleRequest(
                    for: makeRequest(.filter(request: request)),
                    decodingTo: Reporting.Stats.StatsList.self
                )
            },
            aggregateProviders: {
                try await handleRequest(
                    for: makeRequest(.aggregateProviders(domain: domain)),
                    decodingTo: Reporting.Stats.AggregatesProviders.self
                )
            },
            aggregateDevices: {
                try await handleRequest(
                    for: makeRequest(.aggregateDevices(domain: domain)),
                    decodingTo: Reporting.Stats.AggregatesDevices.self
                )
            },
            aggregateCountries: {
                try await handleRequest(
                    for: makeRequest(.aggregateCountries(domain: domain)),
                    decodingTo: Reporting.Stats.AggregatesCountries.self
                )
            }
        )
    }
}

