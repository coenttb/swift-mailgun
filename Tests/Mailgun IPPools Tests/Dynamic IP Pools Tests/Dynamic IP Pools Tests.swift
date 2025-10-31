//
//  Dynamic IP Pools Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 06/08/2025.
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_IPPools
import Testing

@Suite(
  "Mailgun Dynamic IP Pools Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct MailgunDynamicIPPoolsTests {
  @Dependency(Mailgun.DynamicIPPools.self) var dynamicIPPools

}
