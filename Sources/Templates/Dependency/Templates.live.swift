//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Templates.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Templates.API) throws -> URLRequest,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { try await URLSession.shared.data(for: $0) }
    ) -> Self {
        
        
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Templates.Template.Create.Response.self,
                    session: session
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domainId: domain, page: request.page, limit: request.limit, p: request.p)),
                    decodingTo: Templates.Template.List.Response.self,
                    session: session
                )
            },
            
            get: { templateId, active in
                try await handleRequest(
                    for: makeRequest(.get(domainId: domain,  templateId: templateId, active: active)),
                    decodingTo: Templates.Template.Get.Response.self,
                    session: session
                )
            },
            
            update: { templateId, request in
                try await handleRequest(
                    for: makeRequest(.update(domainId: domain, templateId: templateId, request: request)),
                    decodingTo: Templates.Template.Update.Response.self,
                    session: session
                )
            },
            
            delete: { templateId in
                try await handleRequest(
                    for: makeRequest(.delete(domainId: domain, templateId: templateId)),
                    decodingTo: Templates.Template.Delete.Response.self,
                    session: session
                )
            },
            
            versions: { templateId, request in
                try await handleRequest(
                    for: makeRequest(.versions(domainId: domain, templateId: templateId, page: request.page, limit: request.limit)),
                    decodingTo: Templates.Template.Versions.Response.self,
                    session: session
                )
            },
            
            createVersion: { templateId, request in
                try await handleRequest(
                    for: makeRequest(.createVersion(domainId: domain, templateId: templateId, request: request)),
                    decodingTo: Templates.Version.Create.Response.self,
                    session: session
                )
            },
            
            getVersion: { templateId, versionId in
                try await handleRequest(
                    for: makeRequest(.getVersion(domainId: domain, templateId: templateId, versionId: versionId)),
                    decodingTo: Templates.Version.Get.Response.self,
                    session: session
                )
            },
            
            updateVersion: { templateId, versionId, request in
                try await handleRequest(
                    for: makeRequest(.updateVersion(domainId: domain, templateId: templateId, versionId: versionId, request: request)),
                    decodingTo: Templates.Version.Update.Response.self,
                    session: session
                )
            },
            
            deleteVersion: { templateId, versionId in
                try await handleRequest(
                    for: makeRequest(.deleteVersion(domainId: domain, templateId: templateId, versionId: versionId)),
                    decodingTo: Templates.Version.Delete.Response.self,
                    session: session
                )
            },
            
            copyVersion: { templateId, versionId, tag, comment in
                try await handleRequest(
                    for: makeRequest(.copyVersion(domainId: domain, templateId: templateId, versionId: versionId, tag: tag, comment: comment)),
                    decodingTo: Templates.Version.Copy.Response.self,
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
