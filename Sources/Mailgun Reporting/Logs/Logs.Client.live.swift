//
//  Logs.Client.live.swift
//  coenttb-mailgun
//
//  Created by Claude on 08/01/2025.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Reporting_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Reporting.Logs.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Reporting.Logs.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgun.domain) var domain

        return Self()
    }
}

extension Mailgun.Reporting.Logs {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.Reporting.Logs.API,
        Mailgun.Reporting.Logs.API.Router,
        Mailgun.Reporting.Logs.Client
    >
}

extension Mailgun.Reporting.Logs: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Reporting.Logs.Authenticated {
        try! Mailgun.Reporting.Logs.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Reporting.Logs.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Reporting.Logs.API.Router = .init()
}
