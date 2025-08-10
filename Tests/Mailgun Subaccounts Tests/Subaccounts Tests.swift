//
//  Subaccounts Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Subaccounts
import Testing

@Suite(
    "Mailgun Subaccounts Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunSubaccountsTests {
}
