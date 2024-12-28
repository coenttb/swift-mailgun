//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Foundation
import Shared
import Domain

extension Mailgun.Client {
    public struct EnvVars: Codable {
        public var baseURL: URL
        public var apiKey: ApiKey
        public var domain: Domain
        
        public init(
            baseURL: URL,
            apiKey: ApiKey,
            domain: Domain
        ) {
            self.baseURL = baseURL
            self.apiKey = apiKey
            self.domain = domain
        }
    }
}
