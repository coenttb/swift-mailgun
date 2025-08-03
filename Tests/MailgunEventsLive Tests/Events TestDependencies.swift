//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Events
import IssueReporting
import Shared
import Domain
import Coenttb_Authentication

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

typealias AuthenticatedClient = Coenttb_Authentication.Client<Events.API, Events.API.Router, Events.Client>

extension AuthenticatedClient: TestDependencyKey {
    public static var testValue: Self {
        try! Coenttb_Authentication.Client.test {
            Client.testValue
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

extension Events.API.Router: TestDependencyKey {
    public static let testValue: Self = .init()
}
