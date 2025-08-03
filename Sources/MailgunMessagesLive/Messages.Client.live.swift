//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunSharedLive
import Messages

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Messages.Client {
    public static func live(
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Messages.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
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
    public static func live(
        apiKey: ApiKey
    ) throws -> Messages.Client.Authenticated {
        
        @Dependency(Messages.API.Router.self) var router
        @Dependency(\.envVars.mailgunDomain) var domain
        @Dependency(\.envVars.mailgunBaseUrl) var baseUrl
        
        return try AuthenticatedClient.init(
            apiKey: apiKey,
            baseUrl: baseUrl,
            router: router
        ) { makeRequest in
                .live(domain: domain, makeRequest: makeRequest)
        }
    }
}

extension Messages.Client {
    public typealias Authenticated = MailgunSharedLive.AuthenticatedClient<
        Messages.API,
        Messages.API.Router,
        Messages.Client
    >
}

extension Messages.API.Router: @retroactive DependencyKey {
    public static let liveValue: Messages.API.Router = .init()
}

extension Messages.Client.Authenticated: @retroactive DependencyKey {
    public static var liveValue: Self {
        @Dependency(\.envVars.mailgunDomain) var domain
        return try! Messages.Client.Authenticated { Messages.Client.live(domain: domain, makeRequest: $0) }
        
    }
}

extension Messages.Client.Authenticated: @retroactive TestDependencyKey {
    public static var testValue: Self {
        return try! Messages.Client.Authenticated { Messages.Client.testValue }
    }
}

