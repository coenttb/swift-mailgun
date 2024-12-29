import Foundation

public enum Stats {}

extension Stats {
    public enum Total {
        public struct Request: Sendable, Codable, Equatable {
            public let event: String
            public let start: String?
            public let end: String?
            public let resolution: String?
            public let duration: String?
            
            public init(
                event: String,
                start: String? = nil,
                end: String? = nil,
                resolution: String? = nil,
                duration: String? = nil
            ) {
                self.event = event
                self.start = start
                self.end = end
                self.resolution = resolution
                self.duration = duration
            }
        }
    }
    
    public enum Filter {
        public struct Request: Sendable, Codable, Equatable {
            public let event: String
            public let start: String?
            public let end: String?
            public let resolution: String?
            public let duration: String?
            public let filter: String?
            public let group: String?
            
            public init(
                event: String,
                start: String? = nil,
                end: String? = nil,
                resolution: String? = nil,
                duration: String? = nil,
                filter: String? = nil,
                group: String? = nil
            ) {
                self.event = event
                self.start = start
                self.end = end
                self.resolution = resolution
                self.duration = duration
                self.filter = filter
                self.group = group
            }
        }
    }
}

extension Stats {
    public struct Provider: Sendable, Codable, Equatable {
        public let opened: Int
        public let uniqueClicked: Int
        public let unsubscribed: Int
        public let accepted: Int
        public let clicked: Int
        
        public init(
            opened: Int,
            uniqueClicked: Int,
            unsubscribed: Int,
            accepted: Int,
            clicked: Int
        ) {
            self.opened = opened
            self.uniqueClicked = uniqueClicked
            self.unsubscribed = unsubscribed
            self.accepted = accepted
            self.clicked = clicked
        }
        
        private enum CodingKeys: String, CodingKey {
            case opened
            case uniqueClicked = "unique_clicked"
            case unsubscribed
            case accepted
            case clicked
        }
    }
}

extension Stats {
    public struct Device: Sendable, Codable, Equatable {
        public let unsubscribed: Int
        public let accepted: Int
        public let clicked: Int
        public let opened: Int
        public let uniqueClicked: Int
        
        public init(
            unsubscribed: Int,
            accepted: Int,
            clicked: Int,
            opened: Int,
            uniqueClicked: Int
        ) {
            self.unsubscribed = unsubscribed
            self.accepted = accepted
            self.clicked = clicked
            self.opened = opened
            self.uniqueClicked = uniqueClicked
        }
        
        private enum CodingKeys: String, CodingKey {
            case unsubscribed
            case accepted
            case clicked
            case opened
            case uniqueClicked = "unique_clicked"
        }
    }
}

extension Stats {
    public struct TimeStats: Sendable, Codable, Equatable {
        public let time: String
        public let delivered: Delivered
        public let accepted: Accepted
        public let stored: Stored
        public let failed: Failed
        public let unsubscribed: Unsubscribed
        public let opened: Opened
        public let campaign: Campaign
        public let clicked: Clicked
        public let complained: Complained
        public let seedTest: SeedTest
        public let emailValidation: EmailValidation
        public let linkValidationFailed: LinkValidationFailed
        public let linkValidation: LinkValidation
        public let emailPreview: EmailPreview
        public let emailPreviewFailed: EmailPreviewFailed
        
        public init(
            time: String,
            delivered: Delivered,
            accepted: Accepted,
            stored: Stored,
            failed: Failed,
            unsubscribed: Unsubscribed,
            opened: Opened,
            campaign: Campaign,
            clicked: Clicked,
            complained: Complained,
            seedTest: SeedTest,
            emailValidation: EmailValidation,
            linkValidationFailed: LinkValidationFailed,
            linkValidation: LinkValidation,
            emailPreview: EmailPreview,
            emailPreviewFailed: EmailPreviewFailed
        ) {
            self.time = time
            self.delivered = delivered
            self.accepted = accepted
            self.stored = stored
            self.failed = failed
            self.unsubscribed = unsubscribed
            self.opened = opened
            self.campaign = campaign
            self.clicked = clicked
            self.complained = complained
            self.seedTest = seedTest
            self.emailValidation = emailValidation
            self.linkValidationFailed = linkValidationFailed
            self.linkValidation = linkValidation
            self.emailPreview = emailPreview
            self.emailPreviewFailed = emailPreviewFailed
        }
        
        private enum CodingKeys: String, CodingKey {
            case time
            case delivered
            case accepted
            case stored
            case failed
            case unsubscribed
            case opened
            case campaign
            case clicked
            case complained
            case seedTest = "seed_test"
            case emailValidation = "email_validation"
            case linkValidationFailed = "link_validation_failed"
            case linkValidation = "link_validation"
            case emailPreview = "email_preview"
            case emailPreviewFailed = "email_preview_failed"
        }
    }
    
    public struct Delivered: Sendable, Codable, Equatable {
        public let smtp: Int
        public let http: Int
        public let optimized: Int
        public let total: Int
        
        public init(smtp: Int, http: Int, optimized: Int, total: Int) {
            self.smtp = smtp
            self.http = http
            self.optimized = optimized
            self.total = total
        }
    }
    
    public struct Accepted: Sendable, Codable, Equatable {
        public let incoming: Int
        public let outgoing: Int
        public let total: Int
        
        public init(incoming: Int, outgoing: Int, total: Int) {
            self.incoming = incoming
            self.outgoing = outgoing
            self.total = total
        }
    }
    
    public struct Stored: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct Failed: Sendable, Codable, Equatable {
        public let temporary: Temporary
        public let permanent: Permanent
        
        public init(temporary: Temporary, permanent: Permanent) {
            self.temporary = temporary
            self.permanent = permanent
        }
    }
    
    public struct Temporary: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct Permanent: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct Unsubscribed: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct Opened: Sendable, Codable, Equatable {
        public let total: Int
        public let unique: Int
        
        public init(total: Int, unique: Int) {
            self.total = total
            self.unique = unique
        }
    }
    
    public struct Campaign: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct Clicked: Sendable, Codable, Equatable {
        public let total: Int
        public let unique: Int
        
        public init(total: Int, unique: Int) {
            self.total = total
            self.unique = unique
        }
    }
    
    public struct Complained: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct SeedTest: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct EmailValidation: Sendable, Codable, Equatable {
        public let total: Int
        public let isPublic: Int
        public let valid: Int
        public let single: Int
        public let bulk: Int
        public let list: Int
        public let mailgun: Int
        public let mailjet: Int
        
        public init(
            total: Int,
            isPublic: Int,
            valid: Int,
            single: Int,
            bulk: Int,
            list: Int,
            mailgun: Int,
            mailjet: Int
        ) {
            self.total = total
            self.isPublic = isPublic
            self.valid = valid
            self.single = single
            self.bulk = bulk
            self.list = list
            self.mailgun = mailgun
            self.mailjet = mailjet
        }
        
        private enum CodingKeys: String, CodingKey {
            case total
            case isPublic = "public"
            case valid
            case single
            case bulk
            case list
            case mailgun
            case mailjet
        }
    }
    
    public struct LinkValidationFailed: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct LinkValidation: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct EmailPreview: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
    
    public struct EmailPreviewFailed: Sendable, Codable, Equatable {
        public let total: Int
        
        public init(total: Int) {
            self.total = total
        }
    }
}

extension Stats {
    public struct StatsList: Sendable, Codable, Equatable {
        public let description: String
        public let start: String
        public let end: String
        public let resolution: String
        public let stats: [TimeStats]
        
        public init(
            description: String,
            start: String,
            end: String,
            resolution: String,
            stats: [TimeStats]
        ) {
            self.description = description
            self.start = start
            self.end = end
            self.resolution = resolution
            self.stats = stats
        }
    }
}

extension Stats {
    public struct AggregatesProviders: Sendable, Codable, Equatable {
        public let providers: [String: Provider]
        
        public init(providers: [String: Provider]) {
            self.providers = providers
        }
    }
    
    public struct AggregatesDevices: Sendable, Codable, Equatable {
        public let devices: [String: Device]
        
        public init(devices: [String: Device]) {
            self.devices = devices
        }
    }
    
    public struct AggregatesCountries: Sendable, Codable, Equatable {
        public let countries: [String: Int]
        
        public init(countries: [String: Int]) {
            self.countries = countries
        }
    }
}
