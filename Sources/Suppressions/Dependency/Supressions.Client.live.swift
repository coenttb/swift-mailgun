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
            bounces: .live(
                apiKey: apiKey,
                domain: domain,
                makeRequest: { try makeRequest(.bounces($0)) }
            ),
            complaints: .live(
                apiKey: apiKey,
                domain: domain,
                makeRequest: { try makeRequest(.complaints($0)) }
            ),
            unsubscribe: .live(
                apiKey: apiKey,
                domain: domain,
                makeRequest: { try makeRequest(.unsubscribe($0)) }
            ),
            whitelist: .live(
                apiKey: apiKey,
                domain: domain,
                makeRequest: { try makeRequest(.whitelist($0)) }
            )
        )
    }
}
