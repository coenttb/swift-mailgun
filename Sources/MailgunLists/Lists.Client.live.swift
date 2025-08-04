//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Coenttb_Web
import IssueReporting
import ListsTypes
import MailgunShared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Lists.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Lists.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Lists.List.Create.Response.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Lists.List.Response.self
                )
            },

            members: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.members(listAddress: listAddress, request: request)),
                    decodingTo: Lists.List.Members.Response.self
                )
            },

            addMember: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.addMember(listAddress: listAddress, request: request)),
                    decodingTo: Lists.Member.Add.Response.self
                )
            },

            bulkAdd: { listAddress, members, upsert in
                try await handleRequest(
                    for: makeRequest(.bulkAdd(listAddress: listAddress, members: members, upsert: upsert)),
                    decodingTo: Lists.Member.Bulk.Response.self
                )
            },

            bulkAddCSV: { listAddress, csvData, subscribed, upsert in
                try await handleRequest(
                    for: makeRequest(.bulkAddCSV(listAddress: listAddress, request: csvData, subscribed: subscribed, upsert: upsert)),
                    decodingTo: Lists.Member.Bulk.Response.self
                )
            },

            getMember: { listAddress, memberAddress in
                try await handleRequest(
                    for: makeRequest(.getMember(listAddress: listAddress, memberAddress: memberAddress)),
                    decodingTo: Lists.Member.Get.Response.self
                )
                .member
            },

            updateMember: { listAddress, memberAddress, request in
                try await handleRequest(
                    for: makeRequest(.updateMember(listAddress: listAddress, memberAddress: memberAddress, request: request)),
                    decodingTo: Lists.Member.Update.Response.self
                )
            },

            deleteMember: { listAddress, memberAddress in
                try await handleRequest(
                    for: makeRequest(.deleteMember(listAddress: listAddress, memberAddress: memberAddress)),
                    decodingTo: Lists.Member.Delete.Response.self
                )
            },

            update: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.update(listAddress: listAddress, request: request)),
                    decodingTo: Lists.List.Update.Response.self
                )
            },

            delete: { listAddress in
                try await handleRequest(
                    for: makeRequest(.delete(listAddress: listAddress)),
                    decodingTo: Lists.List.Delete.Response.self
                )
            },

            get: { listAddress in
                try await handleRequest(
                    for: makeRequest(.get(listAddress: listAddress)),
                    decodingTo: Lists.List.Get.Response.self
                )
            },

            pages: { limit in
                try await handleRequest(
                    for: makeRequest(.pages(limit: limit)),
                    decodingTo: Lists.List.Pages.Response.self
                )
            },

            memberPages: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.memberPages(listAddress: listAddress, request: request)),
                    decodingTo: Lists.List.Members.Pages.Response.self
                )
            }
        )
    }
}

extension Lists.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Lists.API,
        Lists.API.Router,
        Lists.Client
    >
}

extension Lists.Client.Authenticated: @retroactive DependencyKey {
    public static var liveValue: Self {
        try! Lists.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Lists.Client.Authenticated: @retroactive TestDependencyKey {
    public static var testValue: Self {
        return try! Lists.Client.Authenticated { .testValue }
    }
}

extension Lists.API.Router: @retroactive DependencyKey {
    public static let liveValue: Lists.API.Router = .init()
}
