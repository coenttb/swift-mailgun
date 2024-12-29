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
import Lists
import TestShared

@Suite(
    "Lists Router Tests"
)
struct ListsRouterTests {
    
    @Test("Creates correct URL for list creation")
    func testCreateListURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let createRequest = Lists.List.Create.Request(
            address: try .init("developers@test.com"),
            name: "Developers",
            description: "Test list",
            accessLevel: .readonly,
            replyPreference: .list
        )
        
        let url = router.url(for: .create(request: createRequest))
        #expect(url.path == "/v3/lists")
    }
    
    @Test("Creates correct URL for listing all mailing lists")
    func testListMailingListsURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let listRequest = Lists.List.Request(
            limit: 100,
            skip: 0,
            address: try .init("test@example.com")
        )
        
        let url = router.url(for: .list(request: listRequest))
        #expect(url.path == "/v3/lists")
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(queryDict["limit"] == "100")
        #expect(queryDict["skip"] == "0")
        #expect(queryDict["address"] == "test@example.com")
    }
    
    @Test("Creates correct URL for getting list members")
    func testGetMembersURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let membersRequest = Lists.List.Members.Request(
            address: try .init("test@example.com"),
            subscribed: true,
            limit: 50,
            skip: 10
        )
        
        let url = router.url(for: .members(
            listAddress: try .init("developers@test.com"),
            request: membersRequest
        ))
        
        #expect(url.path == "/v3/lists/developers@test.com/members")
        #expect(url.query?.contains("subscribed=true") == true)
        #expect(url.query?.contains("limit=50") == true)
        #expect(url.query?.contains("skip=10") == true)
    }
    
    @Test("Creates correct URL for adding a member")
    func testAddMemberURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let addRequest = Lists.Member.Add.Request(
            address: try .init("new@example.com"),
            name: "New Member",
            vars: ["role": "developer"],
            subscribed: true,
            upsert: true
        )
        
        let url = router.url(for: .addMember(
            listAddress: try .init("developers@test.com"),
            request: addRequest
        ))
        
        #expect(url.path == "/v3/lists/developers@test.com/members")
    }
    
    @Test("Creates correct URL for bulk member addition")
    func testBulkAddURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let members = [
            Lists.Member.Bulk(
                address: try .init("member1@example.com"),
                name: "Member 1",
                vars: ["role": "admin"],
                subscribed: true
            )
        ]
        
        let url = router.url(for: .bulkAdd(
            listAddress: try .init("developers@test.com"),
            members: members,
            upsert: true
        ))
        
        #expect(url.path == "/v3/lists/developers@test.com/members.json")
        #expect(url.query?.contains("upsert=true") == true)
    }
    
    @Test("Creates correct URL for getting member details")
    func testGetMemberURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let url = router.url(for: .getMember(
            listAddress: try .init("developers@test.com"),
            memberAddress: try .init("member@example.com")
        ))
        
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")
    }
    
    @Test("Creates correct URL for updating member")
    func testUpdateMemberURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let updateRequest = Lists.Member.Update.Request(
            address: try .init("updated@example.com"),
            name: "Updated Name",
            vars: ["role": "lead"],
            subscribed: false
        )
        
        let url = router.url(for: .updateMember(
            listAddress: try .init("developers@test.com"),
            memberAddress: try .init("member@example.com"),
            request: updateRequest
        ))
        
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")
    }
    
    @Test("Creates correct URL for deleting member")
    func testDeleteMemberURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let url = router.url(for: .deleteMember(
            listAddress: try .init("developers@test.com"),
            memberAddress: try .init("member@example.com")
        ))
        
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")
    }
    
    @Test("Creates correct URL for updating list")
    func testUpdateListURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let updateRequest = Lists.List.Update.Request(
            address: try .init("newaddress@test.com"),
            description: "Updated description",
            name: "New Name",
            accessLevel: .members,
            replyPreference: .sender
        )
        
        let url = router.url(for: .update(
            listAddress: try .init("developers@test.com"),
            request: updateRequest
        ))
        
        #expect(url.path == "/v3/lists/developers@test.com")
    }
    
    @Test("Creates correct URL for deleting list")
    func testDeleteListURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let url = router.url(for: .delete(listAddress: try .init("developers@test.com")))
        #expect(url.path == "/v3/lists/developers@test.com")
    }
    
    @Test("Creates correct URL for getting list details")
    func testGetListURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let url = router.url(for: .get(listAddress: try .init("developers@test.com")))
        #expect(url.path == "/v3/lists/developers@test.com")
    }
    
    @Test("Creates correct URL for paginated lists")
    func testPagesURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let url = router.url(for: .pages(limit: 50))
        #expect(url.path == "/v3/lists/pages")
        #expect(url.query?.contains("limit=50") == true)
    }
    
    @Test("Creates correct URL for paginated members")
    func testMemberPagesURL() throws {
        @Dependency(Lists.API.Router.self) var router
        
        let request = Lists.List.Members.Pages.Request(
            subscribed: true,
            limit: 30,
            address: try .init("test@example.com"),
            page: .next
        )
        
        let url = router.url(for: .memberPages(
            listAddress: try .init("developers@test.com"),
            request: request
        ))
        
        print("url.query!", url.query!)
        
        #expect(url.path == "/v3/lists/developers@test.com/members/pages")
        #expect(url.query?.contains("subscribed=true") == true)
        #expect(url.query?.contains("limit=30") == true)
//        #expect(url.query?.contains("address=test%40example.com") == true)
        #expect(url.query?.contains("address=test@example.com") == true)
        #expect(url.query?.contains("page=next") == true)
    }
}
