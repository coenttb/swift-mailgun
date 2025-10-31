//
//  Domain Keys Client Tests.swift
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
  "Domain Keys Client Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct DomainKeysClientTests {
  @Dependency(Mailgun.Domains.DomainKeys.self) var domainKeys

}
