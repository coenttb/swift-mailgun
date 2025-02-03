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
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
        return Self(
            metrics: .live(
                apiKey: apiKey,
                makeRequest: { try makeRequest(.metrics($0)) }
            ),
            stats: .live(
                apiKey: apiKey,
                domain: domain,
                makeRequest: { try makeRequest(.stats($0)) }
            )
        )
    }
}
