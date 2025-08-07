//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared
@_exported import Mailgun_Templates_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Templates.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Templates.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgunDomain) var domain

        return Self(
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domainId: domain, request: request)),
                    decodingTo: Mailgun.Templates.List.Response.self
                )
            },
            
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domainId: domain, request: request)),
                    decodingTo: Mailgun.Templates.Create.Response.self
                )
            },
            
            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domainId: domain)),
                    decodingTo: Mailgun.Templates.DeleteAll.Response.self
                )
            },
            
            versions: { templateName, request in
                try await handleRequest(
                    for: makeRequest(.versions(domainId: domain, templateName: templateName, request: request)),
                    decodingTo: Mailgun.Templates.Versions.Response.self
                )
            },
            
            createVersion: { templateName, request in
                try await handleRequest(
                    for: makeRequest(.createVersion(domainId: domain, templateName: templateName, request: request)),
                    decodingTo: Mailgun.Templates.Version.Create.Response.self
                )
            },
            
            get: { templateName, request in
                try await handleRequest(
                    for: makeRequest(.get(domainId: domain, templateName: templateName, request: request)),
                    decodingTo: Mailgun.Templates.Get.Response.self
                )
            },
            
            update: { templateName, request in
                try await handleRequest(
                    for: makeRequest(.update(domainId: domain, templateName: templateName, request: request)),
                    decodingTo: Mailgun.Templates.Update.Response.self
                )
            },
            
            delete: { templateName in
                try await handleRequest(
                    for: makeRequest(.delete(domainId: domain, templateName: templateName)),
                    decodingTo: Mailgun.Templates.Delete.Response.self
                )
            },
            
            getVersion: { templateName, versionName in
                try await handleRequest(
                    for: makeRequest(.getVersion(domainId: domain, templateName: templateName, versionName: versionName)),
                    decodingTo: Mailgun.Templates.Version.Get.Response.self
                )
            },
            
            updateVersion: { templateName, versionName, request in
                try await handleRequest(
                    for: makeRequest(.updateVersion(domainId: domain, templateName: templateName, versionName: versionName, request: request)),
                    decodingTo: Mailgun.Templates.Version.Update.Response.self
                )
            },
            
            deleteVersion: { templateName, versionName in
                try await handleRequest(
                    for: makeRequest(.deleteVersion(domainId: domain, templateName: templateName, versionName: versionName)),
                    decodingTo: Mailgun.Templates.Version.Delete.Response.self
                )
            },
            
            copyVersion: { templateName, versionName, newVersionName, request in
                try await handleRequest(
                    for: makeRequest(.copyVersion(domainId: domain, templateName: templateName, versionName: versionName, newVersionName: newVersionName, request: request)),
                    decodingTo: Mailgun.Templates.Version.Copy.Response.self
                )
            }
        )
    }
}

extension Mailgun.Templates.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.Templates.API,
        Mailgun.Templates.API.Router,
        Mailgun.Templates.Client
    >
}

extension Mailgun.Templates.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Templates.Client.Authenticated {
        try! Mailgun.Templates.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Templates.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Templates.API.Router = .init()
}