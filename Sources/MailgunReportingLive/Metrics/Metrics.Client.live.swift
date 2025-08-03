//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunSharedLive
import Reporting

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Metrics.Client {
    public static func live(
        apiKey: ApiKey,
        makeRequest: @escaping @Sendable (_ route: Metrics.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
        return Self(
            getAccountMetrics: { request in
                try await handleRequest(
                    for: makeRequest(.getAccountMetrics(request: request)),
                    decodingTo: Metrics.GetAccountMetrics.Response.self
                )
            },
            
            getAccountUsageMetrics: { request in
                try await handleRequest(
                    for: makeRequest(.getAccountUsageMetrics(request: request)),
                    decodingTo: Metrics.GetAccountUsageMetrics.Response.self
                )
            }
        )
    }
}
