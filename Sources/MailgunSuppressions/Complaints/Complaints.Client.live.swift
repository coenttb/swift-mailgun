// Suppressions.Complaints.Client.live.swift

import Coenttb_Web
import IssueReporting
import MailgunShared
import SuppressionsTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Suppressions.Complaints.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Suppressions.Complaints.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain
        
        return Self(
            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Suppressions.Complaints.Import.Response.self
                )
            },
            
            get: { address in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, address: address)),
                    decodingTo: Suppressions.Complaints.Record.self
                )
            },
            
            delete: { address in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, address: address)),
                    decodingTo: Suppressions.Complaints.Delete.Response.self
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Suppressions.Complaints.List.Response.self
                )
            },
            
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Suppressions.Complaints.Create.Response.self
                )
            },
            
            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Suppressions.Complaints.Delete.All.Response.self
                )
            }
        )
    }
}
