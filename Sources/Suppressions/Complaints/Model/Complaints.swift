// Complaints.swift
import Foundation
import EmailAddress

public enum Complaints {}

extension Complaints {
    public struct Record: Sendable, Codable, Equatable {
        public let address: EmailAddress
        public let createdAt: String
        
        public init(
            address: EmailAddress,
            createdAt: String
        ) {
            self.address = address
            self.createdAt = createdAt
        }
        
        private enum CodingKeys: String, CodingKey {
            case address
            case createdAt = "created_at"
        }
    }
}

extension Complaints {
    public enum Import {}
}

extension Complaints.Import {
    public struct Response: Sendable, Codable, Equatable {
        public let message: String
        
        public init(message: String) {
            self.message = message
        }
    }
}

extension Complaints {
    public enum Create {}
}

extension Complaints.Create {
    public struct Request: Sendable, Codable, Equatable {
        public let address: EmailAddress
        public let createdAt: String?
        
        public init(
            address: EmailAddress,
            createdAt: String? = nil
        ) {
            self.address = address
            self.createdAt = createdAt
        }
        
        private enum CodingKeys: String, CodingKey {
            case address
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

extension Complaints {
    public enum Delete {}
}

extension Complaints.Delete {
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

extension Complaints.Delete {
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

extension Complaints {
    public enum List {}
}

extension Complaints.List {
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
        public let items: [Complaints.Record]
        public let paging: Paging
        
        public init(
            items: [Complaints.Record],
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
