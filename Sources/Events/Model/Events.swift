//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import EmailAddress

public struct Event: Sendable, Decodable, Equatable {
    public let method: String?
    public let event: Event.Variant?
    public let id: String?
    public let timestamp: TimeInterval?
    public let logLevel: Event.LogLevel?
    public let flags: [String: Bool]?
    public let reject: Reject?
    public let message: Message?
    public let tags: [String]?
    public let userVariables: [String: String]?
    public let geolocation: GeoLocation?
    public let clientInfo: ClientInfo?
    public let deliveryStatus: DeliveryStatus?
    public let batch: Batch?
    public let recipientDomain: String?
    public let recipientProvider: String?
    public let template: Template?
    public let envelope: Envelope?
    public let sendingIp: String?
    public let severity: Events.List.Query.Severity?

    public init(
        method: String? = nil,
        event: Event.Variant?,
        id: String? = nil,
        timestamp: TimeInterval? = nil,
        logLevel: Event.LogLevel? = nil,
        flags: [String : Bool]? = nil,
        reject: Reject? = nil,
        message: Message? = nil,
        tags: [String]? = nil,
        userVariables: [String : String]? = [:],
        geolocation: GeoLocation? = nil,
        clientInfo: ClientInfo? = nil,
        deliveryStatus: DeliveryStatus? = nil,
        batch: Batch? = nil,
        recipientDomain: String? = nil,
        recipientProvider: String? = nil,
        template: Template? = nil,
        envelope: Envelope? = nil,
        sendingIp: String? = nil,
        severity: Events.List.Query.Severity? = nil
    ) {
        self.method = method
        self.event = event
        self.id = id
        self.timestamp = timestamp
        self.logLevel = logLevel
        self.flags = flags
        self.reject = reject
        self.message = message
        self.tags = tags
        self.userVariables = userVariables
        self.geolocation = geolocation
        self.clientInfo = clientInfo
        self.deliveryStatus = deliveryStatus
        self.batch = batch
        self.recipientDomain = recipientDomain
        self.recipientProvider = recipientProvider
        self.template = template
        self.envelope = envelope
        self.sendingIp = sendingIp
        self.severity = severity
    }
    
    private enum CodingKeys: String, CodingKey {
        case method
        case event
        case id
        case timestamp
        case logLevel = "log-level"
        case flags
        case reject
        case message
        case tags
        case userVariables = "user-variables"
        case geolocation
        case clientInfo = "client-info"
        case deliveryStatus = "delivery-status"
        case batch
        case recipientDomain = "recipient-domain"
        case recipientProvider = "recipient-provider"
        case template
        case envelope
        case sendingIp = "sending-ip"
        case severity
    }
}

extension Event {
    public enum LogLevel: String, Codable, Hashable, Sendable {
        case info
        case warning
        case error
        
        private enum CodingKeys: String, CodingKey {
            case info
            case warning = "warn"
            case error
        }
    }

}
extension Event {
    public enum Variant: String, Codable, Hashable, Sendable {
        case accepted
        case delivered
        case failed
        case rejected
        case clicked
        case opened
        case unsubscribed
        case stored
        case complained
        case emailValidation
        case listMemberUploaded
        case listMemberUploadError
        case listUploaded
        
        private enum CodingKeys: String, CodingKey {
            case accepted
            case delivered
            case failed
            case rejected
            case clicked
            case opened
            case unsubscribed
            case stored
            case complained
            case emailValidation
            case listMemberUploaded = "list_member_uploaded"
            case listMemberUploadError = "list_member_upload_error"
            case listUploaded = "list_uploaded"
        }
    }
}
    
extension Event {
    public enum Flag: String, Codable, Hashable, Sendable  {
        case isAuthenticated = "is-authenticated"
        case isRouted = "is-routed"
        case isAmp = "is-amp"
        case isEncrypted = "is-encrypted"
        case isTestMode = "is-test-mode"
    }
}

extension Event {
    public struct Reject: Sendable, Decodable, Equatable {
        public let reason: String?
        public let description: String??
    }
}

extension Event {
    public struct Message: Sendable, Decodable, Equatable {
        public let headers: Headers
        public let attachments: [Attachment]?
        public let size: Int?
        public let scheduledFor: String?
        public let storage: Storage?

        private enum CodingKeys: String, CodingKey {
            case headers
            case attachments
            case size
            case scheduledFor = "scheduled-for"
            case storage
        }

        public init(
            headers: Headers,
            attachments: [Attachment]?,
            size: Int?,
            scheduledFor: String? = nil,
            storage: Storage? = nil
        ) {
            self.headers = headers
            self.attachments = attachments
            self.size = size
            self.scheduledFor = scheduledFor
            self.storage = storage
        }

        public struct Headers: Sendable, Decodable, Equatable {
            public let messageId: String
            public let from: String
            public let to: String?
            public let subject: String?

            private enum CodingKeys: String, CodingKey {
                case to
                case from
                case subject
                case messageId = "message-id"
            }

            public init(
                messageId: String,
                from: String,
                to: String? = nil,
                subject: String? = nil
            ) {
                self.to = to
                self.from = from
                self.subject = subject
                self.messageId = messageId
            }
        }

        public struct Attachment: Sendable, Decodable, Equatable {
            public let filename: String
            public let contentType: String
            public let size: Int

            public init(filename: String, contentType: String, size: Int) {
                self.filename = filename
                self.contentType = contentType
                self.size = size
            }
        }

        public struct Storage: Sendable, Decodable, Equatable {
            public let key: String
            public let url: String
            public let region: String

            public init(key: String, url: String, region: String) {
                self.key = key
                self.url = url
                self.region = region
            }
        }
    }
}

extension Event {
    public struct GeoLocation: Sendable, Decodable, Equatable {
        public let country: String?
        public let region: String?
        public let city: String?

        public init(country: String?, region: String?, city: String?) {
            self.country = country
            self.region = region
            self.city = city
        }
    }
}

extension Event {
    public struct ClientInfo: Sendable, Decodable, Equatable {
        public let clientType: String?
        public let clientOs: String?
        public let deviceType: String?
        public let clientName: String?
        public let userAgent: String?
        public let ip: String?

        private enum CodingKeys: String, CodingKey {
            case clientType = "client-type"
            case clientOs = "client-os"
            case deviceType = "device-type"
            case clientName = "client-name"
            case userAgent = "user-agent"
            case ip
        }

        public init(
            clientType: String?,
            clientOs: String?,
            deviceType: String?,
            clientName: String?,
            userAgent: String?,
            ip: String?
        ) {
            self.clientType = clientType
            self.clientOs = clientOs
            self.deviceType = deviceType
            self.clientName = clientName
            self.userAgent = userAgent
            self.ip = ip
        }
        
        public enum DeviceType: String, Codable, Hashable, Sendable {
            case desktop
            case mobile
            case tablet
            case unknown
        }
    }
}

extension Event {
    public struct DeliveryStatus: Sendable, Decodable, Equatable {
        public let code: Int?
        public let attemptNo: Int?
        public let message: String?
        public let description: String?
        public let enhancedCode: String?
        public let mxhost: String?
        public let certificateVerified: Bool?
        public let tls: Bool?
        public let utf8: Bool?
        public let firstDeliveryAttemptSeconds: Double?
        public let sessionSeconds: Double?
        public let retrySeconds: Int?

        private enum CodingKeys: String, CodingKey {
            case code
            case attemptNo = "attempt-no"
            case message
            case description
            case enhancedCode = "enhanced-code"
            case mxhost
            case certificateVerified = "certificate-verified"
            case tls
            case utf8
            case firstDeliveryAttemptSeconds = "first-delivery-attempt-seconds"
            case sessionSeconds = "session-seconds"
            case retrySeconds = "retry-seconds"
        }

        public init(
            code: Int?,
            attemptNo: Int?,
            message: String?,
            description: String?,
            enhancedCode: String?,
            mxhost: String?,
            certificateVerified: Bool?,
            tls: Bool?,
            utf8: Bool?,
            firstDeliveryAttemptSeconds: Double?,
            sessionSeconds: Double?,
            retrySeconds: Int?
        ) {
            self.code = code
            self.attemptNo = attemptNo
            self.message = message
            self.description = description
            self.enhancedCode = enhancedCode
            self.mxhost = mxhost
            self.certificateVerified = certificateVerified
            self.tls = tls
            self.utf8 = utf8
            self.firstDeliveryAttemptSeconds = firstDeliveryAttemptSeconds
            self.sessionSeconds = sessionSeconds
            self.retrySeconds = retrySeconds
        }
    }
}

extension Event {
    public struct Batch: Sendable, Decodable, Equatable {
        public let id: String?
        public let severity: Events.List.Query.Severity?

        public init(id: String?, severity: Events.List.Query.Severity?) {
            self.id = id
            self.severity = severity
        }
    }
}

extension Event {
    public struct Template: Sendable, Decodable, Equatable {
        public let name: String?
        public let version: String?
        public let isText: String?

        private enum CodingKeys: String, CodingKey {
            case name
            case version
            case isText = "is-text"
        }

        public init(
            name: String?,
            version: String?,
            isText: String?
        ) {
            self.name = name
            self.version = version
            self.isText = isText
        }
    }
}

extension Event {
    public struct Envelope: Sendable, Decodable, Equatable {
        public let sender: String?
        public let targets: String?
        public let transport: String?
        public let sendingIp: String?

        private enum CodingKeys: String, CodingKey {
            case sender
            case targets
            case transport
            case sendingIp = "sending-ip"
        }

        public init(
            sender: String?,
            targets: String?,
            transport: String?,
            sendingIp: String?
        ) {
            self.sender = sender
            self.targets = targets
            self.transport = transport
            self.sendingIp = sendingIp
        }
    }
}
