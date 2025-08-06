//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 03/08/2025.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared
import Mailgun_Suppressions_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Suppressions.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Suppressions.API) throws -> URLRequest
    ) -> Self {
        Self(
            bounces: .live {
                try makeRequest(.bounces($0))
            },
            complaints: .live {
                try makeRequest(.complaints($0))
            },
            unsubscribe: .live {
                try makeRequest(.unsubscribe($0))
            },
            Allowlist: .live {
                try makeRequest(.Allowlist($0))
            }
        )
    }
}

extension Mailgun.Suppressions.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Suppressions.API,
        Mailgun.Suppressions.API.Router,
        Mailgun.Suppressions.Client
    >
}

extension Mailgun.Suppressions.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Suppressions.Client.Authenticated {
        try! Mailgun.Suppressions.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Suppressions.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Suppressions.API.Router = .init()
}
