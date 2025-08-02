//
//  Tags.TestDependencies.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Tags
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Tags.API.Router: TestDependencyKey {
    public static let testValue: Self = .init()
}
