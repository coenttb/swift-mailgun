import Dependencies
import Foundation
import IssueReporting
import MailgunShared
import SuppressionsTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

//extension Suppressions.Bounces.Client: TestDependencyKey {
//    public static var testValue: Self {
//        return Self(
//            importList: { _ in
//                .init(message: "file uploaded successfully")
//            },
//            get: { _ in
//                .init(
//                    address: try .init("test@example.com"),
//                    code: "550",
//                    error: "No such mailbox",
//                    createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
//                )
//            },
//            delete: { address in
//                .init(
//                    message: "Bounce has been removed",
//                    address: address
//                )
//            },
//            list: { _ in
//                .init(
//                    items: [
//                        .init(
//                            address: try .init("test@example.com"),
//                            code: "550",
//                            error: "No such mailbox",
//                            createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
//                        )
//                    ],
//                    paging: .init(
//                        previous: "<previous page url>",
//                        first: "<first page url>",
//                        next: "<next page url>",
//                        last: "<last page url>"
//                    )
//                )
//            },
//            create: { _ in
//                .init(message: "Bounce event has been created")
//            },
//            deleteAll: {
//                .init(message: "Bounced addresses for this domain have been removed")
//            }
//        )
//    }
//}
