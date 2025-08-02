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
import Shared
import Webhooks

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Webhooks.API.Router: TestDependencyKey {
    public static let testValue: Self = .init()
}
