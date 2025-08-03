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
       apiKey: ApiKey,
       domain: Domain,
       makeRequest: @escaping @Sendable (_ route: Webhooks.API) throws -> URLRequest
   ) -> Self {
       @Dependency(URLRequest.Handler.self) var handleRequest
       
       return Self(
           list: {
               try await handleRequest(
                   for: makeRequest(.list(domain: domain)),
                   decodingTo: [Webhook.Variant: Webhook].self
               )
           },
           
           get: { type in
               try await handleRequest(
                   for: makeRequest(.get(domain: domain, type: type)),
                   decodingTo: Webhook.self
               )
           },
           
           create: { type, url in
               try await handleRequest(
                   for: makeRequest(.create(domain: domain, type: type, url: url)),
                   decodingTo: Client.Response.self
               )
           },
           
           update: { type, url in
               try await handleRequest(
                   for: makeRequest(.update(domain: domain, type: type, url: url)),
                   decodingTo: Client.Response.self
               )
           },
           
           delete: { type in
               try await handleRequest(
                   for: makeRequest(.delete(domain: domain, type: type)),
                   decodingTo: Client.Response.self
               )
           }
       )
   }
}
