//
//  Logs.Client.live.swift
//  coenttb-mailgun
//
//  Created by Claude on 08/01/2025.
//

import Dependencies
import Foundation
import IssueReporting
import MailgunShared
import ReportingTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Reporting.Logs.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Reporting.Logs.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self()
    }
}

extension Reporting.Logs.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Reporting.Logs.API,
        Reporting.Logs.API.Router,
        Reporting.Logs.Client
    >
}

extension Reporting.Logs.API.Router: @retroactive DependencyKey {
    public static let liveValue: Reporting.Logs.API.Router = .init()
}
