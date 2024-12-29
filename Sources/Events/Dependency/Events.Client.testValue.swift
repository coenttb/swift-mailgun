//
//  Events.Client.testValue.swift
//  coenttb-mailgun
//
//  Created by coenttb on 28/12/2024.
//

import Foundation
import CoenttbWeb
import EmailAddress

extension Events.Client: TestDependencyKey {
    public static var testValue: Self {
        Self(
            list: { query in
                var events: [Event] = [
                    .init(
                        method: "smtp",
                        event: .delivered,
                        id: "test-message-id-1",
                        timestamp: Date().timeIntervalSince1970 - 3600,
                        logLevel: .info,
                        flags: ["is-test-mode": false],
                        message: .init(
                            headers: .init(
                                messageId: "test-message-id-1",
                                from: "sender@test.com",
                                to: "recipient@test.com",
                                subject: "Test Email"
                            ),
                            attachments: [],
                            size: 1024
                        ),
                        tags: ["test-tag"],
                        userVariables: [:],
                        recipientDomain: "test.com"
                    ),
                    .init(
                        method: "smtp",
                        event: .accepted,
                        id: "test-message-id-2",
                        timestamp: Date().timeIntervalSince1970 - 7200,
                        logLevel: .info,
                        flags: ["is-test-mode": false],
                        message: .init(
                            headers: .init(
                                messageId: "test-message-id-2",
                                from: "sender@test.com",
                                to: "recipient@test.com",
                                subject: "Test Email 2"
                            ),
                            attachments: [],
                            size: 512
                        ),
                        tags: [],
                        userVariables: [:],
                        recipientDomain: "test.com"
                    ),
                    .init(
                        method: "smtp",
                        event: .delivered,
                        id: "test-message-id-3",
                        timestamp: Date().timeIntervalSince1970 - 1800,
                        logLevel: .info,
                        flags: ["is-test-mode": false],
                        message: .init(
                            headers: .init(
                                messageId: "test-message-id-3",
                                from: "sender@test.com",
                                to: "recipient@test.com",
                                subject: "Test Email 3"
                            ),
                            attachments: [],
                            size: 768
                        ),
                        tags: ["test-tag"],
                        userVariables: [:],
                        recipientDomain: "test.com"
                    )
                ]
                
                if let query = query {
                    if let begin = query.begin {
                        events = events.filter { $0.timestamp! >= begin.timeIntervalSince1970 }
                    }
                    if let end = query.end {
                        events = events.filter { $0.timestamp! <= end.timeIntervalSince1970 }
                    }
                    
                    if let eventType = query.event {
                        events = events.filter { $0.event == eventType }
                    }
                    
                    if let tags = query.tags, !tags.isEmpty {
                        events = events.filter { event in
                            guard let eventTags = event.tags else { return false }
                            return !Set(tags).isDisjoint(with: Set(eventTags))
                        }
                    }
                    
                    if let limit = query.limit {
                        events = Array(events.prefix(limit))
                    }
                    
                    if let ascending = query.ascending {
                        events.sort { a, b in
                            switch ascending {
                            case .yes:
                                return a.timestamp! < b.timestamp!
                            case .no:
                                return a.timestamp! > b.timestamp!
                            }
                        }
                    }
                }
                
                return .init(
                    items: events,
                    paging: .init(
                        next: URL(string: "https://api.mailgun.net/v3/domain.com/events/next")!,
                        previous: URL(string: "https://api.mailgun.net/v3/domain.com/events/prev")!
                    )
                )
            }
        )
    }
}
