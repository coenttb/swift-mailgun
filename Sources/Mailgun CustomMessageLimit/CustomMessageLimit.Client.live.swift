//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_CustomMessageLimit_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.CustomMessageLimit.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.CustomMessageLimit.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            getMonthlyLimit: {
                try await handleRequest(
                    for: makeRequest(.getMonthly),
                    decodingTo: Mailgun.CustomMessageLimit.Monthly.Get.Response.self
                )
            },
            setMonthlyLimit: { request in
                try await handleRequest(
                    for: makeRequest(.setMonthly(request: request)),
                    decodingTo: Mailgun.CustomMessageLimit.Monthly.Set.Response.self
                )
            },
            deleteMonthlyLimit: {
                try await handleRequest(
                    for: makeRequest(.deleteMonthly),
                    decodingTo: Mailgun.CustomMessageLimit.Monthly.Delete.Response.self
                )
            },
            enableAccount: {
                try await handleRequest(
                    for: makeRequest(.enableAccount),
                    decodingTo: Mailgun.CustomMessageLimit.EnableAccount.Response.self
                )
            }
        )
    }
}

extension Mailgun.CustomMessageLimit {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.CustomMessageLimit.API,
        Mailgun.CustomMessageLimit.API.Router,
        Mailgun.CustomMessageLimit.Client
    >
}

extension Mailgun.CustomMessageLimit: @retroactive DependencyKey {
    public static var liveValue: Mailgun.CustomMessageLimit.Authenticated {
        try! Mailgun.CustomMessageLimit.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.CustomMessageLimit.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.CustomMessageLimit.API.Router = .init()
}
