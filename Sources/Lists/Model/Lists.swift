//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Coenttb_Web


public struct List: Sendable, Codable, Equatable {
    public let address: EmailAddress
    public let name: String?
    public let description: String?
    public let accessLevel: AccessLevel?
    public let replyPreference: ReplyPreference?
    public let createdAt: String
    public let membersCount: Int
    
    public init(
        address: EmailAddress,
        name: String?,
        description: String?,
        accessLevel: AccessLevel?,
        replyPreference: ReplyPreference?,
        createdAt: String,
        membersCount: Int
    ) {
        self.address = address
        self.name = name
        self.description = description
        self.accessLevel = accessLevel
        self.replyPreference = replyPreference
        self.createdAt = createdAt
        self.membersCount = membersCount
    }
    
    enum CodingKeys: String, CodingKey {
        case address
        case name
        case description
        case accessLevel = "access_level"
        case replyPreference = "reply_preference"
        case createdAt = "created_at"
        case membersCount = "members_count"
    }
}

public struct Member: Sendable, Codable, Equatable {
    public let address: EmailAddress?
    public let name: String?
    public let vars: [String: String]?
    public let subscribed: Bool?
    
    public init(
        address: EmailAddress?,
        name: String?,
        vars: [String: String]?,
        subscribed: Bool?
    ) {
        self.address = address
        self.name = name
        self.vars = vars
        self.subscribed = subscribed
    }
    
    
}

public struct Paging: Sendable, Codable, Equatable {
    public let first: URL
    public let last: URL
    public let next: URL?
    public let previous: URL?
    
    public init(first: URL, last: URL, next: URL?, previous: URL?) {
        self.first = first
        self.last = last
        self.next = next
        self.previous = previous
    }
}

public enum AccessLevel: String, Sendable, Codable, Equatable {
    case readonly
    case members
    case everyone
}

public enum ReplyPreference: String, Sendable, Codable, Equatable {
    case list
    case sender
}

public enum PageDirection: String, Sendable, Codable, Equatable, RawRepresentable {
    case first
    case last
    case next
    case prev
}

// List Operations
extension List {
    public enum Create {
        public struct Request: Sendable, Codable, Equatable {
            public let address: EmailAddress
            public let name: String?
            public let description: String?
            public let accessLevel: Lists.AccessLevel?
            public let replyPreference: Lists.ReplyPreference?
            
            public init(
                address: EmailAddress,
                name: String? = nil,
                description: String? = nil,
                accessLevel: Lists.AccessLevel?,
                replyPreference: Lists.ReplyPreference? = nil
            ) {
                self.address = address
                self.name = name
                self.description = description
                self.accessLevel = accessLevel
                self.replyPreference = replyPreference
            }
            
            enum CodingKeys: String, CodingKey {
                case address
                case name
                case description
                case accessLevel = "access_level"
                case replyPreference = "reply_preference"
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let list: Lists.List
            public let message: String
            
            public init(list: Lists.List, message: String) {
                self.list = list
                self.message = message
            }
        }
    }
    
    public struct Request: Sendable, Codable, Equatable {
        public let limit: Int?
        public let skip: Int?
        public let address: EmailAddress?
        
        public init(
            limit: Int? = nil,
            skip: Int? = nil,
            address: EmailAddress? = nil
        ) {
            self.limit = limit
            self.skip = skip
            self.address = address
        }
    }
    
    public struct Response: Sendable, Codable, Equatable {
        public let totalCount: Int
        public let items: [Lists.List]
        
        public init(totalCount: Int, items: [Lists.List]) {
            self.totalCount = totalCount
            self.items = items
        }
    }
    
    public enum Update {
        public struct Request: Sendable, Codable, Equatable {
            public let address: EmailAddress?
            public let description: String?
            public let name: String?
            public let accessLevel: Lists.AccessLevel?
            public let replyPreference: Lists.ReplyPreference?
            public let listId: String?
            
            public init(
                address: EmailAddress? = nil,
                description: String? = nil,
                name: String? = nil,
                accessLevel: Lists.AccessLevel? = nil,
                replyPreference: Lists.ReplyPreference? = nil,
                listId: String? = nil
            ) {
                self.address = address
                self.name = name
                self.description = description
                self.accessLevel = accessLevel
                self.replyPreference = replyPreference
                self.listId = listId
            }
            
            enum CodingKeys: String, CodingKey {
                case address
                case description
                case name
                case accessLevel = "access_level"
                case replyPreference = "reply_reference"
                case listId = "list-id"
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let message: String
            public let list: Lists.List
            
            public init(message: String, list: Lists.List) {
                self.message = message
                self.list = list
            }
        }
    }
    
    public enum Delete {
        public struct Response: Sendable, Decodable, Equatable {
            public let address: EmailAddress
            public let message: String
            
            public init(address: EmailAddress, message: String) {
                self.address = address
                self.message = message
            }
        }
    }
    
    public enum Get {
        public struct Response: Sendable, Decodable, Equatable {
            public let list: Lists.List
            
            public init(list: Lists.List) {
                self.list = list
            }
        }
    }
    
    public enum Pages {
        public struct Response: Sendable, Decodable, Equatable {
            public let paging: Lists.Paging
            public let items: [Lists.List]
            
            public init(paging: Lists.Paging, items: [Lists.List]) {
                self.paging = paging
                self.items = items
            }
        }
    }
}

extension Lists.List {
    public enum Members {
        public struct Request: Sendable, Codable, Equatable {
            public let address: EmailAddress?
            public let subscribed: Bool?
            public let limit: Int?
            public let skip: Int?
            
            public init(
                address: EmailAddress? = nil,
                subscribed: Bool? = nil,
                limit: Int? = nil,
                skip: Int? = nil
            ) {
                self.address = address
                self.subscribed = subscribed
                self.limit = limit
                self.skip = skip
            }
        }
        
        public struct Response: Sendable, Decodable, Equatable {
            public let totalCount: Int
            public let items: [Lists.Member]
            
            public init(totalCount: Int, items: [Lists.Member]) {
                self.totalCount = totalCount
                self.items = items
            }
        }
        
        public enum Pages {
            public struct Request: Sendable, Decodable, Equatable {
                public let subscribed: Bool?
                public let limit: Int?
                public let address: EmailAddress?
                public let page: Lists.PageDirection?
                
                public init(
                    subscribed: Bool? = nil,
                    limit: Int? = nil,
                    address: EmailAddress? = nil,
                    page: Lists.PageDirection? = nil
                ) {
                    self.subscribed = subscribed
                    self.limit = limit
                    self.address = address
                    self.page = page
                }
            }
            
            public struct Response: Sendable, Codable, Equatable {
                public let paging: Lists.Paging
                public let items: [Lists.Member]
                
                public init(paging: Lists.Paging, items: [Lists.Member]) {
                    self.paging = paging
                    self.items = items
                }
            }
        }
    }
}

extension Lists.Member {
    
    public enum Get {
        public struct Response: Sendable, Codable, Equatable {
            public let member: Lists.Member
            
            public init(member: Lists.Member) {
                self.member = member
            }
        }
    }
    
    public enum Add {
        public struct Request: Sendable, Codable, Equatable {
            public let address: EmailAddress
            public let name: String?
            public let vars: [String: String]?
            public let subscribed: Bool?
            public let upsert: Bool?
            
            public init(
                address: EmailAddress,
                name: String? = nil,
                vars: [String: String]? = nil,
                subscribed: Bool? = nil,
                upsert: Bool? = nil
            ) {
                self.address = address
                self.name = name
                self.vars = vars
                self.subscribed = subscribed
                self.upsert = upsert
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let member: Lists.Member
            public let message: String
            
            public init(member: Lists.Member, message: String) {
                self.member = member
                self.message = message
            }
        }
    }
    
    public enum Update {
        public struct Request: Sendable, Codable, Equatable {
            public let address: EmailAddress?
            public let name: String?
            public let vars: [String: String]?
            public let subscribed: Bool?
            
            public init(
                address: EmailAddress? = nil,
                name: String? = nil,
                vars: [String: String]? = nil,
                subscribed: Bool? = nil
            ) {
                self.address = address
                self.name = name
                self.vars = vars
                self.subscribed = subscribed
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let member: Lists.Member
            public let message: String
            
            public init(member: Lists.Member, message: String) {
                self.member = member
                self.message = message
            }
        }
    }
    
    public enum Delete {
        public struct Response: Sendable, Codable, Equatable {
            public let member: DeletedInfo
            public let message: String
            
            public init(member: DeletedInfo, message: String) {
                self.member = member
                self.message = message
            }
        }
        
        public struct DeletedInfo: Sendable, Codable, Equatable {
            public let address: EmailAddress
            
            public init(address: EmailAddress) {
                self.address = address
            }
        }
    }
    
    public struct Bulk: Sendable, Codable, Equatable {
        public let address: EmailAddress
        public let name: String?
        public let vars: [String: String]?
        public let subscribed: Bool?
        
        public init(
            address: EmailAddress,
            name: String? = nil,
            vars: [String: String]? = nil,
            subscribed: Bool? = nil
        ) {
            self.address = address
            self.name = name
            self.vars = vars
            self.subscribed = subscribed
        }
    }
}

extension Lists.Member.Bulk {
    public struct Response: Sendable, Codable, Equatable {
        public let list: Lists.List
        public let taskId: String
        public let message: String
        
        public init(list: Lists.List, taskId: String, message: String) {
            self.list = list
            self.taskId = taskId
            self.message = message
        }
        
        enum CodingKeys: String, CodingKey {
            case list
            case taskId = "task_id"
            case message
        }
    }
}

