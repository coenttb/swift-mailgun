//
//  File.swift
//  coenttb-mailgun
//
//  Created by coenttb on 26/12/2024.
//

import Coenttb_Web
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Events.Client {
    public static func live(
        apiKey: ApiKey,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Events.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
        return Self(
            list: { query in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, query: query)),
                    decodingTo: Events.List.Response.self
                )
            }
        )
    }
}
