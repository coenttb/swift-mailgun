//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import Mailgun_IPs_Types
@_exported import Mailgun_Shared
import TypesFoundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.IPs.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.IPs.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: {
                try await handleRequest(
                    for: makeRequest(.list),
                    decodingTo: Mailgun.IPs.List.Response.self
                )
            },

            get: { ip in
                try await handleRequest(
                    for: makeRequest(.get(ip: ip)),
                    decodingTo: Mailgun.IPs.IP.self
                )
            },

            listDomains: { ip in
                try await handleRequest(
                    for: makeRequest(.listDomains(ip: ip)),
                    decodingTo: Mailgun.IPs.DomainList.Response.self
                )
            },

            assignDomain: { ip, request in
                try await handleRequest(
                    for: makeRequest(.assignDomain(ip: ip, request: request)),
                    decodingTo: Mailgun.IPs.AssignDomain.Response.self
                )
            },

            unassignDomain: { ip, domain in
                try await handleRequest(
                    for: makeRequest(.unassignDomain(ip: ip, domain: domain)),
                    decodingTo: Mailgun.IPs.Delete.Response.self
                )
            },

            assignIPBand: { ip, request in
                try await handleRequest(
                    for: makeRequest(.assignIPBand(ip: ip, request: request)),
                    decodingTo: Mailgun.IPs.IPBand.Response.self
                )
            },

            requestNew: { request in
                try await handleRequest(
                    for: makeRequest(.requestNew(request: request)),
                    decodingTo: Mailgun.IPs.RequestNew.Response.self
                )
            },

            getRequestedIPs: {
                try await handleRequest(
                    for: makeRequest(.getRequestedIPs),
                    decodingTo: Mailgun.IPs.RequestNew.Response.self
                )
            },

            deleteDomainIP: { domain, ip in
                @Dependency(\.envVars.mailgunDomain) var defaultDomain
                let parsedDomain = try Domain(domain)
                return try await handleRequest(
                    for: makeRequest(.deleteDomainIP(domain: parsedDomain, ip: ip)),
                    decodingTo: Mailgun.IPs.Delete.Response.self
                )
            },

            deleteDomainPool: { domain, ip in
                @Dependency(\.envVars.mailgunDomain) var defaultDomain
                let parsedDomain = try Domain(domain)
                return try await handleRequest(
                    for: makeRequest(.deleteDomainPool(domain: parsedDomain, ip: ip)),
                    decodingTo: Mailgun.IPs.Delete.Response.self
                )
            }
        )
    }
}

extension Mailgun.IPs.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.IPs.API,
        Mailgun.IPs.API.Router,
        Mailgun.IPs.Client
    >
}

extension Mailgun.IPs.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.IPs.Client.Authenticated {
        try! Mailgun.IPs.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.IPs.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.IPs.API.Router = .init()
}
