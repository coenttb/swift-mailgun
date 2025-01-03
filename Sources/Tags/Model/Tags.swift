//
//  Tags.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Foundation
import Shared

public struct Tag: Sendable, Codable, Equatable {
    public let tag: String
    public let description: String
    public let firstSeen: String
    public let lastSeen: String
    
    public init(
        tag: String,
        description: String,
        firstSeen: String,
        lastSeen: String
    ) {
        self.tag = tag
        self.description = description
        self.firstSeen = firstSeen
        self.lastSeen = lastSeen
    }
    
    enum CodingKeys: String, CodingKey {
        case tag
        case description
        case firstSeen = "first-seen"
        case lastSeen = "last-seen"
    }
}

extension Tag {
    public enum List {
        public struct Request: Sendable, Codable, Equatable {
            public let page: String?
            public let limit: Int?
            
            public init(page: String? = nil, limit: Int? = nil) {
                self.page = page
                self.limit = limit
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let items: [Tag]
            public let paging: Paging
            
            public init(items: [Tag], paging: Paging) {
                self.items = items
                self.paging = paging
            }
        }
        
        public struct Paging: Sendable, Codable, Equatable {
            public let previous: URL?
            public let first: URL
            public let next: URL?
            public let last: URL
            
            public init(previous: URL?, first: URL, next: URL?, last: URL) {
                self.previous = previous
                self.first = first
                self.next = next
                self.last = last
            }
        }
    }
}

extension Tag {
    public enum Stats {
        public struct Request: Sendable, Codable, Equatable {
            public let event: [String]
            public let start: String?
            public let end: String?
            public let resolution: String?
            public let duration: String?
            public let provider: String?
            public let device: String?
            public let country: String?
            
            public init(
                event: [String],
                start: String? = nil,
                end: String? = nil,
                resolution: String? = nil,
                duration: String? = nil,
                provider: String? = nil,
                device: String? = nil,
                country: String? = nil
            ) {
                self.event = event
                self.start = start
                self.end = end
                self.resolution = resolution
                self.duration = duration
                self.provider = provider
                self.device = device
                self.country = country
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let description: String
            public let start: String
            public let end: String
            public let resolution: String
            public let stats: [Stat]
            public let tag: String
            
            public init(
                description: String,
                start: String,
                end: String,
                resolution: String,
                stats: [Stat],
                tag: String
            ) {
                self.description = description
                self.start = start
                self.end = end
                self.resolution = resolution
                self.stats = stats
                self.tag = tag
            }
            
            public struct Stat: Sendable, Codable, Equatable {
                public let time: String
                public let accepted: StatCount?
                public let delivered: StatCount?
                public let failed: StatCount?
                public let opened: StatCount?
                public let clicked: StatCount?
                public let unsubscribed: StatCount?
                public let complained: StatCount?
                public let stored: StatCount?
                
                public init(
                    time: String,
                    accepted: StatCount? = nil,
                    delivered: StatCount? = nil,
                    failed: StatCount? = nil,
                    opened: StatCount? = nil,
                    clicked: StatCount? = nil,
                    unsubscribed: StatCount? = nil,
                    complained: StatCount? = nil,
                    stored: StatCount? = nil
                ) {
                    self.time = time
                    self.accepted = accepted
                    self.delivered = delivered
                    self.failed = failed
                    self.opened = opened
                    self.clicked = clicked
                    self.unsubscribed = unsubscribed
                    self.complained = complained
                    self.stored = stored
                }
            }
            
            public struct StatCount: Sendable, Codable, Equatable {
                public let count: Int
                public let total: Int?
                
                public init(count: Int, total: Int? = nil) {
                    self.count = count
                    self.total = total
                }
            }
        }
    }
}

extension Tag {
    public enum Aggregates {
        public struct Request: Sendable, Codable, Equatable {
            public let type: String
            
            public init(type: String) {
                self.type = type
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let provider: [String: ProviderStats]?
            public let device: [String: DeviceStats]?
            public let country: [String: CountryStats]?
            
            public init(
                provider: [String: ProviderStats]? = nil,
                device: [String: DeviceStats]? = nil,
                country: [String: CountryStats]? = nil
            ) {
                self.provider = provider
                self.device = device
                self.country = country
            }
            
            public struct ProviderStats: Sendable, Codable, Equatable {
                public let opened: Int
                public let clicked: Int
                public let unsubscribed: Int
                public let accepted: Int
                public let uniqueClicked: Int
                
                public init(
                    opened: Int,
                    clicked: Int,
                    unsubscribed: Int,
                    accepted: Int,
                    uniqueClicked: Int
                ) {
                    self.opened = opened
                    self.clicked = clicked
                    self.unsubscribed = unsubscribed
                    self.accepted = accepted
                    self.uniqueClicked = uniqueClicked
                }
                
                enum CodingKeys: String, CodingKey {
                    case opened, clicked, unsubscribed, accepted
                    case uniqueClicked = "unique_clicked"
                }
            }
            
            public struct DeviceStats: Sendable, Codable, Equatable {
                public let opened: Int
                public let clicked: Int
                public let uniqueClicked: Int
                
                public init(opened: Int, clicked: Int, uniqueClicked: Int) {
                    self.opened = opened
                    self.clicked = clicked
                    self.uniqueClicked = uniqueClicked
                }
                
                enum CodingKeys: String, CodingKey {
                    case opened, clicked
                    case uniqueClicked = "unique_clicked"
                }
            }
            
            public struct CountryStats: Sendable, Codable, Equatable {
                public let opened: Int
                public let clicked: Int
                public let uniqueClicked: Int
                
                public init(opened: Int, clicked: Int, uniqueClicked: Int) {
                    self.opened = opened
                    self.clicked = clicked
                    self.uniqueClicked = uniqueClicked
                }
                
                enum CodingKeys: String, CodingKey {
                    case opened, clicked
                    case uniqueClicked = "unique_clicked"
                }
            }
        }
    }
}

extension Tag {
    public enum Delete {}
}

extension Tag.Delete {
    public struct Response: Decodable {
        public let message: String
    }
}

extension Tag {
    public enum Limits {
        public struct Response: Sendable, Codable, Equatable {
            public let limit: Int
            public let count: Int
            public let id: String?
            
            public init(limit: Int, count: Int, id: String? = nil) {
                self.limit = limit
                self.count = count
                self.id = id
            }
        }
    }
}
