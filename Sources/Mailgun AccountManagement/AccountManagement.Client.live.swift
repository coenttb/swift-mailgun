//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import Mailgun_Shared
import Mailgun_Types_Shared
import Mailgun_AccountManagement_Types
@_exported import enum Mailgun_Types.Mailgun
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.AccountManagement.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.AccountManagement.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            updateAccount: { request in
                try await handleRequest(
                    for: makeRequest(.updateAccount(request: request)),
                    decodingTo: Mailgun.AccountManagement.Update.Response.self
                )
            },
            
            getHttpSigningKey: {
                try await handleRequest(
                    for: makeRequest(.getHttpSigningKey),
                    decodingTo: Mailgun.AccountManagement.HttpSigningKey.self
                )
            },
            
            regenerateHttpSigningKey: {
                try await handleRequest(
                    for: makeRequest(.regenerateHttpSigningKey),
                    decodingTo: Mailgun.AccountManagement.RegenerateHttpSigningKey.Response.self
                )
            },
            
            getSandboxAuthRecipients: {
                try await handleRequest(
                    for: makeRequest(.getSandboxAuthRecipients),
                    decodingTo: Mailgun.AccountManagement.Sandbox.AuthRecipientsList.self
                )
            },
            
            addSandboxAuthRecipient: { email in
                try await handleRequest(
                    for: makeRequest(.addSandboxAuthRecipient(email: email)),
                    decodingTo: Mailgun.AccountManagement.Sandbox.AddAuthRecipientResponse.self
                )
            },
            
            deleteSandboxAuthRecipient: { email in
                try await handleRequest(
                    for: makeRequest(.deleteSandboxAuthRecipient(email: email)),
                    decodingTo: Mailgun.AccountManagement.Sandbox.DeleteAuthRecipientResponse.self
                )
            },
            
            resendActivationEmail: {
                try await handleRequest(
                    for: makeRequest(.resendActivationEmail),
                    decodingTo: Mailgun.AccountManagement.ResendActivationEmail.Response.self
                )
            },
            
            getSAMLOrganization: {
                try await handleRequest(
                    for: makeRequest(.getSAMLOrganization),
                    decodingTo: Mailgun.AccountManagement.SAML.Organization.self
                )
            },
            
            createSAMLOrganization: { request in
                try await handleRequest(
                    for: makeRequest(.createSAMLOrganization(request: request)),
                    decodingTo: Mailgun.AccountManagement.SAML.Organization.self
                )
            }
        )
    }
}

extension Mailgun.AccountManagement.Client {
    public typealias Authenticated = Mailgun_Shared.AuthenticatedClient<
        Mailgun.AccountManagement.API,
        Mailgun.AccountManagement.API.Router,
        Mailgun.AccountManagement.Client
    >
}

extension Mailgun.AccountManagement.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.AccountManagement.Client.Authenticated {
        try! Mailgun.AccountManagement.Client.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.AccountManagement.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.AccountManagement.API.Router = .init()
}
