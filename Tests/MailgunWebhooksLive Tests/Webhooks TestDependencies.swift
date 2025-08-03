//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import IssueReporting
import MailgunSharedLive
import Webhooks
import Coenttb_Authentication

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

typealias AuthenticatedClient = Coenttb_Authentication.Client<Webhooks.API, Webhooks.API.Router, Webhooks.Client>

extension AuthenticatedClient: TestDependencyKey {
    public static var testValue: Self {
        try! Coenttb_Authentication.Client.test {
            Webhooks.Client.testValue
        }
    }
    
    public static var liveTest: Self {
        try! Coenttb_Authentication.Client.test { apiKey, baseUrl, domain, makeRequest in
            Client.live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                domain: domain,
                makeRequest: makeRequest
            )
        }
    }
}

extension Webhooks.API.Router: TestDependencyKey {
    public static let testValue: Self = .init()
}
