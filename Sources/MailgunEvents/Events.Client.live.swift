//
//  File.swift
//  coenttb-mailgun
//
//  Created by coenttb on 26/12/2024.
//

import Coenttb_Web
import EventsTypes
import IssueReporting
import MailgunShared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Events.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Events.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            list: { query in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, query: query)),
                    decodingTo: Events.List.Response.self
                )
            }
        )
    }
}

extension Events.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Events.API,
        Events.API.Router,
        Events.Client
    >
}

extension Events.Client.Authenticated: @retroactive DependencyKey {
    public static var liveValue: Self {
        try! Events.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Events.Client.Authenticated: @retroactive TestDependencyKey {
    public static var testValue: Self {
        return try! Events.Client.Authenticated { .testValue }
    }
}

extension Events.API.Router: @retroactive DependencyKey {
    public static let liveValue: Events.API.Router = .init()
}
