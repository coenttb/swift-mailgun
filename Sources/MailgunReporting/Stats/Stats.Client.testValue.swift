//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import MailgunShared
import ReportingTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

//extension Reporting.Stats.Client: TestDependencyKey {
//    public static var testValue: Self {
//        return Self(
//            total: { _ in
//                .init(
//                    description: "Test Stats",
//                    start: "Tue, 14 Feb 2024 00:00:00 UTC",
//                    end: "Fri, 01 Mar 2024 00:00:00 UTC",
//                    resolution: "month",
//                    stats: [
//                        .init(
//                            time: "Fri, 01 Mar 2024 00:00:00 UTC",
//                            delivered: .init(smtp: 100, http: 50, optimized: 25, total: 175),
//                            accepted: .init(incoming: 200, outgoing: 180, total: 380),
//                            stored: .init(total: 15),
//                            failed: .init(
//                                temporary: .init(total: 5),
//                                permanent: .init(total: 2)
//                            ),
//                            unsubscribed: .init(total: 3),
//                            opened: .init(total: 150, unique: 120),
//                            campaign: .init(total: 2),
//                            clicked: .init(total: 80, unique: 65),
//                            complained: .init(total: 1),
//                            seedTest: .init(total: 10),
//                            emailValidation: .init(
//                                total: 500,
//                                isPublic: 450,
//                                valid: 480,
//                                single: 400,
//                                bulk: 50,
//                                list: 50,
//                                mailgun: 300,
//                                mailjet: 200
//                            ),
//                            linkValidationFailed: .init(total: 2),
//                            linkValidation: .init(total: 98),
//                            emailPreview: .init(total: 45),
//                            emailPreviewFailed: .init(total: 5)
//                        )
//                    ]
//                )
//            },
//
//            filter: { _ in
//                .init(
//                    description: "Filtered Stats",
//                    start: "Tue, 14 Feb 2024 00:00:00 UTC",
//                    end: "Fri, 01 Mar 2024 00:00:00 UTC",
//                    resolution: "month",
//                    stats: [
//                        .init(
//                            time: "Fri, 01 Mar 2024 00:00:00 UTC",
//                            delivered: .init(smtp: 50, http: 25, optimized: 15, total: 90),
//                            accepted: .init(incoming: 100, outgoing: 90, total: 190),
//                            stored: .init(total: 8),
//                            failed: .init(
//                                temporary: .init(total: 3),
//                                permanent: .init(total: 1)
//                            ),
//                            unsubscribed: .init(total: 2),
//                            opened: .init(total: 75, unique: 60),
//                            campaign: .init(total: 1),
//                            clicked: .init(total: 40, unique: 32),
//                            complained: .init(total: 1),
//                            seedTest: .init(total: 5),
//                            emailValidation: .init(
//                                total: 250,
//                                isPublic: 225,
//                                valid: 240,
//                                single: 200,
//                                bulk: 25,
//                                list: 25,
//                                mailgun: 150,
//                                mailjet: 100
//                            ),
//                            linkValidationFailed: .init(total: 1),
//                            linkValidation: .init(total: 49),
//                            emailPreview: .init(total: 22),
//                            emailPreviewFailed: .init(total: 3)
//                        )
//                    ]
//                )
//            },
//
//            aggregateProviders: {
//                .init(providers: [
//                    "gmail.com": .init(
//                        opened: 75,
//                        uniqueClicked: 45,
//                        unsubscribed: 1,
//                        accepted: 100,
//                        clicked: 50
//                    ),
//                    "yahoo.com": .init(
//                        opened: 50,
//                        uniqueClicked: 30,
//                        unsubscribed: 1,
//                        accepted: 80,
//                        clicked: 35
//                    )
//                ])
//            },
//
//            aggregateDevices: {
//                .init(devices: [
//                    "desktop": .init(
//                        unsubscribed: 1,
//                        accepted: 100,
//                        clicked: 45,
//                        opened: 75,
//                        uniqueClicked: 40
//                    ),
//                    "mobile": .init(
//                        unsubscribed: 1,
//                        accepted: 80,
//                        clicked: 35,
//                        opened: 50,
//                        uniqueClicked: 30
//                    ),
//                    "tablet": .init(
//                        unsubscribed: 0,
//                        accepted: 20,
//                        clicked: 10,
//                        opened: 15,
//                        uniqueClicked: 8
//                    )
//                ])
//            },
//
//            aggregateCountries: {
//                .init(countries: [
//                    "US": 150,
//                    "GB": 75,
//                    "CA": 50,
//                    "AU": 25
//                ])
//            }
//        )
//    }
//}
