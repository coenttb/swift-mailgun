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
import Shared
import Coenttb_Authentication
import Messages

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Messages.AuthenticatedClient: @retroactive TestDependencyKey {
    public static var testValue: Self {
        @Dependency(TestStrategy.self) var testStrategy
        
        switch testStrategy {
        case .local:
            return try! Messages.AuthenticatedClient.test { Messages.Client.testValue }
        case .liveTest, .live:
            @Dependency(\.envVars.mailgunDomain) var domain
            return try! Messages.AuthenticatedClient.test { Messages.Client.live(domain: domain, makeRequest: $0) }
        }
    }
}
