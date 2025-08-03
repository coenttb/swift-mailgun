//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Foundation
import URLRouting
import Events
import EmailAddress

@Suite(
    "Events Router Tests"
)
struct EventsRouterTests {
    
    @Test("Creates correct URL for listing events with minimal parameters")
    func testListEventsMinimalURL() throws {
        @Dependency(Events.API.Router.self) var router
        
        let url = router.url(for: .list(
            domain: try .init("test.domain.com"),
            query: nil
        ))
        
        #expect(url.path == "/v3/test.domain.com/events")
    }
    
    @Test("Creates correct URL for listing events with all query parameters")
    func testListEventsFullURL() throws {
        @Dependency(Events.API.Router.self) var router
        
        let query = Events.List.Query(
            begin: Date(timeIntervalSince1970: .timeInterval1970to20220101),
            end: Date(timeIntervalSince1970: .timeInterval1970to20220102),
            ascending: true,
            limit: 300,
            event: .delivered,
            list: "developers@test.com",
            attachment: "document.pdf",
            from: try .init("sender@test.com"),
            messageId: "test123",
            subject: "Test Subject",
            to: try .init("recipient@test.com"),
            size: 1024,
            recipient: try .init("recipient@test.com"),
            recipients: [try .init("recipient1@test.com"), try .init("recipient2@test.com")],
            tags: ["tag1", "tag2"],
            severity: .temporary
        )
        
        let url = router.url(for: .list(
            domain: try .init("test.domain.com"),
            query: query
        ))
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        
        #expect(url.path == "/v3/test.domain.com/events")
        #expect(try #require(queryDict["begin"])?.contains("2022") == true)
        #expect(try #require(queryDict["end"])?.contains("2022") == true)
        #expect(queryDict["ascending"] == "yes")
        #expect(queryDict["limit"] == "300")
        #expect(queryDict["event"] == "delivered")
        #expect(queryDict["list"] == "developers@test.com")
        #expect(queryDict["attachment"] == "document.pdf")
        #expect(queryDict["from"] == "sender@test.com")
        #expect(queryDict["message-id"] == "test123")
        #expect(queryDict["subject"] == "Test Subject")
        #expect(queryDict["to"] == "recipient@test.com")
        #expect(queryDict["size"] == "1024")
        #expect(queryDict["recipient"] == "recipient@test.com")
        #expect(try #require(queryDict["recipients"])?.contains("recipient1@test.com") == true)
        #expect(try #require(queryDict["recipients"])?.contains("recipient2@test.com") == true)
        #expect(try #require(queryDict["tags"])?.contains("tag1") == true)
        #expect(try #require(queryDict["tags"])?.contains("tag2") == true)
        #expect(queryDict["severity"] == "temporary")
    }
    
    @Test("Creates correct URL for listing events with partial query parameters")
    func testListEventsPartialURL() throws {
        @Dependency(Events.API.Router.self) var router
        
        let query = Events.List.Query(
            limit: 100,
            event: .failed,
            from: try .init("sender@test.com"),
            to: try .init("recipient@test.com"),
            severity: .permanent
        )
        
        let url = router.url(for: .list(
            domain: try .init("test.domain.com"),
            query: query
        ))
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(url.path == "/v3/test.domain.com/events")
        #expect(queryDict["limit"] == "100")
        #expect(queryDict["event"] == "failed")
        #expect(queryDict["from"] == "sender@test.com")
        #expect(queryDict["to"] == "recipient@test.com")
        #expect(queryDict["severity"] == "permanent")
        
        #expect(queryDict["begin"] == nil)
        #expect(queryDict["end"] == nil)
        #expect(queryDict["ascending"] == nil)
        #expect(queryDict["list"] == nil)
        #expect(queryDict["attachment"] == nil)
        #expect(queryDict["message-id"] == nil)
        #expect(queryDict["subject"] == nil)
        #expect(queryDict["size"] == nil)
        #expect(queryDict["recipient"] == nil)
        #expect(queryDict["recipients"] == nil)
        #expect(queryDict["tags"] == nil)
    }
    
    @Test("Creates correct URL for listing events with time range parameters")
    func testListEventsTimeRangeURL() throws {
        @Dependency(Events.API.Router.self) var router
        
        let query = Events.List.Query(
            begin: Date(timeIntervalSince1970: .timeInterval1970to20220101),
            end: Date(timeIntervalSince1970: .timeInterval1970to20220102),
            ascending: true
        )
        
        let url = router.url(for: .list(
            domain: try .init("test.domain.com"),
            query: query
        ))
        
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(url.path == "/v3/test.domain.com/events")
        #expect(try #require(queryDict["begin"])?.contains("2022") == true)
        #expect(try #require(queryDict["end"])?.contains("2022") == true)
        #expect(queryDict["ascending"] == "yes")
    }
}

extension Double {
    fileprivate static let timeInterval1970to20220101: Self = 1640995200
    fileprivate static let timeInterval1970to20220102: Self = 1641081600
}
