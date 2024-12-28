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

@Suite("Mailgun Router Complaints URL Tests")
struct MailgunComplaintsRouterTests {
    
    @Test("Creates correct URL for importing complaints list")
    func testImportComplaintsURL() throws {
        @Dependency(Complaints.API.Router.self) var router
        
        let testData = Data("test".utf8)
        let url = router.url(for: .importList(domain: try .init("test.domain.com"), request: testData))
        
        #expect(url.path == "/v3/test.domain.com/complaints/import")
    }
    
    @Test("Creates correct URL for getting specific complaint")
    func testGetComplaintURL() throws {
        @Dependency(Complaints.API.Router.self) var router
        
        let url = router.url(for: .get(
            domain: try .init("test.domain.com"),
            address: try .init("test@example.com")
        ))
        
        #expect(url.path == "/v3/test.domain.com/complaints/test@example.com")
    }
    
    @Test("Creates correct URL for deleting specific complaint")
    func testDeleteComplaintURL() throws {
        @Dependency(Complaints.API.Router.self) var router
        
        let url = router.url(for: .delete(
            domain: try .init("test.domain.com"),
            address: try .init("test@example.com")
        ))
        
        #expect(url.path == "/v3/test.domain.com/complaints/test@example.com")
    }
    
    @Test("Creates correct URL for listing complaints with query parameters")
    func testListComplaintsURL() throws {
        @Dependency(Complaints.API.Router.self) var router
        
        let request = Complaints.List.Request(
            address: try .init("test@example.com"),
            term: "test",
            limit: 25,
            page: "next"
        )
        
        let url = router.url(for: .list(domain: try .init("test.domain.com"), request: request))
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(url.path == "/v3/test.domain.com/complaints")
        #expect(queryDict["address"] == "test@example.com")
        #expect(queryDict["term"] == "test")
        #expect(queryDict["limit"] == "25")
        #expect(queryDict["page"] == "next")
    }
    
    @Test("Creates correct URL for creating complaint")
    func testCreateComplaintURL() throws {
        @Dependency(Complaints.API.Router.self) var router
        
        let request = Complaints.Create.Request(
            address: try .init("test@example.com"),
            createdAt: "2024-12-27"
        )
        
        let url = router.url(for: .create(domain: try .init("test.domain.com"), request: request))
        
        #expect(url.path == "/v3/test.domain.com/complaints")
    }
    
    @Test("Creates correct URL for deleting all complaints")
    func testDeleteAllComplaintsURL() throws {
        @Dependency(Complaints.API.Router.self) var router
        
        let url = router.url(for: .deleteAll(domain: try .init("test.domain.com")))
        
        #expect(url.path == "/v3/test.domain.com/complaints")
    }
}
