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
import Suppressions

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Unsubscribe.API.Router: TestDependencyKey {
    public static let testValue: Unsubscribe.API.Router = .init()
}
