//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import EmailAddress

public enum Unsubscribe {}

extension Unsubscribe {
    public struct Record: Sendable, Codable, Equatable {
        public let address: EmailAddress
        public let tags: [String]
        public let createdAt: String
        
        public init(
            address: EmailAddress,
            tags: [String],
            createdAt: String
        ) {
            self.address = address
            self.tags = tags
            self.createdAt = createdAt
        }
        
        private enum CodingKeys: String, CodingKey {
            case address
            case tags
            case createdAt = "created_at"
        }
    }
}

extension Unsubscribe {
    public enum Import {}
}

extension Unsubscribe.Import {
    public struct Response: Sendable, Codable, Equatable {
        public let message: String
        
        public init(message: String) {
            self.message = message
        }
    }
}

extension Unsubscribe {
    public enum Create {}
}

extension Unsubscribe.Create {
    public struct Request: Sendable, Codable, Equatable {
        public let address: EmailAddress
        public let tags: [String]?
        public let createdAt: String?
        
        public init(
            address: EmailAddress,
            tags: [String]? = nil,
            createdAt: String? = nil
        ) {
            self.address = address
            self.tags = tags
            self.createdAt = createdAt
        }
        
        private enum CodingKeys: String, CodingKey {
            case address
            case tags
            case createdAt = "created_at"
        }
    }
    
    public struct Response: Sendable, Codable, Equatable {
        public let message: String
        
        public init(message: String) {
            self.message = message
        }
    }
}

extension Unsubscribe {
    public enum Delete {}
}

extension Unsubscribe.Delete {
    public struct Response: Sendable, Codable, Equatable {
        public let message: String
        public let address: EmailAddress
        
        public init(
            message: String,
            address: EmailAddress
        ) {
            self.message = message
            self.address = address
        }
    }
}

extension Unsubscribe.Delete {
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


extension Unsubscribe {
    public enum List {}
}

extension Unsubscribe.List {
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
        public let items: [Unsubscribe.Record]
        public let paging: Paging
        
        public init(
            items: [Unsubscribe.Record],
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
