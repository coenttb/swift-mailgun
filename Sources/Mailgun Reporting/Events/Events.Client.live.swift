//
//  File.swift
//  coenttb-mailgun
//
//  Created by coenttb on 26/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import Mailgun_Shared
import Mailgun_Types_Shared
import Mailgun_Reporting_Types
@_exported import enum Mailgun_Types.Mailgun
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Reporting.Events.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Reporting.Events.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            list: { query in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, query: query)),
                    decodingTo: Mailgun.Reporting.Events.List.Response.self
                )
            }
        )
    }
}

extension Mailgun.Reporting.Events.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Reporting.Events.API,
        Mailgun.Reporting.Events.API.Router,
        Mailgun.Reporting.Events.Client
    >
}

extension Mailgun.Reporting.Events.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Reporting.Events.Client.Authenticated {
        try! Mailgun.Reporting.Events.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Reporting.Events.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Reporting.Events.API.Router = .init()
}
