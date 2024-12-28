//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation

public struct Webhook: Sendable, Codable, Equatable {
    public let urls: [String]
    
    public init(urls: [String]) {
        self.urls = urls
    }
}

extension Webhook {
    public enum Variant: String, Sendable, Codable, Equatable {
        case accepted
        case delivered
        case opened
        case clicked
        case unsubscribed
        case complained
        case permanentFail = "permanent_fail"
        case temporaryFail = "temporary_fail"
    }
}

extension Client {
    public struct Response: Sendable, Codable, Equatable {
        public let message: String
        public let webhook: Webhook
        
        public init(message: String, webhook: Webhook) {
            self.message = message
            self.webhook = webhook
        }
    }
}
