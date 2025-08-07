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
@_exported import Mailgun_Webhooks_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Webhooks.Client {
   public static func live(
       makeRequest: @escaping @Sendable (_ route: Mailgun.Webhooks.API) throws -> URLRequest
   ) -> Self {
       @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
       @Dependency(\.envVars.mailgun.domain) var domain

       return Self(
           list: {
               try await handleRequest(
                   for: makeRequest(.list(domain: domain)),
                   decodingTo: Mailgun.Webhooks.List.Response.self
               )
           },

           get: { webhookName in
               try await handleRequest(
                   for: makeRequest(.get(domain: domain, webhookName: webhookName)),
                   decodingTo: Mailgun.Webhooks.Get.Response.self
               )
           },

           create: { request in
               try await handleRequest(
                   for: makeRequest(.create(domain: domain, request: request)),
                   decodingTo: Mailgun.Webhooks.Create.Response.self
               )
           },

           update: { webhookName, request in
               try await handleRequest(
                   for: makeRequest(.update(domain: domain, webhookName: webhookName, request: request)),
                   decodingTo: Mailgun.Webhooks.Update.Response.self
               )
           },

           delete: { webhookName in
               try await handleRequest(
                   for: makeRequest(.delete(domain: domain, webhookName: webhookName)),
                   decodingTo: Mailgun.Webhooks.Delete.Response.self
               )
           }
       )
   }
}

extension Mailgun.Webhooks {
    public typealias Authenticated = Mailgun_Shared.Authenticated<
        Mailgun.Webhooks.API,
        Mailgun.Webhooks.API.Router,
        Mailgun.Webhooks.Client
    >
}

extension Mailgun.Webhooks: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Webhooks.Authenticated {
        try! Mailgun.Webhooks.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Webhooks.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Webhooks.API.Router = .init()
}
