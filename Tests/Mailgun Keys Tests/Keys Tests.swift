//
//  Keys Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Keys
import Testing

@Suite(
    "Mailgun Keys Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunKeysTests {
    @Dependency(Mailgun.Keys.self) var keys

    }
