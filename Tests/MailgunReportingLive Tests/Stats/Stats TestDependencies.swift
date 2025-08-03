//
//  Stats TestDependencies.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 29/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import IssueReporting
import MailgunSharedLive
import Reporting

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Stats.API.Router: TestDependencyKey {
    public static let testValue: Stats.API.Router = .init()
}
