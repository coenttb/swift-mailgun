//
//  CustomMessageLimit Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_CustomMessageLimit
import Mailgun_Shared
import Testing

@Suite(
  "Mailgun CustomMessageLimit Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct MailgunCustomMessageLimitTests {
  @Dependency(Mailgun.CustomMessageLimit.self) var customMessageLimit

}
