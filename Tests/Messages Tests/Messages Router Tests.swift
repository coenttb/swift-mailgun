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
import Messages

@Suite("Messages Router Tests")
struct MessagesRouterTests {
    
    @Test("Creates correct URL for sending message")
    func testSendMessageURL() throws {
        @Dependency(Messages.API.Router.self) var router
        
        let sendRequest = Messages.Send.Request(
            from: try .init("sender@test.com"),
            to: [try .init("recipient@test.com")],
            subject: "Test Subject",
            html: "<p>Test content</p>",
            text: "Test content",
            cc: ["cc@test.com"],
            bcc: ["bcc@test.com"],
            tags: ["test-tag"],
            testMode: true
        )
        
        let url = router.url(for: .send(domain: try .init("test.domain.com"), request: sendRequest))
        #expect(url.path == "/v3/test.domain.com/messages")
    }
    
    @Test("Creates correct URL for sending MIME message")
    func testSendMimeMessageURL() throws {
        @Dependency(Messages.API.Router.self) var router
        
        let mimeRequest = Messages.Send.Mime.Request(
            to: [try .init("recipient@test.com")],
            message: Data("MIME content".utf8),
            tags: ["test-tag"],
            testMode: true
        )
        
        let url = router.url(for: .sendMime(domain: try .init("test.domain.com"), request: mimeRequest))
        #expect(url.path == "/v3/test.domain.com/messages.mime")
    }
    
    @Test("Creates correct URL for retrieving stored message")
    func testRetrieveMessageURL() throws {
        @Dependency(Messages.API.Router.self) var router
        
        let url = router.url(for: .retrieve(
            domain: try .init("test.domain.com"),
            storageKey: "message123"
        ))
        
        #expect(url.path == "/v3/domains/test.domain.com/messages/message123")
    }
    
    @Test("Creates correct URL for queue status")
    func testQueueStatusURL() throws {
        @Dependency(Messages.API.Router.self) var router
        
        let url = router.url(for: .queueStatus(domain: try .init("test.domain.com")))
        #expect(url.path == "/v3/domains/test.domain.com/sending_queues")
    }
    
    @Test("Creates correct URL for deleting scheduled messages")
    func testDeleteScheduledURL() throws {
        @Dependency(Messages.API.Router.self) var router
        
        let url = router.url(for: .deleteScheduled(domain: try .init("test.domain.com")))
        #expect(url.path == "/v3/test.domain.com/envelopes")
    }
}
