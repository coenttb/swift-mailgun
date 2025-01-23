//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 23/01/2025.
//

import Foundation
import Coenttb_Web

extension EnvironmentVariables {
    package var mailgunBaseUrl: URL {
        get { self["MAILGUN_BASE_URL"].flatMap(URL.init(string:))! }
    }
    
    package var mailgunPrivateApiKey: ApiKey? {
        get { self["MAILGUN_PRIVATE_API_KEY"].map(ApiKey.init(rawValue:)) }
    }
    
    package var mailgunDomain: Domain {
        get { try! self["MAILGUN_DOMAIN"].map(Domain.init)! }
    }
    
    package var mailgunTestMailingList: EmailAddress {
        get { self["MAILGUN_TEST_MAILINGLIST"].map{ try! EmailAddress($0) }! }
    }
    
    package var mailgunTestRecipient: EmailAddress {
        get { self["MAILGUN_TEST_RECIPIENT"].map{ try! EmailAddress($0) }! }
    }
    
    package var mailgunFrom: EmailAddress {
        get { self["MAILGUN_FROM_EMAIL"].map{ try! EmailAddress($0) }!  }
    }
    
    package var mailgunTo: EmailAddress {
        get { self["MAILGUN_TO_EMAIL"].map{ try! EmailAddress($0) }!  }
    }
}


extension EnvVars {
    package static let liveTest: Self = try! .live(localDevelopment: .projectRoot.appendingPathComponent(".env.development"))
}

extension URL {
    package static var projectRoot: URL {
        return .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
