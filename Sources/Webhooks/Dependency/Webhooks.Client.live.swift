//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Coenttb_Web
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Client {
   public static func live(
       apiKey: ApiKey,
       baseUrl: URL,
       domain: Domain,
       makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest,
       session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
   ) -> Self {
       return Self(
           list: {
               try await handleRequest(
                   for: makeRequest(.list(domain: domain)),
                   decodingTo: [Webhook.Variant: Webhook].self,
                   session: session
               )
           },
           
           get: { type in
               try await handleRequest(
                   for: makeRequest(.get(domain: domain, type: type)),
                   decodingTo: Webhook.self,
                   session: session
               )
           },
           
           create: { type, url in
               try await handleRequest(
                   for: makeRequest(.create(domain: domain, type: type, url: url)),
                   decodingTo: Client.Response.self,
                   session: session
               )
           },
           
           update: { type, url in
               try await handleRequest(
                   for: makeRequest(.update(domain: domain, type: type, url: url)),
                   decodingTo: Client.Response.self,
                   session: session
               )
           },
           
           delete: { type in
               try await handleRequest(
                   for: makeRequest(.delete(domain: domain, type: type)),
                   decodingTo: Client.Response.self,
                   session: session
               )
           }
       )
   }
}
