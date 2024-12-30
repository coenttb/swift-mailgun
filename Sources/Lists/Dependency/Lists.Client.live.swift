//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Coenttb_Web
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Lists.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        makeRequest: @escaping @Sendable (_ route: Lists.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Lists.List.Create.Response.self,
                    session: session
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Lists.List.Response.self,
                    session: session
                )
            },
            
            members: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.members(listAddress: listAddress, request: request)),
                    decodingTo: Lists.List.Members.Response.self,
                    session: session
                )
            },
            
            addMember: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.addMember(listAddress: listAddress, request: request)),
                    decodingTo: Lists.Member.Add.Response.self,
                    session: session
                )
            },
            
            bulkAdd: { listAddress, members, upsert in
                try await handleRequest(
                    for: makeRequest(.bulkAdd(listAddress: listAddress, members: members, upsert: upsert)),
                    decodingTo: Lists.Member.Bulk.Response.self,
                    session: session
                )
            },
            
            bulkAddCSV: { listAddress, csvData, subscribed, upsert in
                try await handleRequest(
                    for: makeRequest(.bulkAddCSV(listAddress: listAddress, request: csvData, subscribed: subscribed, upsert: upsert)),
                    decodingTo: Lists.Member.Bulk.Response.self,
                    session: session
                )
            },
            
            getMember: { listAddress, memberAddress in
                try await handleRequest(
                    for: makeRequest(.getMember(listAddress: listAddress, memberAddress: memberAddress)),
                    decodingTo: Lists.Member.Get.Response.self,
                    session: session
                )
                .member
            },
            
            updateMember: { listAddress, memberAddress, request in
                try await handleRequest(
                    for: makeRequest(.updateMember(listAddress: listAddress, memberAddress: memberAddress, request: request)),
                    decodingTo: Lists.Member.Update.Response.self,
                    session: session
                )
            },
            
            deleteMember: { listAddress, memberAddress in
                try await handleRequest(
                    for: makeRequest(.deleteMember(listAddress: listAddress, memberAddress: memberAddress)),
                    decodingTo: Lists.Member.Delete.Response.self,
                    session: session
                )
            },
            
            update: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.update(listAddress: listAddress, request: request)),
                    decodingTo: Lists.List.Update.Response.self,
                    session: session
                )
            },
            
            delete: { listAddress in
                try await handleRequest(
                    for: makeRequest(.delete(listAddress: listAddress)),
                    decodingTo: Lists.List.Delete.Response.self,
                    session: session
                )
            },
            
            get: { listAddress in
                try await handleRequest(
                    for: makeRequest(.get(listAddress: listAddress)),
                    decodingTo: Lists.List.Get.Response.self,
                    session: session
                )
            },
            
            pages: { limit in
                try await handleRequest(
                    for: makeRequest(.pages(limit: limit)),
                    decodingTo: Lists.List.Pages.Response.self,
                    session: session
                )
            },
            
            memberPages: { listAddress, request in
                try await handleRequest(
                    for: makeRequest(.memberPages(listAddress: listAddress, request: request)),
                    decodingTo: Lists.List.Members.Pages.Response.self,
                    session: session
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

