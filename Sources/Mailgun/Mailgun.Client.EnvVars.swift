//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Domain
import Foundation
import MailgunShared
import MailgunTypes

extension Mailgun.Client {
    public struct EnvVars: Codable {
        public var baseUrl: URL
        public var apiKey: ApiKey
        public var domain: Domain

        public init(
            baseUrl: URL,
            apiKey: ApiKey,
            domain: Domain
        ) {
            self.baseUrl = baseUrl
            self.apiKey = apiKey
            self.domain = domain
        }
    }
}
