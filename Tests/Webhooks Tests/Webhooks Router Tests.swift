//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Foundation
import URLRouting
import TestShared
import Webhooks

@Suite("Mailgun Router Webhooks URL Tests")
struct MailgunWebhooksRouterTests {
    
    @Test("Creates correct URL for listing webhooks")
    func testListWebhooksURL() throws {
        @Dependency(API.Router.self) var router
        
        let url = router.url(for: .list(domain: try .init("test.domain.com")))
        #expect(url.path == "/v3/domains/test.domain.com/webhooks")
    }
    
    @Test("Creates correct URL for getting specific webhook")
    func testGetWebhookURL() throws {
        @Dependency(API.Router.self) var router
        
        let url = router.url(for: .get(
            domain: try .init("test.domain.com"),
            type: .delivered
        ))
        
        #expect(url.path == "/v3/domains/test.domain.com/webhooks/delivered")
    }
    
    @Test("Creates correct URL for creating webhook")
    func testCreateWebhookURL() throws {
        @Dependency(API.Router.self) var router
        
        let url = router.url(for: .create(
            domain: try .init("test.domain.com"),
            type: .opened,
            url: "https://webhook.site/123"
        ))
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(url.path == "/v3/domains/test.domain.com/webhooks")
        #expect(queryDict["id"] == "opened")
        #expect(queryDict["url"] == "https://webhook.site/123")
    }
    
    @Test("Creates correct URL for updating webhook")
    func testUpdateWebhookURL() throws {
        @Dependency(API.Router.self) var router
        
        let url = router.url(for: .update(
            domain: try .init("test.domain.com"),
            type: .clicked,
            url: "https://webhook.site/456"
        ))
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(url.path == "/v3/domains/test.domain.com/webhooks/clicked")
        #expect(queryDict["url"] == "https://webhook.site/456")
    }
    
    @Test("Creates correct URL for deleting webhook")
    func testDeleteWebhookURL() throws {
        @Dependency(API.Router.self) var router
        
        let url = router.url(for: .delete(
            domain: try .init("test.domain.com"),
            type: .complained
        ))
        
        #expect(url.path == "/v3/domains/test.domain.com/webhooks/complained")
    }
    
    @Test("Creates correct URL with permanent_fail webhook type")
    func testPermanentFailWebhookURL() throws {
        @Dependency(API.Router.self) var router
        
        let url = router.url(for: .get(
            domain: try .init("test.domain.com"),
            type: .permanentFail
        ))
        
        #expect(url.path == "/v3/domains/test.domain.com/webhooks/permanent_fail")
    }
    
    @Test("Creates correct URL with temporary_fail webhook type")
    func testTemporaryFailWebhookURL() throws {
        @Dependency(API.Router.self) var router
        
        let url = router.url(for: .get(
            domain: try .init("test.domain.com"),
            type: .temporaryFail
        ))
        
        #expect(url.path == "/v3/domains/test.domain.com/webhooks/temporary_fail")
    }
}
