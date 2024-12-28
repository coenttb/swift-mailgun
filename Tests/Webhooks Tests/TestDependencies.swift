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
import TestShared
import Shared
import Authenticated
import Webhooks


#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

typealias AuthenticatedClient = Authenticated.Client<Webhooks.API, Webhooks.API.Router, Webhooks.Client>

extension Authenticated.Client<Webhooks.API, Webhooks.API.Router, Webhooks.Client>: TestDependencyKey {
    public static var testValue: Self? {
        withDependencies {
            $0.envVars = .liveTest
        } operation: {
            @Dependency(Webhooks.API.Router.self) var router
            
            return try? Authenticated.Client.test(
                router: router
            ) { makeRequest in
                Webhooks.Client.testValue
            }
        }
    }
    
    public static var liveTest: Self? {
        withDependencies {
            $0.envVars = .liveTest
        } operation: {
            @Dependency(Webhooks.API.Router.self) var router
            
            return try? Authenticated.Client.test(
                router: router
            ) { apiKey, baseUrl, domain, makeRequest in
                Webhooks.Client.live(
                    apiKey: apiKey,
                    baseUrl: baseUrl,
                    domain: domain,
                    makeRequest: makeRequest
                )
            }
        }
    }
}

extension DependencyValues {
    var client: AuthenticatedClient? {
        get { self[AuthenticatedClient.self] }
        set { self[AuthenticatedClient.self] = newValue }
    }
}

extension Webhooks.API.Router: TestDependencyKey {
    public static let testValue: Webhooks.API.Router = .init()
}
