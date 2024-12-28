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
import Messages
import IssueReporting
import TestShared
import Shared
import Authenticated

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Authenticated.Client<Messages.API, Messages.API.Router, Messages.Client>: TestDependencyKey {
    public static var testValue: Self? {
        
        @Dependency(\.envVars) var envVars

        guard
            let apiKey: ApiKey = try? #require(envVars.mailgunPrivateApiKey),
            let baseUrl = try? #require(envVars.mailgunBaseUrl),
            let domain = try? #require(envVars.mailgunDomain)
        else { return nil }
        
        @Dependency(Messages.API.Router.self) var router
        
        return try? Authenticated.Client.test(
            router: router
        ) { makeRequest in
            return .live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                domain: domain,
                makeRequest: makeRequest
            )
        }
    }
}

extension Messages.API.Router: TestDependencyKey {
    public static let testValue: Messages.API.Router = .init()
}
