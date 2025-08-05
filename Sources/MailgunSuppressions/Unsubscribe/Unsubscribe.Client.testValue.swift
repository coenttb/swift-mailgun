//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import MailgunShared
import SuppressionsTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

//extension Suppressions.Unsubscribe.Client: TestDependencyKey {
//    public static var testValue: Self {
//        return Self(
//            get: { _ in
//                .init(
//                    address: try .init("test@example.com"),
//                    tags: ["*"],
//                    createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
//                )
//            },
//            delete: { _ in
//                .init(
//                    message: "Unsubscribe event has been removed",
//                    address: try .init("test@example.com")
//                )
//            },
//            list: { _ in
//                .init(
//                    items: [
//                        .init(
//                            address: try .init("test@example.com"),
//                            tags: ["*"],
//                            createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
//                        )
//                    ],
//                    paging: .init(
//                        previous: "https://api.mailgun.net/v3/domain/unsubscribes?page=prev",
//                        first: "https://api.mailgun.net/v3/domain/unsubscribes?page=first",
//                        next: "https://api.mailgun.net/v3/domain/unsubscribes?page=next",
//                        last: "https://api.mailgun.net/v3/domain/unsubscribes?page=last"
//                    )
//                )
//            },
//            create: { _ in
//                .init(message: "Unsubscribe event has been created")
//            },
//            deleteAll: {
//                .init(
//                    message: "All unsubscribe events have been removed"
//                )
//            },
//            importList: { _ in
//                .init(message: "file uploaded successfully")
//            }
//        )
//    }
//}
