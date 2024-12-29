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
    "Suppressions Router Tests"
)
struct SuppressionsRouterTests {
    
    @Test("Routes bounce requests correctly")
    func testBouncesRouting() throws {
        @Dependency(API.Router.self) var router
        
        let listRequest = Bounces.List.Request(limit: 25)
        let bouncesAPI = Bounces.API.list(domain: try .init("test.domain.com"), request: listRequest)
        let url = router.url(for: .bounces(bouncesAPI))
        
        #expect(url.path == "/v3/test.domain.com/bounces")
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryDict = Dictionary(
            uniqueKeysWithValues: (components?.queryItems ?? []).map { ($0.name, $0.value) }
        )
        #expect(queryDict["limit"] == "25")
    }
    
    @Test("Routes complaint requests correctly")
    func testComplaintsRouting() throws {
        @Dependency(API.Router.self) var router
        
        let complaintsAPI = Complaints.API.get(domain: try .init("test.domain.com"), address: try .init("test@example.com"))
        let url = router.url(for: .complaints(complaintsAPI))
        
        #expect(url.path == "/v3/test.domain.com/complaints/test@example.com")
    }
    
    @Test("Routes unsubscribe requests correctly")
    func testUnsubscribeRouting() throws {
        @Dependency(API.Router.self) var router
        
        let createRequest = Unsubscribe.Create.Request(
            address: try .init("test@example.com"),
            tags: ["newsletter"]
        )
        let unsubscribeAPI = Unsubscribe.API.create(domain: try .init("test.domain.com"), request: createRequest)
        let url = router.url(for: .unsubscribe(unsubscribeAPI))
        
        #expect(url.path == "/v3/test.domain.com/unsubscribes")
    }
    
    @Test("Routes whitelist requests correctly")
    func testWhitelistRouting() throws {
        @Dependency(API.Router.self) var router
        
        let whitelistAPI = Whitelist.API.delete(domain: try .init("test.domain.com"), value: "example.com")
        let url = router.url(for: .whitelist(whitelistAPI))
        
        #expect(url.path == "/v3/test.domain.com/whitelists/example.com")
    }
}
