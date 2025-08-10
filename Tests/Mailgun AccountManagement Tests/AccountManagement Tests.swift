//
//  AccountManagement Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_AccountManagement
import Testing
import TypesFoundation

@Suite(
    "Mailgun AccountManagement Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunAccountManagementTests {
    @Dependency(Mailgun.AccountManagement.self) var accountManagement
    
}

