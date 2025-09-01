//
//  IPAllowlist Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_IPAllowlist
import Testing

@Suite(
    "Mailgun IPAllowlist Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunIPAllowlistTests {
    @Dependency(Mailgun.IPAllowlist.self) var ipAllowlist

    }
