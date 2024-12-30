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
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Messages.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        
        return Self(
            send: { request in
                try await Shared.handleRequest(
                    for: makeRequest(.send(domain: domain, request: request)),
                    decodingTo: Messages.Send.Response.self,
                    session: session
                )
            },

            sendMime: { request in
                try await Shared.handleRequest(
                    for: makeRequest(.sendMime(domain: domain, request: request)),
                    decodingTo: Messages.Send.Response.self,
                    session: session
                )
            },

            retrieve: { storageKey in
                try await Shared.handleRequest(
                    for: makeRequest(.retrieve(domain: domain, storageKey: storageKey)),
                    decodingTo: Messages.StoredMessage.self,
                    session: session
                )
            },

            queueStatus: {
                try await Shared.handleRequest(
                    for: makeRequest(.queueStatus(domain: domain)),
                    decodingTo: Messages.Queue.Status.self,
                    session: session
                )
            },

            deleteAll: {
                try await Shared.handleRequest(
                    for: makeRequest(.deleteScheduled(domain: domain)),
                    decodingTo: Messages.Delete.Response.self,
                    session: session
                )
            }
        )
    }
}


