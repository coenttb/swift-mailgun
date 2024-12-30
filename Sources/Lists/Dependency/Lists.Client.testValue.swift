//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Coenttb_Web

extension Client: TestDependencyKey {
    public static var testValue: Self {
        Self(
            create: { request in
                .init(
                    list: .init(
                        address: request.address,
                        name: request.name ?? "Test List",
                        description: request.description ?? "Test Description",
                        accessLevel: request.accessLevel ?? .readonly,
                        replyPreference: request.replyPreference ?? .list,
                        createdAt: "Tue, 09 Aug 2011 20:50:27 -0000",
                        membersCount: 0
                    ),
                    message: "Mailing list has been created"
                )
            },
            list: { request in
                .init(
                    totalCount: 1,
                    items: [
                        .init(
                            address: try! .init("developers@test.com"),
                            name: "Developers",
                            description: "Test mailing list",
                            accessLevel: .readonly,
                            replyPreference: .list,
                            createdAt: "Tue, 09 Aug 2011 20:50:27 -0000",
                            membersCount: 0
                        )
                    ]
                )
            },
            members: { listAddress, request in
                .init(
                    totalCount: 1,
                    items: [
                        .init(
                            address: try! .init("test@example.com"),
                            name: "Test Member",
                            vars: [:],
                            subscribed: true
                        )
                    ]
                )
            },
            addMember: { listAddress, request in
                .init(
                    member: .init(
                        address: request.address,
                        name: request.name,
                        vars: request.vars ?? [:],
                        subscribed: request.subscribed ?? true
                    ),
                    message: "Member has been added"
                )
            },
            bulkAdd: { listAddress, members, upsert in
                .init(
                    list: .init(
                        address: listAddress,
                        name: "Test List",
                        description: "Test Description",
                        accessLevel: .readonly,
                        replyPreference: .list,
                        createdAt: "Tue, 09 Aug 2011 20:50:27 -0000",
                        membersCount: members.count
                    ),
                    taskId: "test-task-id",
                    message: "Bulk import started"
                )
            },
            bulkAddCSV: { listAddress, csvData, subscribed, upsert in
                .init(
                    list: .init(
                        address: listAddress,
                        name: "Test List",
                        description: "Test Description",
                        accessLevel: .readonly,
                        replyPreference: .list,
                        createdAt: "Tue, 09 Aug 2011 20:50:27 -0000",
                        membersCount: 0
                    ),
                    taskId: "test-task-id",
                    message: "CSV import started"
                )
            },
            getMember: { listAddress, memberAddress in
                .init(
                    address: memberAddress,
                    name: "Test Member",
                    vars: [:],
                    subscribed: true
                )
            },
            updateMember: { listAddress, memberAddress, request in
                .init(
                    member: .init(
                        address: request.address ?? memberAddress,
                        name: request.name ?? "Test Member",
                        vars: request.vars ?? [:],
                        subscribed: request.subscribed ?? true
                    ),
                    message: "Mailing list member has been updated"
                )
            },
            deleteMember: { listAddress, memberAddress in
                .init(
                    member: .init(address: memberAddress),
                    message: "Member has been deleted"
                )
            },
            update: { listAddress, request in
                .init(
                    message: "Mailing list has been updated",
                    list: .init(
                        address: request.address ?? listAddress,
                        name: request.name ?? "Test List",
                        description: request.description ?? "Test Description",
                        accessLevel: request.accessLevel ?? .readonly,
                        replyPreference: request.replyPreference,
                        createdAt: "Tue, 09 Aug 2011 20:50:27 -0000",
                        membersCount: 0
                    )
                )
            },
            delete: { listAddress in
                .init(
                    address: listAddress,
                    message: "Mailing list has been removed"
                )
            },
            get: { listAddress in
                .init(
                    list: .init(
                        address: listAddress,
                        name: "Test List",
                        description: "Test Description",
                        accessLevel: .readonly,
                        replyPreference: .list,
                        createdAt: "Tue, 09 Aug 2011 20:50:27 -0000",
                        membersCount: 0
                    )
                )
            },
            pages: { limit in
                .init(
                    paging: .init(
                        first: URL(string: "https://api.mailgun.net/v3/lists/pages?page=first")!,
                        last: URL(string: "https://api.mailgun.net/v3/lists/pages?page=last")!,
                        next: URL(string: "https://api.mailgun.net/v3/lists/pages?page=next")!,
                        previous: nil
                    ),
                    items: [
                        .init(
                            address: try! .init("test@example.com"),
                            name: "Test List",
                            description: "Test Description",
                            accessLevel: .readonly,
                            replyPreference: .list,
                            createdAt: "Tue, 09 Aug 2011 20:50:27 -0000",
                            membersCount: 0
                        )
                    ]
                )
            },
            memberPages: { listAddress, request in
                .init(
                    paging: .init(
                        first: URL(string: "https://api.mailgun.net/v3/lists/\(listAddress)/members/pages?page=first")!,
                        last: URL(string: "https://api.mailgun.net/v3/lists/\(listAddress)/members/pages?page=last")!,
                        next: URL(string: "https://api.mailgun.net/v3/lists/\(listAddress)/members/pages?page=next")!,
                        previous: nil
                    ),
                    items: [
                        .init(
                            address: try! .init("test@example.com"),
                            name: "Test Member",
                            vars: [:],
                            subscribed: true
                        )
                    ]
                )
            }
        )
    }
}
