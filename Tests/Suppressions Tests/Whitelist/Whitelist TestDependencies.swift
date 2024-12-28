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

extension Whitelist.API.Router: TestDependencyKey {
    public static let testValue: Whitelist.API.Router = .init()
}


