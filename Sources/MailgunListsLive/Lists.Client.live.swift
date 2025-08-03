//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunSharedLive
import Lists

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Lists.Client {
    public static func live(
        apiKey: ApiKey,
        makeRequest: @escaping @Sendable (_ route: Lists.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
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

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}()


private let jsonEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    return encoder
}()

