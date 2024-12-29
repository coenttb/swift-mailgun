//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import IssueReporting
import TestShared
import Shared
import Authenticated
import Suppressions

@Suite(
    "Unsubscribe Client Tests",
    .dependency(\.envVars, .liveTest)
)
struct UnsubscribeClientTests {
    @Test("Should successfully import unsubscribe list")
    func testImportUnsubscribeList() async throws {
        @Dependency(\.suppressions.unsubscribe) var client
        let testData = Data("test@example.com".utf8)
        
        let response = try await client.importList(testData)
        
        #expect(response.message == "file uploaded successfully")
    }
    
    @Test("Should successfully get unsubscribe record")
    func testGetUnsubscribeRecord() async throws {
        @Dependency(\.suppressions.unsubscribe) var client
        
        let unsubscribe = try await client.get(.init("test@example.com"))
        
        #expect(unsubscribe.address.address == "test@example.com")
        #expect(!unsubscribe.tags.isEmpty)
        #expect(!unsubscribe.createdAt.isEmpty)
    }
    
    @Test("Should successfully delete unsubscribe record")
    func testDeleteUnsubscribeRecord() async throws {
        @Dependency(\.suppressions.unsubscribe) var client
        
        let response = try await client.delete(try .init("test@example.com"))
        
        #expect(response.message == "Unsubscribe event has been removed")
        #expect(response.address.address == "test@example.com")
    }
    
    @Test("Should successfully list unsubscribe records")
    func testListUnsubscribeRecords() async throws {
        @Dependency(\.suppressions.unsubscribe) var client
        
        let request = Unsubscribe.List.Request(
            address: try .init("test@example.com"),
            term: nil,
            limit: 25,
            page: nil
        )
        
        let response = try await client.list(request)
        
        #expect(!response.items.isEmpty)
        #expect(!response.paging.first.isEmpty)
        #expect(!response.paging.last.isEmpty)
    }
    
    @Test("Should successfully create unsubscribe record")
    func testCreateUnsubscribeRecord() async throws {
        @Dependency(\.suppressions.unsubscribe) var client
        
        let request = Unsubscribe.Create.Request(
            address: try .init("test@example.com"),
            tags: ["newsletter"]
        )
        
        let response = try await client.create(request)
        
        #expect(response.message == "Unsubscribe event has been created")
    }
    
    @Test("Should successfully delete all unsubscribe records")
    func testDeleteAllUnsubscribeRecords() async throws {
        @Dependency(\.suppressions.unsubscribe) var client
        
        let response = try await client.deleteAll()
        
        #expect(response.message == "All unsubscribe events have been removed")
    }
}
