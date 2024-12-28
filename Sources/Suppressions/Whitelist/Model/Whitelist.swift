//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import EmailAddress
import Shared
import Domain

public enum Whitelist {}

extension Whitelist {
    public struct Record: Sendable, Codable, Equatable {
        public let type: String
        public let value: String
        public let reason: String
        public let createdAt: String
        
        public init(
            type: String,
            value: String,
            reason: String,
            createdAt: String
        ) {
            self.type = type
            self.value = value
            self.reason = reason
            self.createdAt = createdAt
        }
        
        private enum CodingKeys: String, CodingKey {
            case type
            case value
            case reason
            case createdAt = "createdAt"
        }
    }
}

extension Whitelist {
    public enum List {}
}

extension Whitelist.List {
    public struct Request: Sendable, Codable, Equatable {
        public let address: EmailAddress?
        public let term: String?
        public let limit: Int?
        public let page: String?
        
        public init(
            address: EmailAddress? = nil,
            term: String? = nil,
            limit: Int? = nil,
            page: String? = nil
        ) {
            self.address = address
            self.term = term
            self.limit = limit
            self.page = page
        }
    }
    
    public struct Response: Sendable, Codable, Equatable {
        public let items: [Whitelist.Record]
        public let paging: Paging
        
        public init(
            items: [Whitelist.Record],
            paging: Paging
        ) {
            self.items = items
            self.paging = paging
        }
    }
    
    public struct Paging: Sendable, Codable, Equatable {
        public let previous: String?
        public let first: String
        public let next: String?
        public let last: String
        
        public init(
            previous: String?,
            first: String,
            next: String?,
            last: String
        ) {
            self.previous = previous
            self.first = first
            self.next = next
            self.last = last
        }
    }
}

extension Whitelist {
    public enum Create {}
}

extension Whitelist.Create {
    public enum Request: Sendable, Codable, Equatable {
            case address(EmailAddress)
            case domain(Domain)
            
            private enum CodingKeys: String, CodingKey {
                case address
                case domain
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                switch self {
                case .address(let email):
                    try container.encode(email.address, forKey: .address)
                case .domain(let domain):
                    try container.encode(domain.rawValue, forKey: .domain)
                }
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                if let address = try container.decodeIfPresent(String.self, forKey: .address) {
                    self = .address(try EmailAddress(address))
                } else if let domain = try container.decodeIfPresent(String.self, forKey: .domain) {
                    self = .domain(try Domain(domain))
                } else {
                    throw DecodingError.dataCorrupted(
                        DecodingError.Context(
                            codingPath: container.codingPath,
                            debugDescription: "Missing both address and domain keys"
                        )
                    )
                }
            }
        }
    
    public struct Response: Sendable, Codable, Equatable {
        public let message: String
        public let type: String
        public let value: String
        
        public init(
            message: String,
            type: String,
            value: String
        ) {
            self.message = message
            self.type = type
            self.value = value
        }
    }
}

extension Whitelist {
    public enum Delete {}
}

extension Whitelist.Delete {
    public struct Response: Sendable, Codable, Equatable {
        public let message: String
        public let value: String
        
        public init(
            message: String,
            value: String
        ) {
            self.message = message
            self.value = value
        }
    }
}

extension Whitelist.Delete {
    public enum All {
        public struct Response: Sendable, Codable, Equatable {
            public let message: String
            
            public init(
                message: String
            ) {
                self.message = message
            }
        }
    }
}

extension Whitelist {
    public enum Import {}
}

extension Whitelist.Import {
    public struct Response: Sendable, Codable, Equatable {
        public let message: String
        
        public init(message: String) {
            self.message = message
        }
    }
}
