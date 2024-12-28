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
import Suppressions

@Suite("Mailgun Router Bounces URL Tests")
struct MailgunBouncesRouterTests {
    
    @Test("Creates correct URL for importing bounce list")
    func testImportBouncesURL() throws {
        @Dependency(Bounces.API.Router.self) var router
        
        let testData = Data("test".utf8)
        let url = router.url(for: .importList(domain: try .init("test.domain.com"), request: testData))
        
        #expect(url.path == "/v3/test.domain.com/bounces/import")
    }
    
    @Test("Creates correct URL for getting specific bounce")
    func testGetBounceURL() throws {
        @Dependency(Bounces.API.Router.self) var router
        
        let url = router.url(for: .get(
            domain: try .init("test.domain.com"),
            address: try .init("test@example.com")
        ))
        
        #expect(url.path == "/v3/test.domain.com/bounces/test@example.com")
    }
    
    @Test("Creates correct URL for deleting specific bounce")
    func testDeleteBounceURL() throws {
        @Dependency(Bounces.API.Router.self) var router
        
        let url = router.url(for: .delete(
            domain: try .init("test.domain.com"),
            address: try .init("test@example.com")
        ))
        
        #expect(url.path == "/v3/test.domain.com/bounces/test@example.com")
    }
    
    @Test("Creates correct URL for listing bounces with query parameters")
    func testListBouncesURL() throws {
        @Dependency(Bounces.API.Router.self) var router
        
        let request = Bounces.List.Request(
            limit: 25,
            page: "next",
            term: "test"
        )
        
        let url = router.url(for: .list(domain: try .init("test.domain.com"), request: request))
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(url.path == "/v3/test.domain.com/bounces")
        #expect(queryDict["limit"] == "25")
        #expect(queryDict["page"] == "next")
        #expect(queryDict["term"] == "test")
    }
    
    @Test("Creates correct URL for creating bounce")
    func testCreateBounceURL() throws {
        @Dependency(Bounces.API.Router.self) var router
        
        let request = Bounces.Create.Request(
            address: try .init("test@example.com"),
            code: "550",
            error: "Test error",
            createdAt: "2024-12-27"
        )
        
        let url = router.url(for: .create(domain: try .init("test.domain.com"), request: request))
        
        #expect(url.path == "/v3/test.domain.com/bounces")
    }
    
    @Test("Creates correct URL for deleting all bounces")
    func testDeleteAllBouncesURL() throws {
        @Dependency(Bounces.API.Router.self) var router
        
        let url = router.url(for: .deleteAll(domain: try .init("test.domain.com")))
        
        #expect(url.path == "/v3/test.domain.com/bounces")
    }
}
