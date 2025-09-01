//
//  DKIM Security Client Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_Domains
import Mailgun_Shared
import Testing

@Suite(
    "DKIM Security Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct DKIMSecurityClientTests {
    @Dependency(Mailgun.Domains.DKIM_Security.self) var dkimSecurity
    

    }
