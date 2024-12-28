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
    public static var testValue: Self? {
        @Dependency(Events.API.Router.self) var router
        
        return try? Authenticated.Client.test(
            router: router
        ) { makeRequest in
            Events.Client.testValue
        }
    }
    
    public static var liveTest: Self? {
        @Dependency(Events.API.Router.self) var router
        
        return try? Authenticated.Client.test(
            router: router
        ) { apiKey, baseUrl, domain, makeRequest in
            Events.Client.live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                domain: domain,
                makeRequest: makeRequest
            )
        }
    }
}

extension DependencyValues {
    var client: AuthenticatedClient? {
        get { self[AuthenticatedClient.self] }
        set { self[AuthenticatedClient.self] = newValue }
    }
}

extension Events.API.Router: TestDependencyKey {
    public static let testValue: Events.API.Router = .init()
}
