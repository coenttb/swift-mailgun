//
//  Tags.Client.testValue.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Foundation
import Dependencies
import Domain

extension Client: TestDependencyKey {
    public static var testValue: Self {
        
        let domain: Domain = try! .init("test.domain.com")
        
        return Self(
            list: { request in
                .init(
                    items: [
                        .init(
                            tag: "test-tag-1",
                            description: "Test Tag 1",
                            firstSeen: "2023-01-02 02:14:27 +0000 UTC",
                            lastSeen: "2023-09-06 18:45:51 +0000 UTC"
                        ),
                        .init(
                            tag: "test-tag-2",
                            description: "Test Tag 2",
                            firstSeen: "2023-01-02 02:14:27 +0000 UTC",
                            lastSeen: "2023-09-06 18:45:51 +0000 UTC"
                        )
                    ],
                    paging: .init(
                        previous: URL(string: "https://api.mailgun.net/v3/\(domain)/tags?page=prev"),
                        first: URL(string: "https://api.mailgun.net/v3/\(domain)/tags?page=first")!,
                        next: URL(string: "https://api.mailgun.net/v3/\(domain)/tags?page=next"),
                        last: URL(string: "https://api.mailgun.net/v3/\(domain)/tags?page=last")!
                    )
                )
            },
            
            get: { tag in
                .init(
                    tag: tag,
                    description: "Test Tag Description",
                    firstSeen: "2023-01-02 02:14:27 +0000 UTC",
                    lastSeen: "2023-09-06 18:45:51 +0000 UTC"
                )
            },
            
            update: { tag, description in
                .init(
                    tag: tag,
                    description: description,
                    firstSeen: "2023-01-02 02:14:27 +0000 UTC",
                    lastSeen: "2023-09-06 18:45:51 +0000 UTC"
                )
            },
            
            delete: { tag in
                "Tag has been deleted"
            },
            
            stats: { tag, request in
                .init(
                    description: "Test Tag Stats",
                    start: "2023-01-02 02:14:27 +0000 UTC",
                    end: "2023-09-06 18:45:51 +0000 UTC",
                    resolution: "day",
                    stats: [
                        .init(
                            time: "2023-09-06 18:45:51 +0000 UTC",
                            accepted: .init(count: 100, total: 100),
                            delivered: .init(count: 95, total: 100),
                            failed: .init(count: 5, total: 100),
                            opened: .init(count: 75, total: 95),
                            clicked: .init(count: 50, total: 95),
                            unsubscribed: .init(count: 2, total: 95),
                            complained: .init(count: 1, total: 95),
                            stored: .init(count: 100, total: 100)
                        )
                    ],
                    tag: tag
                )
            },
            
            aggregates: { tag, request in
                .init(
                    provider: [
                        "gmail.com": .init(
                            opened: 75,
                            clicked: 50,
                            unsubscribed: 2,
                            accepted: 100,
                            uniqueClicked: 45
                        )
                    ],
                    device: [
                        "mobile": .init(
                            opened: 45,
                            clicked: 30,
                            uniqueClicked: 25
                        ),
                        "desktop": .init(
                            opened: 30,
                            clicked: 20,
                            uniqueClicked: 20
                        )
                    ],
                    country: [
                        "US": .init(
                            opened: 50,
                            clicked: 35,
                            uniqueClicked: 30
                        ),
                        "GB": .init(
                            opened: 25,
                            clicked: 15,
                            uniqueClicked: 15
                        )
                    ]
                )
            },
            
            limits: {
                .init(
                    limit: 20000,
                    count: 1500,
                    id: "test-id"
                )
            }
        )
    }
}
