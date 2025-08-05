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

//extension Suppressions.Whitelist.Client: TestDependencyKey {
//    public static var testValue: Self {
//        return Self(
//            get: { _ in
//                .init(
//                    type: "domain",
//                    value: "example.com",
//                    reason: "Test whitelist record",
//                    createdAt: "Fri, 27 Dec 2024 18:28:14 UTC"
//                )
//            },
//            delete: { value in
//                .init(
//                    message: "Whitelist address/domain has been removed",
//                    value: value
//                )
//            },
//            list: { _ in
//                .init(
//                    items: [
//                        .init(
//                            type: "domain",
//                            value: "example.com",
//                            reason: "Test whitelist record",
//                            createdAt: "Fri, 27 Dec 2024 18:28:14 UTC"
//                        )
//                    ],
//                    paging: .init(
//                        previous: "https://api.mailgun.net/v3/whitelists?page=previous",
//                        first: "https://api.mailgun.net/v3/whitelists?page=first",
//                        next: "https://api.mailgun.net/v3/whitelists?page=next",
//                        last: "https://api.mailgun.net/v3/whitelists?page=last"
//                    )
//                )
//            },
//            create: { request in
//                switch request {
//                case let .address(address):
//                    return .init(
//                        message: "Address/Domain has been added to the whitelists table",
//                        type: "address",
//                        value: address.address
//                    )
//                case let .domain(domain):
//                    return .init(
//                        message: "Address/Domain has been added to the whitelists table",
//                        type: "domain",
//                        value: domain.rawValue
//                    )
//                }
//            },
//            deleteAll: {
//                .init(
//                    message: "Whitelist addresses/domains for this domain have been removed"
//                )
//            },
//            importList: { _ in
//                .init(message: "file uploaded successfully")
//            }
//        )
//    }
//}
