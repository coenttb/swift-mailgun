//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunSharedLive
import Webhooks
import Dependencies
import Coenttb_Web

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Webhooks.Client {
   public static func live(
       makeRequest: @escaping @Sendable (_ route: Webhooks.API) throws -> URLRequest
   ) -> Self {
       @Dependency(URLRequest.Handler.self) var handleRequest
       @Dependency(\.envVars.mailgunDomain) var domain
       
       return Self(
           list: {
               try await handleRequest(
                   for: makeRequest(.list(domain: domain)),
                   decodingTo: Webhooks.Client.Response.List.self
               )
           },
           
           get: { type in
               try await handleRequest(
                   for: makeRequest(.get(domain: domain, type: type)),
                   decodingTo: Webhooks.Client.Response.Webhook.self
               )
           },
           
           create: { type, url in
               try await handleRequest(
                   for: makeRequest(.create(domain: domain, type: type, url: url)),
                   decodingTo: Webhooks.Client.Response.self
               )
           },
           
           update: { type, url in
               try await handleRequest(
                   for: makeRequest(.update(domain: domain, type: type, url: url)),
                   decodingTo: Webhooks.Client.Response.self
               )
           },
           
           delete: { type in
               try await handleRequest(
                   for: makeRequest(.delete(domain: domain, type: type)),
                   decodingTo: Webhooks.Client.Response.self
               )
           }
       )
   }
}

extension Webhooks.Client {
    public typealias Authenticated = MailgunSharedLive.AuthenticatedClient<
        Webhooks.API,
        Webhooks.API.Router,
        Webhooks.Client
    >
}

extension Webhooks.Client.Authenticated: @retroactive DependencyKey {
    public static var liveValue: Self {
        try! Webhooks.Client.Authenticated { Webhooks.Client.live(makeRequest: $0) }
    }
}

extension Webhooks.Client.Authenticated: @retroactive TestDependencyKey {
    public static var testValue: Self {
        return try! Webhooks.Client.Authenticated { Webhooks.Client.testValue }
    }
}

extension Webhooks.API.Router: @retroactive DependencyKey {
    public static let liveValue: Webhooks.API.Router = .init()
}
