//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import IssueReporting
import MailgunShared
import TemplatesTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Templates.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Templates.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domainId: domain, request: request)),
                    decodingTo: Templates.Template.Create.Response.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domainId: domain, page: request.page, limit: request.limit, p: request.p)),
                    decodingTo: Templates.Template.List.Response.self
                )
            },

            get: { templateId, active in
                try await handleRequest(
                    for: makeRequest(.get(domainId: domain, templateId: templateId, active: active)),
                    decodingTo: Templates.Template.Get.Response.self
                )
            },

            update: { templateId, request in
                try await handleRequest(
                    for: makeRequest(.update(domainId: domain, templateId: templateId, request: request)),
                    decodingTo: Templates.Template.Update.Response.self
                )
            },

            delete: { templateId in
                try await handleRequest(
                    for: makeRequest(.delete(domainId: domain, templateId: templateId)),
                    decodingTo: Templates.Template.Delete.Response.self
                )
            },
            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domainId: domain)),
                    decodingTo: Templates.Template.Delete.All.Response.self
                )
            },
            versions: { templateName, page, limit, p in
                try await handleRequest(
                    for: makeRequest(.versions(domainId: domain, templateName: templateName, page: page, limit: limit, p: p)),
                    decodingTo: Templates.Template.Versions.Response.self
                )
            },

            createVersion: { templateId, request in
                try await handleRequest(
                    for: makeRequest(.createVersion(domainId: domain, templateId: templateId, request: request)),
                    decodingTo: Templates.Version.Create.Response.self
                )
            },

            getVersion: { templateId, versionId in
                try await handleRequest(
                    for: makeRequest(.getVersion(domainId: domain, templateId: templateId, versionId: versionId)),
                    decodingTo: Templates.Version.Get.Response.self
                )
            },

            updateVersion: { templateId, versionId, request in
                try await handleRequest(
                    for: makeRequest(.updateVersion(domainId: domain, templateId: templateId, versionId: versionId, request: request)),
                    decodingTo: Templates.Version.Update.Response.self
                )
            },

            deleteVersion: { templateId, versionId in
                try await handleRequest(
                    for: makeRequest(.deleteVersion(domainId: domain, templateId: templateId, versionId: versionId)),
                    decodingTo: Templates.Version.Delete.Response.self
                )
            },

            copyVersion: { templateName, versionName, newVersionName, comment in
                try await handleRequest(
                    for: makeRequest(.copyVersion(domainId: domain, templateName: templateName, versionName: versionName, newVersionName: newVersionName, comment: comment)),
                    decodingTo: Templates.Version.Copy.Response.self
                )
            }
        )
    }
}

extension Templates.Client {
    public typealias Authenticated = MailgunShared.AuthenticatedClient<
        Templates.API,
        Templates.API.Router,
        Templates.Client
    >
}

extension Templates.Client: @retroactive DependencyKey {
    public static var liveValue: Templates.Client.Authenticated {
        try! Templates.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Templates.API.Router: @retroactive DependencyKey {
    public static let liveValue: Templates.API.Router = .init()
}
