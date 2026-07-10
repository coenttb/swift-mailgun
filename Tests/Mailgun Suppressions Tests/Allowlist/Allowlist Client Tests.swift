//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import Dependencies_Test_Support
import Mailgun_Suppressions
import Testing

@Suite(
    "Allowlist Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct SuppressionsAllowlistClientTests {
}
