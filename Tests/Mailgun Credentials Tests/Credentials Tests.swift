//
//  Credentials Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_Credentials
import Testing

@Suite(
    "Mailgun Credentials Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunCredentialsTests {
    @Dependency(Mailgun.Credentials.self) var credentials

}
