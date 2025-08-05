//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import MailgunShared
import ReportingTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Reporting.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Reporting.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunPrivateApiKey) var apiKey
        return Self(
            metrics: .live { try makeRequest(.metrics($0)) },
            stats: .live { try makeRequest(.stats($0)) },
            events: .live { try makeRequest(.events($0)) },
            tags: .live { try makeRequest(.tags($0)) },
            logs: .live { try makeRequest(.logs($0)) }
        )
    }
}

extension Reporting.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Reporting.API,
        Reporting.API.Router,
        Reporting.Client
    >
}

extension Reporting.API.Router: @retroactive DependencyKey {
    public static let liveValue: Reporting.API.Router = .init()
}
