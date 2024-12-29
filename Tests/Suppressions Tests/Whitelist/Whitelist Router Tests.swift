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

@Suite(
    "Whitelist Router Tests"
)
struct WhitelistRouterTests {
    
    @Test("Creates correct URL for importing whitelist")
    func testImportWhitelistURL() throws {
        @Dependency(Whitelist.API.Router.self) var router
        
        let testData = Data("test".utf8)
        let url = router.url(for: .importList(domain: try .init("test.domain.com"), request: testData))
        
        #expect(url.path == "/v3/test.domain.com/whitelists/import")
    }
    
    @Test("Creates correct URL for getting specific whitelist entry")
    func testGetWhitelistURL() throws {
        @Dependency(Whitelist.API.Router.self) var router
        
        let url = router.url(for: .get(
            domain: try .init("test.domain.com"),
            value: "example.com"
        ))
        
        #expect(url.path == "/v3/test.domain.com/whitelists/example.com")
    }
    
    @Test("Creates correct URL for deleting specific whitelist entry")
    func testDeleteWhitelistURL() throws {
        @Dependency(Whitelist.API.Router.self) var router
        
        let url = router.url(for: .delete(
            domain: try .init("test.domain.com"),
            value: "example.com"
        ))
        
        #expect(url.path == "/v3/test.domain.com/whitelists/example.com")
    }
    
    @Test("Creates correct URL for listing whitelists with query parameters")
    func testListWhitelistsURL() throws {
        @Dependency(Whitelist.API.Router.self) var router
        
        let request = Whitelist.List.Request(
            address: try .init("test@example.com"),
            term: "test",
            limit: 25,
            page: "next"
        )
        
        let url = router.url(for: .list(domain: try .init("test.domain.com"), request: request))
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(url.path == "/v3/test.domain.com/whitelists")
        #expect(queryDict["address"] == "test@example.com")
        #expect(queryDict["term"] == "test")
        #expect(queryDict["limit"] == "25")
        #expect(queryDict["page"] == "next")
    }
    
    @Test("Creates correct URL for creating whitelist entry")
    func testCreateWhitelistURL() throws {
        @Dependency(Whitelist.API.Router.self) var router
        
        let request = Whitelist.Create.Request.domain(try .init("example.com"))
        
        let url = router.url(for: .create(domain: try .init("test.domain.com"), request: request))
        
        #expect(url.path == "/v3/test.domain.com/whitelists")
    }
    
    @Test("Creates correct URL for deleting all whitelists")
    func testDeleteAllWhitelistsURL() throws {
        @Dependency(Whitelist.API.Router.self) var router
        
        let url = router.url(for: .deleteAll(domain: try .init("test.domain.com")))
        
        #expect(url.path == "/v3/test.domain.com/whitelists")
    }
}
