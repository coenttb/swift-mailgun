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
import Suppressions

@Suite(
    .dependency(\.envVars, .liveTest),
    .dependency(\.calendar, .current)
)
struct SuppressionsClientTests {
    
}

private struct TestError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}
