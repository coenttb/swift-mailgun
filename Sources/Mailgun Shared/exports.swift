//
//  File.swift
//  swift-kamer-van-koophandel
//
//  Created by Coen ten Thije Boonkkamp on 23/01/2025.
//

@_exported import Mailgun_Shared_Live

import EnvironmentVariables

extension EnvVars {
    package static var development: Self {
        let projectRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        return try! .live(
            environmentConfiguration: .projectRoot(
                projectRoot,
                environment: "development"
            ),
            requiredKeys: []
        )
    }
}
