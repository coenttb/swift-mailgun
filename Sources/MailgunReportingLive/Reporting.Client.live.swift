//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunSharedLive
import Reporting

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Reporting.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Reporting.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        @Dependency(\.envVars.mailgunPrivateApiKey) var apiKey
        return Self(
            metrics: .live { try makeRequest(.metrics($0)) },
            stats: .live { try makeRequest(.stats($0)) }
        )
    }
}

extension Reporting.Client {
    public typealias Authenticated = MailgunSharedLive.AuthenticatedClient<
        Reporting.API,
        Reporting.API.Router,
        Reporting.Client
    >
}

extension Reporting.Client.Authenticated: @retroactive DependencyKey {
    public static var liveValue: Self {
        try! Reporting.Client.Authenticated { Reporting.Client.live(makeRequest: $0) }
    }
}

extension Reporting.Client.Authenticated: @retroactive TestDependencyKey {
    public static var testValue: Self {
        return try! Reporting.Client.Authenticated { Reporting.Client.testValue }
    }
}

extension Reporting.API.Router: @retroactive DependencyKey {
    public static let liveValue: Reporting.API.Router = .init()
}
