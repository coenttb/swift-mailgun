//
//  IPPools Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_IPPools
import Testing

@Suite(
    "Mailgun IPPools Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunIPPoolsTests {
    @Dependency(Mailgun.IPPools.self) var ipPools

    }
