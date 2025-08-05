//
//  Logs.Client.live.swift
//  coenttb-mailgun
//
//  Created by Claude on 08/01/2025.
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

extension Mailgun.Reporting.Logs.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Reporting.Logs.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self()
    }
}

extension Mailgun.Reporting.Logs.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Reporting.Logs.API,
        Mailgun.Reporting.Logs.API.Router,
        Mailgun.Reporting.Logs.Client
    >
}

extension Mailgun.Reporting.Logs.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Reporting.Logs.Client.Authenticated {
        try! Mailgun.Reporting.Logs.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Reporting.Logs.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Reporting.Logs.API.Router = .init()
}
