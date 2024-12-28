//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Foundation
import URLRouting
@testable import Mailgun

@Suite(
    "Mailgun Authenticated Router Tests",
    .dependency(\.envVars, .local)
)
struct MailgunAuthenticatedRouterTests {
    
    @Dependency(\.envVars.mailgunBaseUrl!) var baseURL
    @Dependency(\.envVars.mailgunPrivateApiKey!) var apiKey
    
    @Test("Creates URL with correct base URL for messages")
    func testBaseURLForMessages() throws {
        let router = Mailgun.API.Authenticated.Router(
            baseURL: baseURL,
            router: .init()
        )
        
        let url = router.url(for: .init(
            apiKey: apiKey,
            route: .messages(.send(
                domain: try .init("test.domain.com"),
                request: .init(
                    from: try .init("test@example.com"),
                    to: [try .init("recipient@example.com")],
                    subject: "Test"
                )
            ))
        ))
        
        #expect(url.absoluteString.hasPrefix(baseURL.absoluteString))
        #expect(url.path.hasSuffix("/v3/test.domain.com/messages"))
    }
    
    @Test("Creates URL with correct base URL for lists")
    func testBaseURLForLists() throws {
        let router = Mailgun.API.Authenticated.Router(
            baseURL: baseURL,
            router: .init()
        )
        
        let url = router.url(
            for: .init(
                apiKey: apiKey,
                route: .lists(
                    .create(
                        request: .init(
                            address: "test@example.com",
                            accessLevel: .readonly
                        )
                    )
                )
            )
        )
        
        #expect(url.absoluteString.hasPrefix(baseURL.absoluteString))
        #expect(url.path.hasSuffix("/v3/lists"))
    }
    
    @Test("Sets correct authentication headers")
    func testAuthenticationHeaders() throws {
        let router = Mailgun.API.Authenticated.Router(
            baseURL: baseURL,
            router: .init()
        )

        let authenticated = Mailgun.API.Authenticated(
            apiKey: apiKey,
            route: .lists(.pages(limit: 10))
        )
        
        let components = try router.print(authenticated)
        
        let expectedAuthHeader = "Basic " + Data("api:\(apiKey)".utf8).base64EncodedString()
        
        let headers = try #require(components.headers["Authorization"])
        
        let optionalHeader = try #require(headers.first)
        
        let header = try #require(optionalHeader)
        
        #expect(header == expectedAuthHeader)
    }

    @Test("Maintains auth headers with custom base URL")
    func testAuthWithCustomBaseURL() throws {
        let customBaseURL = URL(string: "https://api.eu.mailgun.net")!
        let router = Mailgun.API.Authenticated.Router(
            baseURL: customBaseURL,
            router: .init()
        )

        let authenticated = Mailgun.API.Authenticated(
            apiKey: apiKey,
            route: .messages(.queueStatus(domain: try .init("test.domain.com")))
        )
        
        let components = try router.print(authenticated)
        
        let expectedAuthHeader = "Basic " + Data("api:\(apiKey)".utf8).base64EncodedString()
        
        let headers = try #require(components.headers["Authorization"])
        
        let optionalHeader = try #require(headers.first)
        
        let header = try #require(optionalHeader)
        
        #expect(header == expectedAuthHeader)
    }
}
