//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunShared
import MessagesTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Messages.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Messages.API) throws -> URLRequest
    ) -> Self {
        @Dependency(\.envVars.mailgunDomain) var domain
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            send: { request in
                try await handleRequest(
                    for: makeRequest(.send(domain: domain, request: request)),
                    decodingTo: Messages.Send.Response.self
                )
            },

            sendMime: { request in
                try await handleRequest(
                    for: makeRequest(.sendMime(domain: domain, request: request)),
                    decodingTo: Messages.Send.Response.self
                )
            },

            retrieve: { storageKey in
                try await handleRequest(
                    for: makeRequest(.retrieve(domain: domain, storageKey: storageKey)),
                    decodingTo: Messages.StoredMessage.self
                )
            },

            queueStatus: {
                try await handleRequest(
                    for: makeRequest(.queueStatus(domain: domain)),
                    decodingTo: Messages.Queue.Status.self
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteScheduled(domain: domain)),
                    decodingTo: Messages.Delete.Response.self
                )
            }
        )
    }
}

extension Messages.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Messages.API,
        Messages.API.Router,
        Messages.Client
    >
}

extension Messages.Client.Authenticated: @retroactive DependencyKey {
    public static var liveValue: Self {
        try! Messages.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Messages.Client.Authenticated: @retroactive TestDependencyKey {
    public static var testValue: Self {
        return try! Messages.Client.Authenticated { .testValue }
    }
}

extension Messages.API.Router: @retroactive DependencyKey {
    public static let liveValue: Messages.API.Router = .init()
}
