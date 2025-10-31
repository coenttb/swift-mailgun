//
//  Complaints Client Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_Suppressions
import Testing

@Suite(
  "Mailgun Suppressions Complaints Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct MailgunSuppressionsComplaintsTests {
  @Dependency(Mailgun.Suppressions.Complaints.self) var complaints

}
