//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import Mailgun_Shared
import Mailgun_Types_Shared
import Mailgun_Domains_Types
@_exported import enum Mailgun_Types.Mailgun
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Domains.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.API) throws -> URLRequest
    ) -> Self {
        .init(
            domains: .live {
                try makeRequest(.domain($0))
            },
            dkimSecurity: .live {
                try makeRequest(.dkimSecurity($0))
            },
            domainKeys: .live {
                try makeRequest(.dkimKeys($0))
            },
            domainTracking: .live {
                try makeRequest(.dkimTracking($0))
            }
        )
    }
}

extension Mailgun.Domains.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.API,
        Mailgun.Domains.API.Router,
        Mailgun.Domains.Client
    >
}

extension Mailgun.Domains.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.Client.Authenticated {
        try! Mailgun.Domains.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.API.Router = .init()
}
