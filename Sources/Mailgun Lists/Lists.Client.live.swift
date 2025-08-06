//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import Mailgun_Types_Shared
import Mailgun_Lists_Types
import Mailgun_Shared
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Lists.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Lists.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Lists.List.Create.Response.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Mailgun.Lists.List.Response.self
                )
            },

            members: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.members(listAddress: listAddress, request: request)),
                    decodingTo: Mailgun.Lists.List.Members.Response.self
                )
            },

            addMember: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.addMember(listAddress: listAddress, request: request)),
                    decodingTo: Mailgun.Lists.Member.Add.Response.self
                )
            },

            bulkAdd: { listAddress, members, upsert in
                try await handleRequest(
                    for: makeRequest(.bulkAdd(listAddress: listAddress, members: members, upsert: upsert)),
                    decodingTo: Mailgun.Lists.Member.Bulk.Response.self
                )
            },

            bulkAddCSV: { listAddress, csvData, subscribed, upsert in
                try await handleRequest(
                    for: makeRequest(.bulkAddCSV(listAddress: listAddress, request: csvData, subscribed: subscribed, upsert: upsert)),
                    decodingTo: Mailgun.Lists.Member.Bulk.Response.self
                )
            },

            getMember: { listAddress, memberAddress in
                try await handleRequest(
                    for: makeRequest(.getMember(listAddress: listAddress, memberAddress: memberAddress)),
                    decodingTo: Mailgun.Lists.Member.Get.Response.self
                )
                .member
            },

            updateMember: { listAddress, memberAddress, request in
                try await handleRequest(
                    for: makeRequest(.updateMember(listAddress: listAddress, memberAddress: memberAddress, request: request)),
                    decodingTo: Mailgun.Lists.Member.Update.Response.self
                )
            },

            deleteMember: { listAddress, memberAddress in
                try await handleRequest(
                    for: makeRequest(.deleteMember(listAddress: listAddress, memberAddress: memberAddress)),
                    decodingTo: Mailgun.Lists.Member.Delete.Response.self
                )
            },

            update: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.update(listAddress: listAddress, request: request)),
                    decodingTo: Mailgun.Lists.List.Update.Response.self
                )
            },

            delete: { listAddress in
                try await handleRequest(
                    for: makeRequest(.delete(listAddress: listAddress)),
                    decodingTo: Mailgun.Lists.List.Delete.Response.self
                )
            },

            get: { listAddress in
                try await handleRequest(
                    for: makeRequest(.get(listAddress: listAddress)),
                    decodingTo: Mailgun.Lists.List.Get.Response.self
                )
            },

            pages: { limit in
                try await handleRequest(
                    for: makeRequest(.pages(limit: limit)),
                    decodingTo: Mailgun.Lists.List.Pages.Response.self
                )
            },

            memberPages: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.memberPages(listAddress: listAddress, request: request)),
                    decodingTo: Mailgun.Lists.List.Members.Pages.Response.self
                )
            }
        )
    }
}

extension Mailgun.Lists.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Lists.API,
        Mailgun.Lists.API.Router,
        Mailgun.Lists.Client
    >
}

extension Mailgun.Lists.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Lists.Client.Authenticated {
        try! Mailgun.Lists.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Lists.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Lists.API.Router = .init()
}
