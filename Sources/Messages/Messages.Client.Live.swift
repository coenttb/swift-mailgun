//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Coenttb_Web
import IssueReporting
import Shared

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
//                try await handleRequest(
//                    for: makeRequest(.send(domain: domain, request: request)),
//                    decodingTo: Messages.Send.Response.self
//                )
                var request = request  // Create mutable copy
                
                // Initialize headers if nil
                if request.headers == nil {
                    request.headers = [:]
                }
                
                // Set headers
                request.headers?["Content-Transfer-Encoding"] = "quoted-printable"
                request.headers?["Content-Type"] = "text/html; charset=ascii"
                
                // Create request with modified headers
                let req = try makeRequest(.send(domain: domain, request: request))
                
                // Send and return response
                return try await handleRequest(
                    for: req,
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

extension Client {
    public static func live(
        apiKey: ApiKey
    ) -> AuthenticatedClient {
        
        @Dependency(API.Router.self) var router
        @Dependency(\.envVars.mailgunDomain) var domain
        @Dependency(\.envVars.mailgunBaseUrl) var baseUrl
        
        return AuthenticatedClient.init(
            apiKey: apiKey,
            baseUrl: baseUrl,
            router: router
        ) { makeRequest in
                .live(domain: domain, makeRequest: makeRequest)
            }
    }
}
