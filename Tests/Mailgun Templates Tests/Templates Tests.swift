//
//  Templates Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Templates
import Testing

@Suite(
  "Mailgun Templates Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct MailgunTemplatesTests {

}
