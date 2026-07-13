//
//  Domains Domains Client Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import Dependencies_Test_Support
import Mailgun_Domains
import Mailgun_Shared
import Testing

@Suite(
    "Domains Domains Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct DomainsDomainsClientTests {
    @Dependency(Mailgun.Domains.Domains.self) var domainsDomains

}
