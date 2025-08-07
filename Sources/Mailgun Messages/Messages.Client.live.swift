//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Messages_Types
@_exported import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Messages.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Messages.API) throws -> URLRequest
    ) -> Self {
        @Dependency(\.envVars.mailgunDomain) var domain
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            send: { request in
                try await handleRequest(
                    for: makeRequest(.send(domain: domain, request: request)),
                    decodingTo: Mailgun.Messages.Send.Response.self
                )
            },

            sendMime: { request in
                try await handleRequest(
                    for: makeRequest(.sendMime(domain: domain, request: request)),
                    decodingTo: Mailgun.Messages.Send.Response.self
                )
            },

            retrieve: { storageKey in
                try await handleRequest(
                    for: makeRequest(.retrieve(domain: domain, storageKey: storageKey)),
                    decodingTo: Mailgun.Messages.StoredMessage.self
                )
            },

            queueStatus: {
                try await handleRequest(
                    for: makeRequest(.queueStatus(domain: domain)),
                    decodingTo: Mailgun.Messages.Queue.Status.self
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteScheduled(domain: domain)),
                    decodingTo: Mailgun.Messages.Delete.Response.self
                )
            }
        )
    }
}

extension Mailgun.Messages {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.Messages.API,
        Mailgun.Messages.API.Router,
        Mailgun.Messages.Client
    >
}

extension Mailgun.Messages: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Messages.Authenticated {
        try! Mailgun.Messages.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Messages.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Messages.API.Router = .init()
}
