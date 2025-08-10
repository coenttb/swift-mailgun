//
//  IPs Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_IPs
import Testing

@Suite(
    "Mailgun IPs Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunIPsTests {
    @Dependency(Mailgun.IPs.self) var ips

    }
