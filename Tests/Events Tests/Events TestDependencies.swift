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
import TestShared
import Shared
import Authenticated
import Domain

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

typealias AuthenticatedClient = Authenticated.Client<Events.API, Events.API.Router, Events.Client>

extension AuthenticatedClient: TestDependencyKey {
    public static var testValue: Self {
        try! Authenticated.Client.test {
            Client.testValue
        }
    }
    
    public static var liveTest: Self {
        try! Authenticated.Client.test { apiKey, baseUrl, domain, makeRequest in
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
