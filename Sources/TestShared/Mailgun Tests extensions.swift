//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Foundation
import CoenttbWeb
import Shared
import DependenciesTestSupport
import Testing
import Authenticated

extension URL {
    package static var projectRoot: URL {
        return .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}

extension EnvironmentVariables {
    // Mailgun
    package var mailgunBaseUrl: URL? {
        get { self["MAILGUN_BASE_URL"].flatMap(URL.init(string:)) }
    }
    
    package var mailgunPrivateApiKey: ApiKey? {
        get { self["MAILGUN_PRIVATE_API_KEY"].map(ApiKey.init(rawValue:)) }
    }
    
    package var mailgunDomain: Domain? {
        get { try? self["MAILGUN_DOMAIN"].map(Domain.init) }
    }
    
    package var mailgunTestMailingList: EmailAddress? {
        get { try? self["MAILGUN_TEST_MAILINGLIST"].map(EmailAddress.init) }
    }
    
    package var mailgunTestRecipient: EmailAddress? {
        get { try? self["MAILGUN_TEST_RECIPIENT"].map(EmailAddress.init) }
    }
    
    package var mailgunFrom: EmailAddress? {
        get { try? self["MAILGUN_FROM_EMAIL"].map(EmailAddress.init)  }
    }
    
    package var mailgunTo: EmailAddress? {
        get { try? self["MAILGUN_TO_EMAIL"].map(EmailAddress.init)  }
    }
}

extension EnvVars {
    package static let liveTest: Self = try! .live(localDevelopment: .projectRoot.appendingPathComponent(".env.development"))
}

extension Authenticated.Client {
    package static func test(
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { request in try await URLSession.shared.data(for: request) },
        router: APIRouter,
        buildClient: @escaping @Sendable (
            _ makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
        ) -> ClientOutput
    ) throws -> Self {
        try withDependencies {
            $0.envVars = .liveTest
        } operation: {
            @Dependency(\.envVars) var envVars
            
            let apiKey: ApiKey = try #require(envVars.mailgunPrivateApiKey)
            let baseUrl = try #require(envVars.mailgunBaseUrl)
            
            return Authenticated.Client(
                apiKey: apiKey,
                baseUrl: baseUrl,
                session: session,
                router: router,
                buildClient: buildClient
            )
        }
    }
}

extension Authenticated.Client {
    package static func test(
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { request in try await URLSession.shared.data(for: request) },
        router: APIRouter,
        buildClient: @escaping @Sendable (
            _ apiKey: ApiKey,
            _ baseUrl: URL,
            _ domain: Domain,
            _ makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
        ) -> ClientOutput
    ) throws -> Self {
        try withDependencies {
            $0.envVars = .liveTest
        } operation: {
            @Dependency(\.envVars) var envVars
            
            let apiKey: ApiKey = try #require(envVars.mailgunPrivateApiKey)
            let baseUrl = try #require(envVars.mailgunBaseUrl)
            let domain = try #require(envVars.mailgunDomain)
            
            return Authenticated.Client(
                apiKey: apiKey,
                baseUrl: baseUrl,
                session: session,
                router: router,
                buildClient: {
                    buildClient(apiKey, baseUrl, domain, $0)
                }
            )
        }
    }
}

