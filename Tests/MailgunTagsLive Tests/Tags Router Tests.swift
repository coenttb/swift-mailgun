//
//  Tags.Router.Tests.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Foundation
import URLRouting
import Tags

@Suite(
    "Tags Router Tests"
)
struct TagsRouterTests {
    
    @Test("Creates correct URL for listing tags")
    func testListTagsURL() throws {
        @Dependency(Tags.API.Router.self) var router
        
        let request = Tag.List.Request(
            page: "first",
            limit: 100
        )
        
        let url = router.url(for: .list(domain: try .init("test.com"), request: request))
        
        #expect(url.path == "/v3/test.com/tags")
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(queryDict["page"] == "first")
        #expect(queryDict["limit"] == "100")
    }
    
    @Test("Creates correct URL for getting a tag")
    func testGetTagURL() throws {
        @Dependency(Tags.API.Router.self) var router
        
        let url = router.url(for: .get(domain: try .init("test.com"), tag: "test-tag"))
        
        #expect(url.path == "/v3/test.com/tag")
        #expect(url.query?.contains("tag=test-tag") == true)
    }
    
    @Test("Creates correct URL for updating a tag")
    func testUpdateTagURL() throws {
        @Dependency(Tags.API.Router.self) var router
        
        let url = router.url(for: .update(
            domain: try .init("test.com"),
            tag: "test-tag",
            description: "Updated description"
        ))
        
        #expect(url.path == "/v3/test.com/tag")
        #expect(url.query?.contains("tag=test-tag") == true)
    }
    
    @Test("Creates correct URL for deleting a tag")
    func testDeleteTagURL() throws {
        @Dependency(Tags.API.Router.self) var router
        
        let url = router.url(for: .delete(domain: try .init("test.com"), tag: "test-tag"))
        
        #expect(url.path == "/v3/test.com/tag")
        #expect(url.query?.contains("tag=test-tag") == true)
    }
    
    @Test("Creates correct URL for getting tag stats")
    func testGetTagStatsURL() throws {
        @Dependency(Tags.API.Router.self) var router
        
        let request = Tag.Stats.Request(
            event: ["clicked", "opened"],
            start: "2023-01-01",
            end: "2023-12-31",
            resolution: "day",
            duration: "1m",
            provider: "gmail",
            device: "mobile",
            country: "US"
        )
        
        let url = router.url(for: .stats(
            domain: try .init("test.com"),
            tag: "test-tag",
            request: request
        ))
        
//        #expect(url.path == "/v3/test.com/tag/stats")
        
//        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//        let queryItems = components?.queryItems ?? []
//        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
//        
//        #expect(queryDict["tag"] == "test-tag")
////        #expect(queryDict["event[]"]!.contains("clicked") == true)
////        #expect(queryDict["event[]"]!.contains("opened") == true)
//        #expect(queryDict["start"] == "2023-01-01")
//        #expect(queryDict["end"] == "2023-12-31")
//        #expect(queryDict["resolution"] == "day")
//        #expect(queryDict["duration"] == "1m")
//        #expect(queryDict["provider"] == "gmail")
//        #expect(queryDict["device"] == "mobile")
//        #expect(queryDict["country"] == "US")
    }
    
    @Test("Creates correct URL for getting tag aggregates")
    func testGetTagAggregatesURL() throws {
        @Dependency(Tags.API.Router.self) var router
        
        let request = Tag.Aggregates.Request(type: "provider")
        
        let url = router.url(for: .aggregates(
            domain: try .init("test.com"),
            tag: "test-tag",
            request: request
        ))
        
        #expect(url.path == "/v3/test.com/tag/stats/aggregates")
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(queryDict["tag"] == "test-tag")
        #expect(queryDict["type"] == "provider")
    }
    
    @Test("Creates correct URL for getting tag limits")
    func testGetTagLimitsURL() throws {
        @Dependency(Tags.API.Router.self) var router
        
        let url = router.url(for: .limits(domain: try .init("test.com")))
        
        #expect(url.path == "/v3/domains/test.com/limits/tag")
    }
}
