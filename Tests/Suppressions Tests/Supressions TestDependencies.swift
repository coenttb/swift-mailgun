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
import Suppressions

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Authenticated.Client<Suppressions.API, Suppressions.API.Router, Suppressions.Client>: TestDependencyKey {
    public static var testValue: Self? {
        @Dependency(Suppressions.API.Router.self) var router
        
        return try? Authenticated.Client.test(
            router: router
        ) { makeRequest in
            Suppressions.Client.testValue
        }
    }
    
    public static var liveTest: Self? {
        withDependencies {
            $0.envVars = .liveTest
        } operation: {
            @Dependency(\.envVars) var envVars

            guard
                let apiKey: ApiKey = try? #require(envVars.mailgunPrivateApiKey),
                let baseUrl = try? #require(envVars.mailgunBaseUrl),
                let domain = try? #require(envVars.mailgunDomain)
            else { return nil }
            
            @Dependency(Suppressions.API.Router.self) var router
            
            return try? Authenticated.Client.test(
                router: router
            ) { makeRequest in
                .live(
                    apiKey: apiKey,
                    baseUrl: baseUrl,
                    domain: domain,
                    makeRequest: makeRequest
                )
            }
        }
    }
}

extension Suppressions.API.Router: TestDependencyKey {
    public static let testValue: Suppressions.API.Router = .init()
}

extension DependencyValues {
    public var suppressions: Authenticated.Client<Suppressions.API, Suppressions.API.Router, Suppressions.Client>? {
        get { self[Authenticated.Client<Suppressions.API, Suppressions.API.Router, Suppressions.Client>.self] }
        set { self[Authenticated.Client<Suppressions.API, Suppressions.API.Router, Suppressions.Client>.self] = newValue }
    }
}
