//
//  File.swift
//  swift-kamer-van-koophandel
//
//  Created by Coen ten Thije Boonkkamp on 23/01/2025.
//

import Environment_Dependencies
import Foundation
@_exported import Mailgun_Shared_Live

extension EnvVars {
    package static var development: Self {
        let projectRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        // swiftlint:disable:next force_try
        return try! .live(
            environmentConfiguration: .projectRoot(
                projectRoot,
                environment: "development"
            )
        )
    }
}
