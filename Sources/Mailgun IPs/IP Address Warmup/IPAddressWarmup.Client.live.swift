//
//  IPAddressWarmup.Client.live.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 05/08/2025.
//

import Dependencies
import Foundation
import IssueReporting
import Mailgun_Shared
import Mailgun_Types_Shared
import Mailgun_IPs_Types
@_exported import enum Mailgun_Types.Mailgun

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.IPAddressWarmup.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.IPAddressWarmup.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: {
                try await handleRequest(
                    for: makeRequest(.list),
                    decodingTo: Mailgun.IPAddressWarmup.ListResponse.self
                )
            },
            
            get: { ip in
                try await handleRequest(
                    for: makeRequest(.get(ip: ip)),
                    decodingTo: Mailgun.IPAddressWarmup.IPWarmup.self
                )
            },
            
            create: { ip, request in
                try await handleRequest(
                    for: makeRequest(.create(ip: ip, request: request)),
                    decodingTo: Mailgun.IPAddressWarmup.CreateResponse.self
                )
            },
            
            delete: { ip in
                try await handleRequest(
                    for: makeRequest(.delete(ip: ip)),
                    decodingTo: Mailgun.IPAddressWarmup.DeleteResponse.self
                )
            }
        )
    }
}

extension Mailgun.IPAddressWarmup.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.IPAddressWarmup.API,
        Mailgun.IPAddressWarmup.API.Router,
        Mailgun.IPAddressWarmup.Client
    >
}

extension Mailgun.IPAddressWarmup.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.IPAddressWarmup.Client.Authenticated {
        try! Mailgun.IPAddressWarmup.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.IPAddressWarmup.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.IPAddressWarmup.API.Router = .init()
}