//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import Dependencies_Test_Support
import Foundation
import Mailgun_Suppressions
import Testing

@Suite(
    "Bounces Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct SuppressionsBouncesClientTests {
}
