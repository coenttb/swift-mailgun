import Coenttb_Web
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Bounces.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Bounces.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        return Self(
            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Bounces.Import.Response.self,
                    session: session
                )
            },
            
            get: { address in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, address: address)),
                    decodingTo: Bounces.Record.self,
                    session: session
                )
            },
            
            delete: { address in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, address: address)),
                    decodingTo: Bounces.Delete.Response.self,
                    session: session
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Bounces.List.Response.self,
                    session: session
                )
            },
            
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Bounces.Create.Response.self,
                    session: session
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Bounces.Delete.All.Response.self,
                    session: session
                )
            }
        )
    }
}
