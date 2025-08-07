//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 23/01/2025.
//

import Domain
import EnvironmentVariables
import Foundation

extension EnvironmentVariables {
    public struct Mailgun: Sendable {
        package var baseUrl: URL
        package var apiKey: ApiKey
        package var domain: Domain
    }
    
    package var mailgun: Mailgun {
        // DESIGN CHOICE TO FAIL EARLY IN CASE NO ENVIRONMENT VARIABLES ARE DETECTED
        .init(
            baseUrl: self["MAILGUN_BASE_URL"].flatMap(URL.init(string:))!,
            apiKey: self["MAILGUN_PRIVATE_API_KEY"].map(ApiKey.init(rawValue:))!,
            domain: try! self["MAILGUN_DOMAIN"].map(Domain.init)!
        )
    }
}

// MARK: - Testing conveniences

extension EnvironmentVariables {
    package var mailgunTestMailingList: EmailAddress {
        get { self["MAILGUN_TEST_MAILINGLIST"].map { try! EmailAddress($0) }! }
    }

    package var mailgunTestRecipient: EmailAddress {
        get { self["MAILGUN_TEST_RECIPIENT"].map { try! EmailAddress($0) }! }
    }

    package var mailgunFrom: EmailAddress {
        get { self["MAILGUN_FROM_EMAIL"].map { try! EmailAddress($0) }!  }
    }

    package var mailgunTo: EmailAddress {
        get { self["MAILGUN_TO_EMAIL"].map { try! EmailAddress($0) }!  }
    }
}

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
