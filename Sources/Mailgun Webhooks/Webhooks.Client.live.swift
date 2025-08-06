//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared
import Mailgun_Webhooks_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


extension Mailgun.Webhooks.Client {
   public static func live(
       makeRequest: @escaping @Sendable (_ route: Mailgun.Webhooks.API) throws -> URLRequest
   ) -> Self {
       @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
       @Dependency(\.envVars.mailgunDomain) var domain

       return Self(
           list: {
               try await handleRequest(
                   for: makeRequest(.list(domain: domain)),
                   decodingTo: Mailgun.Webhooks.Client.Response.List.self
               )
           },

           get: { type in
               try await handleRequest(
                   for: makeRequest(.get(domain: domain, type: type)),
                   decodingTo: Mailgun.Webhooks.Client.Response.Webhook.self
               )
           },

           create: { type, url in
               try await handleRequest(
                   for: makeRequest(.create(domain: domain, type: type, url: url)),
                   decodingTo: Mailgun.Webhooks.Client.Response.self
               )
           },

           update: { type, url in
               try await handleRequest(
                   for: makeRequest(.update(domain: domain, type: type, url: url)),
                   decodingTo: Mailgun.Webhooks.Client.Response.self
               )
           },

           delete: { type in
               try await handleRequest(
                   for: makeRequest(.delete(domain: domain, type: type)),
                   decodingTo: Mailgun.Webhooks.Client.Response.self
               )
           }
       )
   }
}

extension Mailgun.Webhooks.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Webhooks.API,
        Mailgun.Webhooks.API.Router,
        Mailgun.Webhooks.Client
    >
}

extension Mailgun.Webhooks.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Webhooks.Client.Authenticated {
        try! Mailgun.Webhooks.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Webhooks.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Webhooks.API.Router = .init()
}
