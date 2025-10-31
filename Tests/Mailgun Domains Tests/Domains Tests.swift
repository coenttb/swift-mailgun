//
//  Domains Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_Domains
import Mailgun_Shared
import Testing

@Suite(
  "Mailgun Domains Aggregation Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct MailgunDomainsAggregationTests {
  @Dependency(Mailgun.Domains.self) var domains

}
