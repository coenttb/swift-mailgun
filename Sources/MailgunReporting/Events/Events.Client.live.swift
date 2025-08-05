//
//  File.swift
//  coenttb-mailgun
//
//  Created by coenttb on 26/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import MailgunShared
import ReportingTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Reporting.Events.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Reporting.Events.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            list: { query in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, query: query)),
                    decodingTo: Reporting.Events.List.Response.self
                )
            }
        )
    }
}

extension Reporting.Events.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Reporting.Events.API,
        Reporting.Events.API.Router,
        Reporting.Events.Client
    >
}

extension Reporting.Events.Client: @retroactive DependencyKey {
    public static var liveValue: Reporting.Events.Client.Authenticated {
        try! Reporting.Events.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Reporting.Events.API.Router: @retroactive DependencyKey {
    public static let liveValue: Reporting.Events.API.Router = .init()
}
