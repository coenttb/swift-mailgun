//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunShared
import ReportingTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Reporting.Metrics.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Reporting.Metrics.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
        return Self(
            getAccountMetrics: { request in
                try await handleRequest(
                    for: makeRequest(.getAccountMetrics(request: request)),
                    decodingTo: Reporting.Metrics.GetAccountMetrics.Response.self
                )
            },
            
            getAccountUsageMetrics: { request in
                try await handleRequest(
                    for: makeRequest(.getAccountUsageMetrics(request: request)),
                    decodingTo: Reporting.Metrics.GetAccountUsageMetrics.Response.self
                )
            }
        )
    }
}
