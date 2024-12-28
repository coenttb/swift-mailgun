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
import Lists
import IssueReporting
import TestShared
import Shared
import Authenticated

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Authenticated.Client<Lists.API, Lists.API.Router, Lists.Client>: TestDependencyKey {
    public static var testValue: Self? {
        
        @Dependency(\.envVars) var envVars

        guard
            let apiKey: ApiKey = try? #require(envVars.mailgunPrivateApiKey),
            let baseUrl = try? #require(envVars.mailgunBaseUrl)
        else { return nil }
        
        @Dependency(Lists.API.Router.self) var router
        
        return try? Authenticated.Client.test(
            router: router
        ) { makeRequest in
            return .live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                makeRequest: makeRequest
            )
        }
    }
}

extension Lists.API.Router: TestDependencyKey {
    public static let testValue: Lists.API.Router = .init()
}
