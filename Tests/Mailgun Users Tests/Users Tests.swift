//
//  Users Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Users
import Testing

@Suite(
    "Mailgun Users Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunUsersTests {
    
}
