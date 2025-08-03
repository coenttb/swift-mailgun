//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 23/01/2025.
//

import Coenttb_Server
import Foundation

extension EnvironmentVariables {
    public var mailgunBaseUrl: URL {
        get { self["MAILGUN_BASE_URL"].flatMap(URL.init(string:))! }
    }

    public var mailgunPrivateApiKey: ApiKey {
        get { self["MAILGUN_PRIVATE_API_KEY"].map(ApiKey.init(rawValue:))! }
    }

    public var mailgunDomain: Domain {
        get { try! self["MAILGUN_DOMAIN"].map(Domain.init)! }
        set { self["MAILGUN_DOMAIN"] = newValue.description }
    }
}

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
        @Dependency(\.projectRoot) var projectRoot
        return try! .live(environmentConfiguration: .projectRoot(projectRoot, environment: "development"), requiredKeys: [])
    }
}
