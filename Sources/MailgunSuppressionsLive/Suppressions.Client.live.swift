//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 03/08/2025.
//

import Coenttb_Web
import IssueReporting
import MailgunSharedLive
import Suppressions

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Suppressions.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Suppressions.API) throws -> URLRequest
    ) -> Self {
        Self(
            bounces: .live { try makeRequest(.bounces($0)) },
            complaints: .live { try makeRequest(.complaints($0)) },
            unsubscribe: .live { try makeRequest(.unsubscribe($0)) },
            whitelist: .live { try makeRequest(.whitelist($0)) }
        )
    }
}

extension Suppressions.Client {
    public typealias Authenticated = MailgunSharedLive.AuthenticatedClient<
        Suppressions.API,
        Suppressions.API.Router,
        Suppressions.Client
    >
}

extension Suppressions.Client.Authenticated: @retroactive DependencyKey {
    public static var liveValue: Self {
        try! Suppressions.Client.Authenticated { Suppressions.Client.live(makeRequest: $0) }
    }
}

extension Suppressions.Client.Authenticated: @retroactive TestDependencyKey {
    public static var testValue: Self {
        return try! Suppressions.Client.Authenticated { Suppressions.Client.testValue }
    }
}

extension Suppressions.API.Router: @retroactive DependencyKey {
    public static let liveValue: Suppressions.API.Router = .init()
}
