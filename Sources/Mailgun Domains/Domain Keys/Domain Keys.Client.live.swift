//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared
import Mailgun_Domains_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Domains.DomainKeys.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.DomainKeys.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Mailgun.Domains.DomainKeys.List.Response.self
                )
            },
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Domains.DomainKeys.Create.Response.self
                )
            },
            delete: { request in
                try await handleRequest(
                    for: makeRequest(.delete(request: request)),
                    decodingTo: Mailgun.Domains.DomainKeys.Delete.Response.self
                )
            },
            activate: { authorityName, selector in
                try await handleRequest(
                    for: makeRequest(.activate(authorityName: authorityName, selector: selector)),
                    decodingTo: Mailgun.Domains.DomainKeys.Activate.Response.self
                )
            },
            listDomainKeys: { authorityName in
                try await handleRequest(
                    for: makeRequest(.listDomainKeys(authorityName: authorityName)),
                    decodingTo: Mailgun.Domains.DomainKeys.DomainKeysList.Response.self
                )
            },
            deactivate: { authorityName, selector in
                try await handleRequest(
                    for: makeRequest(.deactivate(authorityName: authorityName, selector: selector)),
                    decodingTo: Mailgun.Domains.DomainKeys.Deactivate.Response.self
                )
            },
            setDkimAuthority: { domainName, request in
                try await handleRequest(
                    for: makeRequest(.setDkimAuthority(domainName: domainName, request: request)),
                    decodingTo: Mailgun.Domains.DomainKeys.SetDkimAuthority.Response.self
                )
            },
            setDkimSelector: { domainName, request in
                try await handleRequest(
                    for: makeRequest(.setDkimSelector(domainName: domainName, request: request)),
                    decodingTo: Mailgun.Domains.DomainKeys.SetDkimSelector.Response.self
                )
            }
        )
    }
}

extension Mailgun.Domains.DomainKeys.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Domains.DomainKeys.API,
        Mailgun.Domains.DomainKeys.API.Router,
        Mailgun.Domains.DomainKeys.Client
    >
}

extension Mailgun.Domains.DomainKeys.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.DomainKeys.Client.Authenticated {
        try! Mailgun.Domains.DomainKeys.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.DomainKeys.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.DomainKeys.API.Router = .init()
}
